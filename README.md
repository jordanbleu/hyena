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