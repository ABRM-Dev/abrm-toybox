
SWEP.PrintName = "Babyinator"
SWEP.Author = "AdventurousMR"
SWEP.Category = "Holmes Toybox"

SWEP.Spawnable = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "	models/weapons/w_rpg.mdl"


function SWEP:ShootEffects()

    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )  -- View model animation
    self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
    self:EmitSound(self.ClassName .. "/woosh.mp3")

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

    self:ShootEffects()
    self:SetNextPrimaryFire( CurTime() + 0.25 )

end


function SWEP:SecondaryAttack()

    if ( CLIENT ) then return end

    local Burnt = Color( 0, 0, 0, 255 )
    local baby = FireBaby(self)

    baby:Ignite(7.5)

    timer.Simple(1, function ()
        baby:SetColor(Burnt)
    end)

    self:ShootEffects()

    
    self:SetNextPrimaryFire( CurTime() + 0.25 )
    

end