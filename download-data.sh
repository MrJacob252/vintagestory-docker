#!/bin/bash
if [ ! -d ./data-backup ]; then
    mkdir ./data-backup
fi
sudo docker cp vs-server:/home/vintagestory/data ./data-backup
sudo chown -R "$USER:" ./data-backup/data
