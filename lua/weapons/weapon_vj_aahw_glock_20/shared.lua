if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "aahw glock 20"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "madness combat"

if CLIENT then
SWEP.Slot						= 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale 					= 4 -- Default is 1, The scale of the viewmodel sway
SWEP.UseHands					= true
end
-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly = false -- Is this weapon meant to be for NPCs only?
SWEP.ViewModel					= "models/madness/weapons/c_glock20.mdl"
SWEP.WorldModel = "models/noob_dev2323/madness/weapons/w_glock_20.mdl"
SWEP.HoldType = "pistol"
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= "weapons/pistol/pistol_reload1.wav"
SWEP.Reload_TimeUntilAmmoIsSet	= 1 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 2 -- How much time until the player can play idle animation, shoot, etc.
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 2 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire = 1 -- How much time until the bullet/projectile is fired?
SWEP.NPC_CustomSpread = 2
SWEP.NPC_HasSecondaryFire = false -- Can the weapon have a secondary fire?
-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 10 -- Damage
SWEP.Primary.Force = 5 -- Force applied on the object the bullet hits
SWEP.Primary.Delay				= 0.25 -- Time until it can shoot again
SWEP.Primary.ClipSize = 15 -- Max amount of bullets per clip
SWEP.Primary.Automatic			= false -- Is it automatic?
SWEP.Primary.AllowFireInWater	= true -- If true, you will be able to use primary fire in water
SWEP.Primary.Ammo = "Pistol" -- Ammo type
SWEP.Primary.Sound = {"weapons/glock.wav"}
SWEP.Primary.DistantSound = {"weapons/glock.wav"}
SWEP.PrimaryEffects_MuzzleAttachment = "muzzle"
SWEP.PrimaryEffects_ShellAttachment = "1"
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_PistolShell1"
function SWEP:CustomOnInitialize()
    if self.Owner:IsPlayer() then
        self.WorldModel	= "models/madness/weapons/w_glock_20_for_player.mdl"
    end
end