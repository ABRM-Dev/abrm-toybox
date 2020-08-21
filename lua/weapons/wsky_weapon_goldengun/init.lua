hook.Add("Initialize", "WskyWeaponGoldenGunAmmo", function ()
  game.AddAmmoType({
    name = "WskyGoldenGun",
    dmgtype = DMG_BULLET,
    tracer = TRACER_LINE,
    plydmg = 0,
    npcdmg = 0,
    force = 0,
    minsplash = 0,
    maxsplash = 0
  })
end)

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")