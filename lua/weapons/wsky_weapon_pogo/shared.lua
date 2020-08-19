DEFINE_BASECLASS("wsky_weapon_base")

SWEP.PrintName = "Wsky Pogo Stick"
SWEP.Category = "Whiskee Toybox"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_hands.mdl"
SWEP.WorldModel = "models/weapons/w_fists_t.mdl"

function SWEP:Initialize()
  BaseClass.Initialize( self )
end

function SWEP:Think()
end

function SWEP:Holster()
  hook.Remove("OnPlayerHitGround", "WskyPogoPlayerHitGround")
  hook.Remove("GetFallDamage", "WskyPogoPreventFallDamage")

  if SERVER then
    local trail = self:GetOwner():GetNWEntity("WskyPogoTrail")
    if (trail != NULL) then trail:Remove() end
  end
  return true
end

function SWEP:Deploy()
  hook.Add("OnPlayerHitGround", "WskyPogoPlayerHitGround", function (player, inWater, onFloater, speed)
    local trail = player:GetNWEntity("WskyPogoTrail")
    if (!player:KeyDown(IN_DUCK)) then
      if (player:KeyDown(IN_JUMP)) then
        speed = math.min(1.7, math.ceil(speed / 192))
      else
        speed = 1
      end
      local multi = speed * 1.551
      if (multi >= 1) then
        player:SetVelocity(Vector(0, 0, player:GetJumpPower() * multi))
        player:EmitSound("garrysmod/content_downloaded.wav", 100, 50 + math.random(1, 100))

        local startWidth, endWidth = 20, 0
        local lifetime = 1
        if (trail == NULL) then 
          trail = util.SpriteTrail(player, 0, Color(255, 255, 255), false, startWidth, endWidth, lifetime, 1 / (startWidth + endWidth) * 0.5, "trails/plasma  ")
          player:SetNWEntity("WskyPogoTrail", trail)
        end
      else
        if (trail != NULL) then trail:Remove() end
      end
    else
      if (trail != NULL) then trail:Remove() end
    end
  end)
  hook.Add("GetFallDamage", "WskyPogoPreventFallDamage", function () return 0 end)
  return true
end