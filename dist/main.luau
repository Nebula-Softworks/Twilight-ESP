local a a={cache={}, load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}end return a.cache[b].c end}do function a.a()
local function cast(b)
return cloneref and cloneref(game:GetService(b))or game:GetService(b)
end


local b={}
setmetatable(b,{
__index=function(c,d)
return cast(d)
end,
})
return b end function a.b()

return{}end end

local b,
c=a.load('a'),a.load('b')

local d,
e,
f,
g=b.Players,b.RunService,b.UserInputService,workspace.CurrentCamera
local h,

i=d.LocalPlayer,{
Settings={


Enabled=false,
Checks={
Visible={
Enabled=false,
OnlyVisible=false,
Recolor=false,
},
Team={
Enabled=false,
SelectedTeams={
enemy=false,
friendly=false,
generic=false,
self=false,
},
},
},

currentColors={
generic={
Box={
Outline={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
Fill={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},
CornerBox={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},

healthBar={
Outline=Color3.new(1,1,1),
Fills={
Low=Color3.new(1,1,1),
Medium=Color3.new(1,1,1),
High=Color3.new(1,1,1),
},
},

Tracer={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},

Text=Color3.new(1,1,1),

Chams={
Outline={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
Fill={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},

Skeleton={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},
friendly={
Box={
Outline={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
Fill={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},
CornerBox={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},

healthBar={
Outline=Color3.new(1,1,1),
Fills={
Low=Color3.new(1,1,1),
Medium=Color3.new(1,1,1),
High=Color3.new(1,1,1),
},
},

Tracer={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},

Text=Color3.new(1,1,1),

Chams={
Outline={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
Fill={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},

Skeleton={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},
enemy={
Box={
Outline={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
Fill={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},
CornerBox={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},

healthBar={
Outline=Color3.new(1,1,1),
Fills={
Low=Color3.new(1,1,1),
Medium=Color3.new(1,1,1),
High=Color3.new(1,1,1),
},
},

Tracer={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},

Text=Color3.new(1,1,1),

Chams={
Outline={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
Fill={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},

Skeleton={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},
self={
Box={
Outline={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
Fill={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},
CornerBox={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},

healthBar={
Outline=Color3.new(1,1,1),
Fills={
Low=Color3.new(1,1,1),
Medium=Color3.new(1,1,1),
High=Color3.new(1,1,1),
},
},

Tracer={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},

Text=Color3.new(1,1,1),

Chams={
Outline={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
Fill={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},

Skeleton={
Visible=Color3.new(1,1,1),
Invisible=Color3.new(1,1,1),
},
},
},

healthBarSettings={
Enabled={
enemy=false,
friendly=false,
self=false,
generic=false,
},

Bar=false,
Text=false,
MaxHealthEnabled=false,

Position=1,
Suffix="HP",
},

Style=1,
Box={
Enabled=false,
Filled={
Enabled=false,
Transparency=0.6,
},
Thickness=1,
},
CornerBox={
Enabled=false,
Thickness=3,
},

Tracer={
Enabled={
enemy=false,
friendly=false,
generic=false,
},
Origin=1,
Style=1,
Thickness=1,
},

Name={
Enabled={
enemy=false,
friendly=false,
self=false,
generic=false,
},

Style=1,
},
Distance={
Enabled={
enemy=false,
friendly=false,
self=false,
generic=false,
},
DistanceUnit=1,
},

Chams={
Enabled={
enemy=false,
friendly=false,
self=false,
generic=false,
},
Outline={
Enabled=true,
Thickness=0.1,
Transparency=0.5,
},
Fill=true,
OutlineThickness=0.1,
Occlusion=false,
},

Skeleton={
Enabled={
enemy=false,
friendly=false,
self=false,
generic=false,
},
Thickness=1,
Transparency=1,
ExplicitBodyType=nil,
},

TextSize=14,
MaxDistance=2000,
RefreshRate=4.166666666666667E-3,

Snaplines=true,
},

Drawings={
ESP={},
Tracers={},
Boxes={},
Healthbars={},
Names={},
Distances={},
Snaplines={},
Skeleton={},
},
Highlights={},

_connections={},
}

function i.CleanupESP()
for j,k in ipairs(d:GetPlayers())do


end
i.Drawings.ESP={}
i.Drawings.Skeleton={}
i.Highlights={}
end

function i:Load()end

function i:Unload(j)end

function i:BindESPToObject(j,k)end

function i:EnablePlayerESP()end

function i:DisablePlayerESP()end

return i