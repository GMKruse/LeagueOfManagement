global.player_id_map = {};

init_player_pool()
available_players = []


global.player_team = createTeam(global.team_name)
global.ai_team = createTeam("C9")

with(global.player_team){
	self.side = "Blue"
}
with(global.ai_team){
	self.side = "Red"
}

create_team_display(global.player_team, global.ai_team)

global.player_draft = create_player_draft_state()

// Track if we're waiting for AI to pick
ai_pick_pending = false;

// Show available players immediately
available_players = get_available_players(global.player_draft)

