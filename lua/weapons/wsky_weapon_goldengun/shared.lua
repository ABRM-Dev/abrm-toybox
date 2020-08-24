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

local possibleRagdollMaterials = {
  "models/player/shared/ice_player",
  "models/player/shared/gold_player"
}

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
    if (entityType == 'NPC' or entityType == 'Player') then
      if (SERVER) then

        --[[ Create Ragdoll ]]
        local ragdoll = ents.Create("prop_ragdoll")
        ragdoll:SetModel(entity:GetModel())
        ragdoll:SetPos(entity:GetPos())
        ragdoll:SetRenderMode( RENDERMODE_TRANSCOLOR )
        ragdoll:Spawn()

        --[[ Copy Pose info from entity to ragdoll ]]
        for i = 0, entity:GetNumPoseParameters() - 1 do
          local sPose = entity:GetPoseParameterName(i)
          ragdoll:SetPoseParameter(sPose, entity:GetPoseParameter(sPose))
        end

        --[[ Kill/Remove Entity (depending on type) ]]
        if (entityType == 'Player') then entity:KillSilent()
        else entity:Remove() end

        --[[ Set Golden ]]
        ragdoll:SetMaterial(possibleRagdollMaterials[math.random(1, table.Count(possibleRagdollMaterials))])

        --[[ Freeze all bones ]]
        local bones = ragdoll:GetPhysicsObjectCount()
        for bone = 1, bones-1 do
          ragdoll:GetPhysicsObjectNum(bone):EnableMotion(false)
        end

        --[[ Start a timer to fade away the ragdoll ]]
        timer.Create("WskyGoldenGunRagdollFading" .. ragdoll:GetCreationID(), 5, 1, function ()
          print("set invis")
          ragdoll:SetCollisionGroup(COLLISION_GROUP_DISSOLVING)
          local i = 1
          timer.Create("WskyGoldenGunRagdollFader" .. ragdoll:GetCreationID(), 0.05, 128, function ()
            ragdoll:SetColor(Color(255,255,255,255 - i))
            i = i+2
          end)
          timer.Create("WskyGoldenGunRagdollRemover" .. ragdoll:GetCreationID(), 7, 1, function ()
            ragdoll:Remove()
          end)
        end)
      elseif (CLIENT) then

        --[[ Add Death Notice (can only be done from client... idk why either) ]]
        local attacker, victim = self:GetOwner(), entity
        GAMEMODE:AddDeathNotice(attacker:GetName(), attacker:Team(), self.ClassName, victim:GetName(), victim:Team())
      end
    end
  end

  self.BaseClass.ShootEffects(self)
  self:GetOwner():FireBullets(bullet)

  self:TakePrimaryAmmo(1)

  if (!self:HasAmmo()) then
    self:GetOwner():DropWeapon(self)
  end
end