#!/bin/bash

tmux new-session -d -s vintagestory 
# tmux send-keys "dotnet ./server/VintagestoryServer.dll --dataPath /home/vintagestory/data" C-m
tmux send-keys "./server/server.sh start" C-m
tmux detach -s vintagestory

tail -f /dev/null
