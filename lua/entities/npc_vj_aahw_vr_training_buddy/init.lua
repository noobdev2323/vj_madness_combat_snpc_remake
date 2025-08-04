AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 30
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Green" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = false  -- Does it spawn a decal when damaged?
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.VJ_NPC_Class = {"CLASS_AAHW"} -- NPCs with the same class with be allied to each other

ENT.HasSounds = true -- Put to false to disable ALL sound
ENT.SoundTbl_Pain = {"noob_dev2323/madness/vr_guy/VRGuyPain1.wav","noob_dev2323/madness/vr_guy/VRGuyPain2.wav","noob_dev2323/madness/vr_guy/VRGuyPain3.wav","noob_dev2323/madness/vr_guy/VRGuyPain5.wav","noob_dev2323/madness/vr_guy/VRGuyPain6.wav","noob_dev2323/madness/vr_guy/VRGuyPain7.wav","noob_dev2323/madness/vr_guy/VRGuyPain8.wav"}
ENT.SoundTbl_Death = {"noob_dev2323/madness/vr_guy/VRGuyDeath1.wav","noob_dev2323/madness/vr_guy/VRGuyDeath2.wav","noob_dev2323/madness/vr_guy/VRGuyDeath3.wav","noob_dev2323/madness/vr_guy/VRGuyDeath4.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"noob_dev2323/madness/vr_guy/VRGuyPain3.wav","noob_dev2323/madness/vr_guy/VRGuyPain4.wav"}
ENT.PainSoundLevel = 130
ENT.DeathSoundLevel = 130

ENT.isVR = true  
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.totalDamage = {}
	self.GetDamageType = {} --need to gib work
	self.gib_type = "ok"
	self:SetMaterial("models/noob_dev2323/madness_combat/shaders/Wireframe") -- set material
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
