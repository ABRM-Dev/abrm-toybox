DEFINE_BASECLASS("wsky_weapon_base")

SWEP.PrintName = "Golden Gun"
SWEP.Category = sharedCategoryName

SWEP.Spawnable = true

SWEP.Primary.Ammo = "WskyGoldenGun"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

function SWEP:Initialize()
  BaseClass.Initialize(self)
end

function SWEP:PrimaryAttack()

  --[[ If can't fire, do nowt ]]
  if (!self:CanPrimaryAttack()) then return end

  local bullet = {}
  bullet.Num = 1
  bullet.Src = self:GetOwner():GetShootPos()
  bullet.Dir = self:GetOwner():GetAimVector()
  bullet.Spread = Vector( 0,0,0 )
  bullet.Tracer = 1
  bullet.Force = 0
  bullet.Damage = -1
  bullet.AmmoType = self.Primary.Ammo
  bullet.Callback = function (attacker, tr, dmgInfo)
    local entity = tr.Entity
    local entityType = type(entity)
    if (entityType == 'NPC' or entityType == 'Player') then turnEntityToGold(entity) end
  end

  self.BaseClass.ShootEffects(self)
  self:GetOwner():FireBullets(bullet)

  self:TakePrimaryAmmo(1)

  if (!self:HasAmmo()) then
    self:GetOwner():DropWeapon(self)
  end
end