/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("madness combat remake", "NPC")

local spawnCategory = "madness combat remake" -- Category, you can also set a category individually by replacing the spawnCategory with a string value

VJ.AddNPC("aahw grunt", "npc_vj_aahw_grunt", spawnCategory) -- Adds a NPC to the spawnmenu
VJ.AddNPC("aahw grunt melee", "npc_vj_aahw_grunt_melee", spawnCategory) -- Adds a NPC to the spawnmenu
VJ.AddNPC("aahw vr training buddy", "npc_vj_aahw_vr_training_buddy", spawnCategory) -- Adds a NPC to the spawnmenu

game.AddDecal("VJ_AAWH_GRUNT_BLOOD", {"decals/grunt/Blood01","decals/grunt/Blood02","decals/grunt/Blood03","decals/grunt/Blood04"})
game.AddDecal("VJ_AAWH_GRUNT_YELLOW_BLOOD", {"decals/yellow/yellow_01","decals/yellow/yellow_02","decals/yellow/yellow_03"})