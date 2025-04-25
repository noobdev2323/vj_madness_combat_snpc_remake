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
    end
end

hook.Add("EntityTakeDamage", "EntityMadness_ent_TakeDamage", function(target, dmginfo)
	if GetConVar("vj_madness_can_gib_ragdoll"):GetBool() == true then
		if target:IsRagdoll() and target.vj_madness_destructible_Corpse and CurTime() > target.vj_madness_Start_delay then 
			local hit = GetClosestPhysBone(target,dmginfo:GetDamagePosition()) --get hit physbone
			local physbone = target:TranslatePhysBoneToBone(hit)
			local bone_name = target:GetBoneName( physbone ) 
			if target.madness_boneHealth[bone_name] then
				target.madness_boneHealth[bone_name] = target.madness_boneHealth[bone_name] - dmginfo:GetDamage()
				print("health"..target.madness_boneHealth[bone_name])
			end

			if target.madness_boneHealth["head"] <= 0 && !target.Head_gibbed then 
				madness_gib_head(target)
				target.Head_gibbed = true 
			end
			if !dmginfo:IsBulletDamage() or !dmginfo:IsDamageType(DMG_NEVERGIB) then
				local doDamege = true 
				local dmg_force = dmginfo:GetDamage()

				if dmgType == DMG_CRUSH && dmginfo:GetDamage() < 500 then
					doDamege = false 
				elseif dmginfo:IsExplosionDamage() && dmg_force >= 10 then 
					dmginfo:ScaleDamage(3) --escale the damege on explosions     
				end 
				if doDamege == false then
					return 
				else
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
function madness_GetClosestPhysBone(ent,pos)
	local closest_distance = -1
	local closest_bone = -1
	
	for i=0, ent:GetPhysicsObjectCount()-1 do
		local bone = ent:TranslatePhysBoneToBone(i)
		
		if bone then 
			local phys = ent:GetPhysicsObjectNum(i)
			
			if IsValid(phys) then
				local distance = phys:GetPos():Distance(pos)
				
				if (distance < closest_distance || closest_distance == -1) then
					closest_distance = distance
					closest_bone = i
				end
			end
		end
	end
	return closest_bone
end
function madness_gib_head(target)
	local bloodeffect = EffectData()
	bloodeffect:SetOrigin(target:GetPos() +target:OBBCenter())
	bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
	bloodeffect:SetScale(50)
	util.Effect("VJ_Blood1",bloodeffect)

	target:SetBodygroup(1, 1)
end