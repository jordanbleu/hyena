# Project Hyene Code Docs

# Standards / patterns / rules

### Global variables are incredibly rare

They should only be used in rare cases, or for enums (in the `enums.lua` file).

### User proper casing

GLOBAL_VARIABLES use all uppercase snake case
methodNames use camel case
ClassNames use pascal case
luaFileNames and folders are camel case 
resource-file-names are kebab case

### Every game object is a sprite

This simplifies logic because every object will automatically have its `update()` function called. It also makes the scene transitions easier.

Classes can extend each other but everything used as an in game object that updates each frame should extend gfx.sprite.

### Use OO except everything is public.

Because lua / the playdate sdk don't have any sort of private methods, the only other option would be to use local functions. However that makes things a pain because they have to be defined in a particular order and because you'd have to pass `self` everywhere.  So instead we just go with the normal object functionality.  

**Functions that are meant to be 'private' should be prepended with a "_".  For example:**

```lua
ClassName:_privateMethod(param1, param2)
```

The one awkward example to this is the 'update' function since that's overriding the sprite's update function.  So...i guess just don't call the update function anywhere because that's weird.

### Classes should be organized in the proper order

1. Aliasing of commonly used playdate sdk things:

```lua 
local gfx <const> = playdate.graphics
```

2. Class definition with a block comment explaining what it does

```lua
--[[ this class does whawkjewlkjflkwejflk ]]
class("WhateverClass").extends(gfx.sprite)
```

3. locals

```lua
local var1 
local var2
local var3

local ENUM_EXAMPLE <const> = 
{
    BLAH1 = 0,
    BLAH2 = 1
}

```

4. Constructor

```lua
function WhateverClass:init(params)
    -- initialization stuff
end 
```

5. public methods
6. private methods

### Z-Index Standards

0-10 - background layers

0 = farthest BG, usually a static image

1-9 = parallax layers

11-20 - Behind Actors

21-30 - Actors

30 - Player - black screen

31 - Player

50 - effects

100+ - UI

### Troubleshooting

* Game freezes up and simulator is unresponsive 
  * Check if you're doing one of the following:
    * Calling a super class method without passing in `self`
    * Using `gfx.image.load('path')` instead of `gfx.image.new('path')`
    * Calling a super class method like `self.xxx` instead of `self:xxx`
    * Missing an import.
        *  To test this in the debugger, check if the function you're calling is `nil`
    * Infinite recursion or something  
   * If you're still stuck, try running the .pdx manually without debugging, this makes the playdate terminal work.


* VS Code Debug button stops working with the playdate debug extension 
  * (These steps are specific to Jordan's computer tbh)
  * Go to the 'debug' menu option in vs code
  * click "run in playdate simulator'
  * It doesn't work
  * For some reason this mades the debug button work again lol

### Performance Notes

* The max amount of `basicEnemy` instances that should be on screen at a time seems to be about 16 (16 will give mild frame drops though).  This is for a 16x16 image, with very little movement logic
* For collision logic, instead of iterating over every collision, it seems to be better to just respond to the first collision each frame