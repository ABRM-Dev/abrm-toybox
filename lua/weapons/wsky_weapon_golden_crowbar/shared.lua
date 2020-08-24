DEFINE_BASECLASS("wsky_weapon_base")

SWEP.PrintName = "Golden Crowbar"
SWEP.Category = sharedCategoryName

SWEP.Spawnable = true

SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"

SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

modelMaterial = "models/player/shared/gold_player"

function SWEP:ShootEffect()
  print("ACT_VM_SWINGHARD")
  self:SendWeaponAnim( ACT_VM_HITCENTER )  -- View model animation
  self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:Initialize()
  self:SetHoldType("melee2")
  self:SetMaterial(modelMaterial)
end

function SWEP:PreDrawViewModel(vm, weapon, ply)
  vm:SetMaterial(modelMaterial)
end

function SWEP:PrimaryAttack()
  self:ShootEffect()
  self:EmitSound(self.ClassName .. "/attack1.mp3", 75)
end