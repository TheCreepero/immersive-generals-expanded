# Immersive Generals Expanded - Development & Agent Rules

## 1. Mod Architecture & Workspace Layout
- This project follows a unified single-root mod layout:
  - **Workspace & Git root**: `C:\dev\immersive-generals-expanded` (Git repository root containing `.git/`)
  - All mod descriptors (`descriptor.mod`), build tools (`build.ps1`), content (`common/`), tests (`tests/`), and agent configurations (`GEMINI.md`) reside at the project root.
  - Release archives (`artifacts/`) and scratch scripts (`scratch/`) are git-ignored.

## 2. Clausewitz File Format & Syntax Invariants
- **UTF-8 Without BOM**: All Clausewitz script files (`.mod`, `.txt`, `.gui`, `.gfx`) must be saved in UTF-8 without BOM. Never use standard Windows PowerShell `Set-Content -Encoding UTF8` because it writes a BOM (`\ufeff`). Always write text files using:
  `[System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($false))`
- **Key-Value Syntax**: `descriptor.mod` must strictly follow `key="value"` without spaces around the `=` operator.
- **Bracket Balance**: Curly braces `{}` and double quotes `""` must always be strictly balanced.
- **No Empty Blocks**: Avoid empty blocks such as `unique = { }` or `ordered = { }`.

## 3. Build & Automation Protocol
- Always run pre-flight syntax and descriptor checks before declaring work complete:
  `powershell -File .\build.ps1 -ValidateOnly`
- Run the full automated Pester test suite:
  `powershell -File .\build.ps1 -Test`
- Use `.\build.ps1 -DevLink` for zero-copy live editing directly from the repository.
- Use `.\build.ps1 -Package` to verify that release packaging strictly excludes `.git`, `.github`, `.vscode`, `tests`, `wiki`, and developer scripts.

## 4. Git & Commit Guidelines
- Do not commit to the Git repository unless explicitly instructed by the user. The user prefers to review changes before committing.
- **Git Verification Invariant**: After completing changes, always verify `git status` to ensure the working tree reflects expected changes.

## 5. Hearts of Iron IV Character & General Invariants
- **Clausewitz Character System (v1.11+)**: All unit leaders (corps commanders and field marshals) are authored in `common/characters/ige_<TAG>_characters.txt` under the root `characters = { ... }` block.
- **Zero-Conflict Recruitment Strategy**: Never overwrite vanilla `history/countries/TAG.txt` files to recruit generals. Always recruit custom generals dynamically using `common/on_actions/ige_on_actions.txt` with `on_startup = { effect = { TAG = { recruit_character = <TAG_name> } } }` to ensure 100% compatibility with vanilla, historical overhauls, and Road to 56.
- **Portrait Technical Standards**:
  - Army Leader Portraits (large): `156x210` pixels, `.dds` format (BC3/DXT5 or uncompressed 8.8.8.8 ARGB) in `gfx/leaders/<TAG>/`.
  - Division / Advisor Portraits (small): `65x67` pixels, `.dds` format (BC3/DXT5).
  - All portraits must have corresponding `spriteType` definitions declared in `interface/ige_portraits.gfx`.
- **Localisation Encoding**: While Clausewitz `.txt` and `.gfx` files must be UTF-8 without BOM, HOI4 YAML localisation files (`localisation/english/*.yml`) **MUST** be encoded in UTF-8 with BOM (`0xEF, 0xBB, 0xBF`) and begin with `l_english:`.
- **Character Skills & Traits**:
  - `skill`: Integer 1 to 5.
  - `attack_skill`, `defense_skill`, `planning_skill`, `logistics_skill`: Integer 1 to 10.
  - Always assign `legacy_id = -1`.
- **In-Game Debug Console**: Test in-game with `-debug`. Use `reload characters`, `reload interface`, and `reload textures` to instantly hot-reload without restarting the game.