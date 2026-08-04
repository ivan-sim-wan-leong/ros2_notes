### For Ubuntu 22 ###
# 1. sudo nano /etc/default/ufw
# 2. DEFAULT_FORWARD_POLICY="ACCEPT"

# 3. add post routing
#*nat
#:POSTROUTING ACCEPT [0:0]

## Forward traffic from LAN to Wi-Fi
#-A POSTROUTING -s 10.42.0.0/24 -o wlp2s0 -j MASQUERADE

#### disable firewall
# sudo ufw disable

# Share Wi-Fi internet over a specified Ethernet interface with customizable IP
share_wifi_to_lan() {
    # 1. Check if an interface argument was provided
    if [ -z "$1" ]; then
        echo "❌ Error: Please specify an ethernet interface."
        echo "Usage: share_wifi_to_lan <interface_name> [lan_ip]"
        echo "Example: share_wifi_to_lan enp0s31f6 192.168.1.120"
        return 1
    fi

    local IFACE="$1"
    
    # 2. Set LAN IP: use 2nd argument if provided, otherwise default to 10.42.0.1
    local LAN_IP="${2:-10.42.0.1}"

    # Simple regex validation for IPv4 format
    if [[ ! "$LAN_IP" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo "❌ Error: '$LAN_IP' is not a valid IPv4 address."
        return 1
    fi

    # 3. Verify if the interface actually exists on the system
    if ! ip link show "$IFACE" > /dev/null 2>&1; then
        echo "❌ Error: Interface '$IFACE' does not exist."
        echo "Available interfaces:"
        ip -br link show | awk '{print "  - " $1}'
        return 1
    fi

    echo "⚙️  Setting up internet sharing on $IFACE with IP $LAN_IP..."

    # 4. Delete any existing profile with the same name to prevent conflicts
    sudo nmcli connection delete "Share-WiFi-to-LAN" > /dev/null 2>&1

    # 5. Add the connection profile with 'shared' method
    sudo nmcli connection add \
        type ethernet \
        con-name "Share-WiFi-to-LAN" \
        ifname "$IFACE" \
        ipv4.method shared

    # 6. FORCE the custom IP and subnet mask onto the shared connection
    # NetworkManager needs this modification step to override its default 10.42.0.1 behavior
    sudo nmcli connection modify "Share-WiFi-to-LAN" ipv4.addresses "$LAN_IP/24"

    # 7. Bring the connection up
    sudo nmcli connection up "Share-WiFi-to-LAN"

    echo "✅ Internet sharing is now active on $IFACE!"
    echo "💡 Plug your client PC into this port."
    echo "   Gateway/Host IP: $LAN_IP"
    echo "   Client PCs will automatically receive IPs in the range of $(echo $LAN_IP | cut -d. -f1-3).x"
}

# Autocomplete function for share_wifi_to_lan
_share_wifi_to_lan_completion() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Only autocomplete the 1st argument (the interface).
    if [ "$COMP_CWORD" -eq 1 ]; then
        # Get a list of interfaces, excluding loopback (lo) and typical wifi interfaces (wl*)
        local interfaces=$(ip -br link show | awk '{print $1}' | grep -vE '^(lo|wl)')
        COMPREPLY=( $(compgen -W "${interfaces}" -- "$cur") )
    fi
    return 0
}

# Register the autocomplete function to bind with your command
complete -F _share_wifi_to_lan_completion share_wifi_to_lan
