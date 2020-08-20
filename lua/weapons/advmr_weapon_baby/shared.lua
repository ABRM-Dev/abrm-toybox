
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

function SWEP:PrimaryAttack()

    if ( CLIENT ) then return end
    local Ent = ents.Create( "prop_physics" )
    if ( !IsValid( Ent ) ) then return end
    Ent:SetModel( "models/props_c17/doll01.mdl" )

    Ent:SetPos( self:GetOwner():EyePos() + (self:GetOwner():GetAimVector() * 25 ) )
    Ent:SetAngles( 
        self:GetOwner():EyeAngles() )
    Ent:Spawn()

    local phys = Ent:GetPhysicsObject()
	if ( !IsValid( phys ) ) then ent:Remove() return end

    local velocity = 
    self:GetOwner():GetAimVector()
    velocity = velocity * 5000
    velocity = velocity + (VectorRand() * 10)
    phys:ApplyForceCenter( velocity )

    cleanup.Add( 
        self:GetOwner(), "props", Ent )

    undo.Create( "Thrown_Baby" )
        undo.AddEntity( Ent )
        undo.SetPlayer( 
            self:GetOwner() )
    undo.Finish()

    self:ShootEffects()

    self:SetNextPrimaryFire( CurTime() + 0.25 )

end


function SWEP:SecondaryAttack()

    if ( CLIENT ) then return end
    local Ent = ents.Create( "prop_physics" )
    if ( !IsValid( Ent ) ) then return end
    Ent:SetModel( "models/props_c17/doll01.mdl" )
    local Burnt = Color( 0, 0, 0, 255 )

    Ent:SetPos( self:GetOwner():EyePos() + (self:GetOwner():GetAimVector() * 25 ) )
    Ent:SetAngles( 
        self:GetOwner():EyeAngles() )
    Ent:Ignite(7.5)
    timer.Simple(1, function ()
        Ent:SetColor(Burnt)
    end)
 
    Ent:Spawn()
    

    local phys = Ent:GetPhysicsObject()
    if ( !IsValid( phys ) ) then ent:Remove() return end


    local velocity = 
    self:GetOwner():GetAimVector()
    velocity = velocity * 5000
    velocity = velocity + (VectorRand() * 10)
    phys:ApplyForceCenter( velocity )
   

    cleanup.Add( 
        self:GetOwner(), "props", Ent )

    undo.Create( "Thrown_Baby" )
        undo.AddEntity( Ent )
        undo.SetPlayer( 
            self:GetOwner() )
    undo.Finish()

    self:ShootEffects()

    
    self:SetNextPrimaryFire( CurTime() + 0.25 )
    

end