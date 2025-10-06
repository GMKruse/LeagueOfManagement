
function destroyTower(towerId){
	instance_destroy(towerId)
	for(i = 0; i < array_length(attackableTowers); i++){
		if(i == towerId){
			array_delete(attackableTowers, i, 1)
		}
	}
	//if(towerId == 8 || ){
	//	array_push(attackableTowers, towerArray[])
	//}
}