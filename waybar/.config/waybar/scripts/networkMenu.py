#!/usr/bin/env python3
"""
Filename:   networkMenu.py
Author:     RedonlineOfficial
Created:    27OCT2025
Updated:    27OCT2025
Version:    v0.0.1-alpha
License:    UNLICENSE (https://unlicense.org)
"""
#!/usr/bin/env python3
import subprocess
import sys

# --- Helper ---
def run(cmd):
    """Run a shell command and return its stdout."""
    return subprocess.run(cmd, shell=True, capture_output=True, text=True).stdout.strip()

# --- Get system info ---
def get_airplane_mode():
    output = run("nmcli -t -f WIFI,HARDWARE radio")
    lines = output.splitlines()
    # nmcli radio output looks like:
    # enabled:enabled
    # So we just look for "disabled"
    if "disabled" in output:
        return False
    return True

def get_wifi_networks():
    output = run("nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list")
    networks = []
    for line in output.splitlines():
        if not line.strip():
            continue
        parts = (line.split(":", 2) + ["", ""])[:3]
        ssid, signal, security = [p.strip() for p in parts]
        if ssid:
            networks.append({
                "ssid": ssid,
                "signal": signal,
                "security": security
            })
    return networks

def get_active_connections():
    output = run("nmcli -t -f NAME,TYPE,DEVICE connection show --active")
    active = {"wifi": None, "ethernet": [], "vpn": []}
    for line in output.splitlines():
        if not line.strip():
            continue
        name, typ, dev = (line.split(":") + ["", ""])[:3]
        if typ == "wifi":
            active["wifi"] = name
        elif typ == "ethernet":
            active["ethernet"].append(name)
        elif typ == "vpn":
            active["vpn"].append(name)
    return active

def get_vpn_connections():
    out = run("nmcli -t -f NAME,TYPE connection show | grep vpn || true")
    vpns = [line.split(":")[0].strip() for line in out.splitlines() if line.strip()]
    return vpns

def get_ethernet_devices():
    out = run("nmcli -t -f DEVICE,STATE,TYPE dev | grep ethernet || true")
    eths = []
    for line in out.splitlines():
        dev, state, typ = (line.split(":") + ["", ""])[:3]
        eths.append({"device": dev, "state": state})
    return eths

# --- Menu builder ---
def build_menu(airplane, networks, active, vpns, eths):
    menu = []

    # Airplane Mode
    menu.append("Airplane Mode")
    menu.append("--------------------")
    state = "Enabled ✈️" if not airplane else "Disabled 🟢"
    menu.append(state)
    menu.append("")

    # Wi-Fi section
    menu.append("Wi-Fi Networks")
    menu.append("--------------------")
    if active["wifi"]:
        menu.append(f"  Disconnect ({active['wifi']})")
    for n in networks:
        line = f"{n['ssid']} ({n['signal']}%)"
        if n["security"] != "--":
            line += " 🔒"
        menu.append(line)
    menu.append("")

    # Ethernet section
    menu.append("Ethernet")
    menu.append("--------------------")
    for e in eths:
        status = "Connected" if e["state"] == "connected" else "Disconnected"
        menu.append(f"{e['device']}: {status}")
    menu.append("")

    # VPN section
    menu.append("VPN Connections")
    menu.append("--------------------")
    if active["vpn"]:
        for vpn in active["vpn"]:
            menu.append(f"{vpn} (connected)")
    for vpn in vpns:
        if vpn not in active["vpn"]:
            menu.append(vpn)

    return "\n".join(menu)

# --- Main ---
def main():
    airplane = get_airplane_mode()
    networks = get_wifi_networks()
    active = get_active_connections()
    vpns = get_vpn_connections()
    eths = get_ethernet_devices()

    menu_text = build_menu(airplane, networks, active, vpns, eths)
    selected = run(f'echo "{menu_text}" | wofi --dmenu --prompt "Network Manager"')

    if not selected:
        sys.exit(0)

    # --- Airplane toggle ---
    if selected.startswith("Enabled"):
        run("nmcli radio all on")
        sys.exit(0)
    elif selected.startswith("Disabled"):
        run("nmcli radio all off")
        sys.exit(0)

    # --- Wi-Fi disconnect ---
    if selected.startswith("  Disconnect"):
        run(f"nmcli connection down '{active['wifi']}'")
        sys.exit(0)

    # --- Wi-Fi connect ---
    for n in networks:
        if selected.startswith(n["ssid"]):
            ssid = n["ssid"]
            subprocess.Popen(["nmcli", "dev", "wifi", "connect", ssid])
            sys.exit(0)

    # --- Ethernet toggle ---
    for e in eths:
        if selected.startswith(e["device"]):
            if e["state"] == "connected":
                run(f"nmcli dev disconnect {e['device']}")
            else:
                run(f"nmcli dev connect {e['device']}")
            sys.exit(0)

    # --- VPN connect/disconnect ---
    for vpn in vpns:
        if selected.startswith(vpn):
            if "(connected)" in selected:
                run(f"nmcli connection down '{vpn}'")
            else:
                run(f"nmcli connection up '{vpn}'")
            sys.exit(0)

if __name__ == "__main__":
    main()
