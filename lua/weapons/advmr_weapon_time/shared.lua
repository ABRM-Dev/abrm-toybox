SWEP.PrintName = "Time Rifle"
SWEP.Author = "AdventurousMR"
SWEP.Category = sharedCategoryName

SWEP.Spawnable = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.UseHands = true

SWEP.Primary.Cooldown = 0.25
SWEP.Secondary.Cooldown = 0.75
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true

SWEP.Primary.Sound = Sound("advmr_weapon_time/shoot2.mp3")
SWEP.Secondary.Sound = Sound("advmr_weapon_time/shoot2.mp3")

function SWEP:Initialize()
    self:SetHoldType("rpg")
end

function SWEP:ShootEffect(type)

    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )  -- View model animation
    self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
    if (type == "primary") then
        self:EmitSound(self.Primary.Sound)
    elseif (type == "secondary") then
        self:EmitSound(self.Secondary.Sound)
    end

end

function SWEP:PrimaryAttack()

    if ( CLIENT ) then return end

    local scale = game.GetTimeScale() 
    

    game.SetTimeScale(scale + 0.1)


    self:ShootEffect("primary")
    self:SetNextPrimaryFire( CurTime() + 0.1 )

end


function SWEP:SecondaryAttack()

    if ( CLIENT ) then return end

    local scale = game.GetTimeScale()

    game.SetTimeScale(scale - 0.1)

    self:ShootEffect("secondary")
    self:SetNextSecondaryFire( CurTime() + 0.1)
    

end

function SWEP:Reload()

    local ReloadSound = Sound("advmr_weapon_time/Reload.mp3")

    self:EmitSound(ReloadSound)
    game.SetTimeScale(1)

end