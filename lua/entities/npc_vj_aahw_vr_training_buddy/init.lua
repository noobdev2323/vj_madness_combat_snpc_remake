AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 30
ENT.VJ_IsHugeMonster = false -- Is this a huge monster?
ENT.HullType = HULL_HUMAN
ENT.HasHull = true -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Green" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.CustomBlood_Decal = {} -- Decals to spawn when it's damaged
--------------------------------------------------------------------------------------------------------------
ENT.DeathCorpseFade = true -- Fades the ragdoll on death
ENT.DeathCorpseFadeTime = 0.5 -- How much time until the ragdoll fades | Unit = Seconds

ENT.VJ_NPC_Class = {"CLASS_AAHW"} -- NPCs with the same class with be allied to each other

ENT.HasSounds = true -- Put to false to disable ALL sound
ENT.SoundTbl_Pain = {"noob_dev2323/madness/vr_guy/VRGuyPain1.wav","noob_dev2323/madness/vr_guy/VRGuyPain2.wav","noob_dev2323/madness/vr_guy/VRGuyPain3.wav","noob_dev2323/madness/vr_guy/VRGuyPain5.wav","noob_dev2323/madness/vr_guy/VRGuyPain6.wav","noob_dev2323/madness/vr_guy/VRGuyPain7.wav","noob_dev2323/madness/vr_guy/VRGuyPain8.wav"}
ENT.SoundTbl_Death = {"noob_dev2323/madness/vr_guy/VRGuyDeath1.wav","noob_dev2323/madness/vr_guy/VRGuyDeath2.wav","noob_dev2323/madness/vr_guy/VRGuyDeath3.wav","noob_dev2323/madness/vr_guy/VRGuyDeath4.wav"}

ENT.PainSoundLevel = 130
ENT.DeathSoundLevel = 130
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.totalDamage = {}
	self:SetMaterial("models/grunt/debugwireframe") -- set material
end
function ENT:MeleeAttackKnockbackVelocity(hitEnt)
	return self:GetForward()*math.random(100, 140) + self:GetUp()*10
end
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
	if GetConVar("vj_madness_gore"):GetInt() == 1 then
   		local damageForce = dmginfo:GetDamageForce():Length()
    	self.totalDamage[hitgroup] = (self.totalDamage[hitgroup] or 0) + damageForce
			if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 12000	 then    -- Dismember heads code
				self.head_less = true
   		 	end
		if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
			self.head_damage = true
    	end
		if hitgroup == HITGROUP_LEFTLEG and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
			madness_combat_snpc_doText(self,"my LEG")
			self.l_leg = true
   		end
		if hitgroup == HITGROUP_RIGHTLEG and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
			madness_combat_snpc_doText(self,"my LEG")
			self.R_leg = true
    	end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	self.gibbed_aiaia = true
end

function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	local bones = {
		"r_upper_arm",
		"r_lower_arm",
		"l_upper_arm",
		"l_lower_arm",
	}
	for k, v in pairs( bones ) do
		local head_bone = corpseEnt:LookupBone(v)
		local bone = corpseEnt:TranslateBoneToPhysBone(head_bone)
		local colide = corpseEnt:GetPhysicsObjectNum( bone )
		colide:EnableCollisions(false)
		colide:EnableGravity(false)
	end
	for i = 0, corpseEnt:GetPhysicsObjectCount() - 1 do
		local colide = corpseEnt:GetPhysicsObjectNum( i )
		colide:EnableGravity(false)
    end
	if self.head_less then
		corpseEnt:SetBodygroup(1, 1)
	end
	if self.head_damage then
		if self.head_less then return end
		corpseEnt:SetBodygroup(1, 2)
	end
	if self.gibbed_aiaia then
		local bone = corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("head"))
		corpseEnt:RemoveInternalConstraint(bone)
	end
	if self.l_leg then
		local bone = corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("L_foot"))
		corpseEnt:RemoveInternalConstraint(bone)
	end
	if self.R_leg then
		local bone = corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("R_foot"))
		corpseEnt:RemoveInternalConstraint(bone)
	end
	dmginfo:SetDamageForce(dmginfo:GetDamageForce())
	corpseEnt:TakeDamageInfo(dmginfo)
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
