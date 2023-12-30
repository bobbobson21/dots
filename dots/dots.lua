	
	local dots = {}
	local DotsCode = {}
	local DotsCodeOparationData = {}
	local ImportedFile = {...}
	VarNil = "{[!£$%^&*dotsvarnil*&^%$£!]}"

function OnClose() end --to make something happpend when the program closes
function OparationOut( DotID, Oparation, X, Y ) end --can be used for knowing the op exacuted
function GetUserInputText() return "enter Input: " end --gets user Input text
function SetUserInputText( Tex ) function GetUserInputText() return Tex end end --can be used to give a reason for user Input
function GetFileDirectory() return ( string.match( ( ImportedFile[1] or "" ), "^(.*[/\\])[^/\\]-$", 1 ) or "" ) end --get file dir
function GetFileName() return ( string.match( ( ImportedFile[1] or "" ), "[\\/]([^/\\]+)$", 1 ) or "" ) end --get file name
function Var( K, V ) --to make safe vars
if V == nil then return DotsCodeOparationData["LUACODESAFEVAR_"..tostring( K )] end
	DotsCodeOparationData["LUACODESAFEVAR_"..tostring( K )] = V
if V == VarNil then DotsCodeOparationData["LUACODESAFEVAR_"..tostring( K )] = nil end
end

function CMDClear() --clears jargon from cmd window
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

function ReadFromFile( FileDir, PrintCode ) --reads from a file
	local File = io.open( FileDir, "r" )
	local FileData = File:read( "*all" )..string.char( 10 )..""; File:close()
	local EndOfLastLinePos = 1

for Z = 1, string.len( FileData ) do
if string.sub( FileData, Z, Z ) == string.char( 10 ) or string.sub( FileData, Z, Z +1 ) == ";;" then
	DotsCode[#DotsCode +1] = string.sub( FileData, EndOfLastLinePos, Z -1 )
if PrintCode == true then print( DotsCode[#DotsCode] ) end
	EndOfLastLinePos = Z +1
if string.sub( FileData, Z, Z +1 ) == ";;" then EndOfLastLinePos = EndOfLastLinePos +1 end
      end
   end
end

function ReadFromUserInput( UserCreatedNewLineCount ) --reads from user Input
if UserCreatedNewLineCount == nil then UserCreatedNewLineCount = 1 end
	local LineCountDisplayText = tostring( UserCreatedNewLineCount ).."| "

if UserCreatedNewLineCount <= 9 then LineCountDisplayText = "0"..LineCountDisplayText end
if UserCreatedNewLineCount <= 99 then LineCountDisplayText = "0"..LineCountDisplayText end
io.write( LineCountDisplayText )

	local Input = io.read()..";;"

if Input ~= "run;;" then
	local EndOfLastLinePos = 1
for Z = 1, string.len( Input ) do
if string.sub( Input, Z, Z ) == string.char( 10 ) or string.sub( Input, Z, Z +1 ) == ";;" then
	DotsCode[#DotsCode +1] = string.sub( Input, EndOfLastLinePos, Z -1 )
	EndOfLastLinePos = Z +1
if string.sub( Input, Z, Z +1 ) == ";;" then EndOfLastLinePos = EndOfLastLinePos +1 end
   end
end

ReadFromUserInput( UserCreatedNewLineCount +1 )
   end
end

function CompileRead( CompileFromLine, CompileUpToLine ) --compiles the code that was read into the program
	CompileFromLine = CompileFromLine or 1
for Z = CompileFromLine, ( CompileUpToLine or #DotsCode ) do --makes comments work
	local LineHasComentPastThisPoint, Nil = string.find( DotsCode[Z], "''", 1, true )
if LineHasComentPastThisPoint ~= nil then
	DotsCode[Z] = string.sub( DotsCode[Z], 1, LineHasComentPastThisPoint -1 )
   end
end

for Z = CompileFromLine, ( CompileUpToLine or #DotsCode ) do --loads in dots also the forth unit of data is for storing stuff
for Y = 1, string.len( DotsCode[Z] ) do
if string.sub( DotsCode[Z], Y, Y ) == "." or string.sub( DotsCode[Z], Y, Y ) == "•" then
	local HasDotEntBeenAdded = false
if string.sub( DotsCode[Z], Y+1, Y +1 ) == "-" and HasDotEntBeenAdded ~= true then dots[#dots +1], HasDotEntBeenAdded = {["X"]=Y,["Y"]=Z,["Dir"]="px",["data"]=nil}, true end --to right
if string.sub( DotsCode[Z +1] or "", Y, Y ) == "|" and HasDotEntBeenAdded ~= true then dots[#dots +1], HasDotEntBeenAdded = {["X"]=Y,["Y"]=Z,["Dir"]="py",["data"]=nil}, true end --down if line is on the line ahead on Y
if string.sub( DotsCode[Z], Y-1, Y -1 ) == "-" and HasDotEntBeenAdded ~= true then dots[#dots +1], HasDotEntBeenAdded = {["X"]=Y,["Y"]=Z,["Dir"]="nx",["data"]=nil}, true end --to left
if string.sub( DotsCode[Z -1] or "", Y, Y ) == "|" and HasDotEntBeenAdded ~= true then dots[#dots +1], HasDotEntBeenAdded = {["X"]=Y,["Y"]=Z,["Dir"]="ny",["data"]=nil}, true end --up if line starts behind it on y
         end
      end
   end
end

CMDClear()

if ImportedFile[1] ~= nil then ReadFromFile( ImportedFile[1], false ) else ReadFromUserInput() end --how program should open

CMDClear()
CompileRead()
math.randomseed( math.floor( os.time() /10000000 ) )
::mainloop:: --the main loop, the nexus of the dots wrold -----------------------------------------------------------------------------------------------------
if dots[DotsCodeOparationData["OnlyRunThis"]] == nil then DotsCodeOparationData["OnlyRunThis"] = nil end --this prevents reading errors so dont delete it

for K, V in pairs( dots ) do
if DotsCodeOparationData["OnlyRunThis"] == nil or K == DotsCodeOparationData["OnlyRunThis"] then --this prevents reading errors so dont delete it

if V["Dir"] == "px" then V["X"] = V["X"] +1 end
if V["Dir"] == "nx" then V["X"] = V["X"] -1 end
if V["Dir"] == "ny" then V["Y"] = V["Y"] -1 end
if V["Dir"] == "py" then V["Y"] = V["Y"] +1 end

	local DotsCurrentOparation = string.sub( DotsCode[V["Y"]] or "", V["X"], V["X"] )
	local IsOparationInvalid = true --will invalid untill the oparation proves its validness

if ( V["Y"] <= 0 or V["X"] <= 0 ) and V["BlankSpacesDontKill"] ~= true then dots[K] = nil; IsOparationInvalid = false end
if dots[K] ~= nil and ( DotsCurrentOparation == "" or DotsCurrentOparation == " " ) and V["BlankSpacesDontKill"] ~= true then dots[K] = nil; IsOparationInvalid = false end

if V["BlankSpacesDontKill"] == true then
if V["X"] <= 0 or V["X"] >= string.len( DotsCode[V["Y"]] or "" ) +1 then print( "DOT["..tostring( K ).."] left the codespace and could not be destroyed at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if V["Y"] <= 0 or V["Y"] >= #DotsCode +1 then print( "DOT["..tostring( K ).."] left the codespace and could not be destroyed at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
end

-- the main important stuff to the codeing lang is bellow -----------------------------------------------------------------------------------------------------

if DotsCurrentOparation == "`" and IsOparationInvalid == true and dots[K] ~= nil then IsOparationInvalid, V["DONTEDIT"] = false, true end

if DotsCurrentOparation == "$" and IsOparationInvalid == true and dots[K] ~= nil and V["DONTEDIT"] ~= true and V["FuncScan"] ~= true and V["WriteScan"] ~= true then if V["PrintScan"] == nil then V["BlankSpacesDontKill"], V["PrintScan"] = true, true else V["BlankSpacesDontKill"], V["PrintScan"] = nil, nil end; IsOparationInvalid = false end
if dots[K] ~= nil and V["PrintScan"] == true and IsOparationInvalid == true then --print content
	IsOparationInvalid = false
	local TextReplace = DotsCurrentOparation
if V["DONTEDIT"] ~= true then
if DotsCurrentOparation == "#" then TextReplace = V["Data"] end
if DotsCurrentOparation == "-" and string.sub( V["Dir"], 2, 2 ) == "x" then TextReplace = " " end
if DotsCurrentOparation == "|" and string.sub( V["Dir"], 2, 2 ) == "y" then TextReplace = " " end
if DotsCurrentOparation == "" and string.sub( V["Dir"], 2, 2 ) == "y" then TextReplace = " " end
end
if V["PrintText"] == nil then V["PrintText"] = "" end
	V["PrintText"] = V["PrintText"]..tostring( TextReplace )
end
if dots[K] ~= nil and V["PrintScan"] ~= true and V["PrintText"] ~= nil then
print( V["PrintText"] )
	V["PrintText"], V["PrintScan"] = nil, nil
end

if ( DotsCurrentOparation == "(" or DotsCurrentOparation == ")" ) and IsOparationInvalid == true and dots[K] ~= nil and V["DONTEDIT"] ~= true and V["PrintScan"] ~= true and V["WriteScan"] ~= true then if V["FuncScan"] == nil then V["BlankSpacesDontKill"], V["FuncScan"] = true, true else V["BlankSpacesDontKill"], V["FuncScan"] = nil, nil end; IsOparationInvalid = false end
if dots[K] ~= nil and V["FuncScan"] ~= nil and V["FuncScan"] == true and IsOparationInvalid == true then --function content
	IsOparationInvalid = false
	local TextReplace = DotsCurrentOparation
if V["DONTEDIT"] ~= true then
if DotsCurrentOparation == "#" then TextReplace = V["Data"] end
if DotsCurrentOparation == "-" and string.sub( V["Dir"], 2, 2 ) == "x" then TextReplace = " " end
if DotsCurrentOparation == "|" and string.sub( V["Dir"], 2, 2 ) == "y" then TextReplace = " " end
if DotsCurrentOparation == "" and string.sub( V["Dir"], 2, 2 ) == "y" then TextReplace = " " end
end
if V["FuncText"] == nil then V["FuncText"] = "" end
	V["FuncText"] = V["FuncText"]..tostring( TextReplace )
end
if dots[K] ~= nil and V["FuncScan"] ~= true and V["FuncText"] ~= nil then
if string.sub( V["FuncText"], 1, 1 ) == "c" then --create
DotsCodeOparationData["FUNC_"..string.sub( V["FuncText"], 3, string.len( V["FuncText"] ) )] = {["X"]=V["X"],["Y"]=V["Y"],["Dir"]=V["Dir"],}
	dots[K] = nil
end
if string.sub( V["FuncText"], 1, 1 ) == "e" then --exacute
	local Func = DotsCodeOparationData["FUNC_"..string.sub( V["FuncText"], 3, string.len( V["FuncText"] ) )]
if Func ~= nil then
	V["X"] = Func["X"]
	V["Y"] = Func["Y"]
	V["Dir"] = Func["Dir"]
	V["TiedToFunction"] = string.sub( V["FuncText"], 3, string.len( V["FuncText"] ) )
else
print( "DOT["..tostring( K ).."] tried to exacute invalid function at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return
   end
end
if string.sub( V["FuncText"], 1, 1 ) == "r" then --return
	local FuncName = string.sub( V["FuncText"], 3, string.len( V["FuncText"] ) )
if V["TiedToFunction"] ~= FuncName then print( "DOT["..tostring( K ).."] tried to return data for a function not associated with dot at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["FUNC_"..FuncName] == nil then print( "DOT["..tostring( K ).."] tried to return for invalid function at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	DotsCodeOparationData["FUNC_RET_"..FuncName] = V["Data"]
	dots[K] = nil
end
if string.sub( V["FuncText"], 1, 1 ) == "g" then --get
if DotsCodeOparationData["FUNC_"..string.sub( V["FuncText"], 3, string.len( V["FuncText"] ) )] == nil then print( "DOT["..tostring( K ).."] tried to get from invalid function at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	V["Data"] = DotsCodeOparationData["FUNC_RET_"..string.sub( V["FuncText"], 3, string.len( V["FuncText"] ) )]
end
if string.sub( V["FuncText"], 1, 1 ) == "p" then --probe
	V["Data"] = ( DotsCodeOparationData["FUNC_"..string.sub( V["FuncText"], 3, string.len( V["FuncText"] ) )] ~= nil )
end
if string.sub( V["FuncText"], 1, 1 ) == "t" then --terminate
if DotsCodeOparationData["FUNC_"..FuncName] == nil then print( "DOT["..tostring( K ).."] tried to terminate a invalid function at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	DotsCodeOparationData["FUNC_RET_"..FuncName] = nil
	DotsCodeOparationData["FUNC_"..FuncName] = nil
end
if string.sub( V["FuncText"], 1, 1 ) == "l" then --lua
	local Run, Err = load( string.sub( V["FuncText"], 3, string.len( V["FuncText"] ) ) )
function GetDotKV( L ) return V[L] end
function SetDotKV( L, W ) V[L] = W end
function RemoveDot() dots[K] = nil end
	local Returned = Run()
if Returned ~= nil then V["Data"] = Returned end
end
if string.sub( V["FuncText"], 1, 1 ) == "d" then --dots
	DotsCode[#DotsCode +1], DotsCode[#DotsCode +1] = "", "" --adds two empty lines into the program
	local CodeOrFileOfCode = string.sub( V["FuncText"], 3, string.len( V["FuncText"] ) )
	local loadpoint = #DotsCode
	local EndOfLastLinePos = 1
	local File = io.open( CodeOrFileOfCode, "r" )

if File == nil then
	CodeOrFileOfCode = CodeOrFileOfCode..";"
for Z = 1, string.len( CodeOrFileOfCode ) do --reads our code into the program
if string.sub( CodeOrFileOfCode, Z, Z ) == string.char( 10 ) or string.sub( CodeOrFileOfCode, Z, Z ) == ";" then
	DotsCode[#DotsCode +1] = string.sub( CodeOrFileOfCode, EndOfLastLinePos, Z -1 )
	EndOfLastLinePos = Z +1
   end
end

CompileRead( loadpoint ) --compiles new code
else
File:close()
ReadFromFile( CodeOrFileOfCode ) --ReadFromFile can only add not remove or edit and that makes this useful here
CompileRead( loadpoint )
   end
end

if dots[K] ~= nil then
	V["FuncText"], V["FuncScan"] = nil, nil
   end
end

if DotsCurrentOparation == "#" and IsOparationInvalid == true and dots[K] ~= nil and V["DONTEDIT"] ~= true and V["FuncScan"] ~= true and V["PrintScan"] ~= true then if V["WriteScan"] == nil then V["BlankSpacesDontKill"], V["WriteScan"] = true, true else V["BlankSpacesDontKill"], V["WriteScan"] = nil, nil end; IsOparationInvalid = false end
if dots[K] ~= nil and V["WriteScan"] == true and IsOparationInvalid == true then --write to dot content
	IsOparationInvalid = false
	local TextReplace = DotsCurrentOparation
if V["DONTEDIT"] ~= true then
if DotsCurrentOparation == "-" and string.sub( V["Dir"], 2, 2 ) == "x" then TextReplace = " " end
if DotsCurrentOparation == "|" and string.sub( V["Dir"], 2, 2 ) == "y" then TextReplace = " " end
if DotsCurrentOparation == "" and string.sub( V["Dir"], 2, 2 ) == "y" then TextReplace = " " end
end
if V["WriteText"] == nil then V["WriteText"] = "" end
	V["WriteText"] = V["WriteText"]..tostring( TextReplace )
end
if dots[K] ~= nil and V["WriteScan"] ~= true and V["WriteText"] ~= nil then
	V["Data"] = V["WriteText"]
if V["Data"] == "nil" then V["Data"] = nil end
if V["Data"] == "true" then V["Data"] = true end
if V["Data"] == "false" then V["Data"] = false end
if tonumber( V["Data"] ) ~= nil then V["Data"] = tonumber( V["Data"] ) end
	V["WriteText"] = nil
	V["WriteScan"] = nil
end
if DotsCurrentOparation == "?" then
	IsOparationInvalid = false
io.write( GetUserInputText() )
V["Data"] = io.read()
if V["Data"] == "nil" then V["Data"] = nil end
if V["Data"] == "true" then V["Data"] = true end
if V["Data"] == "false" then V["Data"] = false end
if tonumber( V["Data"] ) ~= nil then V["Data"] = tonumber( V["Data"] ) end
end

if DotsCodeOparationData["OnlyRunThisOnManual"] ~= true and V["DONTEDIT"] ~= true then
if DotsCurrentOparation == "$" and V["FuncScan"] ~= true and V["WriteScan"] ~= true then
if DotsCodeOparationData["OnlyRunThis"] == nil then DotsCodeOparationData["OnlyRunThis"] = K else DotsCodeOparationData["OnlyRunThis"] = nil end
end
if ( DotsCurrentOparation == "(" or DotsCurrentOparation == ")" ) and V["PrintScan"] ~= true and V["WriteScan"] ~= true then
if DotsCodeOparationData["OnlyRunThis"] == nil then DotsCodeOparationData["OnlyRunThis"] = K else DotsCodeOparationData["OnlyRunThis"] = nil end
end
if DotsCurrentOparation == "#" and V["PrintScan"] ~= true and V["FuncScan"] ~= true then
if DotsCodeOparationData["OnlyRunThis"] == nil then DotsCodeOparationData["OnlyRunThis"] = K else DotsCodeOparationData["OnlyRunThis"] = nil end
   end
end

if DotsCurrentOparation ~= "`" and dots[K] ~= nil and V["DONTEDIT"] == true then V["DONTEDIT"] = nil end

	local InBracket = false
if ( DotsCurrentOparation == "[" or string.sub( DotsCode[V["Y"]] or "", V["X"] -1, V["X"] -1 ) == "[" or string.sub( DotsCode[V["Y"]] or "", V["X"] -2, V["X"] -2 ) == "[" ) and IsOparationInvalid == true and dots[K] ~= nil then IsOparationInvalid, InBracket = false, true end
if ( DotsCurrentOparation == "[" or string.sub( DotsCode[V["Y"]] or "", V["X"] +1, V["X"] +1 ) == "]" or string.sub( DotsCode[V["Y"]] or "", V["X"] +2, V["X"] +2 ) == "]" ) and IsOparationInvalid == true and dots[K] ~= nil then IsOparationInvalid = false end

if DotsCurrentOparation == "]" and IsOparationInvalid == true and dots[K] ~= nil then IsOparationInvalid, InBracket = false, true end

if ( IsOparationInvalid == true or InBracket == true ) and dots[K] ~= nil then
	local IsMuiltyOparationInvalid = true

if string.sub( DotsCode[V["Y"]] or "", V["X"] -1, V["X"] -1 ) == "[" and string.sub( DotsCode[V["Y"]] or "", V["X"] +1, V["X"] +1 ) == "]" then
if DotsCodeOparationData["OnlyRunThis"] == K then print( "DOT["..tostring( K ).."] exacuted a multi oparation that can not be done with OnlyRunThis.dot running at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if V["Data"] == "reset" then DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )], dots[K] = nil, nil end

if dots[K] ~= nil then
if DotsCurrentOparation == "*" then --muiltyply
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] *V["Data"]
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil 
   end
end
if DotsCurrentOparation == "/" then --divide
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] /V["Data"]
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == "+" then --add
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] =  DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] +V["Data"]
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == "-" then --takeaway
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] -V["Data"]
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == "%" then --modules/ persent math
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] %V["Data"]
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == "^" then --num ^num
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ^V["Data"]
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == "&" then --and gate
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "boolean" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = ( ( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == true ) and ( V["Data"] == true ) )
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == "!" then --not gate
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "boolean" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	V["Data"] = ( V["Data"] == false )
end
if DotsCurrentOparation == "o" then --or gate
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "boolean" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = ( ( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == true ) or ( V["Data"] == true ) )
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == "x" then --xor gate
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "boolean" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = (  ( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == true ) or ( V["Data"] == true ) )
if ( ( V["Data"] == true ) and ( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == true ) ) then V["Data"] = false end
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == ">" then --more than
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = ( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] > V["Data"] )
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == "<" then --less than
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = ( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] < V["Data"] )
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == "=" then --equals
	IsMuiltyOparationInvalid = false
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = ( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == V["Data"] )
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if DotsCurrentOparation == "~" then --not equals
	IsMuiltyOparationInvalid = false
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = ( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= V["Data"] )
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end

if IsMuiltyOparationInvalid == true then print( "DOT["..tostring( K ).."] tried to exacute a invalid multi oparation at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
   end
end
 
if string.sub( DotsCode[V["Y"]] or "", V["X"] -2, V["X"] -2 ) == "[" and string.sub( DotsCode[V["Y"]] or "", V["X"] +2, V["X"] +2 ) == "]" then
	local newop = string.sub( DotsCode[V["Y"]] or "", V["X"] -1, V["X"] +1 )

if DotsCodeOparationData["OnlyRunThis"] == K then print( "DOT["..tostring( K ).."] exacuted a multi oparation that can not be done with OnlyRunThis.dot running at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if V["Data"] == "reset" then DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )], dots[K] = nil, nil end

if dots[K] ~= nil then
if newop == "=>=" then --more than
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = ( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] >= V["Data"] )
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if newop == "=<=" then --less than
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = ( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] <= V["Data"] )
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if newop == "apl" then --append left
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] =  V["data"]..DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )]
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if newop == "apr" then --append right
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )]..V["Data"]
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if newop == "fir" then --find right
	IsMuiltyOparationInvalid = false
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == nil then DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = {} end
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][#DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] +1] = V["Data"]
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == 1 and type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] >= 2 and type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] >= 3 then
	local MasterString = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][3]
	local FindInMasterString = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][2]
	local StartSearchingFrom = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][1]

	local StringLeft, StringRight = string.find( MasterString, FindInMasterString, StartSearchingFrom, true )
	V["Data"] = StringRight
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	dots[K] = nil
   end
end

if newop == "fil" then --find right
	IsMuiltyOparationInvalid = false
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == nil then DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = {} end
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][#DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] +1] = V["Data"]
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == 1 and type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] >= 2 and type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] >= 3 then
	local MasterString = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][3]
	local FindInMasterString = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][2]
	local StartSearchingFrom = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][1]

	local StringLeft, StringRight = string.find( MasterString, FindInMasterString, StartSearchingFrom, true )
	V["Data"] = StringLeft
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	dots[K] = nil
   end
end
if newop == "rep" then --string replace
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == nil then DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = {} end
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][#DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] +1] = V["Data"]
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] >= 3 then
	local MasterString = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][3]
	local FindInMasterString = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][2]
	local ReplaceFindWithString = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][1]
	local StringLeft, StringRight = string.find( MasterString, tofind, Z, false )
	local StartSearchingFrom = 1
	
while (StringLeft ~= nil and StringRight ~= nil) do
	StringLeft, StringRight = string.find( MasterString, tofind, Z, false )
if StringLeft ~= nil and StringRight ~= nil then
	MasterString = string.sub( MasterString, 1, StringLeft -1 )..ReplaceFindWithString..string.sub( MasterString, StringRight +1, string.len( MasterString ) )
	StartSearchingFrom = StringRight
   end
end

	V["Data"] = MasterString
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	dots[K] = nil
   end
end
if newop == "sub" then --string sub
	IsMuiltyOparationInvalid = false
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == nil then DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = {} end
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][#DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] +1] = V["Data"]
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == 3 and type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] <= 2 and type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] >= 3 then
	local MasterString = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][3]
	local LeftCut = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][2]
	local RightCut = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][1]

	V["Data"] = string.sub( MasterString, LeftCut, RightCut )
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	dots[K] = nil
   end
end
if newop == "ext" then --extract
	IsMuiltyOparationInvalid = false
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == nil then DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = {} end
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][#DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] +1] = V["Data"]
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == 1 and type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] >= 2 and type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if #DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] >= 3 then
	local MasterString = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][3]..DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][2]
	local FindInMasterString = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][2]
	local StopExtractionAfter = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )][1]
	local EndOfLastLinePos = 1
	local CurrentExtractonPoint = 0
	
for Z = 1, string.len( MasterString ) do
if string.sub( MasterString, Z, Z+ ( string.len( FindInMasterString ) -1 ) ) == FindInMasterString and CurrentExtractonPoint <= StopExtractionAfter then
	V["Data"] = string.sub( MasterString, EndOfLastLinePos, Z -1 )
	CurrentExtractonPoint = CurrentExtractonPoint +1
	EndOfLastLinePos = Z +string.len( FindInMasterString )
   end 
end
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	dots[K] = nil
   end
end
if newop == "rnd" then --random
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= nil then 
	V["Data"] = math.random( math.min( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )], V["Data"] ), math.max( DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )], V["Data"] ) )
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	 DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = V["Data"]
	 dots[K] = nil
   end
end
if newop == "typ" then --type
	IsMuiltyOparationInvalid = false
	V["Data"] = type( V["Data"] )
end
if newop == "ton" then --tonumber
	IsMuiltyOparationInvalid = false
	V["Data"] = tonumber( V["Data"] ) or 0
end
if newop == "tos" then --tostring
	IsMuiltyOparationInvalid = false
	V["Data"] = tostring( V["Data"] ) or ""
end
if newop == "toc" then --to char
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	V["Data"] = string.char( V["Data"] )
end
if newop == "tob" then --to byte
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	V["Data"] = string.byte( V["data"], 1, 1 )
end
if newop == "upp" then --upper
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	V["Data"] = string.upper( V["Data"] )
end
if newop == "low" then --lower
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	V["Data"] = string.lower( V["Data"] )
end
if newop == "len" then --lower
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "string" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	V["Data"] = string.len( V["Data"] )
end
if newop == "rou" then --round
	IsMuiltyOparationInvalid = false
if type( V["Data"] ) ~= "number" then print( "DOT["..tostring( K ).."] pass a type of data on to a multi oparation that can not accept that type of data at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	V["Data"] = math.floor( V["Data"] +0.50 )
end
	local fillpower = tonumber( newop ) or 0
if fillpower >= 2 and fillpower <= 888 then --count DotsCurrentOparation
	IsMuiltyOparationInvalid = false
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] == nil then DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = 0 end
DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] +1
if DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] >= fillpower then 
	DotsCodeOparationData["[]_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
else
	dots[K] = nil
   end
end

if IsMuiltyOparationInvalid == true then print( "DOT["..tostring( K ).."] tried to exacute a invalid multi oparation at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ) end
      end
   end
end

if ( DotsCurrentOparation == "-" or DotsCurrentOparation == "|" or DotsCurrentOparation == "+" or DotsCurrentOparation == "." or DotsCurrentOparation == "•" ) and IsOparationInvalid == true and dots[K] ~= nil then --path content
	IsOparationInvalid = false
if dots[K] ~= nil and ( V["Dir"] == "px" or V["Dir"] == "nx" ) and DotsCurrentOparation == "|" then print( "DOT["..tostring( K ).."] crashed in to other track at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if dots[K] ~= nil and ( V["Dir"] == "py" or V["Dir"] == "ny" ) and DotsCurrentOparation == "-" then print( "DOT["..tostring( K ).."] crashed in to other track at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
end

if DotsCurrentOparation == ">" and IsOparationInvalid == true and dots[K] ~= nil then V["Dir"] = "px"; IsOparationInvalid = false end --movement content
if DotsCurrentOparation == "<" and IsOparationInvalid == true and dots[K] ~= nil then V["Dir"] = "nx"; IsOparationInvalid = false end
if DotsCurrentOparation == "^" and IsOparationInvalid == true and dots[K] ~= nil then V["Dir"] = "ny"; IsOparationInvalid = false end
if DotsCurrentOparation == "V" and IsOparationInvalid == true and dots[K] ~= nil then V["Dir"] = "py"; IsOparationInvalid = false end

if ( DotsCurrentOparation == "/" or DotsCurrentOparation == string.char( 92 ) ) and dots[K] ~= nil then
if V["Data"] == "reset" then DotsCodeOparationData["//_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil end
if V["invertflow"] == true and dots[K] ~= nil then
if DotsCodeOparationData["//_"..tostring( V["X"] )..","..tostring( V["Y"] )] ~= true then DotsCodeOparationData["//_"..tostring( V["X"] )..","..tostring( V["Y"] )] = true else DotsCodeOparationData["//_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil end
	V["invertflow"] = nil
end
if DotsCodeOparationData["//_"..tostring( V["X"] )..","..tostring( V["Y"] )] == true and dots[K] ~= nil then
if DotsCurrentOparation == "/" then DotsCurrentOparation = string.char( 92 ) else DotsCurrentOparation = "/" end
   end
end

if DotsCurrentOparation == "/" and IsOparationInvalid == true and dots[K] ~= nil then --angled reflectors
if V["Dir"] == "px" and IsOparationInvalid ~= false then V["Dir"], IsOparationInvalid = "ny", false end
if V["Dir"] == "nx" and IsOparationInvalid ~= false then V["Dir"], IsOparationInvalid = "py", false end
if V["Dir"] == "py" and IsOparationInvalid ~= false then V["Dir"], IsOparationInvalid = "nx", false end
if V["Dir"] == "ny" and IsOparationInvalid ~= false then V["Dir"], IsOparationInvalid = "px", false end
end

if DotsCurrentOparation == string.char( 92 ) and IsOparationInvalid == true and dots[K] ~= nil then --angled reflectors
if V["Dir"] == "px" and IsOparationInvalid ~= false then V["Dir"], IsOparationInvalid = "py", false end
if V["Dir"] == "nx" and IsOparationInvalid ~= false then V["Dir"], IsOparationInvalid = "ny", false end
if V["Dir"] == "py" and IsOparationInvalid ~= false then V["Dir"], IsOparationInvalid = "px", false end
if V["Dir"] == "ny" and IsOparationInvalid ~= false then V["Dir"], IsOparationInvalid = "nx", false end
end

if DotsCurrentOparation == "*" and IsOparationInvalid == true and dots[K] ~= nil then --dotdupe content
if DotsCodeOparationData["OnlyRunThis"] == K then print( "DOT["..tostring( K ).."] exacuted an oparation that should not be exacuted with OnlyRunThis.dot running at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
	IsOparationInvalid = false
	local d = string.sub( V["Dir"], 2, 2 )
	local exspandabletbla, exspandabletblb = {}, {}
for L, W in pairs( V ) do exspandabletbla[L], exspandabletblb[L] = W, W end

if string.sub( DotsCode[V["Y"]] or "", V["X"] +1, V["X"] +1 ) == "-" and d == "y" then
	exspandabletbla["Dir"] = "px"
	dots[#dots +1] = exspandabletbla
end
if string.sub( DotsCode[V["Y"]] or "", V["X"] -1, V["X"] -1 ) == "-" and d == "y" then
	exspandabletblb["Dir"] = "nx"
	dots[#dots +1] = exspandabletblb
end
if string.sub( DotsCode[V["Y"] +1] or "", V["X"], V["X"] ) == "|" and d == "x" then
	exspandabletbla["Dir"] = "py"
	dots[#dots +1] = exspandabletbla
end
if string.sub( DotsCode[V["Y"] -1] or "", V["X"], V["X"] ) == "|" and d == "x" then
	exspandabletblb["Dir"] = "ny"
	dots[#dots +1] = exspandabletblb
end
if V["Dir"] == "px" and string.sub( DotsCode[V["Y"]] or "", V["X"] +1, V["X"] +1 ) ~= "-" then dots[K] = nil end
if V["Dir"] == "nx" and string.sub( DotsCode[V["Y"]] or "", V["X"] -1, V["X"] -1 ) ~= "-" then dots[K] = nil end
if V["Dir"] == "py" and string.sub( DotsCode[V["Y"] +1] or "", V["X"], V["X"] ) ~= "|" then dots[K] = nil end
if V["Dir"] == "ny" and string.sub( DotsCode[V["Y"] -1] or "", V["X"], V["X"] ) ~= "|" then dots[K] = nil end
end
if DotsCurrentOparation == "=" and IsOparationInvalid == true and dots[K] ~= nil then --only make one dot move and all other dots freeze
	IsOparationInvalid = false
if DotsCodeOparationData["OnlyRunThis"] == nil then DotsCodeOparationData["OnlyRunThis"] = K else DotsCodeOparationData["OnlyRunThis"] = nil end
if DotsCodeOparationData["OnlyRunThisOnManual"] == nil then DotsCodeOparationData["OnlyRunThisOnManual"] = true else DotsCodeOparationData["OnlyRunThisOnManual"] = nil end
end

if DotsCurrentOparation == "A" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "A", false end --bracket gate key content
if DotsCurrentOparation == "B" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "B", false end
if DotsCurrentOparation == "C" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "C", false end
if DotsCurrentOparation == "D" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "D", false end
if DotsCurrentOparation == "E" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "E", false end
if DotsCurrentOparation == "F" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "F", false end
if DotsCurrentOparation == "G" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "G", false end
if DotsCurrentOparation == "H" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "H", false end
if DotsCurrentOparation == "I" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "I", false end
if DotsCurrentOparation == "J" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "J", false end
if DotsCurrentOparation == "K" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "K", false end
if DotsCurrentOparation == "L" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "L", false end
if DotsCurrentOparation == "M" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "M", false end
if DotsCurrentOparation == "N" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "N", false end
if DotsCurrentOparation == "O" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "O", false end
if DotsCurrentOparation == "P" and IsOparationInvalid == true and dots[K] ~= nil then V["gatekey"], IsOparationInvalid = "P", false end

if DotsCurrentOparation == "@" and IsOparationInvalid == true and dots[K] ~= nil then --send the dots data through the bracket gate to other dots
	V["GateData"], IsOparationInvalid = true, false
if V["invertflow"] == true then V["GateData"], V["invertflow"] = "INVERTED", nil end
end
if DotsCurrentOparation == "}" and IsOparationInvalid == true and dots[K] ~= nil then --bracket gate content
	IsOparationInvalid = false

if V["Data"] == "reset" then V["gatekey"], V["GateData"], V["Data"] = nil, nil, nil end
if DotsCodeOparationData["OnlyRunThis"] == K then print( "DOT["..tostring( K ).."] exacuted an oparation that should not be exacuted with OnlyRunThis.dot running at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if V["Dir"] == "py" or V["Dir"] == "ny" then print( "DOT["..tostring( K ).."] tried to exacute oparation incorrectly at"..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if V["Dir"] == "nx" then V["Dir"], V["Gate"] = "na", "}" end
if V["Dir"] == "px" then
for L, W in pairs( dots ) do
if DotsCodeOparationData["{}_"..tostring( W["X"] )..","..tostring( W["Y"] )] ~= true then
if V["GateData"] ~= "INVERTED" or V["Data"] == W["Data"] then
if W["Gate"] == "{" and V["GateKey"] == W["GateKey"] and W ~= V then W["Dir"] = "px" end
if W["Gate"] == "}" and V["GateKey"] == W["GateKey"] and W ~= V then W["Dir"] = "nx" end
if V["GateKey"] == W["GateKey"] and W ~= V then
if V["GateData"] == true then W["Data"] = V["Data"] end
	DotsCodeOparationData["{}_"..tostring( W["X"] )..","..tostring( W["Y"] )] = true
	W["gatekey"], W["GateData"], W["Gate"] = nil, nil
	     end
	  end
   end
end
	V["gatekey"], V["GateData"] = nil, nil
   end
end
if DotsCurrentOparation == "{" and IsOparationInvalid == true and dots[K] ~= nil then
	IsOparationInvalid = false

if V["Data"] == "reset" then V["gatekey"], V["GateData"], V["Data"] = nil, nil, nil end
if DotsCodeOparationData["OnlyRunThis"] == K then print( "DOT["..tostring( K ).."] exacuted an oparation that can not be done with OnlyRunThis.dot running at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if V["Dir"] == "py" or V["Dir"] == "ny" then print( "DOT["..tostring( K ).."] tried to exacute oparation incorrectly at"..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if V["Dir"] == "px" then V["Dir"], V["Gate"] = "na", "{" end
if V["Dir"] == "nx" then
for L, W in pairs( dots ) do
if DotsCodeOparationData["{}_"..tostring( W["X"] )..","..tostring( W["Y"] )] ~= true then
if V["GateData"] ~= "INVERTED" or W["Data"] == V["Data"] then
if W["Gate"] == "{" and V["GateKey"] == W["GateKey"] and W ~= V then W["Dir"] = "px" end
if W["Gate"] == "}" and V["GateKey"] == W["GateKey"] and W ~= V then W["Dir"] = "nx" end
if V["GateKey"] == W["GateKey"] and W ~= V then
if V["GateData"] == true then W["Data"] = V["Data"] end
	DotsCodeOparationData["{}_"..tostring( W["X"] )..","..tostring( W["Y"] )] = true
	W["gatekey"], W["GateData"], W["Gate"] = nil, nil
	     end
	  end
   end
end
	V["gatekey"], V["GateData"] = nil, nil
   end
end

if DotsCurrentOparation == "~" and IsOparationInvalid == true and dots[K] ~= nil then
	IsOparationInvalid = false

if V["Dir"] == "ny" then
if V["Data"] ~= nil and V["Data"] ~= false then
	DotsCodeOparationData["cf_"..tostring( V["X"] )..","..tostring( V["Y"] )] = true
end
if V["invertflow"] == true and ( V["Data"] == nil or V["Data"] == false ) then
	DotsCodeOparationData["cf_"..tostring( V["X"] )..","..tostring( V["Y"] )] = true
end
	dots[K] = nil
end
if DotsCodeOparationData["cf_"..tostring( V["X"] )..","..tostring( V["Y"] )] == true and dots[K] ~= nil then
	DotsCodeOparationData["cf_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil
	V["Dir"] = "ny"
end
if V["Data"] == "reset" then DotsCodeOparationData["cf_"..tostring( V["X"] )..","..tostring( V["Y"] )] = nil end
end

if DotsCurrentOparation == ":" and IsOparationInvalid == true and dots[K] ~= nil then
	IsOparationInvalid = false
if V["Data"] ~= nil and V["Data"] ~= false then
	V["Dir"] = "ny"
end
if V["invertflow"] == true and ( V["Data"] == nil or V["Data"] == false ) then
	V["Dir"] = "ny"
end
	V["invertflow"] = nil
end

	local jumpower = tonumber( DotsCurrentOparation ) or 0 --allows dots to jump spaces
if jumpower >= 2 and jumpower <= 8 and IsOparationInvalid == true and dots[K] ~= nil then
	IsOparationInvalid = false
if V["Dir"] == "px" then V["X"] = V["X"] +( jumpower -1 ) end
if V["Dir"] == "nx" then V["X"] = V["X"] -( jumpower -1 ) end
if V["Dir"] == "py" then V["Y"] = V["Y"] +( jumpower -1 ) end
if V["Dir"] == "ny" then V["Y"] = V["Y"] -( jumpower -1 ) end
end

if DotsCurrentOparation == "&" and IsOparationInvalid == true and dots[K] ~= nil then
	IsOparationInvalid = false
for L, W in pairs( dots ) do dots[L] = nil end
end

if DotsCurrentOparation ~= "!" and dots[K] ~= nil and V["invertflow"] == true then print( "DOT["..tostring( K ).."] exacuted a flow inverter oparation without a invertable oparation infont of dot at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end
if DotsCurrentOparation == "!" and IsOparationInvalid == true and dots[K] ~= nil then V["invertflow"], IsOparationInvalid = true, false end

	local OpparationBeingInvalidIsFine = false
if InBracket ~= true and V["PrintScan"] ~= true and V["WriteScan"] ~= true and V["FuncScan"] ~= true then OpparationBeingInvalidIsFine = OparationOut( V, DotsCurrentOparation, V["X"], V["Y"] ) end
if InBracket == true then  OpparationBeingInvalidIsFine = OparationOut( K, "[]", V["X"], V["Y"] ) end
if V["PrintScan"] == true then OpparationBeingInvalidIsFine = OparationOut( K, "$", V["X"], V["Y"] ) end
if V["WriteScan"] == true then OpparationBeingInvalidIsFine = OparationOut( K, "#", V["X"], V["Y"] ) end
if V["FuncScan"] == true then OpparationBeingInvalidIsFine = OparationOut( K, "()", V["X"], V["Y"] ) end

if OpparationBeingInvalidIsFine == true then IsOparationInvalid = false end
if IsOparationInvalid == true and dots[K] ~= nil then print( "DOT["..tostring( K ).."] tried to exacute a invalid oparation at "..tostring( V["X"] )..", "..tostring( V["Y"] ) ); return end

   end
end

	local GateCode = "{}_" --stops gates from breaking due to clogage
for K, V in pairs( DotsCodeOparationData ) do
if string.sub( K, 1, string.len( GateCode ) ) == GateCode then
	DotsCodeOparationData[K] = nil
   end
end

if next( dots ) ~= nil then goto mainloop else OnClose() end

