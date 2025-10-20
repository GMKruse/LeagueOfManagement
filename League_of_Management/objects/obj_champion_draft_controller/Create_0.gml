
instance_create_depth(room_width*0.5, room_height*0.45, 0, obj_background)

// Initialize champion pool
if (!variable_global_exists("champion_pool")) {
    init_champion_pool();
}

// Create champion draft state
global.champion_draft = create_champion_draft_state();

// Track available champions for current phase
// Initialize with actual champions for ban phase
available_champions = get_available_champions_for_ban(global.champion_draft);

// Track AI action pending
ai_action_pending = false;

// Display team rosters on sides
create_team_display(global.player_team, global.ai_team);

show_debug_message("Champion draft controller initialized");
show_debug_message("Starting ban phase...");
show_debug_message("Available champions: " + string(array_length(available_champions)));

// Show initial available champions after a short delay
alarm[2] = 10;
