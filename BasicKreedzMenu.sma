#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fun>
#include <fakemeta>

#define PLUGIN "Basic Kreedz Menu"
#define VERSION "1.0"
#define AUTHOR "big_biceps"
// ------------------------------
#define PAGE_ZERO 0
#define VISUAL_SHIFT_ONLY 0
#define POSITION_OF_EYES 1

new Float:cpPrevPos[32][3], cpPrevVAngles[32][3], Float:cpPrevAngles[32][3], bool:isCpPrevSet[32];
new Float:cpPrevPrevPos[32][3], Float:cpPrevPrevVAngles[32][3], Float:cpPrevPrevAngles[32][3], bool:isCpPrevPrevSet[32];

new kz_menu;
new bool:isKzMenuOpen[32];

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	create_tp_menu();
	delete_buyzone();
}

public create_tp_menu() {
	kz_menu = menu_create("Kreedz Menu", "menu_handler");
	menu_additem(kz_menu, "Checkpoint", "1");
	menu_additem(kz_menu, "Teleport", "2");
	menu_addblank(kz_menu, VISUAL_SHIFT_ONLY);
	menu_additem(kz_menu, "Stuck", "3");

	// Also allow clients to manually call the commands
	register_clcmd("say /menu", "show_menuu");
	register_clcmd("sayteam /menu", "show_menuu");
	
	register_clcmd("say /cp", "cmdCheckPoint");
	register_clcmd("sayteam /cp", "cmdCheckPoint");
	
	register_clcmd("say /tp", "cmdTeleport");
	register_clcmd("sayteam /tp", "cmdTeleport");
	
	register_clcmd("say /stuck", "cmdStuck");
	register_clcmd("sayteam /stuck", "cmdStuck");
	
	// The built-in command 'chooseteam' is bound to 'm' by defualt,
	// so we hook our own handler to it. As such, clients will
	// be able to open the menu by pressing 'm'.
	register_clcmd("chooseteam", "show_menuu");
}

public delete_buyzone() {
	// TODO: Look into if there's a better way to disallow
	// clients to open buy menu. This needs to be ran after
	// each round end as well after change of maps.
	// No bueno!
	remove_entity_name("info_map_parameters");
	remove_entity_name("func_buyzone");
	new Entity = create_entity("info_map_parameters");
	DispatchKeyValue(Entity, "buying", "3");
	DispatchSpawn(Entity);
}

public show_menuu(id) {
	if (!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if (isKzMenuOpen[id])
		return PLUGIN_HANDLED;
	
	isKzMenuOpen[id] = true;
	
	menu_display(id, kz_menu, PAGE_ZERO);
	return PLUGIN_HANDLED;
}

public menu_handler(id, menu, item) {
	
	if (item == MENU_EXIT)
	{
		isKzMenuOpen[id] = false;
		return PLUGIN_HANDLED;
	}
	
	static accesss, callback, info[6], name[6];
	menu_item_getinfo(kz_menu, item, accesss, info, charsmax(info), name, charsmax(name), callback);

	switch(info[0]) {
		case '1': { cmdCheckPoint(id); }
		case '2': { cmdTeleport(id); }
		case '3': { cmdStuck(id); }
		default: { /* How the heck did we get here? */ }
	}
	
	// Display menu again after selecting an option.
	menu_display(id, kz_menu, 0);
	
	return PLUGIN_HANDLED;
}

stock IsOnGround(id) 
{    
	static flags;
	flags = pev(id, pev_flags);
	return (flags & FL_ONGROUND) 
		|| (flags & FL_PARTIALGROUND) 
		|| (flags & FL_INWATER) 
		|| (flags & FL_CONVEYOR) 
		|| (flags & FL_FLOAT)
}

public cmdCheckPoint(id) {
	
	if (!IsOnGround(id))
		return PLUGIN_HANDLED;
	
	// 3. Stuck
	if (isCpPrevSet[id]) {
		// If there's a previus position available,
		// set it as previous-previus position.
		cpPrevPrevPos[id] = cpPrevPos[id];
		cpPrevPrevVAngles[id] = cpPrevVAngles[id];
		cpPrevPrevAngles[id] = cpPrevAngles[id];
		isCpPrevPrevSet[id] = true;
	}
	
	// 1. Checkpoint
	if(get_user_origin(id, cpPrevPos[id], POSITION_OF_EYES)){
		isCpPrevSet[id] = true;
		pev(id, pev_v_angle, cpPrevVAngles[id]);
		pev(id, pev_angles, cpPrevAngles[id]);
	}

	return PLUGIN_HANDLED;
}

public revert_to(id, Float:pos[3], Float:v_angle[3], Float:angles[3]) {
	
	set_user_origin(id, pos);
	
	// Reset any non-zero momentum.
	static Float:zeroV[3] = {0.0, 0.0, 0.0};
	set_user_velocity(id, zeroV);
	
	// Make player face the direction they were facing when the cp was made.
	set_pev(id, pev_v_angle, v_angle);
	set_pev(id, pev_angles, angles);

	// Force engine to apply new angles.
	entity_set_int(id, EV_INT_fixangle, 1)
}


public cmdTeleport(id) {
	if (!isCpPrevSet[id]) {
		// If the user has not checkpointed at least once, 
		// there's nowhere to teleport to.
		set_hudmessage(225, 225, 225, -1.0, 0.90, 0, 6.0, 1.5, 0.1, 0.2, 4);
		show_hudmessage(id, "You haven't created a checkpoint yet.");
		return PLUGIN_HANDLED;
	}
		
	revert_to(id, cpPrevPos[id], cpPrevVAngles[id], cpPrevAngles[id]);
	return PLUGIN_HANDLED;
}

public cmdStuck(id) {
	if (!isCpPrevPrevSet[id]) {
		// If the user has not checkpointed at least twice,
		// then it's not possible to go back twice.
		set_hudmessage(225, 225, 225, -1.0, 0.90, 0, 6.0, 1.5, 0.1, 0.2, 4);
		show_hudmessage(id, "You only have one checkpoint, can't back twice.");
		return PLUGIN_HANDLED;
	}
	
	// Backing twice means losing the previous position.
	cpPrevPos[id] = cpPrevPrevPos[id];
	cpPrevVAngles[id] = cpPrevPrevVAngles[id];
	cpPrevAngles[id] = cpPrevPrevAngles[id];
	isCpPrevPrevSet[id] = false;
	
	revert_to(id, cpPrevPrevPos[id], cpPrevPrevVAngles[id], cpPrevPrevAngles[id]);
	return PLUGIN_HANDLED;
}
