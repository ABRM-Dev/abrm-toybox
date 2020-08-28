AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

util.AddNetworkString("wsky_vending_machine_openmenu")

function ENT:Initialize()
  self:SetPos(self:GetPos() + Vector(0, 0, 250))
  self:SetModel("models/wsky_vending_machine/wsky_vending_machine.mdl")
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  self:SetUseType(SIMPLE_USE)

  local phys = self:GetPhysicsObject()
  if (phys:IsValid()) then phys:Wake() end
end

function ENT:Use ( activator, caller, useType, value )
  if (activator:IsPlayer()) then
    net.Start("wsky_vending_machine_openmenu")
      net.WriteFloat(self:EntIndex())
    net.Send(activator)
  end
end