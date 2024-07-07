// https://www.amxmodx.org/api/
#include <amxmodx>
#include <amxmisc>

#define PLUGIN "XXX"
#define VERSION "YYY"
#define AUTHOR "ZZZ"

public plugin_init() {
    register_plugin(PLUGIN, VERSION, AUTHOR);
}

public plugin_precache() {
    register_clcmd("say /ping", "cmdPingPong");
}

public cmdPingPong(id) {
    client_print(id, print_chat, "Pong!");
    return PLUGIN_HANDLED;
}
