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

## localization

Normal localization for things like menus / etc are done via normal playdate localization framework, i.e. use the en.strings file.  

### dialogue localization

Dialogue files go somewhere inside the `strings/dialogue-en` folder.  A single file should be a single dialogue exchange between characters.  

There are three parts to each line in the dialogue files:

* Avatar ID is the avatar animation (see below for details)
* Title is the name of the character, or "[N/A]" if there's no one talking (narration, etc)
* The text is the actual dialogue text obviously :)

Avatars work in a very particular way, so do these steps:

In `source/images/ui/dialogue/avatars` add a folder for your avatar.  The name should be something like 'avatarNameAnim' to match the naming conventions of the others.  

Inside of there add image table anims like you normally would, except name the images like "avatar-table-x.png".  If there's only one image, just add a single "avatar-table-1.png" image.  

Now, when you write your dialogue line, for the avatar id write the name of the avatar anim folder, including the 'anim' part.  

For example:

* Inside of source/images/ui/dialogue/avatars there'd be a folder called 'whateverSadFaceAnim'.
* Inside whateverSadFaceAnim there'd be 'avatar-table-1, avatar-table-2, etc
* in the dialogue text file you'd say something like "whatevetSadFaceAnim|Sad Guy|I am so sad"


