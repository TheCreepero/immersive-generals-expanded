# Immersive Generals Expanded - Agent Rules

Shared rules for every mod in this tree (file encodings, build commands, engine knowledge, git) are in the Modding Manager's `../../GEMINI.md`; Claude Code loads it by itself, Antigravity reads it first.

## What this mod is
- Adds historical corps commanders and field marshals as characters, recruited at game start without touching vanilla country history files; not yet on the Workshop. `docs/GENERALS_AUTHORING_GUIDE.md` is the authoring guide, `docs/ROSTER_PLANNING.md` the roster plan.

## Mod invariants
- Characters are authored in `common/characters/ige_<TAG>_characters.txt` under a root `characters = { ... }` block [CHR-001].
- Never overwrite `history/countries/<TAG>.txt`: the mod's copy would replace the whole file [LOAD-010]. Recruit from `common/on_actions/ige_on_actions.txt` with `on_startup` and `recruit_character` (guide section 5). The technique has not yet been seen working with a real character [CHR-003]: check the first general in a new game before authoring more.
- Portraits: large `156x210` uncompressed `.dds` under `gfx/leaders/<TAG>/` [CHR-004], small `65x67` [CHR-005], each with a `spriteType` in `interface/ige_portraits.gfx` (guide section 6).
- `skill` 1 to 5 and the four sub-skills within vanilla's start range of 1 to 6 [CHR-006]; `legacy_id = -1` is this mod's convention [CHR-007]; look every trait id up with `hoi4-vanilla-lookup`, never from memory.
- Localisation exists for every language of the game and starts with `l_<language>:` [LOC-001].
- A changed `.gfx` file or texture is seen only after a restart [AUTO-005] [AUTO-006]; whether `reload characters` works is untried [CHR-008].

## Commands beyond build.ps1
- None.

## Read when
| Task | Read |
|---|---|
| Authoring a character | `docs/GENERALS_AUTHORING_GUIDE.md` sections 2 to 4 (block anatomy, stats, traits) |
| Recruitment or portraits | guide sections 5 and 6 |
| Choosing the next nation | `docs/ROSTER_PLANNING.md` |

## Engine Knowledge
- Engine facts live in the Modding Manager's register, reached through the user-level `hoi4-modding-knowledge` skill: search it before a new kind of file and before asking for a game launch, cite ids here, never write a fact into this repository.
- Topics this mod leans on: `characters`, `localisation`, `encoding-and-syntax`, `loading-and-overrides`.
- `tests/Knowledge.Tests.ps1` runs the register's audit for this repository; it is a copy the Manager keeps current.
