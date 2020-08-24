local possibleRagdollMaterials = {
  "models/player/shared/ice_player",
  "models/player/shared/gold_player"
}

function turnEntityToGold(entity)
  --[[ Create Ragdoll ]]
  local ragdoll = ents.Create("prop_ragdoll")
  ragdoll:SetModel(entity:GetModel())
  ragdoll:SetPos(entity:GetPos())
  ragdoll:SetRenderMode( RENDERMODE_TRANSCOLOR )
  ragdoll:Spawn()

  print(entity:GetModel())

  -- [[ Weld bones together ]]
  local bones = ragdoll:GetPhysicsObjectCount()
  if (bones >= 2) then
    for bone = 1, bones do
      local constraint = constraint.Weld(ragdoll, ragdoll, 0, bone, 0)
    local effectdata = EffectData()
      effectdata:SetOrigin( ragdoll:GetBonePosition(bone) )
      effectdata:SetScale( 1 )
      effectdata:SetMagnitude( 1 )
    util.Effect( "Sparks", effectdata, true, true )
    end
  end

  --[[ Kill/Remove Entity (depending on type) ]]
  if (type(entity) == 'Player') then entity:KillSilent()
  else entity:Remove() end

  --[[ Set Golden ]]
  ragdoll:SetMaterial(possibleRagdollMaterials[math.random(1, table.Count(possibleRagdollMaterials))])

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