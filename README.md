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

