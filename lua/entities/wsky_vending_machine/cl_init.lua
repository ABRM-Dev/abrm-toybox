include('shared.lua')

-- killicon.Add("wsky_vending_machine", "HUD/killicons/wsky_vending_machine", Color( 255, 80, 0, 255 ))

function ENT:Draw()
  self:DrawModel()
end

net.Receive("wsky_vending_machine_openmenu", function (len, pl)
  if (len) then
    local vmIndex = net.ReadFloat()
    local vm = nil
    if vmIndex then vm = Entity(vmIndex) end
    if (vm && vm:IsValid()) then
      local Frame = vgui.Create( "DFrame" )
      Frame:SetSize(ScrW() / 2, ScrH() / 2)
      Frame:SetVisible(true)
      Frame:SetDraggable(false)
      Frame:ShowCloseButton(true)
      Frame:MakePopup()
      Frame:Center()
      Frame:SetTitle("View window for vending machine number: #" .. vmIndex)
    end
  end
end)