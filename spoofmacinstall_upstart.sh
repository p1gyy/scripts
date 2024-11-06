#!/bin/bash

INTERFACE="wlan0"
NEW_MAC="C4:D0:E3:39:AF:8A"
SCRIPT_PATH="/bin/spoofmac.sh"
SERVICE_PATH="/etc/init/spoofmac.conf"

echo "Creating script at $SCRIPT_PATH"
cat <<EOF > "$SCRIPT_PATH"
#!/bin/bash

ip link set dev $INTERFACE down
ip link set dev $INTERFACE address $NEW_MAC
ip link set dev $INTERFACE up
EOF

chmod +x "$SCRIPT_PATH"

echo "Creating Upstart service at $SERVICE_PATH"
cat <<EOF > "$SERVICE_PATH"
description "spoofs mac address on startup of network manager"
start on (started network-services and started shill and started wpa_supplicant)
task

script
    "$SCRIPT_PATH"
end script
EOF

initctl reload-configuration
initctl start spoofmac

echo "Service installed!"
initctl status spoofmac
