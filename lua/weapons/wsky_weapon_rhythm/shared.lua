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
local fadeDec = 0.01
local songPlaying = nil

local possibleSongs = {
  {
    name = "Duck Face",
    author = "Code",
    file = "Duck Face - Code.mp3"
  },
  {
    name = "Happy",
    author = "Rob Gasser",
    file = "Happy - Rob Gasser.mp3"
  },
  {
    name = "Future",
    author = "Por Favore",
    file = "Future - Por Favore.mp3"
  },
  {
    name = "Know You",
    author = "Notes",
    file = "Know You - Notes.mp3"
  },
  {
    name = "Shadow",
    author = "F1NG3RS",
    file = "Shadow - Fingers.mp3"
  },
  {
    name = "Spy",
    author = "Raky",
    file = "Spy - Raky.mp3"
  },
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
    songPlaying = possibleSongs[math.random(1, table.Count(possibleSongs))]
    sound.PlayFile("sound/wsky_weapon_rhythm/" .. songPlaying.file, "mono", function (source, err, errname)
      if (err) then
        print(err, errname)
        net.Start("WskyRhythmPlayerDropWeapon")
          net.WriteEntity(player)
        net.SendToServer()
      end
      audioSource = source
      timer.Simple(0.05, function () audioSource:SetVolume(0.25) end)
    end)
    net.Start("WskyRhythmFreezePlayer")
      net.WriteEntity(player)
    net.SendToServer()
    visColor = Color(math.random(100, 255), math.random(100, 255), math.random(100, 255), visColor.a)
  elseif (!player:GetNWBool("WskyRhythmPlay") && audioSource) then
    net.Start("WskyRhythmUnfreezePlayer")
      net.WriteEntity(player)
    net.SendToServer()
    audioSource:Stop()
    audioSource = nil
  end

  if (audioSource) then
    if (bgFade < 1) then
      bgFade = bgFade + fadeDec
    end
  else
    if (bgFade > 0) then
      bgFade = bgFade - fadeDec
    end
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
  local fovFractionClamp = 1
  draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(25, 25, 25, math.Clamp(bgFade * 250, 0, 255)))
  if !audioSource then
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
  local timeRemaining = math.floor(audioSource:GetLength() - audioSource:GetTime())
  local hour = math.Clamp(math.floor(timeRemaining / 3600), 0, 24)
  local minute = math.Clamp(math.floor((timeRemaining - (hour * 3600)) / 60), 0, 60)
  local seconds = math.Clamp(math.floor((timeRemaining - (hour * 3600) - (minute * 60))), 0, 60)
  local timePrint = (hour .. ":" .. minute .. ":" .. seconds)

  surface.SetFont("DermaLarge")
  local w, h = surface.GetTextSize(songPlaying.name)
  draw.DrawText(songPlaying.name, "DermaLarge", (ScrW() / 2) - (w / 2), 16, Color(255,255,255,255), TEXT_ALIGN_LEFT)

  local w, h = surface.GetTextSize(timePrint)
  draw.DrawText(timePrint, "DermaLarge", (ScrW() / 2) - (w / 2), 80, Color(255,255,255,255), TEXT_ALIGN_LEFT)

  surface.SetFont("DermaDefaultBold")
  local w, h = surface.GetTextSize(songPlaying.author)
  draw.DrawText(songPlaying.author, "DermaDefaultBold", (ScrW() / 2) - (w / 2), 48, Color(255,255,255,255), TEXT_ALIGN_LEFT)

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
  local mult = (count / (total / fovFractionClamp)) / 10

  LocalPlayer():SetFOV(60 + math.Clamp(mult * 40, 0, 60), 0.10)
end)