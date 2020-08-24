DEFINE_BASECLASS("wsky_weapon_base")

SWEP.PrintName = "Golden Crowbar"
SWEP.Category = "Holmes Toybox"

SWEP.Spawnable = true

SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"

SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
  self:SetHoldType("magic")
end