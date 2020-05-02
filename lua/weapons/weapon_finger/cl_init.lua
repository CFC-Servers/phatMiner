include( "shared.lua" )

net.Receive( "magic_particle", function()
	local particleName = net.ReadString()
	local parentEnt = net.ReadEntity()
	local angle = net.ReadAngle()
	local duration = net.ReadInt(32)

	local pos = parentEnt:GetPos()

	local emitter = ParticleEmitter( parentEnt:GetPos(), true )
	for i = 0, 64 do
		local part = emitter:Add( particleName, pos )
		if ( part ) then
			part:SetDieTime( 2 )
			part:SetStartSize( 3 )
			part:SetEndSize( 3 )
			part:SetGravity( Vector( 0, 0, -250 ) )
			part:SetVelocity( VectorRand() * 50 )
		end
	end

	timer.Simple( duration, function()
		emitter:Finish()
	end )
end )
