# Champion Draft Room Setup Guide

## Room Creation Steps

You need to manually create the room in GameMaker Studio 2. Follow these steps:

### 1. Create the Room

1. In GameMaker IDE, right-click on **Rooms** folder
2. Select **Create** > **Room**
3. Name it: `room_champion_draft`

### 2. Room Settings

- **Width**: 1366 (or match your other rooms)
- **Height**: 768 (or match your other rooms)
- **Background**: Use `spr_background` or a suitable background

### 3. Add Controller Instance

1. In the room editor, go to the **Instances** layer
2. Add an instance of `obj_champion_draft_controller`
3. Position it at (0, 0) - position doesn't matter for controllers

### 4. Room Order

Make sure the room order is:

1. `room_create_team` (team name entry)
2. `room_draft_players` (player draft)
3. **`room_champion_draft`** (new! ban/pick phase)
4. `room_game_simulation` (actual game)

## Files Created

### Scripts:

- ✅ `scr_champion_draft/scr_champion_draft.gml` - All champion draft logic (ban + pick phases)
- ✅ `scr_champion_display/scr_champion_display.gml` - Display creation functions

### Objects:

- ✅ `obj_champion_draft_controller/` - Main controller

  - `Create_0.gml` - Initialize draft state
  - `Step_0.gml` - Handle AI turn detection
  - `Draw_0.gml` - Render UI and champions
  - `Alarm_0.gml` - AI ban action
  - `Alarm_1.gml` - AI pick action
  - `Alarm_2.gml` - Refresh display timer

- ✅ `obj_champion_display/` - Individual champion card
  - `Create_0.gml` - Initialize champion display
  - `Draw_0.gml` - Draw champion sprite and name
  - `Mouse_4.gml` - Handle player clicks (ban/pick)

### Modified Files:

- ✅ `obj_draft_players_controller/Step_0.gml` - Now goes to `room_champion_draft` instead of `room_game_simulation`

## How It Works

### Ban Phase (6 bans total):

- Ban order: [Team 1, Team 2, Team 2, Team 1, Team 1, Team 2]
- Player clicks champion to ban when it's their turn
- AI waits 2 seconds then bans randomly
- Banned champions shown on sides of screen
- After 6 bans, automatically transitions to pick phase

### Pick Phase (10 picks total - snake draft):

- Pick order: [1, 2, 2, 1, 1, 2, 2, 1, 1, 2]
- Same as player draft
- Each role drafted in order: Top → Jungle → Mid → ADC → Support
- Banned champions are excluded from available picks
- AI waits 2 seconds between picks
- After all picks, champions are assigned to players

### Transition Flow:

```
room_draft_players (pick players)
    ↓ [Press SPACE]
room_champion_draft (ban + pick champions)
    ↓ [Press SPACE]
room_game_simulation (play the game)
```

## Testing

Once you create the room:

1. Run the game from `room_create_team`
2. Enter team name and create team
3. Draft your 5 players
4. Press SPACE to go to champion draft
5. **Ban 3 champions** (alternating with AI)
6. **Pick 5 champions** (one per role, alternating with AI)
7. Press SPACE to start the match

## Notes

- All player and team instances are persistent (survive room changes)
- Champion sprites will default to `spr_question_mark` if not set
- You can extend `ai_ban_champion` and `ai_pick_champion` for smarter AI logic later
- The system filters out banned champions from pick phase automatically
