CreateConVar("vj_madness_gore", "1", FCVAR_ARCHIVE, "vj_madness_gore")
CreateConVar("vj_madness_can_gib_ragdoll", "1", FCVAR_ARCHIVE, "vj_madness_can_gib_ragdoll")
util.AddNetworkString( "vj_madness_combat.text" ) 

function madness_combat_snpc_doText(ent,text)
	timer.Simple( 0.05, function()
    	if IsValid(ent) then
	    	net.Start( "vj_madness_combat.text" )
	    		net.WriteEntity(ent)
	    		net.WriteString(text)
	    	net.Broadcast()
	    end
    end)
end
function vj_madness_make_corpse_destructible(ent)
	if ent:IsValid() and GetConVar("vj_madness_can_gib_ragdoll"):GetBool() == true then
	    ent.vj_madness_destructible_Corpse = true
	    ent.vj_madness_Start_delay = CurTime() + 1
	    ent.ragdoll_Health = 400  

	    local defalt_value = 50
	    ent.madness_boneHealth = {}
	    ent.madness_boneHealth["head"] = defalt_value
		ent.madness_boneHealth["R_foot"] = defalt_value
		ent.madness_boneHealth["L_foot"] = defalt_value
    end
end

hook.Add("EntityTakeDamage", "EntityMadness_ent_TakeDamage", function(target, dmginfo)
	if GetConVar("vj_madness_can_gib_ragdoll"):GetBool() == true then
		if target:IsRagdoll() and target.vj_madness_destructible_Corpse and CurTime() > target.vj_madness_Start_delay then 
			local doDamege = true 
			local dmg_force = dmginfo:GetDamage()

			if dmgType == DMG_CRUSH && dmginfo:GetDamage() < 500 then
				doDamege = false 
			elseif dmginfo:IsExplosionDamage() && dmg_force >= 10 then 
				dmginfo:ScaleDamage(3) --escale the damege on explosions     
			end 
			local hit = madness_GetClosestPhysBone(target,dmginfo) --get hit physbone
			if hit == nil then
				return 
			end
			local bone = target:TranslatePhysBoneToBone(hit)
			local bone_name = target:GetBoneName( bone ) 		

			if target.madness_boneHealth[bone_name] then
				target.madness_boneHealth[bone_name] = target.madness_boneHealth[bone_name] - dmginfo:GetDamage()
				print("health"..target.madness_boneHealth[bone_name])
			end

			if target.madness_boneHealth["head"] <= 0 && !target.Head_gibbed then 
				target.Head_gibbed = true 
				madness_gib_head(target)
			end
			if target.madness_boneHealth["R_foot"] <= 0 && !target.R_foot then 
				target.R_foot = true 
				target:ManipulateBoneScale(target:LookupBone("R_foot"),Vector(0,0,0))
				madness_physbone_colide(target,"R_foot",true)
			end
			if target.madness_boneHealth["L_foot"] <= 0 && !target.L_foot then 
				target.L_foot = true 
				target:ManipulateBoneScale(target:LookupBone("L_foot"),Vector(0,0,0))
				madness_physbone_colide(target,"L_foot",true)
			end
			if !dmginfo:IsBulletDamage() or !dmginfo:IsDamageType(DMG_NEVERGIB) then
				if doDamege == true  then 
					target.ragdoll_Health = target.ragdoll_Health - dmginfo:GetDamage()		
				end
				if target.ragdoll_Health <= 0 then 
					timer.Simple( 0.05, function()
						if IsValid(target) then
							ragdoll_gib(target,dmginfo)
						end
					end )
				end
			end
		end 
	end
end)


function madness_GetClosestPhysBone(ent,dmginfo)
	local mdl = ent:GetModel()
	local COLL_CACHE = {}

	local vec_max = Vector(1, 1, 1)
	local vec_min = -vec_max

	local colls = COLL_CACHE[mdl]
	if !colls then
		colls = CreatePhysCollidesFromModel(mdl)
		COLL_CACHE[mdl] = colls
	end
	local dmgpos = dmginfo:GetDamagePosition()

	local dmgdir = dmginfo:GetDamageForce()
	dmgdir:Normalize()

	local ray_start = dmgpos - dmgdir * 50
	local ray_end = dmgpos + dmgdir * 50

	for phys_bone, coll in pairs(colls) do
		phys_bone = phys_bone - 1
		local bone = ent:TranslatePhysBoneToBone(phys_bone)
		local pos, ang = ent:GetBonePosition(bone)
		
		if coll:TraceBox(pos, ang, ray_start, ray_end, vec_min, vec_max) then
			return phys_bone
		end
	end
end
function madness_gib_head(target)
	local bloodeffect = EffectData()
	bloodeffect:SetOrigin(target:GetAttachment(target:LookupAttachment("head_gib")).Pos)
	bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
	bloodeffect:SetScale(50)
	util.Effect("VJ_Blood1",bloodeffect)
	sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", target:GetPos(), 75, 100, 1)
	madness_physbone_colide(target,"head")
	local head_bone = target:LookupBone( "head" )
	target:ManipulateBoneScale(head_bone,Vector(0,0,0))
end
function madness_physbone_colide(target,bone,disable_motion)
	local colide = target:GetPhysicsObjectNum(target:TranslateBoneToPhysBone(target:LookupBone(bone))) --get bone id
	colide:EnableCollisions(false)
	colide:SetMass(0.01)
end
function bonemerge_prop_on_npc(model,ent)
	ent.bonemerge_prop = ents.Create("prop_physics")
	ent.bonemerge_prop:SetModel(model)
	ent.bonemerge_prop:SetLocalPos(ent:GetPos())
	ent.bonemerge_prop:SetOwner(ent)
	ent.bonemerge_prop:SetParent(ent)
	ent.bonemerge_prop:Fire("SetParentAttachment","Head")
	ent.bonemerge_prop:Spawn()
	ent.bonemerge_prop:Activate()
	ent.bonemerge_prop:SetSolid(SOLID_NONE)
	ent.bonemerge_prop:AddEffects(EF_BONEMERGE)
end