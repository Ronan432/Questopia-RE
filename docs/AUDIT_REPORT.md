# Questopia-RE — Audit Report

> **Date:** 11 October 2026
> **Scope:** Code hygiene, on-device storage, security sensitive areas, settings audit, growth plan.
> **Rules applied:** [FLUTTER.md](../FLUTTER.md) and [CLEANUP.md](../CLEANUP.md)
> **Note:** `flutter analyze` could not be executed in the audit environment (the Flutter
> tool crashes on process spawn in that sandbox). Run it locally before committing.

---

## 1. Code Cleanup Report

### 1.1 Files over the 300 line limit (Section 2, rule 4)

| Lines | File | Note |
|---:|---|---|
| 1407 | `lib/features/library/data/game_repository.dart` | Must be split: scanner, downloader, archive extractor, catalog parser. |
| 885 | `lib/features/game/presentation/game_screen.dart` | Split the three tabs into `story_tab.dart`, `vars_tab.dart`, `objects_tab.dart`. |
| 698 | `lib/features/game/providers/game_engine_provider.dart` | Split state, callbacks routing, save handling. |
| 632 | `lib/core/providers/settings_provider.dart` | 33 single-key setters repeated verbatim (see 1.2). |
| 537 | `lib/core/native/qsp_ffi.dart` | FFI layer. Risky, leave unless requested. |
| 470 | `lib/features/settings/presentation/sheets/settings_picker_sheets.dart` | Six near identical sheet skeletons. |
| 308 | `lib/core/native/qsp_callbacks.dart` | FFI layer. Risky. |
| 306 | `lib/core/widgets/window_title_bar.dart` | Minor overshoot. |
| 967 / 443 / 443 | `lib/core/l10n/app_localizations*.dart` | **Generated.** Never edit by hand. |

### 1.2 Confirmed duplication (CLEANUP.md Section 4 verified)

| Priority | Duplication | Verified evidence |
|---|---|---|
| P0 | Single key value write repeated | `settings_provider.dart` has 33 `state = state.copyWith(...)` + `_set(...)` pairs, each differing only by key. |
| P0 | Sheet header pill in two implementations | `QuestopiaSheetHeaderPill` (`core/helpers/sheet_helper.dart`) and a private `_buildSheetHeaderPill` (`settings_picker_sheets.dart:76`). Same markup, two owners. |
| P0 | HTML tag stripping regex repeated | `game_screen.dart:_stripTags`, `game_repository.dart` (title/desc cleaning), `game_message_dialog.dart`. |
| P0 | Sheet skeleton repeated six times | `settings_picker_sheets.dart`: `showThemeModePicker`, `showAccentPicker`, `showLanguagePicker`, `showTypefacePicker`, `showActionsHeightPicker`, `showBinaryPrefixesPicker` all repeat the same `SingleChildScrollView` + `SegmentedListSection` shell. |
| P1 | Desktop platform detection repeated | 26 occurrences across 8 files (`sheet_helper`, `questopia_scaffold`, `game_repository`, `library_screen`, `catalog_games_view`, `local_games_view`, `appearance_general_section`, `main.dart`). |
| P1 | Grid layout block duplicated | `local_games_view.dart:106`, `catalog_games_view.dart:130`, `game_screen.dart:766`. |
| P1 | Launch game flow duplicated | `local_games_view.dart:118-140` and `catalog_games_view.dart:176` repeat the "check file exists, load game, push GameScreen" sequence. |
| P2 | User agent / referer header block repeated | `game_repository.dart` (4 places), `game_poster`, `game_media`. |

### 1.3 Dead code still present (CLEANUP.md Section 3 claims re-verified)

| Location | Symbol | Status |
|---|---|---|
| `game_repository.dart` | `hideGame`, `writeGameInfo` | No caller outside the file. |
| `html_processor.dart` | `wrapVideos`, `videoBootstrapScript`, `ogvBootstrapScript`, `stripImageTags`, `mimeTypeForPath` | Leftovers from the removed WebView video path. |
| `qsp_models.dart` | `QspVar` | Never instantiated. |
| `qsp_path_resolver.dart` | `updatePreloadedIndex` | Never called. |

### 1.4 Rule violations observed

- **Rule 2 (zero hardcoded strings):** `game_screen.dart` contains `'Loading QSP Story...'`,
  `'Loading game world...'`, `'No status information available'`, `'Inventory is empty'`,
  `'Story'`, `'Status'`, `'Inventory'`, `'Item #'`. `game_options_sheet.dart` has
  `'Game Options'`, `cheat_modes_sheet.dart` has `'Cheat Engine and Editor'`,
  `save_slots_sheet.dart` has `'Saves and Slots'`.
- **Rule 3 (English only):** `ogv_asset_server.dart` and `qsp_media.dart` print Turkish
  debug text (`HATA`, `bayt`, `bulunamadi`, `OGV yonlendirmesi`). Comments are English;
  the log strings are not.

### 1.5 Cleanup verdict

Nothing was deleted in this pass, because the user request was an audit plus two targeted
fixes, not a removal pass. Every deletion candidate above is recorded so the next explicit
cleanup can act without re-deriving it.

---

## 2. On-Device Storage and User Data (the 100 MB+ question)

### 2.1 What the app stores

| Data | Location | Size class |
|---|---|---|
| Game registry | `<app support>/questopia_games.json` | KB |
| Catalog cache | `<app support>/remote_stock.xml` | ~100 KB - few MB |
| Crash log | `<app support>/crash_report.txt` | Unbounded (append only) |
| **Imported / downloaded games** | `<games dir>/<game folder>` | **MB - GB** |
| Cached posters | Inside each game folder | 10 - 500 KB each |

Games directory resolution order (`game_repository.dart:getGamesDirectory`):

1. User-selected folder (from Settings).
2. Android: `/storage/emulated/0/Download/Questopia/games` (shared storage).
3. Fallback: `getApplicationDocumentsDirectory()/Questopia/games` (app private storage).
4. Fallback: system temp.

### 2.2 Root causes of the excessive footprint

1. **Tier B full folder copy.** When a picked folder is not directly readable
   (Android 11+ Scoped Storage), `copyDirectory()` duplicates the **entire** source folder
   into the games directory. A 300 MB game folder becomes 600 MB on disk.
   (`game_repository.dart:135-151`, `:445-459`)
2. **Orphan folders are never deleted.** `deleteGame()` only deletes from disk when
   `game.isFromRepo` is true. Tier B copies, folder imports and loose file imports are
   **not** marked `isFromRepo`, so removing them from the library leaves the files on disk
   forever. Storage only ever grows. (`game_repository.dart:350-364`)
3. **Archive extraction duplicates content.** Downloads are written as an archive and then
   extracted next to it (the archive is deleted afterwards for archives, but the extracted
   tree is a full second copy of the original download).
4. **Unbounded crash log.** `crash_report.txt` is opened in `FileMode.append` and never
   trimmed. A repeating error can grow the file without limit. (`crash_reporter.dart:41`)
5. **Storage fallback silently moves games into app-private storage.** On Android 11+ the
   shared `Download/Questopia` path is often not writable without full storage access, so
   the app falls back to its own private directory, where the games count as app data and
   are invisible to the user.
6. **Folder change needs a restart.** `libraryProvider` reads `settings.gamesDirectory`
   once, at provider creation (`library_provider.dart:295`). Changing the folder in Settings
   does not re-scan or move anything until the app restarts.

### 2.3 Recommended reductions (report only, not applied)

- Delete the on-disk folder for **every** removed game, not only repo games, and ask for
  confirmation first.
- For Tier B, keep a reference to the original path and read from it where possible instead
  of copying; where a copy is unavoidable, record it so it can be reclaimed.
- Cap or rotate `crash_report.txt` (for example keep the newest N KB).
- Show a per-game size and a total storage figure in the Storage settings section so the
  user can see where the space went.

---

## 3. Sensitive and Weak Areas

| Severity | Issue | Location |
|---|---|---|
| Critical | Loopback media server serves **any** absolute local path passed in the `path` query parameter. There is no allow list, so any local process that can reach the random `127.0.0.1` port can read arbitrary files. | `ogv_asset_server.dart:_serveMedia` |
| High | `QspSaveGameStatusEvent` is routed to `_openStatusFile()`, which calls `openSaveData()` (a **load**). In-game saves therefore never reach the disk. | `game_engine_provider.dart:321-322`, `:455-469` |
| High | `MANAGE_EXTERNAL_STORAGE` ("All files access") is declared. Google Play restricts this permission to a narrow set of app categories; a game player likely does not qualify and may be rejected. `requestLegacyExternalStorage="true"` is also present and is ignored on Android 11+. `INTERNET` is declared twice. | `android/app/src/main/AndroidManifest.xml` |
| High | Missing `mounted` guard after `await` can throw on a disposed notifier. | `library_provider.dart` |
| High | `QspPathResolver` is rebuilt on every build of the media viewer. | `game_media_viewer.dart:26-28` |
| High | Download stream handle is not closed when the transfer fails. | `game_repository.dart:_downloadFileDirect` |
| Medium | `isSoundEnabled` has a `GameAudio.setSoundEnabled()` method but nothing ever calls it, so the Sound toggle does nothing. | `game_audio.dart`, `settings_provider.dart` |
| Medium | `isVideoMute` has no consumer at all. Video mute never applies. | `settings_provider.dart` |
| Medium | Typeface setting never reached the game text. | Fixed in this pass, see Section 4. |
| Medium | Empty `catch` blocks swallow engine errors (for example `QspCallbackBridge._dispatch`). | `qsp_callbacks.dart:243-247` and others |
| Medium | `'Netflix Sans'` is used as the app wide and game font, but **no `fonts:` section exists in `pubspec.yaml`**. The family is never bundled, so Flutter silently falls back to the platform default everywhere. | `pubspec.yaml`, `questopia_theme.dart:6` |
| Low | Turkish debug strings mixed with English ones. | `ogv_asset_server.dart`, `qsp_media.dart` |
| Low | Mock engine silently takes over when the native library is missing, showing fake story text instead of a clear error. | `game_engine_provider.dart:141-161` |

Positive note: `.secrets` is present but correctly listed in `.gitignore` and is **not**
tracked by git.

---

## 4. Applied Fixes

### 4.1 Slider style and alignment

`lib/features/settings/presentation/widgets/settings_tile_builders.dart` — `sliderTile`:

- Added `titleAlignment: ListTileTitleAlignment.top` so the leading icon lines up with the
  label instead of floating in the middle of the taller slider row.
- Wrapped the slider in `SizedBox(height: 28)`. The default Slider reserves space for a
  large thumb overlay, which produced the wide gap under the label.
- Slimmer, tidier track: `trackHeight: 6`, thumb radius `8`, overlay radius `14`,
  `trackGap: 2`.
- Hid the tick marks (transparent) so the track reads as one clean bar. Values still snap
  to the same `divisions`.
- `minVerticalPadding` reduced from 16 to 12.

Applies to every slider: font size, nav bar blur, autosave interval, custom image width and
height.

### 4.2 Typeface setting now has an effect

Root cause: the game text used a hardcoded `QuestopiaTheme.fontFamily`, and the picker
mapped index 0 to `'Netflix Sans'` and **every other index to `null`**. On top of that the
family was never bundled, so all 12 options rendered identically and nothing changed until
(and even after) a restart.

- `lib/core/theme/questopia_theme.dart` — added `fontFamilyFor(int index)` with real,
  platform-appropriate families (Android: `sans-serif`, `serif`, `monospace`,
  `sans-serif-condensed`, ... Desktop: `Segoe UI`, `Georgia`, `Consolas`,
  `Bahnschrift Condensed`, ...). Index 0 stays "platform default" and returns `null`, so the
  existing look is unchanged for users who never touch the setting.
- `lib/features/game/presentation/game_screen.dart` — both the Story and the Status panes now
  use `QuestopiaTheme.fontFamilyFor(settings.typefaceIndex)`.
- `lib/features/settings/presentation/sheets/settings_picker_sheets.dart` — the live preview
  renders with the real family and updates the instant a typeface is tapped.

The change is picked up immediately through Riverpod, so no restart is needed.

### 4.3 Commit message standard

`FLUTTER.md` rule 10 and Section 6.2 now require that **every commit body contains a
definitive change list**: one bullet per changed file or behaviour, naming the file and what
changed in it. Vague bodies ("various fixes", "cleanup", "improvements") are explicitly
declared a failed commit.

### 4.4 Files changed in this pass

| File | Change |
|---|---|
| `lib/features/settings/presentation/widgets/settings_tile_builders.dart` | Tidier, tighter slider row with top alignment. |
| `lib/core/theme/questopia_theme.dart` | Added `fontFamilyFor(index)` with real per-platform families. |
| `lib/features/game/presentation/game_screen.dart` | Game text uses the selected typeface. |
| `lib/features/settings/presentation/sheets/settings_picker_sheets.dart` | Typeface preview uses the real family and updates live. |
| `FLUTTER.md` | Commit body must be a definitive change list. |

`flutter analyze` still needs to be run locally. No cleanup deletions were performed.

---

## 5. Settings Audit — Every Setting and Its Consumer

"Consumer" means a place outside the settings screens that reads the value and changes
behaviour.

### 5.1 Working settings

| Setting | Consumer |
|---|---|
| `themeMode` | `main.dart` |
| `themeColor` | `main.dart` |
| `language` | `main.dart` |
| `fontSize` | `game_screen.dart` |
| `isImmersiveMode` | `game_screen.dart` |
| `isNavBarBlur` / `navBarBlurPercent` | `game_screen.dart`, `library_screen.dart`, both library views, `questopia_frosted_overlay.dart` |
| `useGameTextColor` / `gameTextColor` | `game_screen.dart` |
| `useGameBackgroundColor` / `gameBackColor` | `game_screen.dart` |
| `actionsHeightRatio` | `game_screen.dart` |
| `gamesDirectory` | `library_provider.dart` (only at startup, see 2.2.6) |
| `typefaceIndex` | `game_screen.dart` — **fixed in this pass** |

### 5.2 Dead settings — no consumer anywhere

These are visible in the UI and persist to `SharedPreferences`, but nothing reads them, so
toggling them changes nothing. Listed for a future decision (wire up or remove):

`isUseGameFont`, `isUseSeparator`, `isUseAutoscroll`, `isImagesInDialogEnabled`,
`isFullscreenImages`, `isPinchZoomEnabled`, `isSquarePosters`, `isExecStringEnabled`,
`isAutoWidth`, `customWidthImage`, `isAutoHeight`, `customHeightImage`,
`useGameLinkColor`, `gameLinkColor`, `isAutosaveEnabled`, `autosaveInterval`,
`isCheatsEnabled`, `isVideoMute`, `isImageDisabled`, `binaryPrefixes`.

### 5.3 Partially wired

| Setting | Problem |
|---|---|
| `isSoundEnabled` | The value is read into `GameAudio`, but nothing ever calls `setSoundEnabled()` with the setting, so audio is never muted. |
| `isCheatsEnabled` | The cheat sheet is reachable regardless of the toggle. The toggle gates nothing. |
| `isAutosaveEnabled` / `autosaveInterval` | No timer, no save hook. Auto-save does not exist yet. |
| `isVideoMute` | Never passed to `QspMedia`; the `muted` flag comes from the HTML tag instead. |
| `gamesDirectory` | Read only when `libraryProvider` is created; a change needs an app restart to take effect. |

Summary: 11 settings work, 20 are dead, 5 are partially wired. This is the single largest
source of user-facing confusion in the app.

---

## 6. Growth and Innovation Plan

### 6.1 Quick wins (small effort, high visibility)

1. **Wire the dead settings or remove them.** Every toggle that does nothing erodes trust.
   Cheapest path: make the sound, video mute, disable images, square posters and pinch zoom
   toggles actually take effect; remove the rest until they are implemented.
2. **Storage dashboard.** Show total library size, per-game size and a "clear cache" action
   in the Storage section. This directly answers the 100 MB question for the user.
3. **Import progress and cancel.** Imports and downloads already report progress; surface it
   with a cancel button so a large copy can be stopped.
4. **Localised empty and loading states.** Replace the hardcoded English placeholders with
   ARB entries (rule 2).

### 6.2 Player experience

5. **Reading themes.** A dedicated set of reading presets (Sepia, Night, High Contrast)
   built on the existing `GameColors`, selectable in one tap.
6. **Save management screen.** Named slots, timestamps, thumbnails, and export/import to a
   file. This also fixes the discovery problem behind the broken save handler.
7. **Reading position memory.** Remember scroll offset per game and restore it on open.
8. **Text-to-speech for the story pane.** A natural fit for a text game and cheap to add.
9. **Word/character counter and estimated reading time** in the status bar.
10. **Gesture layer.** Swipe to go back, long press to copy, double tap to toggle immersive.

### 6.3 Library and catalog

11. **Full offline catalog.** Cache the parsed catalog, not just the XML, and support search
    and filtering without a network round trip.
12. **Collections and tags.** User-defined shelves, plus filters by author, language and
    player.
13. **Metadata sidecar.** Store author, version, language and a description next to each game
    so the library can sort and group meaningfully.
14. **Auto-update check.** Compare the installed version against the catalog version and offer
    an in-place update.
15. **Duplicate and dead-entry janitor.** The scanner already deduplicates by path and by
    title+size; expose a one-tap "clean up library" that also reclaims orphaned folders.

### 6.4 Engineering and platform

16. **Split `game_repository.dart`.** Scanner, downloader, extractor and catalog parser as
    separate files under 300 lines. This is the highest-value refactor in the codebase.
17. **Extract the repeated settings setter.** One typed `_update(key, value)` path instead of
    33 hand written setters.
18. **Shared `QuestopiaSheet` builder.** Collapse the six picker sheets into one parameterised
    sheet. Removes roughly 300 lines and the header pill duplication.
19. **Allow list for the media server.** Restrict `_serveMedia` to files inside the active
    game folder. This closes the critical security finding.
20. **Packaging.** Reconsider `MANAGE_EXTERNAL_STORAGE`; the Storage Access Framework and
    `file_picker` already cover most import flows and keep the app Play-Store friendly.
21. **Desktop parity.** Windows build currently lacks the immersive and blur features that are
    Android-only. Decide and document the platform matrix.
22. **Bundle a real font or drop the claim.** Either ship `Netflix Sans` (licence permitting)
    as a declared asset, or set `fontFamily` to `null` and remove the misleading reference.

### 6.5 Library additions worth evaluating

| Need | Candidate |
|---|---|
| Bundled, licence-clean UI font | `google_fonts` (runtime fetch, cache carefully) or a bundled variable font |
| Richer text rendering for the story pane | keep `flutter_widget_from_html_core`, add `flutter_html` only if a feature gap appears |
| Save file thumbnails | `image` for downscaling, `path_provider` for storage |
| Local database for the library | `drift` or `isar` (replaces the JSON registry, enables queries) |
| State management consistency | already on Riverpod; migrate remaining `StatefulWidget` local state where it grows |
| Crash reporting | `sentry_flutter` or `firebase_crashlytics` instead of the unbounded text log |
| Text to speech | `flutter_tts` |
| Archive coverage | the Rust FFI path plus `archive` already cover the common formats; keep `bsdtar` as the desktop fallback |

---

## 7. Priority Order

1. Fix the save handler (`QspSaveGameStatusEvent`) — data loss risk.
2. Add the media server allow list — security.
3. Reclaim orphaned game folders and cap the crash log — the storage complaint.
4. Decide the fate of the 20 dead settings — user trust.
5. Split `game_repository.dart` — maintainability.
6. Implement the storage dashboard and the save management screen — visible user value.

---

## 8. Second Pass — Applied Changes (11 October 2026)

### 8.1 Critical repairs

| Area | What changed |
|---|---|
| Save handler | `QSP_CALL_SAVE_GAME_STATUS` now snapshots the game with `saveGameData()` and writes it to the requested path. It used to route into the load path, so in-game saves never reached the disk. |
| Media endpoint | `OgvAssetServer` only serves files inside the game folders announced by the player page and answers everything else with `403`. |
| Download stream | `_downloadFileDirect` closes its sink in a `finally` block and deletes the partial file on failure. The handle used to stay open and the fragment stayed on disk. |
| Lifecycle guards | `removeGameFromLibrary` and `removeAllGames` check `mounted` after every `await`. |
| Media resolver | `GameMediaViewer` caches one `QspPathResolver` per game folder instead of rebuilding the index on every frame. |

### 8.2 Storage and user data

| Area | What changed |
|---|---|
| Deleting games | `deleteGame` removes the folder whenever the app owns it (`LocalGame.isManaged`). A folder the user only pointed at is unlinked and left on disk. A loose `.qsp` file inside the games directory is deleted on its own. |
| Orphan cleanup | New `GameRepository.cleanupOrphanFolders` removes leftover folders inside the games directory that hold no game file. |
| Storage dashboard | New Storage settings section shows the games folder, the total bytes used, the game count and a one-tap cleanup action. |
| Byte formatting | New `formatBytes` helper honours the decimal or binary prefix setting. |
| Crash log | `crash_report.txt` is trimmed to its newest 64 KB. It used to grow without bound. |
| Games folder | `libraryProvider` reads the folder on demand, so changing it in Settings applies immediately instead of after a restart. |

### 8.3 Settings that now work

Sound, video mute, disable images, pinch zoom, fullscreen image viewer, image-in-dialog, square posters, separator line, auto-scroll, custom link colour, image width and height overrides, binary prefixes, cheat engine gating, QSP console gating and auto-save all have a real consumer now. `isUseGameFont` was removed because no in-game font concept exists.

### 8.4 New capabilities

- **Reading themes:** four presets (default, sepia, night, high contrast) that set the story and status background, text and link colours. A custom colour still wins over the preset.
- **Real auto-save:** the engine counts counter ticks, snapshots the game at the configured interval, writes it to `<app support>/questopia_autosave/<game id>.sav` and restores it on the next launch. The auto-save slot can also be loaded from the save sheet, which previously pointed at an empty map entry.
- **Catalog details:** tapping a catalogue card opens a sheet with the author, porter, version, language, player, size, modified date and description that the app already downloaded but never displayed.
- **Better search:** library search matches the author, and catalogue search also matches the description.

### 8.5 Scrolling bug in game mode

The header used to pop back the moment the reader reached the end of the story. Root cause: the header animation changed the body height, which changed the scroll extent, which fired another scroll notification, which toggled the header again. On top of that, a `ScrollEndNotification` handler forced the header back after only 250 ms.

The handler now only reacts to `ScrollUpdateNotification` at depth 0, ignores events while the header animation is in flight, and never forces the header back while `extentAfter` is zero. Scrolling up restores it immediately.

### 8.6 Remaining known gaps

| Severity | Issue |
|---|---|
| Medium | Around 50 hardcoded user-facing strings remain in the game sheets and dialogs (rule 2). Each needs an ARB key in both locales. |
| Medium | `game_repository.dart` is still over 1400 lines and needs the split described in Section 1.1. |
| Medium | `MANAGE_EXTERNAL_STORAGE` is still declared in the Android manifest. |
| Low | `game_screen.dart` still logs on every tap through `debugPrint`. The per-frame log spam in `build()` was removed. |
| Low | The accessibility gap remains: `ExcludeSemantics` still wraps the story and media panes. |

### 8.7 Verification status

`flutter analyze` and `dart analyze` could not be executed in the audit environment: the Flutter tool crashes on process spawn and the Dart analysis server cannot start a subprocess there. Every change was reviewed by hand and all edited files were checked for balanced delimiters. The analyzer must be run locally before the branch is considered green.

