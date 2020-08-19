SWEP.PrintName = "Wsky Weapon Base"
SWEP.Author = "Whiskee"
SWEP.Contact = "dev@whiskee.me"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Category = "Whiskee Toybox"

SWEP.Spawnable = false

SWEP.ViewModel = nil
SWEP.WorldModel = nil

function SWEP:Initialize()
  self:SetHoldType("normal")
end

function SWEP:Think()
end

function SWEP:Holster()
  return true
end

function SWEP:Deploy()
  return true
end

function SWEP:PrimaryAttack()
  return
end

function SWEP:SecondaryAttack()
  return
end