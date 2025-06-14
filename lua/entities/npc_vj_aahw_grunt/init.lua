AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 20 -- or you can use a convar: GetConVarNumber("vj_dum_dummy_h")
ENT.VJ_NPC_Class = {"CLASS_AAHW"} -- NPCs with the same class with be allied to each other

ENT.ControllerParams = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "head", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 20), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
ENT.DeathCorpseSetBoneAngles = true -- This can be used to stop the corpse glitching or flying on death
ENT.DeathCorpseApplyForce = false -- If false, force will not be applied to the corpse

ENT.RunAwayOnUnknownDamage = true -- Should run away on damage

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamageType = DMG_CLUB
ENT.AnimTbl_MeleeAttack = {"vjges_punch01","vjges_punch02"} -- Melee Attack Animations
ENT.MeleeAttackAnimationAllowOtherTasks = true -- If set to true, the animation will not stop other tasks from playing, such as chasing | Useful for gesture attacks!
ENT.MeleeAttackDistance = 50 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 120 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0	 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 10

ENT.AnimTbl_Flinch = {"vjges_flinch"} -- If it uses normal based animation, use this
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {DMG_BLAST} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 1 -- Chance of it flinching from 1 to x | 1 will make it always flinch
	-- To let the base automatically detect the animation duration, set this to false:
ENT.NextMoveAfterFlinchTime = false -- How much time until it can move, attack, etc.
ENT.NextFlinchTime = 0.5 -- How much time until it can flinch again?
ENT.FlinchAnimationDecreaseLengthAmount = 0 -- This will decrease the time it can move, attack, etc. | Use it to fix animation pauses after it finished the flinch animation
ENT.HitGroupFlinching_DefaultWhenNotHit = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = nil -- EXAMPLES: {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}

ENT.HasSounds = true -- Put to false to disable ALL sound
ENT.SoundTbl_MeleeAttack = {"killer_chicken/peck.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"noob_dev2323/madness/grunt/Grunt.wav","noob_dev2323/madness/grunt/Grunt-1.wav","noob_dev2323/madness/grunt/Grunt-2.wav","noob_dev2323/madness/grunt/Grunt-3.wav","noob_dev2323/madness/grunt/Grunt-4.wav","noob_dev2323/madness/grunt/Grunt-5.wav","noob_dev2323/madness/grunt/Grunt-6.wav","noob_dev2323/madness/grunt/Grunt-7.wav","noob_dev2323/madness/grunt/Grunt-8.wav"}

ENT.DamageResponse = true -- Should it respond to damages while it has no enemy?
ENT.Weapon_Disabled = true  -- Disable the ability for it to use weapons
ENT.Weapon_IgnoreSpawnMenu = true -- Should it ignore weapon overrides from the spawn menu?
ENT.DropDeathLoot = false -- Should it drop loot on death?
ENT.grunt_NextStumbleT = CurTime() + 3
ENT.grunt_NextText = CurTime() + 3
ENT.isVR = false 
ENT.Weapon_UnarmedBehavior = false   
ENT.Weapon_CanCrouchAttack = false  -- Can it crouch while firing a weapon?
ENT.AnimTbl_WeaponAttack = true    -- Animations to play while firing a weapon
ENT.AnimTbl_WeaponAttackCrouch = false  -- Animations to play while firing a weapon in crouched position
ENT.AnimTbl_WeaponAttack = ACT_RANGE_ATTACK1 -- Animations to play while firing a weapon
ENT.AnimTbl_WeaponAttackGesture = ACT_GESTURE_RANGE_ATTACK1 -- Gesture animations to play while firing a weapon | false = Don't play an animation
ENT.grunt_status = {
	life = 30
}

function ENT:CustomOnInitialize()
	self.totalDamage = {}
	self.GetDamageType = {} --need to gib work
	self.gib_type = "ok"
end

function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
	local dotext = math.random(1,2)
	if dotext == 2 then
		if CurTime() > self.grunt_NextText then
			self.grunt_NextText = CurTime() + 3
			madness_combat_snpc_doText(self,table.Random( madness_npc_text ))	
		end
	end
	if self:Health() <= (self:GetMaxHealth() / 2.2) then
		self.NextAnyAttackTime_Melee = 0.5	 -- How much time until it can use any attack again? | Counted in Seconds
		self.MeleeAttackDamage = 7
		self.AnimTbl_MeleeAttack = {"vjges_punch_hunt_01","vjges_punch_hunt_02"} -- Melee Attack Animations
	end
	if GetConVar("vj_madness_gore"):GetInt() == 1 then
   		local damageForce = dmginfo:GetDamageForce():Length()
    	self.totalDamage[hitgroup] = (self.totalDamage[hitgroup] or 0) + damageForce


		if self.totalDamage[hitgroup] > 4000 then
			if hitgroup == 13 then
				self.gib_type = "head_damege"
				self.head_damege_type = 3 
			elseif hitgroup == 14 then
				self.gib_type = "head_damege"
				self.head_damege_type = 4
			elseif hitgroup == 15 then
				self.gib_type = "head_less"
			elseif hitgroup == 16 then  
				self.gib_type = "head_damege" 
				self.head_damege_type = 2
			elseif hitgroup == 17 then
				self.gib_type = "head_damege"
				self.head_damege_type = 5
			end
			if hitgroup == HITGROUP_LEFTLEG then --Dismember foot code
				madness_combat_snpc_doText(self,"my LEG")
				self.gib_type = "l_leg"
			elseif hitgroup == HITGROUP_RIGHTLEG then --Dismember foot code
				madness_combat_snpc_doText(self,"my LEG")
				self.gib_type = "R_leg"
			end
		end
		if hitgroup == 13 or hitgroup == 14 or hitgroup == 17 or hitgroup == 16 or hitgroup == 15 and self.totalDamage[hitgroup] > 12000 then
			if dmginfo:IsDamageType(DMG_SLASH) then
				local slice = math.random(1,2)
				if slice == 2 then
					self.gib_type = "decapted"
				elseif slice == 1 then 
					self.gib_type = "head_slash"
				end
			elseif self.totalDamage[hitgroup] > 12000 then
				self.gib_type = "head_less"
			end
        end
		if hitgroup == 2 or hitgroup == 3 then --Dismember foot code
			if dmginfo:IsDamageType(DMG_SLASH) and self.totalDamage[hitgroup] > 12000 then
				self.gib_type = "half"
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	self.gibbed_aiaia = true
end

function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)

	if self.isVR == true then
		corpseEnt:Fire("FadeAndRemove","",0.1)
		for i = 0, corpseEnt:GetPhysicsObjectCount() - 1 do
			local colide = corpseEnt:GetPhysicsObjectNum( i )
			colide:EnableGravity(false)
		end
	else
		dmginfo:SetDamageForce(dmginfo:GetDamageForce()/3)
		corpseEnt:TakeDamageInfo(dmginfo)
		vj_madness_make_corpse_destructible(corpseEnt)
	end

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
	end
	if self.gib_type == "head_less" then
		if self.HasGibOnDeathEffects and not self.isVR == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(corpseEnt:GetAttachment(corpseEnt:LookupAttachment("head_gib")).Pos)
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(30)
			util.Effect("VJ_Blood1",bloodeffect)

			local bloodeffect = ents.Create("info_particle_system")
			bloodeffect:SetKeyValue("effect_name","blood_advisor_puncture_withdraw")
			bloodeffect:SetPos(corpseEnt:GetAttachment(corpseEnt:LookupAttachment("head")).Pos)
			bloodeffect:SetAngles(corpseEnt:GetAttachment(corpseEnt:LookupAttachment("head")).Ang)
			bloodeffect:SetParent(corpseEnt)
			bloodeffect:Fire("SetParentAttachment","head")
			bloodeffect:Spawn()
			bloodeffect:Activate()
			bloodeffect:Fire("Start","",0)
			bloodeffect:Fire("Kill","",7) 
		end
		if self.isVR == false then
			local Vel = self:GetRight()*math.Rand(-1000,1000)+self:GetForward()*math.Rand(-1000,10) 
			self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk2.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("2")).Pos,Ang=self:GetAngles(),Vel=vel})
			self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk1.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("5")).Pos,Ang=self:GetAngles(),Vel=vel})
			self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk6.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("4")).Pos,Ang=self:GetAngles(),Vel=vel})
			self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk4.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
			self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk5.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
			self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk3.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head")).Pos,Ang=self:GetAngles(),Vel=vel})
		end
		corpseEnt:SetBodygroup(2, 0)
		corpseEnt:SetBodygroup(1, 1)
		sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
	end
	if self.gib_type == "decapted" then
		sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
		local bone = corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("head"))
		corpseEnt:RemoveInternalConstraint(bone)
		local head_bone = corpseEnt:LookupBone("head")
		local bone = corpseEnt:TranslateBoneToPhysBone(head_bone)
		local colide = corpseEnt:GetPhysicsObjectNum( bone )
		colide:AddVelocity(dmginfo:GetDamageForce())
		corpseEnt:SetSkin(1)
	end
	if self.gib_type == "half" then
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(50)
			util.Effect("VJ_Blood1",bloodeffect)
		end
		sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
		local bone = corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("torax"))
		corpseEnt:RemoveInternalConstraint(bone)
		local head_bone = corpseEnt:LookupBone("torax")
		local bone = corpseEnt:TranslateBoneToPhysBone(head_bone)
		local colide = corpseEnt:GetPhysicsObjectNum( bone )
		colide:AddVelocity(Vector(0,0,999))
		corpseEnt:SetBodygroup(0, 1)
	end
	if self.gib_type == "head_slash" then
		corpseEnt:SetBodygroup(1, 6)
		if self.isVR == false then
			ParticleEffect("blood_impact_red_01_goop",self:GetAttachment(self:LookupAttachment("head_gib")).Pos,self:GetAngles())
			self:CreateGibEntity("prop_physics","models/noob_dev2323/madness/gibs/half_head.mdl",{Pos=corpseEnt:LocalToWorld(Vector(0,0,54)),Ang=corpseEnt:GetAngles()+Angle(0,0,0),Vel=corpseEnt:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})	
			sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
		end
	end

	if self.gib_type == "head_damege" then
		corpseEnt:SetBodygroup(1,self.head_damege_type)
		local att = self.head_damege_type
		if self.isVR == false then
			ParticleEffect("blood_impact_red_01_goop",self:GetAttachment(self:LookupAttachment(att)).Pos,self:GetAngles())
			sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
		end
	end
	if self.gib_type == "l_leg" then
		local bone = corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("L_foot"))
		corpseEnt:RemoveInternalConstraint(bone)
	end
	if self.gib_type == "R_leg" then
		local bone = corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("R_foot"))
		corpseEnt:RemoveInternalConstraint(bone)
	end
end
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if ( hitgroup == HITGROUP_LEFTLEG ) or ( hitgroup == HITGROUP_RIGHTLEG ) and self:GetActivity() == ACT_RUN and math.random(1, 2) == 1 and CurTime() < self.grunt_NextStumbleT then
		self.grunt_NextStumbleT = CurTime() + 3
		self:VJ_ACT_PLAYACTIVITY("run_stumble_01",true,2)
		self.CanFlinch = 0
		timer.Simple( 3, function()
			if IsValid(self) then
				self.CanFlinch = 1
			end
		end )
	end
end
-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base