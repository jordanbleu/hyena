#
# This project was abandoned but i'm keeping it around in case I ever need to refernce any of the Lua code :)

## I ran into some un-recoverable performance issues, and thus will be rewriting this entire game.

Turns out the playdate sdk's implementation of sprites and what i'd call 'pseudo-objects' isn't very performant
for certain use-cases, and unfortunately this game was one of them.  Sprites, in particular, have a lot of overhead
for things like collision detection, z-indexing, calculating redraws, and garbage collection.  My issue, in particular,
was the fact that a shoot-em-up requires a ton of moving sprites all at once.

I was running into frame rate drops with around 12 enemy sprites on screen at a time.  I had considered trying to 
work around this limitation but it would really limit my vision of how I wanted this game to be.

As you can probably see from this code, I went with a whole 'everything is sprites / objects' approach.  Sadly I think
this was a fundamental enough design choice that it's not worth trying to de-object-ify the entire code base, or even
use a hybrid OO / non-OO approach.  Therefore, I think i'll have to rewrite it all.

I am keeping this codebase around though, for two reasons.  One, I'm going to still reference some of the code for my 
own use ;) and also in case anyone is looking for some (objectively) clean OO code for a playdate game.  This approach 
would be much more ideal for a scenario with less moving sprites.  I think my segmented scene code worked really well,
and made development super easy.


# -----------------------------------------------

# hyena
PlayDate Game that I'm making

# File Structure

* **resources** - files that won't be included in the built .pdx files
    * examples: photoshop / aseprite files 
* **source** - everything in this folder gets compiled so don't add garbage
    * **_meta**: files related to the package itself / the playdate UI
    * **images**: .png files only
    * **scripts**: all .lua files go in here in a somewhat organized fashion
    * **sounds**: sounds only (wav or mp3 or whatever we use)
    * **xx.strings**: Localized strings.  
    * **pdxinfo**: File that playdate uses for metadata

## animations 

The playdate sdk doesn't support spritesheets so we have to deal with individual frames. 
So to deal with clutter, we bury animations in folders.  The structure should look something like this:

```
images
  |_ category
      |_ whateverAnim 
         |_ blah-table-1.png
         |_ blah-table-2.png
         |_ blah-table-3.png
         |_ whatever-table-1.png 
         |_ whatever-table-2.png 
```

Note that:
* the folder holding animations is suffixed with 'anim'
* multiple animations can go inside the same folder

# localization

Normal localization for things like menus / etc are done via normal playdate localization framework, i.e. use the en.strings file.  

## dialogue localization

Dialogue files go somewhere inside the `strings/dialogue-en` folder.  A single file should be a single dialogue exchange between characters.  

There are three parts to each line in the dialogue files:

* Avatar ID is the avatar animation (see below for details).  
* Title is the name of the character, or "[N/A]" if there's no one talking (narration, etc)
* The text is the actual dialogue text obviously :)

Note if you leave those blank it will crash the game so don't do that. 

Avatars work in a very particular way, so do these steps:

In `source/images/ui/dialogue/avatars` add a folder for your avatar.  The name should be something like 'avatarNameAnim' to match the naming conventions of the others.  

Inside of there add image table anims like you normally would, except name the images like "avatar-table-x.png".  If there's only one image, just add a single "avatar-table-1.png" image.  

Now, when you write your dialogue line, for the avatar id write the name of the avatar anim folder, including the 'anim' part.  

ALTERNATELY for situations where there's no avatar, in the text file write "[N/A]"


For example:

* Inside of source/images/ui/dialogue/avatars there'd be a folder called 'whateverSadFaceAnim'.
* Inside whateverSadFaceAnim there'd be 'avatar-table-1, avatar-table-2, etc
* in the dialogue text file you'd say something like "whatevetSadFaceAnim|Sad Guy|I am so sad"

# sprite sizes

* Standard cutscene background is 400 x 160

# naming conventions

## scenes

* scenes are generally just named 'sceneXXXX', regardless if theyre a cutscene or whatever.  The XXXX indicates the general order.
* XXXX increases in increments of 10 in case new stuff needs to get stuffed in between later
* Always pad with zeros so the order looks correct in vs code (so 0010, 0110, etc) 


# .strings 

* the goal is just to quickly understand what a thing is used for / where it is located in code.
* do something like 'sceneName.category.description' or 'sceneName.descripton'
* So if it's a cutscene we can just call it 'scene01010.thingIsSaid' where 'thingIsSaid' is a basic summary of what is said 
* If it's something more complex like a ui we'd do 'mainMenu.playButton.text'
