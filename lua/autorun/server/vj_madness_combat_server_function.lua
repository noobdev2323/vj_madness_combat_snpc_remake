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
		if target:IsRagdoll() and target.vj_madness_destructible_Corpse and CurTime() > target.vj_madness_Start_delay and not dmginfo:IsDamageType(DMG_NEVERGIB) then 
			if !dmginfo:IsBulletDamage() then
				local dmg_force = dmginfo:GetDamage()
				if dmginfo:IsExplosionDamage() and dmg_force >= 10 then 
					dmginfo:ScaleDamage(3) --escale the damege on explosions     
				end 
				target.ragdoll_Health = target.ragdoll_Health - dmginfo:GetDamage()
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
