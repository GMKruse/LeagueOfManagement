// Button Press Event - Destroy Random Attackable Structure

// Build array of all attackable structures
var all_attackable = [];

// Add all attackable towers
for (var i = 0; i < array_length(global.attackableTowers); i++) {
    array_push(all_attackable, global.attackableTowers[i]);
}

// Add all attackable inhibitors
for (var i = 0; i < array_length(global.inhibitorArray); i++) {
    if (global.inhibitorArray[i].is_attackable) {
        array_push(all_attackable, global.inhibitorArray[i]);
    }
}

// Add all attackable nexuses
for (var i = 0; i < array_length(global.nexusArray); i++) {
    if (global.nexusArray[i].is_attackable) {
        array_push(all_attackable, global.nexusArray[i]);
    }
}

// Destroy a random one
if (array_length(all_attackable) > 0) {
    var random_index = irandom(array_length(all_attackable) - 1);
    var structure_to_destroy = all_attackable[random_index];
    
    // Determine what type it is and log it
    if (object_get_name(structure_to_destroy.object_index) == "obj_tower") {
        show_debug_message("Destroying TOWER " + string(structure_to_destroy.given_id) + 
                          " - Type: " + string(structure_to_destroy.tower_type) + 
                          " Lane: " + string(structure_to_destroy.lane) + 
                          " Team: " + string(structure_to_destroy.team));
        destroy_tower(structure_to_destroy);
    } 
    else if (object_get_name(structure_to_destroy.object_index) == "obj_inhibitor") {
        show_debug_message("Destroying INHIBITOR " + string(structure_to_destroy.given_id) + 
                          " - Lane: " + string(structure_to_destroy.lane) + 
                          " Team: " + string(structure_to_destroy.team));
        destroy_inhibitor(structure_to_destroy);
    } 
    else if (object_get_name(structure_to_destroy.object_index) == "obj_nexus") {
        show_debug_message("Destroying NEXUS - Team: " + string(structure_to_destroy.team));
        destroy_nexus(structure_to_destroy);
    }
    
    show_debug_message("Total attackable structures remaining: " + string(array_length(all_attackable) - 1));
} else {
    show_debug_message("No attackable structures remaining! Game should be over.");
}