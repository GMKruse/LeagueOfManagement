#region // variables
towerArray = []
attackableTowers = []
inhibitorArray = []

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

// var towerPotitions = [			Id:
//		blueNexusTowerTop			0
//		blueNexusTowerBot			1
//		blueInhibitorTowerTop		2
//		blueInhibitorTowerMid		3
//		blueInhibitorTowerBot		4
//		blueInnerTowerTop			5
//		blueInnerTowerMid			6
//		blueInnerTowerBot			7
//		blueOutterTowerTop			8
//		blueOutterTowerMid			9
//		blueOutterTowerBot			10

//		redNexusTowerTop			11
//		redNexusTowerBot			12
//		redInhibitorTowerTop		13
//		redInhibitorTowerMid		14
//		redInhibitorTowerBot		15
//		redInnerTowerTop			16
//		redInnerTowerMid			17
//		redInnerTowerBot			18
//		redOutterTowerTop			19
//		redOutterTowerMid			20
//		redOutterTowerBot			21
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
#endregion

function createTowers(){
	if(array_length(global.towerXPotitions) == array_length(global.towerYPotitions)){
		for(i = 0; i < array_length(global.towerXPotitions); i++){		
			var tower = instance_create_depth(global.towerXPotitions[i], global.towerYPotitions[i], -1, obj_tower)
			with(tower){
				self.givenId = i 
				self.image_xscale = 0.04 
				self.image_yscale = 0.04
			}
			array_push(towerArray, tower.givenId)
			if(tower.givenId == 8 || tower.givenId == 9 || tower.givenId == 10 || tower.givenId == 19 || tower.givenId == 20 || tower.givenId == 21){
				array_push(attackableTowers, tower.givenId)
			}
		}
	}
}

function createInhibitors(){
	if(array_length(global.inhibitorXPositions) == array_length(global.inhibitorYPositions)){
		for(i = 0; i < array_length(global.inhibitorXPositions); i++){		
			var inhibitor = instance_create_depth(global.inhibitorXPositions[i], global.inhibitorYPositions[i], -1, obj_inhibitor)
			array_push(inhibitorArray, inhibitor.id)
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

function createDragon(){
	var dragon = instance_create_depth(832, 468, -1, obj_dragon)
	with(dragon){
		self.image_xscale = 0.1
		self.image_yscale = 0.1
	}
}


function createBaron(){
	var baron = instance_create_depth(590, 215, -1, obj_baron)
	with(baron){
		self.image_xscale = 0.1 
		self.image_yscale = 0.1
	}
}