AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()		
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS ) 
    self:SetUseType( SIMPLE_USE )

    local phys = self:GetPhysicsObject()
	
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self:SetHealth(40)
end
function ENT:Use(ply) 
	local Position = ply:GetEyeTrace()
	if GetConVar("cannibalism"):GetBool() then
		local health = ply:Health()
		ply:SetHealth( health + 5 )
		local bloodspray = EffectData()
		bloodspray:SetOrigin(Position.HitPos)
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(0)
		util.Effect("BloodImpact",bloodspray)
		self:EmitSound('noob_dev2323/bsmod/eat'..math.random(1,4)..'.wav', 75, 100, 0.4)
		self:Remove()
	end
end
function ENT:Think()
	timer.Simple(GetConVar("gib_fade_time"):GetFloat(), function()
		if IsValid(self) then
			self:Remove()
		end
	end)
end
function ENT:PhysicsCollide(data, physobj)
	if math.random(1, 8) == 1 then
		sound.Play("physics/flesh/flesh_squishy_impact_hard" .. math.random(1,4) .. ".wav", self:GetPos(), 75, 100, 1)
		if	not (self:GetModel() == "models/props_junk/watermelon01_chunk02a.mdl") or (self:GetModel() == "models/mosi/fnv/props/gore/gorehead01.mdl") then
			util.Decal( "Blood", self:GetPos(), self:GetPos() - Vector(math.random(-16,16), math.random(-16,16), 9999))
		end
	end
	if data.Speed > 30 and data.DeltaTime > 0.1 then
		ParticleEffect("blood_impact_red_01_goop", self:GetPos(), self:GetAngles(), self)
	end
end
function ENT:OnTakeDamage( dmginfo )
    local dmg_force = dmginfo:GetDamage()
    local dmg_pos = dmginfo:GetDamagePosition()
	ParticleEffect("blood_impact_red_01_goop", dmg_pos, self:GetAngles(), self)
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self:Health() <= 0 then
		if not (self:GetModel() == "models/props_junk/watermelon01_chunk02a.mdl") then
			local bloodspray = EffectData()
			bloodspray:SetOrigin(self:GetPos())
			bloodspray:SetScale(8)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(0)
			util.Effect("BloodImpact",bloodspray)
			local forceVector = Vector(math.random(-250, 350), math.random(-250, 350), math.random(-250, 350))
			shitgib(self,"models/props_junk/watermelon01_chunk02a.mdl","ValveBiped.Bip01_Head1",true,forceVector,true )
		end
		self:Remove() 
	end
end
