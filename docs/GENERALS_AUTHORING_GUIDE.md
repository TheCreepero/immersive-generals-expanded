# Hearts of Iron IV — Generals Authoring & Planning Guide

This guide details the architecture, historical balancing guidelines, portrait formatting, and zero-conflict recruitment strategies for authoring new generals and field marshals in **Immersive Generals Expanded**.

---

## 1. Directory Structure & File Roles

```
immersive-generals-expanded/
|-- common/
|   |-- characters/                 # Character definition scripts (Clausewitz .txt, UTF-8 no BOM)
|   |   |-- ige_characters_template.txt.example
|   |   \-- ige_<TAG>_characters.txt
|   \-- on_actions/                 # Zero-conflict startup recruitment hooks
|       \-- ige_on_actions.txt
|-- interface/
|   \-- ige_portraits.gfx           # SpriteType declarations linking textures to GFX names
|-- gfx/
|   \-- leaders/
|       |-- <TAG>/                  # Historical portrait textures (.dds)
|       |   |-- portrait_<TAG>_<name>.dds       (156x210)
|       |   \-- portrait_<TAG>_<name>_small.dds (65x67)
|-- localisation/
|   \-- english/
|       \-- ige_characters_l_english.yml        # Names & bios (UTF-8 with BOM)
|-- docs/
|   \-- GENERALS_AUTHORING_GUIDE.md # This guide
\-- tests/
    \-- Characters.Tests.ps1        # Automated Pester test suite
```

---

## 2. Anatomy of a Character Block

In Hearts of Iron IV 1.11+ (No Step Back and later), generals are unified under the Clausewitz character system in `common/characters/<filename>.txt` [CHR-001].

### Corps Commander (Army General) Template:

```clausewitz
characters = {
	TAG_first_last = {
		name = TAG_first_last
		portraits = {
			army = {
				large = "GFX_portrait_TAG_first_last"
				small = "GFX_portrait_TAG_first_last_small"
			}
		}
		corps_commander = {
			traits = { infantry_officer trait_reckless }
			skill = 2
			attack_skill = 3
			defense_skill = 2
			planning_skill = 1
			logistics_skill = 2
			legacy_id = -1
		}
	}
}
```

### Field Marshal Template:

```clausewitz
characters = {
	TAG_field_marshal_name = {
		name = TAG_field_marshal_name
		portraits = {
			army = {
				large = "GFX_portrait_TAG_field_marshal_name"
				small = "GFX_portrait_TAG_field_marshal_name_small"
			}
		}
		field_marshal = {
			traits = { offensive_doctrine logistics_wizard }
			skill = 4
			attack_skill = 4
			defense_skill = 3
			planning_skill = 4
			logistics_skill = 3
			legacy_id = -1
		}
	}
}
```

### Key Fields Breakdown:

- **`TAG_first_last`**: Unique character ID across all HOI4 scripts. Always prefix with the 3-letter country TAG.
- **`name`**: Can be a localization key (e.g. `TAG_first_last`) or a direct quoted string (`"First Last"`). Using localization keys allows multi-language support.
- **`portraits.army.large`**: Sprite name defined in `interface/*.gfx`. Rendered in division assignment, army view, and officer selection.
- **`portraits.army.small`**: Sprite name for division commander strip, advisor icons, and combat bubble.
- **`corps_commander` / `field_marshal`**: Defines unit leader role. A character can possess both if they can serve as either general or field marshal.
- **`skill`**: Starting leader level. Vanilla uses 1 to 5 [CHR-006].
- **`attack_skill`, `defense_skill`, `planning_skill`, `logistics_skill`**: Base individual combat statistics. Vanilla start values run from 0 to 6 and are most often 2; stay within 1 to 6 [CHR-006].
- **`legacy_id = -1`**: A convention of this mod. Vanilla writes -1 in about two thirds of its role blocks and a number in the rest [CHR-007].

---

## 3. Skill & Stat Balancing Guidelines

To maintain historical authenticity and game balance, follow this skill tier framework:

| Skill Level | Historical Experience | Typical Rank (1936-1939) | Total Stat Budget | Example Leaders |
| :---: | :--- | :--- | :---: | :--- |
| **Level 1** | Inexperienced, brigade/regimental commander, political appointee | Major General / Colonel | 5 - 7 | Regional militia leaders |
| **Level 2** | Competent peacetime division or corps commander | Major General / Lieutenant General | 8 - 10 | Standard frontline generals |
| **Level 3** | Distinguished combat record, veteran commander, tactical innovator | Lieutenant General / General | 11 - 13 | Frontline corps/army commanders |
| **Level 4** | Outstanding military mind, high operational competence | General / Army Group Commander | 14 - 16 | Top national military leaders |
| **Level 5** | Supreme strategic genius, master of doctrine and maneuver | Field Marshal / Supreme Commander | 17 - 20 | Legendary figures (Manstein, Zhukov, Patton) |

### Stat Roles:
- **Attack**: Frontline offensive damage and combat breakthrough.
- **Defense**: Entrenchment efficiency and defensive defense value.
- **Planning**: Speed of battle plan preparation and maximum planning bonus.
- **Logistics**: Supply consumption reduction and division attrition mitigation.

---

## 4. Traits Reference Catalog

Trait ids and what they do are read from the game, not from a list kept here. A list goes stale with every patch, and the one that stood here named `mountaineer`, which is not a trait id (the vanilla id is `trait_mountaineer`).

- Every unit leader trait: `common/unit_leader/*.txt` in the game folder.
- One trait, with its modifiers: `Find-HoiDefinition.ps1 <trait id> -Type trait` (skill `hoi4-vanilla-lookup`).
- The traits of a comparable vanilla general: `Get-HoiCharacter.ps1 <character id> -ResolveTraits`.
- The name and description the player sees: `Find-HoiLocalisation.ps1 -Key <trait id>`.

---

## 5. Zero-Conflict Recruitment Architecture

### The Problem With `history/countries/TAG.txt`:
Overriding `history/countries/TAG.txt` in a mod replaces vanilla starting tech, ideas, politics, oob, and ministers [LOAD-010]. This creates severe incompatibility with:
- Major total overhaul mods (Road to 56, Kaiserreich, Millenium Dawn)
- Flavor mods touching history
- Official Paradox game updates and DLCs

### The Zero-Conflict Solution (`common/on_actions/`):
Use `common/on_actions/ige_on_actions.txt` with an `on_startup` hook:

```clausewitz
on_actions = {
	on_startup = {
		effect = {
			FIN = {
				recruit_character = FIN_kaarlo_heiskanen
			}
			GER = {
				# recruit_character = GER_example_general
			}
		}
	}
}
```

This runs when a new game starts and recruits the generals without touching a vanilla history file. It rests on what another project saw of `on_startup` [SCR-007] [SCR-008]; with a real character it has not yet been seen working in the game [CHR-003], so check the first general in a new game before authoring more.

---

## 6. Portrait Graphic Specifications

### File Dimensions & Formats:
- **Large Portrait**: `156 x 210` pixels, DirectDraw Surface (`.dds`). Vanilla portraits are uncompressed, 32 or 16 bit [CHR-004].
- **Small Portrait**: `65 x 67` pixels, `.dds` [CHR-005].

### Folder Convention:
Store textures under `gfx/leaders/<TAG>/`:
```
gfx/leaders/FIN/portrait_FIN_kaarlo_heiskanen.dds
gfx/leaders/FIN/portrait_FIN_kaarlo_heiskanen_small.dds
```

### Interface Sprite Definition (`interface/ige_portraits.gfx`):

```clausewitz
spriteTypes = {
	spriteType = {
		name = "GFX_portrait_FIN_kaarlo_heiskanen"
		texturefile = "gfx/leaders/FIN/portrait_FIN_kaarlo_heiskanen.dds"
	}
	spriteType = {
		name = "GFX_portrait_FIN_kaarlo_heiskanen_small"
		texturefile = "gfx/leaders/FIN/portrait_FIN_kaarlo_heiskanen_small.dds"
	}
}
```

---

## 7. Localisation Guidelines

Character names and biographies reside in `localisation/english/ige_characters_l_english.yml`.

- **Encoding**: Must be **UTF-8 with BOM** (`0xEF, 0xBB, 0xBF`), with a file for every language of the game [LOC-001].
- **Header**: First line must be `l_english:`.
- **Indentation**: One space before key.
- **Version suffix**: `:0` followed by space and double-quoted string.

```yaml
l_english:
 FIN_kaarlo_heiskanen:0 "Kaarlo Heiskanen"
 FIN_kaarlo_heiskanen_desc:0 "Kaarlo Aleksanteri Heiskanen (1894-1962), known as 'Kylmä-Kalle', was a Finnish general and Mannerheim Cross Knight who commanded the 11th Division during the Continuation War and later served as Commander of the Finnish Defence Forces."
```

---

## 8. In-Game Live Testing & Development

Launch Hearts of Iron IV with the `-debug` launch parameter.

- A changed `.gfx` file or texture is seen only after a restart: `reload interface` and `reload textures` answer and change nothing [AUTO-005] [AUTO-006].
- `reload characters` and `reload on_actions` have not been tried by any project [CHR-008]. Restart to be sure.
- `on_startup` runs when a new game starts, so start a new game to see a recruitment [CHR-003].

---

## 9. Build & Automated Testing Commands

From the mod root (`mods\immersive-generals-expanded` under the Modding Manager):

```powershell
# 1. Validate all Clausewitz files (.txt, .gfx, descriptor)
.\build.ps1 -ValidateOnly

# 2. Run full automated Pester test suite
.\build.ps1 -Test

# 3. Enable zero-copy DevLink (points launcher directly to repo)
.\build.ps1 -DevLink

# 4. Package clean distribution zip (excluding dev tools)
.\build.ps1 -Package
```
