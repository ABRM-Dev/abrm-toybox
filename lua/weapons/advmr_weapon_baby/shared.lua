SWEP.PrintName = "Babyinator"
SWEP.Author = "AdventurousMR"
SWEP.Category = "Holmes Toybox"

SWEP.Spawnable = true

function SWEP:Initialize()
end

SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "	models/weapons/w_IRifle.mdl"

function SWEP:PrimaryAttack()

    if ( CLIENT ) then return end
    local Ent = ents.Create( "prop_physics" )
    if ( !IsValid( Ent ) ) then return end
    Ent:SetModel( "models/props_c17/doll01.mdl" )

    Ent:SetPos( self:GetOwner():EyePos() + (self:GetOwner():GetAimVector() * 1 ) )
    Ent:SetAngles( 
        self:GetOwner():EyeAngles() )
    Ent:Spawn()

    local phys = Ent:GetPhysicsObject()
	if ( !IsValid( phys ) ) then ent:Remove() return end

    local velocity = 
    self:GetOwner():GetAimVector()
    velocity = velocity * 1000
    velocity = velocity + (VectorRand() * 10)
    phys:ApplyForceCenter( velocity )

    cleanup.Add( 
        self:GetOwner(), "props", Ent )

    undo.Create( "Thrown_Baby" )
        undo.AddEntity( Ent )
        undo.SetPlayer( 
            self:GetOwner() )
    undo.Finish()

    self.BaseClass.ShootEffects(self)

    self:SetNextPrimaryFire( CurTime() + 0.25 )

end


function SWEP:SecondaryAttack()

    if ( CLIENT ) then return end
    local Ent = ents.Create( "prop_physics" )
    if ( !IsValid( Ent ) ) then return end
    Ent:SetModel( "models/props_c17/doll01.mdl" )

    Ent:SetPos( self:GetOwner():EyePos() + (self:GetOwner():GetAimVector() * 1 ) )
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

    self.BaseClass.ShootEffects(self)

    
    self:SetNextPrimaryFire( CurTime() + 0.25 )
    

end