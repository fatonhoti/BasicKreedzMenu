# Useful resources related to AMX Mod X plugin creation for Counter-Strike 1.6.

* **AMX Mod X API**: https://www.amxmodx.org/api/

* **AMX Mod X Downloads**: [https://www.amxmodx.org/](https://www.amxmodx.org/downloads.php)

* **Online .sma compiler:** https://www.amxmodx.org/webcompiler.cgi

* **AlliedModders forum:** https://forums.alliedmods.net/forumdisplay.php?f=3

## How do I compile my `.sma` script to an `.amxx` file?

* If you're using AMXX-Studio, go into `Tools -> Settings -> Compiler -> Compiler Settings` and set the `Compiler` path to the `amxxpc.exe` located in your servers `addons\amxmodx\scripting` folder.

* Another way to compile your `.sma` script is to copy it to `addons\amxmodx\scripting` then running `compile <name_of_the_script>.sma` in the terminal from directory. The resulting `.amxx` file will be saved in the `addons\amxmodx\scripting\compiled` folder.
