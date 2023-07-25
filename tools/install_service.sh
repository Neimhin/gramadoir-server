#!/bin/bash
SERVICE_NAME=gramadoir-server
sudo ln -s `realpath systemd-service` /etc/systemd/system/$SERVICE_NAME.service
sudo systemctl daemon-reload
sudo systemctl enable --now $SERVICE_NAME


# e.g.
curl localhost:10002?text=mo%20madra
