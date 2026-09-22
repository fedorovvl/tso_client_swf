# TSO Client — source tree & build

Клиент игры TSO на ActionScript 3 / Flex. Исходники лежат в `src/`,
точка входа — `src/_SWMMO_mx_managers_SystemManager.as` (подкласс
`mx.managers.SystemManager`), корневой документ приложения — `src/SWMMO.mxml`.

Сборка гибридная:
- **компилятор** — Apache Flex 4.16.1 (`sdk/4.16.1`, `mxmlc.jar`);
- **рантайм** — Flex 3.6 (`sdk/3.6.0`: `framework.swc`, `rpc.swc`, `mxml-manifest.xml`).

Результат — `client.swf`

## Требования

- Java (8+), доступная как `java` в PATH. Путь можно переопределить
  переменной окружения `JAVA` (например `JAVA=/usr/lib/jvm/.../bin/java`).
- Windows: `build.cmd`; Linux/macOS: `./build.sh` (после `chmod +x build.sh`).

## Сборка

```sh
./build.sh -DebugBuild        # debug-сборка (по умолчанию, если флаг не указан — только -MinimalBuild изменяет его)
./build.sh -MinimalBuild      # release: optimize + compress, без debug
./build.sh -DebugBuild -KeepGeneratedCode   # сохранить generated Actionscript
```

`build.cmd` принимает те же флаги.

Скрипт делает два шага:

1. **Тема** — `sdk/3.6.0` mxmlc собирает `assets/theme/swmmoTheme.css`
   в `assets/theme/swmmo-theme.swf` (runtime-тема, подключается через
   CSS 3.6). mxmlc 3.6 резолвит `localFonts.ser` из CWD, поэтому шаг
   выполняется из `sdk/3.6.0/frameworks`.
2. **Клиент** — `sdk/4.16.1` mxmlc собирает весь `src/` в `client.swf`
   (лог — `compile.log`).

## Конфиги

- `compiler-config.xml` — статичный конфиг клиента: source-path, locale,
  library-path, `strict=false`, `target-player 15.0` / `swf-version 26`,
  `1024×768`, 30 fps, лимиты скриптов. Пути внутри — относительно каталога
  конфига.
- `linker-config.xml` — генерируется скриптом автоматически: полный
  `<frames>`-список всех классов `src/` (кроме точки входа). Обязателен:
  часть классов грузится по имени через `getDefinitionByName` (в т.ч.
  data-driven, имена приходят из данных), их нельзя статически перечислить.
- `theme-config.xml` — конфиг темы (`target-player 10.0.0`,
  `keep-all-type-selectors`).

## Библиотеки (`libs/` + SDK)

- Рантайм Flex 3.6: `framework.swc`, `rpc.swc`, `locale/en_US/framework_rb.swc`,
  `rpc_rb.swc` (`sdk/3.6.0/frameworks`).
- Компиляторные ресурсы Flex 4.16: `locale/en_US/{framework_rb,rpc_rb,mx_rb}.swc`
  (`sdk/4.16.1/frameworks`).
- `airglobal.swc` — AIR API (`NativeApplication`, `File/FileStream`,
  `InvokeEvent`), подключается как `external-library-path`.
- Сторонние SWC: `PureMVC_AS3_2_0_4`, `PureMVC_AS3_MultiCore_1_0_5`,
  `Flint2d_4.0.1`, `XIFF-quiet`, `as3crypto`, `as3zlib`.

## Важные детали

- `-compiler.strict=false` и `-compiler.omit-trace-statements=false` осознанно:
  код наследует старую нестрогую семантику.
- Все классы линкуются в единый кадр `main` (см. `linker-config.xml`);
  `src/generated` после сборки быть не должно.
- Биндинги в MXML — только в форме `{f(x)}` (вызов функции): runtime-`Binding`
  в Flex 3.6 принимает 4 аргумента, а компилятор 4.16 для прочих форм генерит
  5-аргументный конструктор (`Error #1063`). Подробные правила MXML —
  в `AGENTS.md`.
- Стили корневых MXML-компонентов задаются кодом (`setStyle`), не атрибутами:
  корневые стили генерируют `CSSStyleDeclaration(null, styleManager)`, которого
  нет в рантайм-3.6 (`Error #1065`).
- События в MXML-компонентах — только через `addEventListener` в
  `childrenCreated()`.
- Тема собирается в отдельный runtime-`swf` и применяется через
  `StyleManager.initProtoChainRoots` (`SWMMO.swmmoStylesInit`) в стартовом коде.

## Структура

```
src/                      исходники (ActionScript + MXML)
sdk/3.6.0/                runtime Flex 3.6 (swc, manifest, рамки/шрифты)
sdk/4.16.1/               компилятор Apache Flex 4.16.1
libs/                     сторонние SWC
assets/theme/             CSS-тема + собранный runtime-тема swf
compiler-config.xml        конфиг клиента (статичный)
theme-config.xml           конфиг темы (статичный)
reference/                бэкапы исходных файлов до конвертаций (gitignored)
client.swf                результат сборки
compile.log               лог сборки клиента
```

---

# TSO Client — source tree & build

The TSO game client written in ActionScript 3 / Flex. Sources live in `src/`,
the entry point is `src/_SWMMO_mx_managers_SystemManager.as` (a subclass of
`mx.managers.SystemManager`), the application root document is `src/SWMMO.mxml`.

The build is hybrid:

- **compiler** — Apache Flex 4.16.1 (`sdk/4.16.1`, `mxmlc.jar`);
- **runtime** — Flex 3.6 (`sdk/3.6.0`: `framework.swc`, `rpc.swc`, `mxml-manifest.xml`).

The result is `client.swf` in the repository root.

## Requirements

- Java (8+), available as `java` on PATH. You can override the path with the
  `JAVA` environment variable (e.g. `JAVA=/usr/lib/jvm/.../bin/java`).
- Windows: `build.cmd`; Linux/macOS: `./build.sh` (after `chmod +x build.sh`).

## Building

```sh
./build.sh -DebugBuild        # debug build; if no flag is given only -MinimalBuild changes it
./build.sh -MinimalBuild      # release: optimize + compress, no debug
./build.sh -DebugBuild -KeepGeneratedCode   # keep the generated ActionScript
```

`build.cmd` accepts the same flags.

The script does two steps:

1. **Theme** — the `sdk/3.6.0` mxmlc compiles `assets/theme/swmmoTheme.css`
   into `assets/theme/swmmo-theme.swf` (runtime theme, loaded via CSS 3.6).
   The 3.6 mxmlc resolves `localFonts.ser` from the CWD, so this step runs
   from `sdk/3.6.0/frameworks`.
2. **Client** — the `sdk/4.16.1` mxmlc compiles all of `src/` into `client.swf`
   (log — `compile.log`).

## Config files

- `compiler-config.xml` — static client config: source-path, locale,
  library-path, `strict=false`, `target-player 15.0` / `swf-version 26`,
  `1024×768`, 30 fps, script limits. Paths inside are relative to the config
  directory.
- `linker-config.xml` — generated by the script: a full `<frames>` list of every
  class in `src/` (except the entry point). Mandatory: some classes are loaded
  by name via `getDefinitionByName` (including data-driven names that come from
  runtime data and cannot be enumerated statically).
- `theme-config.xml` — theme config (`target-player 10.0.0`,
  `keep-all-type-selectors`).

## Libraries (`libs/` + SDK)

- Flex 3.6 runtime: `framework.swc`, `rpc.swc`, `locale/en_US/framework_rb.swc`,
  `rpc_rb.swc` (`sdk/3.6.0/frameworks`).
- Flex 4.16 compiler resources: `locale/en_US/{framework_rb,rpc_rb,mx_rb}.swc`
  (`sdk/4.16.1/frameworks`).
- `airglobal.swc` — AIR API (`NativeApplication`, `File/FileStream`,
  `InvokeEvent`), linked as `external-library-path`.
- Third-party SWC: `PureMVC_AS3_2_0_4`, `PureMVC_AS3_MultiCore_1_0_5`,
  `Flint2d_4.0.1`, `XIFF-quiet`, `as3crypto`, `as3zlib`.

## Important details

- `-compiler.strict=false` and `-compiler.omit-trace-statements=false` are
  deliberate: the code inherits old lenient semantics.
- All classes link into a single `main` frame (see `linker-config.xml`);
  `src/generated` must not exist after a build.
- MXML bindings must use the `{f(x)}` call form only: the Flex 3.6 runtime
  `Binding` takes 4 arguments, while the 4.16 compiler emits a 5-argument
  constructor for other forms (`Error #1063`). Full MXML rules are in
  `AGENTS.md`.
- Root MXML component styles are set via code (`setStyle`), not attributes:
  root style attributes generate `CSSStyleDeclaration(null, styleManager)`,
  which does not exist in the 3.6 runtime (`Error #1065`).
- Events on MXML components are attached only via `addEventListener` in
  `childrenCreated()`.
- The theme is built as a separate runtime `swf` and applied through
  `StyleManager.initProtoChainRoots` (`SWMMO.swmmoStylesInit`) in the startup
  code.

## Layout

```
src/                      sources (ActionScript + MXML)
sdk/3.6.0/                Flex 3.6 runtime (swc, manifest, fonts)
sdk/4.16.1/               Apache Flex 4.16.1 compiler
libs/                     third-party SWC
assets/theme/             CSS theme + built runtime theme swf
compiler-config.xml       client config (static)
theme-config.xml          theme config (static)
reference/                backups of original files prior to conversions (gitignored)
client.swf                build result
compile.log               client build log
```