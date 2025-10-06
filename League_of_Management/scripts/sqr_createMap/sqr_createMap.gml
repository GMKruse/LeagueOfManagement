towerXPotitions = [
	440,
	455,
	410,
	535,
	575,
	410,
	590,
	690,
	410,
	665,
	860,
	
	955,
	980,
	835,
	880,
	1005,
	700,
	830,
	1005,
	520,
	750,
	1005
]

towerYPotitions = [
	540, 
	560,
	450,
	490,
	600,
	370,
	450,
	600,
	215,
	370,
	600,
	
	110,
	135,
	80,
	195,
	230,
	80,
	240,
	330,
	80,
	310,
	460
]

// var towerPotitions = [
//		blueNexusTowerTop
//		blueNexusTowerBot
//		blueInhibitorTowerTop
//		blueInhibitorTowerMid
//		blueInhibitorTowerBot
//		blueInnerTowerTop
//		blueInnerTowerMid
//		blueInnerTowerBot
//		blueOutterTowerTop
//		blueOutterTowerMid
//		blueOutterTowerBot

//		redNexusTowerTop
//		redNexusTowerBot
//		redInhibitorTowerTop
//		redInhibitorTowerMid
//		redInhibitorTowerBot
//		redInnerTowerTop
//		redInnerTowerMid
//		redInnerTowerBot
//		redOutterTowerTop
//		redOutterTowerMid
//		redOutterTowerBot
//]


inhibitorXPositions = [
410,
507,
540,
	
870,
915,
1005
]

inhibitorYPositions = [
490,
513,
600,

80,
170,
190 
]

//inhibitorPositions = [
//	blueTop,
//	blueMid,
//	blueBot,
	
//	redTop,
//	redMid,
//	redBot
//]

nexusXPositions = [
	420,

	995
]

nexusYPositions = [
	585,

	90
]

//nexusPosition = [
//	blue,

//	red
//]


function createTowers(){
	if(array_length(global.towerXPotitions) == array_length(global.towerYPotitions)){
		for(i = 0; i < array_length(global.towerXPotitions); i++){		
			var tower = instance_create_depth(global.towerXPotitions[i], global.towerYPotitions[i], -1, obj_tower)
			with(tower){
				self.image_xscale = 0.04 
				self.image_yscale = 0.04
				self.alive = true
			}
		}
	}
}

function createInhibitors(){
	if(array_length(global.inhibitorXPositions) == array_length(global.inhibitorYPositions)){
		for(i = 0; i < array_length(global.inhibitorXPositions); i++){		
			var inhibitor = instance_create_depth(global.inhibitorXPositions[i], global.inhibitorYPositions[i], -1, obj_inhibitor)
			with(inhibitor){
				self.image_xscale = 0.04 
				self.image_yscale = 0.04
			}
		}
	}
}

function createNexus(){
	if(array_length(global.nexusXPositions) == array_length(global.nexusYPositions)){
		for(i = 0; i < array_length(global.nexusXPositions); i++){		
			var nexus = instance_create_depth(global.nexusXPositions[i], global.nexusYPositions[i], -1, obj_nexus)
			with(nexus){
				self.image_xscale = 0.06 
				self.image_yscale = 0.06
			}
		}
	}
}

function toggleDragon(){
	var dragon = instance_create_depth(832, 468, -1, obj_dragon)
	with(dragon){
		self.image_xscale = 0.1
		self.image_yscale = 0.1
	}
	//if(dragon.alive){
	//	with(dragon){
	//		self.alive = false
	//	}
	//} else if (spawn_dragon) {
	//	with(dragon){
	//		self.alive = true
			
	//	}
	//}
}


function toggleBaron(){
	var baron = instance_create_depth(590, 215, -1, obj_baron)
	with(baron){
		self.image_xscale = 0.1 
		self.image_yscale = 0.1
	}
}