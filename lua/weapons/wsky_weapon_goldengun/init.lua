hook.Add("Initialize", "WskyWeaponGoldenGunAmmo", function ()
  print("======================= ADDED WSKY GOLDEN GUN AMMO")
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

  PrintTable(game.GetAmmoTypes())
end)

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")