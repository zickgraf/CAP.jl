function StringFile( filename )
	try
		read( filename, String )
	catch e
		fail
	end
end

function FileString( filename, str )
	try
		write( filename, str )
	catch e
		fail
	end
end

function DirectoryTemporary( )
	dir = tempname( ) * "/"
	mkdir( dir )
	dir
end

function Filename( dir, name )
	dir * name
end
