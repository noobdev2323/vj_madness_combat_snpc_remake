AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 20

ENT.VJ_NPC_Class = {"CLASS_AAHW"} -- NPCs with the same class with be allied to each other
  
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.totalDamage = {}
	self.GetDamageType = {} --need to gib work
	self.gib_type = "ok"
	self.melee = true 
	local melee = math.random(1,4)
	if melee == 1 then
		bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_bowieKnife.mdl",self)
		self.MeleeAttackDamage = 35
		self.MeleeAttackDamageType = DMG_SLASH
		self.AnimTbl_MeleeAttack = {"vjges_stab","vjges_melee_attack_01"}
		self.SoundTbl_MeleeAttack = {"noob_dev2323/madness/melee/slash_01.wav","noob_dev2323/madness/melee/slash_02.wav","noob_dev2323/madness/melee/slash_03.wav","noob_dev2323/madness/melee/slash_04.wav"}
	elseif melee == 2 then
		bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_iron_knife.mdl",self)
		self.MeleeAttackDamage = 35
		self.MeleeAttackDamageType = DMG_SLASH
		self.AnimTbl_MeleeAttack = {"vjges_stab","vjges_melee_attack_01"}
		self.SoundTbl_MeleeAttack = {"noob_dev2323/madness/melee/slash_01.wav","noob_dev2323/madness/melee/slash_02.wav","noob_dev2323/madness/melee/slash_03.wav","noob_dev2323/madness/melee/slash_04.wav"}
	elseif melee == 3 then
		bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_bat.mdl",self)
		self.MeleeAttackDamage = 35
		self.MeleeAttackDamageType = DMG_CLUB
		self.AnimTbl_MeleeAttack = {"vjges_melee_attack_01"}
		self.SoundTbl_MeleeAttack = {"noob_dev2323/madness/melee/Hit_1.wav","noob_dev2323/madness/melee/Hit_2.wav","noob_dev2323/madness/melee/Hit_3.wav"}
	elseif melee == 4 then
		bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_hammer.mdl",self)
		self.MeleeAttackDamage = 20
		self.MeleeAttackDamageType = DMG_CLUB
		self.AnimTbl_MeleeAttack = {"vjges_melee_attack_01"}
		self.SoundTbl_MeleeAttack = {"noob_dev2323/madness/melee/Hit_1.wav","noob_dev2323/madness/melee/Hit_2.wav","noob_dev2323/madness/melee/Hit_3.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
