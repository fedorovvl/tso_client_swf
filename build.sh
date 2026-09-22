#!/bin/bash
# Minimal build: runtime theme (mxmlc 3.6) + client (mxmlc 4.16 + 3.6 runtime libs).
# Usage: ./build.sh [-DebugBuild|-MinimalBuild] [-KeepGeneratedCode]
set -u
ROOT="$(cd "$(dirname "$0")" && pwd)"
JAVA="${JAVA:-java}"
MODE=""
KEEP=""
for arg in "$@"; do
    case "$arg" in
        -DebugBuild) MODE="-compiler.debug=true" ;;
        -MinimalBuild) MODE="-compiler.debug=false -compiler.optimize=true -compiler.compress=true" ;;
        -KeepGeneratedCode) KEEP="-compiler.keep-generated-actionscript=true" ;;
    esac
done
command -v "$JAVA" >/dev/null 2>&1 || { echo "Java not found in PATH."; exit 1; }

# ---- theme (mxmlc 3.6 needs localFonts.ser in CWD) ----
cd "$ROOT/sdk/3.6.0/frameworks" || exit 1
"$JAVA" -jar ../lib/mxmlc.jar -load-config=../../../theme-config.xml ../../../assets/theme/swmmoTheme.css -output ../../../assets/theme/swmmo-theme.swf
if [ $? -ne 0 ]; then echo "Theme build failed."; exit 1; fi
echo "Build succeeded: assets/theme/swmmo-theme.swf"
cd "$ROOT" || exit 1

# ---- frames config (force-link string-loaded classes) ----
CFG="$ROOT/linker-config.xml"
{
echo '<flex-config>'
echo '  <frames><frame><label>main</label>'
find src -name '*.as' -o -name '*.mxml' | grep -v 'generated/' | sed -e 's|^src/||' -e 's|\.mxml$||' -e 's|\.as$||' -e 's|/|.|g' | grep -v '^_SWMMO_mx_managers_SystemManager$' | sort -u | sed -e 's|.*|    <classname>&</classname>|'
echo '  </frame></frames>'
echo '</flex-config>'
} > "$CFG"

# ---- client (relative paths, CWD=root) ----
"$JAVA" -Duser.language=en -Duser.country=US -Xmx2g -Dfile.encoding=UTF-8 -Dflexlib=sdk/4.16.1/frameworks -jar sdk/4.16.1/lib/mxmlc.jar -load-config=compiler-config.xml -load-config+=linker-config.xml $MODE $KEEP -output=client.swf src/_SWMMO_mx_managers_SystemManager.as > compile.log 2>&1
if [ $? -ne 0 ]; then echo "Compilation failed. See compile.log."; exit 1; fi
echo "Build succeeded: client.swf"
