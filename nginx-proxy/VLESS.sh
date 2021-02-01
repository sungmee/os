#!/bin/bash
set -e

# https://tlanyan.me/introduce-v2ray-vless-protocol/

cat > ./VLESS.json <<EOF
{
  "inbounds": [
      {
          "port": 443,
          "protocol": "vless",
          "settings": {
              "clients": [
                  {
                      "id": "6baebb63-e1ee-2643-0fc0-37682a7c64eb",
                      "flow":"xtls-rprx-direct",
                      "level": 0
                  }
              ],
              "decryption": "none",
              "fallbacks": [
                  {
                      "dest": 80
                  }
              ]
          },
          "streamSettings": {
              "network": "tcp",
              "security": "xtls",
              "xtlsSettings": {
                  "alpn": [
                      "http/1.1"
                  ],
                  "certificates": [
                      {
                          "certificateFile": "/certs/fullchain.pem",
                          "keyFile": "/certs/key.pem"
                      }
                  ]
              }
          }
      }
  ],
  "outbounds": [
      {
          "protocol": "freedom"
      }
  ]
}
EOF