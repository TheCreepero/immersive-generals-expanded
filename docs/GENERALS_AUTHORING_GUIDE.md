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

In Hearts of Iron IV 1.11+ (No Step Back and later), generals are unified under the Clausewitz character system in `common/characters/<filename>.txt`.

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
- **`skill`**: Starting leader level (1 to 5).
- **`attack_skill`, `defense_skill`, `planning_skill`, `logistics_skill`**: Base individual combat statistics (1 to 10).
- **`legacy_id = -1`**: Required for compatibility with older save formats and engine slot indexing.

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

### Personality Traits (Assigned at start, non-learnable):
- `trait_reckless`: +Attack, higher injury chance.
- `trait_cautious`: +Defense, lower injury chance, slower planning.
- `media_personality`: Political power generation or prestige.
- `harsh_leader`: Low division recovery rate, higher combat bonuses.
- `old_guard`: Reduced XP gain, traditionalist mindset.

### Background / Branch Traits:
- `infantry_officer`: Boosts infantry division coordination and XP.
- `cavalry_officer`: Boosts cavalry and motorized/mechanized units.
- `armor_officer`: Boosts armor division breakthrough and attack.

### Terrain Specialists:
- `mountaineer`: Hills and Mountain combat bonus.
- `hill_fighter`: Hill attack/defense bonus.
- `swamp_fox`: Marsh and swamp combat bonus.
- `desert_fox`: Desert attrition reduction and speed.
- `urban_assault_specialist`: City assault and defense.
- `jungle_rat`: Jungle attrition and movement bonus.
- `ranger`: Forest movement and combat bonus.

### Combat Specializations:
- `trickster`: Reconnaissance bonus and surprise attack chance.
- `winter_specialist`: Reduces winter and deep snow attrition.
- `fortress_buster`: Attack bonus against forts and fortifications.
- `commando`: Special forces (paratroopers, marines, mountaineers) bonus.

### Field Marshal Doctrines:
- `offensive_doctrine`: Increases organization and speed for all assigned armies.
- `defensive_doctrine`: Increases maximum entrenchment for all assigned armies.
- `fast_planner`: Accelerates planning speed across all armies.
- `thorough_planner`: Increases maximum planning cap.
- `logistics_wizard`: Enables extra supply distribution and decreases supply consumption.
- `inspirational_leader`: Increases division recovery rate.
- `unyielding_defender`: Increases combat defense in territory.

---

## 5. Zero-Conflict Recruitment Architecture

### The Problem With `history/countries/TAG.txt`:
Overriding `history/countries/TAG.txt` in a mod replaces vanilla starting tech, ideas, politics, oob, and ministers. This creates severe incompatibility with:
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

This executes dynamically on campaign start, recruiting generals into the correct nation's military officer pool without touching a single vanilla history file!

---

## 6. Portrait Graphic Specifications

### File Dimensions & Formats:
- **Large Portrait**: `156 x 210` pixels, saved in DirectDraw Surface (`.dds`) format using **BC3 / DXT5** (interpolated alpha) or **8.8.8.8 ARGB** uncompressed.
- **Small Portrait**: `65 x 67` pixels, `.dds` format using **BC3 / DXT5**.

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

- **Encoding**: Must be **UTF-8 with BOM** (`0xEF, 0xBB, 0xBF`).
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

Open the in-game console using the tilde key (`~`):
- `reload characters`: Instantly reloads all character definitions in `common/characters/`.
- `reload interface`: Reloads `.gfx` sprite mappings and GUI layouts without restarting.
- `reload textures`: Reloads modified `.dds` textures.
- `reload on_actions`: Reloads on-action scripts.

---

## 9. Build & Automated Testing Commands

From the mod root (`C:\dev\immersive-generals-expanded`):

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
