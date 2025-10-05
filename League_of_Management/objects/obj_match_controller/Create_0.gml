// Initialize pools
init_champion_pool();
init_player_pool();

// Create player draft state (first draft)
player_draft = create_player_draft_state();
champion_ban = noone; 
champion_draft = noone;

// Initialize variables
match_simulated = false;
match_started = false;
winner = noone;
teams_created = false;
ai_pick_timer = 0;
match_state = noone;
map_state = noone;
player_draft_complete = false;
ban_phase_complete = false;

global.banned_champions = [];