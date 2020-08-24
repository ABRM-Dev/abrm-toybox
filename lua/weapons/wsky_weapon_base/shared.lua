SWEP.PrintName = "Wsky Weapon Base"
SWEP.Author = "Whiskee"
SWEP.Contact = "dev@whiskee.me"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Category = sharedCategoryName

SWEP.Spawnable = false

SWEP.ViewModel = nil
SWEP.WorldModel = nil

function SWEP:Initialize()
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