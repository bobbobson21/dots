	
	local dots = {}
	local exportedcode = {}
	local operationdata = {}
	local importedfile = {...}
	varnil = "{[!£$%^&*dotsvarnil*&^%$£!]}"

function onclose() end --to make something happpend when the program closes
function operationout( dotid, op, x, y ) end --can be used for knowing the op exacuted
function getuit( tex ) return "enter input: " end --gets user input text
function changeuit( tex ) function getuit() return tex end end --can be used to give a reason for user input
function getfiledirectory() return ( string.match( ( importedfile[1] or "" ), "^(.*[/\\])[^/\\]-$", 1 ) or "" ) end --get file dir
function getfilename() return ( string.match( ( importedfile[1] or "" ), "[\\/]([^/\\]+)$", 1 ) or "" ) end --get file name
function var( k, v ) --to make safe vars
if v == nil then return operationdata["LUACODESAFEVAR_"..tostring( k )] end
	operationdata["LUACODESAFEVAR_"..tostring( k )] = v
if v == varnil then operationdata["LUACODESAFEVAR_"..tostring( k )] = nil end
end

function cmdclear() --clears jargon from cmd window
if os.getenv("USERPROFILE") ~= nil then
os.execute( "cls" )
else
if os.getenv("HOME") ~= nil then
os.execute( "clear" )
else
os.execute( "reset" )
      end
   end
end

function readff( filelocation, printcode ) --reads from a file
	local file = io.open( filelocation, "r" )
	local filedata = file:read( "*all" )..string.char( 10 )..""; file:close()
	local lastpoint = 1
	local inbrackets = false

for z = 1, string.len( filedata ) do
if string.sub( filedata, z, z ) == string.char( 10 ) or string.sub( filedata, z, z +1 ) == ";;" then
	exportedcode[#exportedcode +1] = string.sub( filedata, lastpoint, z -1 )
if printcode == true then print( string.sub( filedata, lastpoint, z -1 ) ) end
	lastpoint = z +1
if string.sub( filedata, z, z +1 ) == ";;" then lastpoint = lastpoint +1 end
      end
   end
end

function readfi( indepentcount ) --reads from user input
if indepentcount == nil then indepentcount = 1 end
	local icountout = tostring( indepentcount ).."| "

if indepentcount <= 9 then icountout = "0"..icountout end
if indepentcount <= 99 then icountout = "0"..icountout end
io.write( icountout )

	local input = io.read()..";;"

if input ~= "run;;" then
	local lastpoint = 1
for z = 1, string.len( input ) do
if string.sub( input, z, z ) == string.char( 10 ) or string.sub( input, z, z +1 ) == ";;" then
	exportedcode[#exportedcode +1] = string.sub( input, lastpoint, z -1 )
	lastpoint = z +1
if string.sub( input, z, z +1 ) == ";;" then lastpoint = lastpoint +1 end
   end
end

readfi( indepentcount +1 )
   end
end

function compileread( compilefrom, compileto ) --compiles the code that was read into the program
	compilefrom = compilefrom or 1
for z = compilefrom, ( compileto or #exportedcode ) do --makes comments work
	local ejectpoint, nill = string.find( exportedcode[z], "''", 1, true )
if ejectpoint ~= nil then
	exportedcode[z] = string.sub( exportedcode[z], 1, ejectpoint -1 )
   end
end
for z = compilefrom, ( compileto or #exportedcode ) do --loads in dots also the forth unit of data is for storing stuff
for y = 1, string.len( exportedcode[z] ) do
if string.sub( exportedcode[z], y, y ) == "." or string.sub( exportedcode[z], y, y ) == "•" then
	local addeddot = false
if string.sub( exportedcode[z], y+1, y +1 ) == "-" and addeddot ~= true then dots[#dots +1], addeddot = {["x"]=y,["y"]=z,["dir"]="px",["data"]=nil}, true end --to right
if string.sub( exportedcode[z +1] or "", y, y ) == "|" and addeddot ~= true then dots[#dots +1], addeddot = {["x"]=y,["y"]=z,["dir"]="py",["data"]=nil}, true end --down if line is on the line ahead on y
if string.sub( exportedcode[z], y-1, y -1 ) == "-" and addeddot ~= true then dots[#dots +1], addeddot = {["x"]=y,["y"]=z,["dir"]="nx",["data"]=nil}, true end --to left
if string.sub( exportedcode[z -1] or "", y, y ) == "|" and addeddot ~= true then dots[#dots +1], addeddot = {["x"]=y,["y"]=z,["dir"]="ny",["data"]=nil}, true end --up if line starts behind it on y
         end
      end
   end
end

cmdclear()

if importedfile[1] ~= nil then readff( importedfile[1], false ) else readfi() end --how program should open

cmdclear()
compileread()
math.randomseed( math.floor( os.time() /10000000 ) )
::mainloop:: --the main loop, the nexus of the dots wrold -----------------------------------------------------------------------------------------------------
if dots[operationdata["OnlyRunThis"]] == nil then operationdata["OnlyRunThis"] = nil end --this prevents reading errors so dont delete it

for k, v in pairs( dots ) do
if operationdata["OnlyRunThis"] == nil or k == operationdata["OnlyRunThis"] then --this prevents reading errors so dont delete it

if v["dir"] == "px" then v["x"] = v["x"] +1 end
if v["dir"] == "nx" then v["x"] = v["x"] -1 end
if v["dir"] == "ny" then v["y"] = v["y"] -1 end
if v["dir"] == "py" then v["y"] = v["y"] +1 end

	local operation = string.sub( exportedcode[v["y"]] or "", v["x"], v["x"] )
	local operationinvalid = true

if ( v["y"] <= 0 or v["x"] <= 0 ) and v["blankdontkill"] ~= true then dots[k] = nil; operationinvalid = false end
if dots[k] ~= nil and ( operation == "" or operation == " " ) and v["blankdontkill"] ~= true then dots[k] = nil; operationinvalid = false end

if v["blankdontkill"] == true then
if v["x"] <= 0 or v["x"] >= string.len( exportedcode[v["y"]] or "" ) +1 then print( "DOT["..tostring( k ).."] left the exportedcode space and could not be destroyed at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if v["y"] <= 0 or v["y"] >= #exportedcode +1 then print( "DOT["..tostring( k ).."] left the exportedcode space and could not be destroyed at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
end

-- the main important stuff to the codeing lang is bellow -----------------------------------------------------------------------------------------------------

if operation == "`" and operationinvalid == true and dots[k] ~= nil then operationinvalid, v["DONTEDIT"] = false, true end

if operation == "$" and operationinvalid == true and dots[k] ~= nil and v["DONTEDIT"] ~= true and v["funcscan"] ~= true and v["writescan"] ~= true then if v["printscan"] == nil then v["blankdontkill"], v["printscan"] = true, true else v["blankdontkill"], v["printscan"] = nil, nil end; operationinvalid = false end
if dots[k] ~= nil and v["printscan"] == true and operationinvalid == true then --print content
	operationinvalid = false
	local outop = operation
if v["DONTEDIT"] ~= true then
if operation == "#" then outop = v["data"] end
if operation == "-" and string.sub( v["dir"], 2, 2 ) == "x" then outop = " " end
if operation == "|" and string.sub( v["dir"], 2, 2 ) == "y" then outop = " " end
if operation == "" and string.sub( v["dir"], 2, 2 ) == "y" then outop = " " end
end
if v["printtext"] == nil then v["printtext"] = "" end
	v["printtext"] = v["printtext"]..tostring( outop )
end
if dots[k] ~= nil and v["printscan"] ~= true and v["printtext"] ~= nil then
print( v["printtext"] )
	v["printtext"], v["printscan"] = nil, nil
end

if ( operation == "(" or operation == ")" ) and operationinvalid == true and dots[k] ~= nil and v["DONTEDIT"] ~= true and v["printscan"] ~= true and v["writescan"] ~= true then if v["funcscan"] == nil then v["blankdontkill"], v["funcscan"] = true, true else v["blankdontkill"], v["funcscan"] = nil, nil end; operationinvalid = false end
if dots[k] ~= nil and v["funcscan"] ~= nil and v["funcscan"] == true and operationinvalid == true then --function content
	operationinvalid = false
	local outop = operation
if v["DONTEDIT"] ~= true then
if operation == "#" then outop = v["data"] end
if operation == "-" and string.sub( v["dir"], 2, 2 ) == "x" then outop = " " end
if operation == "|" and string.sub( v["dir"], 2, 2 ) == "y" then outop = " " end
if operation == "" and string.sub( v["dir"], 2, 2 ) == "y" then outop = " " end
end
if v["functext"] == nil then v["functext"] = "" end
	v["functext"] = v["functext"]..tostring( outop )
end
if dots[k] ~= nil and v["funcscan"] ~= true and v["functext"] ~= nil then
if string.sub( v["functext"], 1, 1 ) == "c" then --create
operationdata["FUNC_"..string.sub( v["functext"], 3, string.len( v["functext"] ) )] = {["x"]=v["x"],["y"]=v["y"],["dir"]=v["dir"],}
	dots[k] = nil
end
if string.sub( v["functext"], 1, 1 ) == "e" then --exacute
	local func = operationdata["FUNC_"..string.sub( v["functext"], 3, string.len( v["functext"] ) )]
if func ~= nil then
	v["x"] = func["x"]
	v["y"] = func["y"]
	v["dir"] = func["dir"]
	v["funcexacuted"] = string.sub( v["functext"], 3, string.len( v["functext"] ) )
else
print( "DOT["..tostring( k ).."] tried to exacute invalid function at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return
   end
end
if string.sub( v["functext"], 1, 1 ) == "r" then --return
	local funcname = string.sub( v["functext"], 3, string.len( v["functext"] ) )
if v["funcexacuted"] ~= funcname then print( "DOT["..tostring( k ).."] tried to return data for a function not associated with dot at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["FUNC_"..funcname] == nil then print( "DOT["..tostring( k ).."] tried to return for invalid function at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	operationdata["FUNC_RET_"..funcname] = v["data"]
	dots[k] = nil
end
if string.sub( v["functext"], 1, 1 ) == "g" then --get
if operationdata["FUNC_"..string.sub( v["functext"], 3, string.len( v["functext"] ) )] == nil then print( "DOT["..tostring( k ).."] tried to get from invalid function at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	v["data"] = operationdata["FUNC_RET_"..string.sub( v["functext"], 3, string.len( v["functext"] ) )]
end
if string.sub( v["functext"], 1, 1 ) == "p" then --probe
	v["data"] = ( operationdata["FUNC_"..string.sub( v["functext"], 3, string.len( v["functext"] ) )] ~= nil )
end
if string.sub( v["functext"], 1, 1 ) == "t" then --terminate
if operationdata["FUNC_"..funcname] == nil then print( "DOT["..tostring( k ).."] tried to terminate a invalid function at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	operationdata["FUNC_RET_"..funcname] = nil
	operationdata["FUNC_"..funcname] = nil
end
if string.sub( v["functext"], 1, 1 ) == "l" then --lua
	local f, e = load( string.sub( v["functext"], 3, string.len( v["functext"] ) ) )
function getdotkv( l ) return v[l] end
function setdotkv( l, w ) v[l] = w end
function removedot() dots[k] = nil end
	local returned = f()
if returned ~= nil then v["data"] = returned end
end
if string.sub( v["functext"], 1, 1 ) == "d" then --dots
	exportedcode[#exportedcode +1], exportedcode[#exportedcode +1] = "", "" --adds two empty lines into the program
	local cof = string.sub( v["functext"], 3, string.len( v["functext"] ) )
	local loadpoint = #exportedcode
	local lastpoint = 1
	local file = io.open( cof, "r" )

if file == nil then
	cof = cof..";"
for z = 1, string.len( cof ) do --reads our code into the program
if string.sub( cof, z, z ) == string.char( 10 ) or string.sub( cof, z, z ) == ";" then
	exportedcode[#exportedcode +1] = string.sub( cof, lastpoint, z -1 )
	lastpoint = z +1
   end
end

compileread( loadpoint ) --compiles new code
else
file:close()
readff( cof ) --readff can only add not remove or edit and that makes this useful here
compileread( loadpoint )
   end
end

if dots[k] ~= nil then
	v["functext"], v["funcscan"] = nil, nil
   end
end

if operation == "#" and operationinvalid == true and dots[k] ~= nil and v["DONTEDIT"] ~= true and v["funcscan"] ~= true and v["printscan"] ~= true and v["comparescan"] ~= true then if v["writescan"] == nil then v["blankdontkill"], v["writescan"] = true, true else v["blankdontkill"], v["writescan"] = nil, nil end; operationinvalid = false end
if dots[k] ~= nil and v["writescan"] == true and operationinvalid == true then --write to dot content
	operationinvalid = false
	local outop = operation
if v["DONTEDIT"] ~= true then
if operation == "-" and string.sub( v["dir"], 2, 2 ) == "x" then outop = " " end
if operation == "|" and string.sub( v["dir"], 2, 2 ) == "y" then outop = " " end
if operation == "" and string.sub( v["dir"], 2, 2 ) == "y" then outop = " " end
end
if v["writetext"] == nil then v["writetext"] = "" end
	v["writetext"] = v["writetext"]..tostring( outop )
end
if dots[k] ~= nil and v["writescan"] ~= true and v["writetext"] ~= nil then
	v["data"] = v["writetext"]
if v["data"] == "nil" then v["data"] = nil end
if v["data"] == "true" then v["data"] = true end
if v["data"] == "false" then v["data"] = false end
if tonumber( v["data"] ) ~= nil then v["data"] = tonumber( v["data"] ) end
	v["writetext"] = nil
	v["writescan"] = nil
end
if operation == "?" then
	operationinvalid = false
io.write( getuit() )
v["data"] = io.read()
if v["data"] == "nil" then v["data"] = nil end
if v["data"] == "true" then v["data"] = true end
if v["data"] == "false" then v["data"] = false end
if tonumber( v["data"] ) ~= nil then v["data"] = tonumber( v["data"] ) end
end

if operationdata["OnlyRunThisOnManual"] ~= true and v["DONTEDIT"] ~= true then
if operation == "$" and v["funcscan"] ~= true and v["writescan"] ~= true then
if operationdata["OnlyRunThis"] == nil then operationdata["OnlyRunThis"] = k else operationdata["OnlyRunThis"] = nil end
end
if ( operation == "(" or operation == ")" ) and v["printscan"] ~= true and v["writescan"] ~= true then
if operationdata["OnlyRunThis"] == nil then operationdata["OnlyRunThis"] = k else operationdata["OnlyRunThis"] = nil end
end
if operation == "#" and v["printscan"] ~= true and v["funcscan"] ~= true then
if operationdata["OnlyRunThis"] == nil then operationdata["OnlyRunThis"] = k else operationdata["OnlyRunThis"] = nil end
   end
end

if operation ~= "`" and dots[k] ~= nil and v["DONTEDIT"] == true then v["DONTEDIT"] = nil end

	local inbracket = false
if ( operation == "[" or string.sub( exportedcode[v["y"]] or "", v["x"] -1, v["x"] -1 ) == "[" or string.sub( exportedcode[v["y"]] or "", v["x"] -2, v["x"] -2 ) == "[" ) and operationinvalid == true and dots[k] ~= nil then operationinvalid, inbracket = false, true end
if ( operation == "[" or string.sub( exportedcode[v["y"]] or "", v["x"] +1, v["x"] +1 ) == "]" or string.sub( exportedcode[v["y"]] or "", v["x"] +2, v["x"] +2 ) == "]" ) and operationinvalid == true and dots[k] ~= nil then operationinvalid = false end

if operation == "]" and operationinvalid == true and dots[k] ~= nil then operationinvalid, inbracket = false, true end

if ( operationinvalid == true or inbracket == true ) and dots[k] ~= nil then
	local mopinvalid = true

if string.sub( exportedcode[v["y"]] or "", v["x"] -1, v["x"] -1 ) == "[" and string.sub( exportedcode[v["y"]] or "", v["x"] +1, v["x"] +1 ) == "]" then
if operationdata["OnlyRunThis"] == k then print( "DOT["..tostring( k ).."] exacuted a multi operation that can not be done with OnlyRunThis.dot running at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if v["data"] == "reset" then operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )], dots[k] = nil, nil end

if dots[k] ~= nil then
if operation == "*" then --muiltyply
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] *v["data"]
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil 
   end
end
if operation == "/" then --divide
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] /v["data"]
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == "+" then --add
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] =  operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] +v["data"]
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == "-" then --takeaway
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] -v["data"]
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == "%" then --modules/ persent math
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] %v["data"]
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == "^" then --num ^num
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ^v["data"]
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == "&" then --and gate
	mopinvalid = false
if type( v["data"] ) ~= "boolean" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = ( ( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == true ) and ( v["data"] == true ) )
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == "!" then --not gate
	mopinvalid = false
if type( v["data"] ) ~= "boolean" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	v["data"] = ( v["data"] == false )
end
if operation == "o" then --or gate
	mopinvalid = false
if type( v["data"] ) ~= "boolean" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = ( ( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == true ) or ( v["data"] == true ) )
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == "x" then --xor gate
	mopinvalid = false
if type( v["data"] ) ~= "boolean" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = (  ( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == true ) or ( v["data"] == true ) )
if ( ( v["data"] == true ) and ( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == true ) ) then v["data"] = false end
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == ">" then --more than
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = ( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] > v["data"] )
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == "<" then --less than
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = ( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] < v["data"] )
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == "=" then --equals
	mopinvalid = false
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = ( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == v["data"] )
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if operation == "~" then --not equals
	mopinvalid = false
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = ( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= v["data"] )
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end

if mopinvalid == true then print( "DOT["..tostring( k ).."] tried to exacute a invalid multi operation at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
   end
end
 
if string.sub( exportedcode[v["y"]] or "", v["x"] -2, v["x"] -2 ) == "[" and string.sub( exportedcode[v["y"]] or "", v["x"] +2, v["x"] +2 ) == "]" then
	local newop = string.sub( exportedcode[v["y"]] or "", v["x"] -1, v["x"] +1 )

if operationdata["OnlyRunThis"] == k then print( "DOT["..tostring( k ).."] exacuted a multi operation that can not be done with OnlyRunThis.dot running at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if v["data"] == "reset" then operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )], dots[k] = nil, nil end

if dots[k] ~= nil then
if newop == "=>=" then --more than
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = ( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] >= v["data"] )
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if newop == "=<=" then --less than
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = ( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] <= v["data"] )
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if newop == "apl" then --append left
	mopinvalid = false
if type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] =  v["data"]..operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )]
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if newop == "apr" then --append right
	mopinvalid = false
if type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )]..v["data"]
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if newop == "fir" then --find right
	mopinvalid = false
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == nil then operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = {} end
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][#operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] +1] = v["data"]
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == 1 and type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] >= 2 and type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] >= 3 then
	local mstring = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][3]
	local fstring = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][2]
	local posx = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][1]

	local strs, stre = string.find( mstring, fstring, posx, true )
	v["data"] = stre
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	dots[k] = nil
   end
end

if newop == "fil" then --find right
	mopinvalid = false
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == nil then operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = {} end
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][#operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] +1] = v["data"]
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == 1 and type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] >= 2 and type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] >= 3 then
	local mstring = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][3]
	local fstring = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][2]
	local posx = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][1]

	local strs, stre = string.find( mstring, fstring, posx, true )
	v["data"] = strs
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	dots[k] = nil
   end
end
if newop == "rep" then --string replace
	mopinvalid = false
if type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == nil then operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = {} end
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][#operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] +1] = v["data"]
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] >= 3 then
	local mstring = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][3]
	local tofind = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][2]
	local torelink = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][1]

for z = 1, string.len( mstring ) do
	local strs, stre = string.find( mstring, tofind, z, false )
if strs ~= nil and stre ~= nil then
	mstring = string.sub( mstring, 1, strs -1 )..torelink..string.sub( mstring, stre +1, string.len( mstring ) )
   end
end

	v["data"] = mstring
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	dots[k] = nil
   end
end
if newop == "sub" then --string sub
	mopinvalid = false
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == nil then operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = {} end
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][#operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] +1] = v["data"]
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == 3 and type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] <= 2 and type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] >= 3 then
	local mstring = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][3]
	local l = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][2]
	local r = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][1]

	v["data"] = string.sub( mstring, l, r )
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	dots[k] = nil
   end
end
if newop == "ext" then --extract
	mopinvalid = false
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == nil then operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = {} end
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][#operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] +1] = v["data"]
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == 1 and type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] >= 2 and type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if #operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] >= 3 then
	local mstring = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][3]
	local fstring = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][2]
	local wordx = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )][1]
	local lastpoint = 1
	local breakcount = 0
	
for z = 1, string.len( mstring ) do
if string.sub( mstring, z, z+ ( string.len( fstring ) -1 ) ) == fstring and breakcount <= wordx then
	v["data"] = string.sub( mstring, lastpoint, z -1 )
	breakcount = breakcount +1
	lastpoint = z +string.len( fstring )
   end 
end
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	dots[k] = nil
   end
end
if newop == "rnd" then --random
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= nil then 
	v["data"] = math.random( math.min( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )], v["data"] ), math.max( operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )], v["data"] ) )
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	 operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = v["data"]
	 dots[k] = nil
   end
end
if newop == "typ" then --type
	mopinvalid = false
	v["data"] = type( v["data"] )
end
if newop == "ton" then --tonumber
	mopinvalid = false
	v["data"] = tonumber( v["data"] ) or 0
end
if newop == "tos" then --tostring
	mopinvalid = false
	v["data"] = tostring( v["data"] ) or ""
end
if newop == "toc" then --to char
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	v["data"] = string.char( v["data"] )
end
if newop == "tob" then --to byte
	mopinvalid = false
if type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	v["data"] = string.byte( v["data"], 1, 1 )
end
if newop == "upp" then --upper
	mopinvalid = false
if type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	v["data"] = string.upper( v["data"] )
end
if newop == "low" then --lower
	mopinvalid = false
if type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	v["data"] = string.lower( v["data"] )
end
if newop == "len" then --lower
	mopinvalid = false
if type( v["data"] ) ~= "string" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	v["data"] = string.len( v["data"] )
end
if newop == "rou" then --round
	mopinvalid = false
if type( v["data"] ) ~= "number" then print( "DOT["..tostring( k ).."] pass a type of data on to a multi operation that can not accept that type of data at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	v["data"] = math.floor( v["data"] +0.50 )
end
	local fillpower = tonumber( newop ) or 0
if fillpower >= 2 and fillpower <= 888 then --count operation
	mopinvalid = false
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] == nil then operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = 0 end
operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] +1
if operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] >= fillpower then 
	operationdata["[]_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
else
	dots[k] = nil
   end
end

if mopinvalid == true then print( "DOT["..tostring( k ).."] tried to exacute a invalid multi operation at "..tostring( v["x"] )..", "..tostring( v["y"] ) ) end
      end
   end
end

if ( operation == "-" or operation == "|" or operation == "+" or operation == "." or operation == "•" ) and operationinvalid == true and dots[k] ~= nil then --path content
	operationinvalid = false
if dots[k] ~= nil and ( v["dir"] == "px" or v["dir"] == "nx" ) and operation == "|" then print( "DOT["..tostring( k ).."] crashed in to other track at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if dots[k] ~= nil and ( v["dir"] == "py" or v["dir"] == "ny" ) and operation == "-" then print( "DOT["..tostring( k ).."] crashed in to other track at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
end

if operation == ">" and operationinvalid == true and dots[k] ~= nil then v["dir"] = "px"; operationinvalid = false end --movement content
if operation == "<" and operationinvalid == true and dots[k] ~= nil then v["dir"] = "nx"; operationinvalid = false end
if operation == "^" and operationinvalid == true and dots[k] ~= nil then v["dir"] = "ny"; operationinvalid = false end
if operation == "v" and operationinvalid == true and dots[k] ~= nil then v["dir"] = "py"; operationinvalid = false end

if ( operation == "/" or operation == string.char( 92 ) ) and dots[k] ~= nil then
if v["data"] == "reset" then operationdata["//_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil end
if v["invertflow"] == true and dots[k] ~= nil then
if operationdata["//_"..tostring( v["x"] )..","..tostring( v["y"] )] ~= true then operationdata["//_"..tostring( v["x"] )..","..tostring( v["y"] )] = true else operationdata["//_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil end
	v["invertflow"] = nil
end
if operationdata["//_"..tostring( v["x"] )..","..tostring( v["y"] )] == true and dots[k] ~= nil then
if operation == "/" then operation = string.char( 92 ) else operation = "/" end
   end
end

if operation == "/" and operationinvalid == true and dots[k] ~= nil then --angled reflectors
if v["dir"] == "px" and operationinvalid ~= false then v["dir"], operationinvalid = "ny", false end
if v["dir"] == "nx" and operationinvalid ~= false then v["dir"], operationinvalid = "py", false end
if v["dir"] == "py" and operationinvalid ~= false then v["dir"], operationinvalid = "nx", false end
if v["dir"] == "ny" and operationinvalid ~= false then v["dir"], operationinvalid = "px", false end
end

if operation == string.char( 92 ) and operationinvalid == true and dots[k] ~= nil then --angled reflectors
if v["dir"] == "px" and operationinvalid ~= false then v["dir"], operationinvalid = "py", false end
if v["dir"] == "nx" and operationinvalid ~= false then v["dir"], operationinvalid = "ny", false end
if v["dir"] == "py" and operationinvalid ~= false then v["dir"], operationinvalid = "px", false end
if v["dir"] == "ny" and operationinvalid ~= false then v["dir"], operationinvalid = "nx", false end
end

if operation == "*" and operationinvalid == true and dots[k] ~= nil then --dotdupe content
if operationdata["OnlyRunThis"] == k then print( "DOT["..tostring( k ).."] exacuted an operation that should not be exacuted with OnlyRunThis.dot running at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
	operationinvalid = false
	local d = string.sub( v["dir"], 2, 2 )
	local exspandabletbla, exspandabletblb = {}, {}
for l, w in pairs( v ) do exspandabletbla[l], exspandabletblb[l] = w, w end

if string.sub( exportedcode[v["y"]] or "", v["x"] +1, v["x"] +1 ) == "-" and d == "y" then
	exspandabletbla["dir"] = "px"
	dots[#dots +1] = exspandabletbla
end
if string.sub( exportedcode[v["y"]] or "", v["x"] -1, v["x"] -1 ) == "-" and d == "y" then
	exspandabletblb["dir"] = "nx"
	dots[#dots +1] = exspandabletblb
end
if string.sub( exportedcode[v["y"] +1] or "", v["x"], v["x"] ) == "|" and d == "x" then
	exspandabletbla["dir"] = "py"
	dots[#dots +1] = exspandabletbla
end
if string.sub( exportedcode[v["y"] -1] or "", v["x"], v["x"] ) == "|" and d == "x" then
	exspandabletblb["dir"] = "ny"
	dots[#dots +1] = exspandabletblb
end
if v["dir"] == "px" and string.sub( exportedcode[v["y"]] or "", v["x"] +1, v["x"] +1 ) ~= "-" then dots[k] = nil end
if v["dir"] == "nx" and string.sub( exportedcode[v["y"]] or "", v["x"] -1, v["x"] -1 ) ~= "-" then dots[k] = nil end
if v["dir"] == "py" and string.sub( exportedcode[v["y"] +1] or "", v["x"], v["x"] ) ~= "|" then dots[k] = nil end
if v["dir"] == "ny" and string.sub( exportedcode[v["y"] -1] or "", v["x"], v["x"] ) ~= "|" then dots[k] = nil end
end
if operation == "=" and operationinvalid == true and dots[k] ~= nil then --only make one dot move and all other dots freeze
	operationinvalid = false
if operationdata["OnlyRunThis"] == nil then operationdata["OnlyRunThis"] = k else operationdata["OnlyRunThis"] = nil end
if operationdata["OnlyRunThisOnManual"] == nil then operationdata["OnlyRunThisOnManual"] = true else operationdata["OnlyRunThisOnManual"] = nil end
end

if operation == "A" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "A", false end --bracket gate key content
if operation == "B" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "B", false end
if operation == "C" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "C", false end
if operation == "D" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "D", false end
if operation == "E" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "E", false end
if operation == "F" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "F", false end
if operation == "G" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "G", false end
if operation == "H" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "H", false end
if operation == "I" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "I", false end
if operation == "J" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "J", false end
if operation == "K" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "K", false end
if operation == "L" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "L", false end
if operation == "M" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "M", false end
if operation == "N" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "N", false end
if operation == "O" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "O", false end
if operation == "P" and operationinvalid == true and dots[k] ~= nil then v["gatekey"], operationinvalid = "P", false end

if operation == "@" and operationinvalid == true and dots[k] ~= nil then --send the dots data through the bracket gate to other dots
	v["gatedata"], operationinvalid = true, false
if v["invertflow"] == true then v["gatedata"], v["invertflow"] = "INVERTED", nil end
end
if operation == "}" and operationinvalid == true and dots[k] ~= nil then --bracket gate content
	operationinvalid = false

if v["data"] == "reset" then v["gatekey"], v["gatedata"], v["data"] = nil, nil, nil end
if operationdata["OnlyRunThis"] == k then print( "DOT["..tostring( k ).."] exacuted an operation that should not be exacuted with OnlyRunThis.dot running at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if v["dir"] == "py" or v["dir"] == "ny" then print( "DOT["..tostring( k ).."] tried to exacute operation incorrectly at"..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if v["dir"] == "nx" then v["dir"], v["gate"] = "na", "}" end
if v["dir"] == "px" then
for l, w in pairs( dots ) do
if operationdata["{}_"..tostring( w["x"] )..","..tostring( w["y"] )] ~= true then
if v["gatedata"] ~= "INVERTED" or v["data"] == w["data"] then
if w["gate"] == "{" and v["gatekey"] == w["gatekey"] and w ~= v then w["dir"] = "px" end
if w["gate"] == "}" and v["gatekey"] == w["gatekey"] and w ~= v then w["dir"] = "nx" end
if v["gatekey"] == w["gatekey"] and w ~= v then
if v["gatedata"] == true then w["data"] = v["data"] end
	operationdata["{}_"..tostring( w["x"] )..","..tostring( w["y"] )] = true
	w["gatekey"], w["gatedata"], w["gate"] = nil, nil
	     end
	  end
   end
end
	v["gatekey"], v["gatedata"] = nil, nil
   end
end
if operation == "{" and operationinvalid == true and dots[k] ~= nil then
	operationinvalid = false

if v["data"] == "reset" then v["gatekey"], v["gatedata"], v["data"] = nil, nil, nil end
if operationdata["OnlyRunThis"] == k then print( "DOT["..tostring( k ).."] exacuted an operation that can not be done with OnlyRunThis.dot running at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if v["dir"] == "py" or v["dir"] == "ny" then print( "DOT["..tostring( k ).."] tried to exacute operation incorrectly at"..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if v["dir"] == "px" then v["dir"], v["gate"] = "na", "{" end
if v["dir"] == "nx" then
for l, w in pairs( dots ) do
if operationdata["{}_"..tostring( w["x"] )..","..tostring( w["y"] )] ~= true then
if v["gatedata"] ~= "INVERTED" or w["data"] == v["data"] then
if w["gate"] == "{" and v["gatekey"] == w["gatekey"] and w ~= v then w["dir"] = "px" end
if w["gate"] == "}" and v["gatekey"] == w["gatekey"] and w ~= v then w["dir"] = "nx" end
if v["gatekey"] == w["gatekey"] and w ~= v then
if v["gatedata"] == true then w["data"] = v["data"] end
	operationdata["{}_"..tostring( w["x"] )..","..tostring( w["y"] )] = true
	w["gatekey"], w["gatedata"], w["gate"] = nil, nil
	     end
	  end
   end
end
	v["gatekey"], v["gatedata"] = nil, nil
   end
end

if operation == "~" and operationinvalid == true and dots[k] ~= nil then
	operationinvalid = false

if v["dir"] == "ny" then
if v["data"] ~= nil and v["data"] ~= false then
	operationdata["cf_"..tostring( v["x"] )..","..tostring( v["y"] )] = true
end
if v["invertflow"] == true and ( v["data"] == nil or v["data"] == false ) then
	operationdata["cf_"..tostring( v["x"] )..","..tostring( v["y"] )] = true
end
	dots[k] = nil
end
if operationdata["cf_"..tostring( v["x"] )..","..tostring( v["y"] )] == true and dots[k] ~= nil then
	operationdata["cf_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil
	v["dir"] = "ny"
end
if v["data"] == "reset" then operationdata["cf_"..tostring( v["x"] )..","..tostring( v["y"] )] = nil end
end

if operation == ":" and operationinvalid == true and dots[k] ~= nil then
	operationinvalid = false
if v["data"] ~= nil and v["data"] ~= false then
	v["dir"] = "ny"
end
if v["invertflow"] == true and ( v["data"] == nil or v["data"] == false ) then
	v["dir"] = "ny"
end
	v["invertflow"] = nil
end

	local jumpower = tonumber( operation ) or 0 --allows dots to jump spaces
if jumpower >= 2 and jumpower <= 8 and operationinvalid == true and dots[k] ~= nil then
	operationinvalid = false
if v["dir"] == "px" then v["x"] = v["x"] +( jumpower -1 ) end
if v["dir"] == "nx" then v["x"] = v["x"] -( jumpower -1 ) end
if v["dir"] == "py" then v["y"] = v["y"] +( jumpower -1 ) end
if v["dir"] == "ny" then v["y"] = v["y"] -( jumpower -1 ) end
end

if operation == "&" and operationinvalid == true and dots[k] ~= nil then
	operationinvalid = false
for l, w in pairs( dots ) do dots[l] = nil end
end

if operation ~= "!" and dots[k] ~= nil and v["invertflow"] == true then print( "DOT["..tostring( k ).."] exacuted a flow inverter operation without a invertable operation infont of dot at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end
if operation == "!" and operationinvalid == true and dots[k] ~= nil then v["invertflow"], operationinvalid = true, false end

	local approveinvalidation = false
if inbracket ~= true and v["printscan"] ~= true and v["writescan"] ~= true and v["funcscan"] ~= true then approveinvalidation = operationout( v, operation, v["x"], v["y"] ) end
if inbracket == true then  approveinvalidation = operationout( k, "[]", v["x"], v["y"] ) end
if v["printscan"] == true then approveinvalidation = operationout( k, "$", v["x"], v["y"] ) end
if v["writescan"] == true then approveinvalidation = operationout( k, "#", v["x"], v["y"] ) end
if v["funcscan"] == true then approveinvalidation = operationout( k, "()", v["x"], v["y"] ) end

if approveinvalidation == true then operationinvalid = false end
if operationinvalid == true and dots[k] ~= nil then print( "DOT["..tostring( k ).."] tried to exacute a invalid operation at "..tostring( v["x"] )..", "..tostring( v["y"] ) ); return end

   end
end

	local gatecode = "{}_" --stops gates from breaking due to clogage
for k, v in pairs( operationdata ) do
if string.sub( k, 1, string.len( gatecode ) ) == gatecode then
	operationdata[k] = nil
   end
end

if next( dots ) ~= nil then goto mainloop else onclose() end

