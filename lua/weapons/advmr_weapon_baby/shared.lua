
SWEP.PrintName = "Babyinator"
SWEP.Author = "AdventurousMR"
SWEP.Category = "Holmes Toybox"

SWEP.Spawnable = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Cooldown = 0.25
SWEP.Secondary.Cooldown = 0.75

SWEP.Primary.Sound = Sound("advmr_weapon_baby/woosh.mp3")
SWEP.Secondary.Sound = Sound("advmr_weapon_baby/woosh2.mp3")

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

function FireBaby(weapon)
    local ent = ents.Create( "prop_physics" )
    if ( !IsValid( ent ) ) then return end
    ent:SetModel( "models/props_c17/doll01.mdl" )

    ent:SetPos( weapon:GetOwner():EyePos() + (weapon:GetOwner():GetAimVector() * 25 ) )
    ent:SetAngles( 
        weapon:GetOwner():EyeAngles() )
    ent:Spawn()

    local phys = ent:GetPhysicsObject()
    if ( !IsValid( phys ) ) then ent:Remove() return end
    
    local velocity = 
    weapon:GetOwner():GetAimVector()
    velocity = velocity * 5000
    velocity = velocity + (VectorRand() * 10)
    phys:ApplyForceCenter( velocity )

    cleanup.Add( 
        weapon:GetOwner(), "props", ent )

    undo.Create( "Thrown_Baby" )
        undo.AddEntity( ent )
        undo.SetPlayer( 
            weapon:GetOwner() )
    undo.Finish()

    return ent
end

function SWEP:PrimaryAttack()

    if ( CLIENT ) then return end

    FireBaby(self)

    self:ShootEffect("primary")
    self:SetNextPrimaryFire( CurTime() + self.Primary.Cooldown )

end


function SWEP:SecondaryAttack()

    if ( CLIENT ) then return end

    local Burnt = Color( 0, 0, 0, 255 )
    local baby = FireBaby(self)

    baby:Ignite(7.5)

    timer.Simple(1, function ()
        baby:SetColor(Burnt)
    end)

    self:ShootEffect("secondary")

    
    self:SetNextSecondaryFire( CurTime() + self.Secondary.Cooldown )
    

end