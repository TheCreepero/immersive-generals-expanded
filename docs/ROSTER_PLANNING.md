# National Roster Planning & Candidate Tracker

This document tracks planned, researched, and implemented generals across nations for **Immersive Generals Expanded**.

---

## Candidate Priority Matrix

| Nation | TAG | Status | Planned Generals | Focus / Military Branch |
| :--- | :---: | :---: | :---: | :--- |
| **Finland** | `FIN` | In Progress | 4 - 6 | Continuation War division & corps commanders, mountain/infantry specialists |
| **Germany** | `GER` | Planning | 6 - 8 | Early-war divisional commanders, armored spearhead leaders |
| **United States** | `USA` | Planning | 6 - 8 | Pacific & European theater corps commanders |
| **United Kingdom** | `ENG` | Planning | 6 - 8 | Desert warfare & colonial defense commanders |
| **Soviet Union** | `SOV` | Planning | 6 - 8 | Deep battle practitioners, defensive fortress commanders |
| **France** | `FRA` | Planning | 4 - 6 | 1940 mobile division leaders & Free French commanders |
| **Japan** | `JAP` | Planning | 4 - 6 | Island defense & jungle assault leaders |
| **Italy** | `ITA` | Planning | 4 - 6 | Alpini & North African mechanized leaders |

---

## Finland (`FIN`) Roster

### Candidates for Implementation:

1. **Kaarlo Aleksanteri Heiskanen ("Kylmä-Kalle")**
   - **Role**: Corps Commander
   - **Rank**: Major General (Kenraalimajuri)
   - **Skill**: Level 3
   - **Stats**: Attack 2, Defense 4, Planning 2, Logistics 2
   - **Traits**: `infantry_officer`, `trait_cautious`
   - **Historical Context**: Commanded the renowned 11th Division ("The Heavy Division") during the Continuation War and repelled Soviet offensives in the VKT-line (Ihantala). Knight of the Mannerheim Cross. Post-war Commander of the Defence Forces (1953-1959).

2. **Taavetti Laatikainen ("Pappa")**
   - **Role**: Field Marshal / Corps Commander
   - **Rank**: Lieutenant General (Kenraaliluutnantti)
   - **Skill**: Level 3
   - **Stats**: Attack 3, Defense 3, Planning 3, Logistics 2
   - **Traits**: `defensive_doctrine`, `infantry_officer`
   - **Historical Context**: Commanded II Corps on the Karelian Isthmus during the Winter War and IV Corps in the Continuation War. Known for his cool composure under intense pressure. Knight of the Mannerheim Cross.

3. **Einar August Vihma**
   - **Role**: Corps Commander
   - **Rank**: Major General (Kenraalimajuri)
   - **Skill**: Level 3
   - **Stats**: Attack 4, Defense 2, Planning 2, Logistics 2
   - **Traits**: `infantry_officer`, `trait_reckless`
   - **Historical Context**: Commanded the 6th Division during the Battle of Tali-Ihantala. Bold frontline commander who was killed in action at Ihantala in July 1944. Two-time recipient of the Mannerheim Cross.

4. **Aarre Tuompo**
   - **Role**: Corps Commander / Staff
   - **Rank**: Lieutenant General (Kenraaliluutnantti)
   - **Skill**: Level 2
   - **Stats**: Attack 1, Defense 3, Planning 4, Logistics 3
   - **Traits**: `infantry_officer`, `thorough_planner`
   - **Historical Context**: Head of Headquarters Command Staff (Päämajan komento-osasto) and right-hand man to Field Marshal Mannerheim throughout the Winter and Continuation Wars.

---

## Implementation Checklist per General

- [ ] Historical biography & dates verified
- [ ] Starting rank and skill tier determined (1-5)
- [ ] Stat distribution allocated (Attack, Defense, Planning, Logistics)
- [ ] Suitable traits selected from catalog
- [ ] Historical portrait sourced & cropped (156x210 large, 65x67 small)
- [ ] Portrait textures converted to `.dds` (BC3/DXT5) in `gfx/leaders/<TAG>/`
- [ ] Sprite declared in `interface/ige_portraits.gfx`
- [ ] Character block written in `common/characters/ige_<TAG>_characters.txt`
- [ ] Dynamic recruitment call added to `common/on_actions/ige_on_actions.txt`
- [ ] Localisation string entered into `localisation/english/ige_characters_l_english.yml`
- [ ] Run `.\build.ps1 -ValidateOnly` and `.\build.ps1 -Test`
- [ ] Verified in-game via `reload characters`
