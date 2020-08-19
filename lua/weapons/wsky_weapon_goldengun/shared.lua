DEFINE_BASECLASS("wsky_weapon_base")

SWEP.PrintName = "Golden Gun"
SWEP.Category = "Holmes Toybox"

SWEP.Spawnable = true

SWEP.Primary.Ammo = "WskyGoldenGun"
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

function SWEP:Initialize()
  BaseClass.Initialize(self)
end

function SWEP:PrimaryAttack()
  
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
    if (SERVER && (entityType == 'NPC' or entityType == 'Player')) then
      entity:KillSilent()
      local ragdoll = ents.Create("prop_ragdoll")
      ragdoll:SetModel(entity:GetModel())
      ragdoll:SetPos(entity:GetPos())
      ragdoll:Spawn()
      -- ragdoll:SetColor(entity:GetColor())
      ragdoll:SetMaterial("models/player/shared/gold_player")
      local ragdollPhysObj = ragdoll:GetPhysicsObject()
      ragdollPhysObj:EnableMotion(false)
    end
  end

  self.BaseClass.ShootEffects(self)

  self:GetOwner():FireBullets(bullet)
end