## What kind of plugin is 'Basic Kreedz Menu'?
Basic Kreedz Menu (BKM) is a small and simple AMX Mod X plugin that allows the client to

1) Place checkpoints which save current position and facing direction.
2) Teleport to the previous, or previous-previous checkpoint.

It's main purpose is to be used as a handy tool for Kreedz players in Counter-Strike 1.6. Many climbers do not like to do pro runs (no checkpoints) as it can be very unforgiving due to lost progress when the player makes mistakes, as such this tool allows climbers to place checkpoints and teleport back to them in case they fail important jumps.

## Requirements

* **AMX Mod X 1.9** (not been tested on anything lower, e.g. 1.8.2)
* `engine` module (comes with AMX Mod X)
* `fun` module (comes with AMX Mod X)
* `fakemeta` module (comes with AMX Mod X)

## How do add the plugin to my server?
Simply generate the `BasicKreedzMenu.amxx` file (see below instructions on how to compile `.sma` files), place it in `addons\amxmodx\plugins` and update `addons\amxmodx\configs\plugins.ini` by adding a new line that lists the plugin `BasicKreedzMenu.amxx`.

Start the server and run `amx_plugins` in the server console. If you see `[...] Basic Kreedz Menu ... BasicKreedzMenu running` as an entry, the plugin should be successfully installed and ready to be used by clients on your server.

## How do I compile my `.sma` script to an `.amxx` file?

* If you're using AMXX-Studio, go into `Tools -> Settings -> Compiler -> Compiler Settings` and set the `Compiler` path to the `amxxpc.exe` located in your servers `addons\amxmodx\scripting` folder.

* Another way to compile your `.sma` script is to copy it to `addons\amxmodx\scripting` then running `compile <name_of_the_script>.sma` in the terminal from directory. The resulting `.amxx` file will be saved in the `addons\amxmodx\scripting\compiled` folder.
