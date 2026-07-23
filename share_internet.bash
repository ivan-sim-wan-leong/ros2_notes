### For ubuntu 22 if there is no internet downstream ###
# sudo ufw enable

# Share Wi-Fi internet over a specified Ethernet interface
share_wifi_to_lan() {
    # 1. Check if an interface argument was provided
    if [ -z "$1" ]; then
        echo "❌ Error: Please specify an ethernet interface."
        echo "Usage: share_wifi_to_lan <interface_name>"
        echo "Example: share_wifi_to_lan enp0s31f6"
        return 1
    fi

    local IFACE="$1"

    # 2. Verify if the interface actually exists on the system
    if ! ip link show "$IFACE" > /dev/null 2>&1; then
        echo "❌ Error: Interface '$IFACE' does not exist."
        echo "Available interfaces:"
        ip -br link show | awk '{print "  - " $1}'
        return 1
    fi

    echo "⚙️  Setting up internet sharing on $IFACE..."

    # 3. Delete any existing profile with the same name to prevent conflicts
    sudo nmcli connection delete "Share-WiFi-to-LAN" > /dev/null 2>&1

    # 4. Add the shared connection profile
    sudo nmcli connection add type ethernet con-name "Share-WiFi-to-LAN" ifname "$IFACE" ipv4.method shared

    # 5. Bring the connection up
    sudo nmcli connection up "Share-WiFi-to-LAN"

    echo "✅ Internet sharing is now active on $IFACE!"
    echo "💡 Plug your client PC into this port. It should receive an IP automatically."
}

# Autocomplete function for share_wifi_to_lan
_share_wifi_to_lan_completion() {
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Get a list of interfaces, excluding loopback (lo) and typical wifi interfaces (wl*)
    # This ensures you only auto-complete wired, ethernet, or USB network interfaces
    local interfaces=$(ip -br link show | awk '{print $1}' | grep -vE '^(lo|wl)')

    # Generate the matching choices
    COMPREPLY=( $(compgen -W "${interfaces}" -- "$cur") )
    return 0
}

# Register the autocomplete function to bind with your command
complete -F _share_wifi_to_lan_completion share_wifi_to_lan

