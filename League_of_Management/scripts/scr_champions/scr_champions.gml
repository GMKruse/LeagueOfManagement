#region //champion pool
function init_champion_pool() {
    global.champion_pool = { 
	    top: [
	        // Shen - Tank/Teamwork focused, global ultimate
	        create_champion("Shen", "Top", 0.9, 1.3, 1.1, 0.9, 1.1, 1.0),
	        // Aatrox - Mechanics heavy, early game bully
	        create_champion("Aatrox", "Top", 1.3, 0.9, 0.9, 1.2, 1.0, 0.9),
	        // Rumble - Knowledge/positioning, teamfight monster
	        create_champion("Rumble", "Top", 1.0, 1.0, 1.2, 1.0, 1.2, 1.1),
	        // Duelist, high mechanics scaling
	        create_champion("Fiora", "Top", 1.5, 0.8, 1.0, 1.2, 1.1, 1.3),
			// Simple mechanics, teamwork engage
	        create_champion("Malphite", "Top", 0.8, 1.2, 1.0, 1.0, 1.1, 1.0), 
			 // Weak early, insane late scaling
	        create_champion("Kayle", "Top", 1.0, 0.9, 1.2, 0.7, 0.9, 1.4),
			// Precision duelist with strong mid-game
			create_champion("Camille", "Top", 1.4, 1.0, 1.1, 1.1, 1.2, 1.1),
			// Late scaling tank with team utility
			create_champion("Ornn", "Top", 0.9, 1.4, 1.0, 0.8, 1.1, 1.2)
	    ],
	    jungle: [
	        // Lee Sin - High mechanics, early game aggro
	        create_champion("Lee Sin", "Jungle", 1.4, 0.8, 1.0, 1.3, 1.0, 0.8),
	        // Shyvana - Farming jungler, scales into late
	        create_champion("Shyvana", "Jungle", 0.9, 0.9, 1.0, 0.8, 1.0, 1.3),
	        // Kindred - Mechanics + knowledge, scaling marksman
	        create_champion("Kindred", "Jungle", 1.2, 0.9, 1.2, 0.9, 1.1, 1.2),
	        // Early gank pressure, mechanics heavy
	        create_champion("Elise", "Jungle", 1.3, 0.9, 1.1, 1.3, 1.1, 0.8),
			 // Teamfight tank, CC synergy
	        create_champion("Sejuani", "Jungle", 0.9, 1.3, 1.0, 0.9, 1.1, 1.1),
			// Isolated duelist, mechanics focused
	        create_champion("Kha'Zix", "Jungle", 1.4, 0.8, 1.1, 1.2, 1.2, 1.0),
			// Skillshot-based, mechanics high
			create_champion("Nidalee", "Jungle", 1.5, 0.8, 1.1, 1.2, 1.1, 1.0),
			// Teamfight CC and sustain tank
			create_champion("Zac", "Jungle", 0.9, 1.4, 1.0, 0.9, 1.2, 1.2)
	    ],
	    mid: [
	        // Yasuo - Extremely mechanics heavy, high risk/reward
	        create_champion("Yasuo", "Mid", 1.5, 0.8, 0.8, 1.0, 1.1, 1.2),
	        // Galio - Teamwork focused, roaming, engage
	        create_champion("Galio", "Mid", 0.8, 1.4, 1.1, 0.9, 1.2, 1.0),
	        // Anivia - Knowledge/positioning, control mage
	        create_champion("Anivia", "Mid", 0.9, 1.0, 1.4, 0.8, 1.0, 1.3),
	        // Assassin, mechanics intensive
	        create_champion("Zed", "Mid", 1.5, 0.8, 1.0, 1.2, 1.2, 0.9),
			// Knowledge/positioning mage
	        create_champion("Orianna", "Mid", 1.0, 1.2, 1.3, 0.9, 1.2, 1.2),
			// Adaptive scaling, mechanics heavy
	        create_champion("Sylas", "Mid", 1.3, 1.0, 1.2, 1.0, 1.2, 1.1),
			// Infinite scaling mage
			create_champion("Veigar", "Mid", 0.9, 1.0, 1.3, 0.8, 1.0, 1.4),
			// Burst assassin, high mechanics
			create_champion("Akali", "Mid", 1.5, 0.8, 1.1, 1.1, 1.2, 1.2)
	    ],
	    adc: [
	        // Vayne - Mechanics heavy, late game hyper carry
	        create_champion("Vayne", "ADC", 1.4, 0.8, 0.9, 0.7, 0.9, 1.4),
	        // Ashe - Utility/teamwork, consistent throughout
	        create_champion("Ashe", "ADC", 0.9, 1.2, 1.1, 1.0, 1.1, 1.1),
	        // Jhin - Mechanics + knowledge, positioning crucial
	        create_champion("Jhin", "ADC", 1.3, 0.9, 1.2, 1.1, 1.2, 1.0),
	        // Snowball early, mechanics heavy
	        create_champion("Draven", "ADC", 1.5, 0.8, 1.0, 1.3, 1.1, 0.9),
			// Flexible scaling, hybrid damage
	        create_champion("Kai'Sa", "ADC", 1.3, 1.0, 1.1, 0.9, 1.1, 1.3),
			// Lane bully, knowledge positioning
	        create_champion("Caitlyn", "ADC", 1.1, 1.0, 1.2, 1.2, 1.1, 1.0),
			// Safe poke ADC, mechanics + knowledge
			create_champion("Ezreal", "ADC", 1.4, 0.9, 1.2, 1.0, 1.2, 1.2),
			// Combo-based, high mechanical ceiling
			create_champion("Samira", "ADC", 1.5, 0.9, 1.0, 1.2, 1.2, 1.1)
	    ],
	    support: [
	        // Janna - Teamwork/peel, protective enchanter
	        create_champion("Janna", "Support", 0.8, 1.4, 1.0, 0.9, 1.0, 1.1),
	        // Bard - Knowledge heavy, roaming support
	        create_champion("Bard", "Support", 1.0, 1.1, 1.4, 1.1, 1.2, 1.0),
	        // Thresh - Mechanics + teamwork, playmaking
	        create_champion("Thresh", "Support", 1.3, 1.2, 0.9, 1.1, 1.1, 0.9),
	        // Engage tank support
	        create_champion("Leona", "Support", 1.0, 1.3, 1.0, 1.2, 1.2, 1.0),
			// Knowledge + teamwork enchanter
	        create_champion("Nami", "Support", 0.9, 1.3, 1.2, 1.0, 1.1, 1.2),
			// Assassin support, mechanics reliant
	        create_champion("Pyke", "Support", 1.4, 1.0, 1.0, 1.2, 1.1, 1.0),
			// Buff/utility enchanter
			create_champion("Lulu", "Support", 0.9, 1.4, 1.2, 1.0, 1.1, 1.2),
			// Engage/disengage hybrid
			create_champion("Rakan", "Support", 1.2, 1.3, 1.1, 1.1, 1.2, 1.1)
	    ]
	};
}

#endregion


function create_champion(_name, _role, _mech_scale, _team_scale, _know_scale, _early_power, _mid_power, _late_power) {
    return {
        name: _name,
        role: _role,
        mechanics_scaling: _mech_scale,     // Multiplier for mechanics stat
        teamwork_scaling: _team_scale,      // Multiplier for teamwork stat
        knowledge_scaling: _know_scale,     // Multiplier for knowledge stat
        early_power: _early_power,          // 0.7 - 1.3 (power spike timing)
        mid_power: _mid_power,
        late_power: _late_power
    };
}