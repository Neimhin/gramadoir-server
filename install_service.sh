#!/bin/bash
SERVICE_NAME=gramadoir-server
sudo cp systemd-service /etc/systemd/system/$SERVICE_NAME.service
sudo systemctl enable --now $SERVICE_NAME


# e.g.
curl localhost:4100/mo%20madra
