DEFINE_BASECLASS("wsky_weapon_base")

SWEP.PrintName = "Rhythm"
SWEP.Category = sharedCategoryName

SWEP.Spawnable = true

function SWEP:Initialize()
  BaseClass.Initialize(self)
end

local audioSource = nil
local deployed = false
local timeMult = nil
local visColor = Color(180, 0, 180, 150)
local bgFade = 0
local fadeDec = 0.0025

local possibleSongs = {
  "happy",
  "qwerty",
  "riddle",
}

if SERVER then
  util.AddNetworkString( "WskyRhythmPlayerDropWeapon" )
  util.AddNetworkString( "WskyRhythmFreezePlayer" )
  util.AddNetworkString( "WskyRhythmUnfreezePlayer" )
end

net.Receive ("WskyRhythmFreezePlayer", function (len, pl)
  local ply = net.ReadEntity()
  if (ply) then
    ply:Freeze(true)
  end
end)

net.Receive ("WskyRhythmUnfreezePlayer", function (len, pl)
  local ply = net.ReadEntity()
  if (ply) then
    ply:Freeze(false)
  end
end)
net.Receive ("WskyRhythmPlayerDropWeapon", function (len, pl)
  local ply = net.ReadEntity()
  if (ply) then
    ply:DropWeapon(ply:GetActiveWeapon())
    ply:Freeze(false)
  end
end)

function SWEP:Deploy ()
  self:GetOwner():SetNWBool("WskyRhythmPlay", true)
  return true
end

function SWEP:Holster ()
  self:GetOwner():SetNWBool("WskyRhythmPlay", false)
  return true
end

hook.Add("Tick", "WskyRhythmTick", function ()
  if SERVER then return end
  local player = LocalPlayer()
  if (player:GetNWBool("WskyRhythmPlay") && player:GetActiveWeapon():GetClass() == 'wsky_weapon_rhythm'  && !audioSource) then
    net.Start("WskyRhythmFreezePlayer")
      net.WriteEntity(player)
    net.SendToServer()
    sound.PlayFile("sound/wsky_weapon_rhythm/" .. possibleSongs[math.random(1, table.Count(possibleSongs))] .. ".mp3", "mono", function (source)
      audioSource = source
    end)
    visColor = Color(math.random(100, 255), math.random(100, 255), math.random(100, 255), visColor.a)
  elseif (!player:GetNWBool("WskyRhythmPlay") && audioSource) then
    net.Start("WskyRhythmUnfreezePlayer")
      net.WriteEntity(player)
    net.SendToServer()
    audioSource:Stop()
    audioSource = nil
  end
end)

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then
		return false
	end
end )

hook.Add("HUDPaint", "WskyRhythmHUD", function ()
  local audioLevels = {}
  local amp = ScrH()
  local fovFractionClamp = 2
  draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(25, 25, 25, math.Clamp(bgFade * 250, 0, 255)))
  if !audioSource then
    if (bgFade > 0) then
      bgFade = bgFade - fadeDec
    end
    LocalPlayer():SetFOV(100, 0)
    return
  end
  if (audioSource:GetTime() == audioSource:GetLength()) then
    LocalPlayer():SetNWBool("WskyRhythmPlay", false)
    audioSource = nil
    net.Start("WskyRhythmPlayerDropWeapon")
      net.WriteEntity(LocalPlayer())
    net.SendToServer()
    return
  end
  local songName = string.upper(string.Explode(".", string.Explode("/", audioSource:GetFileName())[3])[1])
  local timeRemaining = math.floor(audioSource:GetLength() - audioSource:GetTime())
  local hour = math.Clamp(math.floor(timeRemaining / 3600), 0, 24)
  local minute = math.Clamp(math.floor((timeRemaining - (hour * 3600)) / 60), 0, 60)
  local seconds = math.Clamp(math.floor((timeRemaining - (hour * 3600) - (minute * 60))), 0, 60)
  local timePrint = (hour .. ":" .. minute .. ":" .. seconds)
  local w, h = surface.GetTextSize(timePrint)
  draw.DrawText(timePrint, "DermaLarge", (ScrW() / 2) - (w / 2), 48, Color(255,255,255,255), TEXT_ALIGN_LEFT)
  w, h = surface.GetTextSize(songName)
  draw.DrawText(songName, "DermaLarge", (ScrW() / 2) - (w / 2), 16, Color(255,255,255,255), TEXT_ALIGN_LEFT)
  if (bgFade < 1) then
    bgFade = bgFade + fadeDec
  end
  audioSource:FFT(audioLevels, 4)

  draw.RoundedBox(0, 0, (ScrH() / 2) - 2, ScrW(), 1, ColorAlpha(visColor, 180))

  local smoothLevels = {}
  local count = 0
  local total = table.Count(audioLevels) / 8
  local levelWidth = ScrW() / total
  for i=1,total do
    smoothLevels[i] = 0
  end
  for i=1, total do
    if (i <= total / fovFractionClamp) then
      count = count + audioLevels[i] * amp
    end
    smoothLevels[i] = Lerp(500 * FrameTime(), smoothLevels[i], audioLevels[i])
    local y = (ScrH() / 2) - (((smoothLevels[i] * amp) + 1) / 2)
    draw.RoundedBox(0, (i-1) * levelWidth, y, levelWidth, smoothLevels[i] * amp, visColor)
  end
  local mult = math.Clamp((count / (total / fovFractionClamp)) / 10, .5, 5)

  LocalPlayer():SetFOV(math.max(0, 100 * (mult / 3)), 0.25)
end)