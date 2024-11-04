#!/bin/bash

INTERFACE="wlp0s12f0"
NEW_MAC="C4:D0:E3:39:AF:8A"
SCRIPT_PATH="/bin/spoofmac.sh"
SERVICE_PATH="/etc/systemd/system/spoofmac.service"

echo "Creating script at $SCRIPT_PATH"
cat <<EOF > "$SCRIPT_PATH"
#!/bin/bash

ip link set dev $INTERFACE down
ip link set dev $INTERFACE address $NEW_MAC
ip link set dev $INTERFACE up
EOF

chmod +x "$SCRIPT_PATH"

echo "Creating systemd service at $SERVICE_PATH"
cat <<EOF > "$SERVICE_PATH"
[Unit]
Description=spoofs mac address on startup
After=network.target

[Service]
ExecStart=/bin/spoofmac.sh
Type=oneshot
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable spoofmac.service
systemctl start spoofmac.service

echo "Service installed!"
systemctl status spoofmac.service
