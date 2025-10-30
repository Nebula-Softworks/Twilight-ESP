# Twilight ESP Suite
![Image](https://github.com/Nebula-Softworks/Twilight-ESP/blob/master/assets/Twilight%20Cover%20Image.png?raw=true)

***

## The Pitch
Twilight, the extrasenory star.  
Twilight was made as to provide a beautiful and sexy ESP Library that met the new standard of 'looking nice' with the classic drawing style, maintaining an easy to use and bloat-free API for developers to use. Packed with full customisability, Twilight is open-sourced too!
### Why Twilight?  
It looks good. I can probably count with my fingers how many ESP Libraries as powerful as Twilight that look good. I mean sure Sense is powerful, but does it really look nice? And that brings me to the other reason, and that is the API. If you ever find a nice looking ESP, it is probably not even a Library - and even if it is, there is no way it is as powerful or simple to use as Twilight.  
So Start using Twilight, the extrasensory star, today.  
  
## Preview
|||
|---|---|
| ![preview](https://docs.nebulasoftworks.xyz/img/twilight/Twilight.png) | ![preview2](https://docs.nebulasoftworks.xyz/img/twilight/config.png) |
  

## Structure Of Twilight
A semi-Rojo project made via modular Luau scripts, compiled for usage by Darklua and Lune. Semi-Rojo as it is used for Luau LSP and Selene Linter, but doesn't actually sync to Roblox.  
As of Version 1.2, Twilight does not support usage outside of executors supporting the Drawing sUNC function.  
Prior to Version 1.2, Twilight was compiled for usage with Maui by Latte Softworks.  
  

## [Documentation](https://docs.nebulasoftworks.xyz/twilight)  
> For Releases before Version 1.2, check the 1.1a release's assets.  
  

## How To Compile Your Changes?
> [!note]
> You Will Need Performant Node Package Manager (pnpm) and Python

First, clone the repo `git clone https://github.com/Nebula-Softworks/Twilight-ESP.git` if you have not already.  
Open the repo in your VSC Workspace OR Open the repo in Powershell/Command Prompt.  
Now, run `pnpm bundle`. Your changes will be bundled into the result at dist/Twilight.ESP.luau and dist/Twilight.ESP.rbxm.  
View the `build` folder to see and edit how the code is generated, including the header paragraph etc.  
  
### Using The Dev-Server Method
After completing the first 2 steps, run `pnpm dev-server`. Whenever you save changes, the dist/main.luau file will automatically update.  
In addition, the code will be generated with much more readable content, allowing for easier debugging.  
Replace your URL for HttpGet with `http://localhost:8642/dist/main.luau` - if you have changed the port, change it here as well.  
  

## Credits
Nebula Softworks - Design And Programming  
cyclic@luau.software - Helping With Some Project Setup  
Rojo - RBXM Model Builder, Luau LSP System, Development Helper.  
seaofvoices & Lune - Compiler  
JohnyMorganz - Language Server Used In Development  
Latte Softworks - Compiler prior to Version 1.2
  
  
> Copyright © 2025 Nebula Softworks. All rights reserved.
