local possibleRagdollMaterials = {
  "models/player/shared/ice_player",
  "models/player/shared/gold_player"
}

print("testing!")

function turnEntityToGold(entity)
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
  if (type(entity) == 'Player') then entity:KillSilent()
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
end