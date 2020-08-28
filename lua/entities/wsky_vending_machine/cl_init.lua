include('shared.lua')

-- killicon.Add("wsky_vending_machine", "HUD/killicons/wsky_vending_machine", Color( 255, 80, 0, 255 ))

function ENT:Draw()
  self:DrawModel()
end

net.Receive("wsky_vending_machine_openmenu", function (len, pl)
  if (len) then
    local vm = net.ReadEntity()
    print(vm)
  end
end)