//createNexus()
//createInhibitors()
//createTowers()
//createDragon()
//createBaron()


init_player_pool()

var blueTeam = createTeam("TSM")
var redTeam = createTeam("C9")

add_palyer_to_team(blueTeam, global.player_pool.top[0])
add_palyer_to_team(blueTeam, global.player_pool.jungle[0])
add_palyer_to_team(blueTeam, global.player_pool.mid[0])
add_palyer_to_team(blueTeam, global.player_pool.adc[1])
add_palyer_to_team(blueTeam, global.player_pool.support[1])

create_team_display(blueTeam, redTeam)
