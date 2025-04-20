AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 20 -- or you can use a convar: GetConVarNumber("vj_dum_dummy_h")
ENT.VJ_NPC_Class = {"CLASS_AAHW"} -- NPCs with the same class with be allied to each other


ENT.DeathCorpseFade = false -- Fades the ragdoll on death
ENT.DeathCorpseFadeTime = 10 -- How much time until the ragdoll fades | Unit = Seconds
ENT.DeathCorpseSetBoneAngles = true -- This can be used to stop the corpse glitching or flying on death
ENT.DeathCorpseApplyForce = false -- If false, force will not be applied to the corpse
ENT.WaitBeforeDeathTime = 0 -- Time until the SNPC spawns its corpse and gets removed

	-- ====== Dismemberment/Gib Variables ====== --
ENT.AllowedToGib = true -- Is it allowed to gib in general? This can be on death or when shot in a certain place
ENT.HasGibOnDeath = true -- Is it allowed to gib on death?
ENT.GibOnDeathDamagesTable = {"UseDefault"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasGibOnDeathSounds = true -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibDeathParticles = true -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu
ENT.DeathCorpseSetBoneAngles = true
	-- To use event-based attacks, set this to false:
ENT.RunAwayOnUnknownDamage = true -- Should run away on damage

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamageType = DMG_CLUB
ENT.AnimTbl_MeleeAttack = {"vjges_punch01","vjges_punch02"} -- Melee Attack Animations
ENT.MeleeAttackAnimationAllowOtherTasks = true -- If set to true, the animation will not stop other tasks from playing, such as chasing | Useful for gesture attacks!
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
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

ENT.CallForHelp = true -- Does the SNPC call for help?
ENT.grunt_NextStumbleT = CurTime() + 3
function ENT:CustomOnInitialize()
	self.totalDamage = {}
end
function ENT:MeleeAttackKnockbackVelocity(hitEnt)
	return self:GetForward()*math.random(100, 140) + self:GetUp()*10
end
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
	local dotext = math.random(1,2)
	if dotext == 2 then
        madness_combat_snpc_doText(self,"voce vai conheser o pai reabilitado")
	end
	if GetConVar("vj_madness_gore"):GetInt() == 1 then
   		local damageForce = dmginfo:GetDamageForce():Length()
    	self.totalDamage[hitgroup] = (self.totalDamage[hitgroup] or 0) + damageForce

		if dmginfo:IsDamageType(DMG_SLASH) and hitgroup == HITGROUP_HEAD then
        	local slice = math.random(1,2)
        	if slice == 2 then
                self.gibbed_aiaia = true
            elseif slice == 1 then 
		        self.head_slash = true
        	end
        else
	    	if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 12000	 then    -- Dismember heads code
		    	self.head_less = true
   	    	end
   	    	if hitgroup == 13 and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
	    		self.R_part = true
        	end
        	if hitgroup == 14 and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
	    		self.back = true
        	end
   	    	if hitgroup == 15 and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
	    		self.head_less = true
        	end
        	if hitgroup == 16 and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
	    		self.testa = true
        	end
        	if hitgroup == 17 and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
	    		self.L_part = true
        	end
	    	if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
	    		self.head_damage = true
        	end
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
	end


	if self.head_less then
    if self.head_slash then return end 
		corpseEnt:SetBodygroup(1, 1)
        sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
	end
	if self.head_slash then
		corpseEnt:SetBodygroup(1, 5)
		self:CreateGibEntity("prop_physics","models/noob_dev2323/madness/gibs/half_head.mdl",{Pos=corpseEnt:LocalToWorld(Vector(0,0,54)),Ang=corpseEnt:GetAngles()+Angle(0,0,0),Vel=corpseEnt:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})	
        sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
	end
	if self.head_damage then
		if self.head_less then return end
		corpseEnt:SetBodygroup(1, 2)
	end
	if self.R_part then
		if self.head_less then return end
		corpseEnt:SetBodygroup(1, 3)
	end
	if self.back then
		if self.head_less then return end
		corpseEnt:SetBodygroup(1, 4)
	end
	if self.L_part then
		if self.head_less then return end
		corpseEnt:SetBodygroup(1, 5)
	end
	if self.testa then
		if self.head_less then return end
		corpseEnt:SetBodygroup(1, 2)
	end
	if self.gibbed_aiaia then
        sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
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
	vj_madness_make_corpse_destructible(corpseEnt)
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
