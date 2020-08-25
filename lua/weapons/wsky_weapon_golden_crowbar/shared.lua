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

function SWEP:ShootEffect(hit)
  self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
  if (hit) then
    self:SendWeaponAnim( ACT_VM_HITCENTER )
  else
    self:SendWeaponAnim( ACT_VM_MISSCENTER )
  end
end

function SWEP:Initialize()
  self:SetHoldType("melee2")
  self:SetMaterial(modelMaterial)
end

function SWEP:PrimaryAttack()
  self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")

  local trace = self:GetOwner():GetEyeTraceNoCursor()
  local entity, entityType = trace.Entity, type(trace.Entity)
  if ((trace.Fraction * 100) <= 0.15) then
    self:ShootEffect(true)
    if (entityType == 'Player' or entityType == 'NPC') then
      turnEntityToGold(entity)
    end
  else
    self:ShootEffect()
  end
end