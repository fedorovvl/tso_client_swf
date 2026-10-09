# Changelog

## 2026-10-09

### ✨ FEATURE

- Added an adventure invitation action to the bottom-bar player context menu for friends and guild members.

### 🐛 FIX

- Fixed a crash when opening the population overview tooltip before its child controls were initialized.

## 2026-10-06

### 🐛 FIX

- Fixed XP icon in rewards

### 🎨 UI / UX

- Grouped MysterBox rewards
- Format amount label in MysteryBox

## 2026-10-05

### ✨ FEATURE

- Added an adventure invitation action to the chat player context menu for friends and guild members.
- Added clickable links in chat window.
- Added new mail type filter with findAdventure loot
- Format tooltip number with system separator

### 🎨 UI / UX

- Made the send army window movable.
- Restored trade history loading when the Market window history tab is opened for the first time.

### 🐛 FIX

- Restored the “player is offline” response for private chat messages rejected by the XMPP server.
- Prevented game hotkeys and map scrolling from reacting to keyboard input in HTML-based client dialogs.

## 2026-10-04

### ✨ FEATURE

- Embedded the desktop notification engine into `client.swf`.
- Added an SWF-side buff application event bridge.

## Earlier changes

### ✨ FEATURE

- **Explorer groups**
  - Added group management to the Tavern, including slot purchases, group creation, editing, and renaming.
  - Added member selection with group size validation, filtering, and a “select all” option.
  - Added support for sending groups on regular and special searches, with skill validation across all members.
  - Group status, task description, and progress now follow explorer state and server command updates.
  - Added dedicated group and membership icons, selection states, and Star Menu integration.
- **Bulk Mystery Box opening**
  - Added an amount selector from 1 to 100, capped by the number of available boxes.
  - Opening requests now use the selected amount and correctly reduce the inventory count.
  - Rewards from bulk opening are displayed in a single result window.
- **UI scaling**
  - Added interface scaling with the selected value persisted on the server.
  - Updated major panels, context menus, and the action bar to support scaling.
- **Star Menu**
  - Added a dedicated Adventure Items tab.
  - Made the window resizable and adapted tabs, labels, and tooltips to the available size.
- **Chat**
  - Added a Reply action to the player context menu. It inserts the player name into the input field and places the caret at the end.
  - Guild tags are no longer included when sending messages to guild chat.
- Added a client memory monitoring panel (Forum button below avatar).

### 🎨 UI / UX

- Made the Mystery Box rewards window movable and resizable. Reward cards now wrap across rows and no longer overlap scrollbars.
- Reworked Culture Building and Grand Field Hospital layouts, including card sizes, scrolling areas, and production bonus sections.
- Improved the loading screen:
  - smoother and faster transition into the game UI;
  - game version and current SWF commit information;
  - updated footer layout.
- Fixed layout and scaling across:
  - the action bar;
  - the Mail window and mail context menus;
  - the guild member list;
  - trading panels and trade offers;
  - circular menus;
  - the Cancel Action panel;
  - the Help window;
  - expedition and tracked mission lists;
  - the Dismiss Mails dialog;
  - the task payment panel;
  - the assigned troops overview.
- Updated slider states, scrollbars, tab labels, and tooltips.
- Fixed the online filter and context menu scaling in the Friends List.

### ⚙️ CORE

- Added specialist group VOs and server command handling for:
  - slot purchases;
  - temporary and permanent IDs;
  - member and name updates;
  - task starts;
  - group and ID mapping data received with the zone.
- Updated game tick and server action result processing for explorer groups.
- Fixed zone checksum validation and added specialist group checksum support.
- Updated client version data, resource mappings, and protocol definitions.
- Fixed skill tree dependency calculation and support for additional achievement trigger types.
- Prevented redundant Quest Book refreshes when trigger state has not changed.
- Fixed default mail routing and buff application handling.

### 🚀 PERFORMANCE

- Added lazy window creation so expensive panels are initialized on first use.
- Improved UID generation and reduced initial client loading time.
- Fixed memory leaks in game events, observers, collections, zone maps, and server-side state objects.
- Added proper disposal for `cBigBrotherMessage` and the user achievement manager.
- Removed obsolete lazy creation and TriggerList diagnostic logging.

### 🐛 FIX

- **Mystery Box and rewards**
  - Fixed item names, amounts, missing text, and rewards produced by the Content Generator.
  - Fixed animations starting too early, a black screen, and a missing rewards window in the 32-bit client.
  - Fixed card sizing, row wrapping, and scrollbar placement.
- **Excelsior / Content Generator**
  - Fixed animation playback in the x64 client.
  - Added a three-digit spinner and fixed empty bitmaps.
  - Fixed reward list rendering.
- **Quests and achievements**
  - Fixed repeated Quest Book refreshes.
  - Restored reward images for Dummy effects and resources with non-standard GFX references.
  - Fixed unknown achievement trigger types and specialist achievement progress rendering.
- **Explorer groups**
  - Fixed name and member updates, server confirmation state, slot purchases, and list scrolling.
  - Prevented the representative explorer card from changing while editing a group.
  - Fixed return time calculation, the task speed-up button, and task completion when the final explorer returns.
- Fixed shop costs and trade offer backgrounds.
- Fixed battle reports, health bars, and remaining battle time.
- Fixed window positioning, opening conditions, and repeated Help/Mail window creation.
- Fixed resource application in `cApplyBuffResourcePanel`; the amount field now receives focus and selects its value automatically.

### 🔍 DIAGNOSTICS

- Added resource mismatch and zone state diagnostics.
- Expanded client memory monitoring.
- Added temporary logging for unknown server UpdateVO types during specialist group development.
