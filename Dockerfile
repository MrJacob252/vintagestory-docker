FROM ubuntu:26.04

RUN useradd vintagestory -m
USER root

# Install required packages
RUN apt-get update && apt-get install -y apt-transport-https
RUN apt-get -y install wget
RUN apt-get -y install procps
RUN apt-get -y install screen
RUN apt-get -y install tmux
RUN apt-get -y install curl
RUN apt-get -y install tar
RUN apt-get -y install libicu-dev
RUN apt-get -y install vim

USER vintagestory
WORKDIR /home/vintagestory

# Setup .NET10
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
RUN chmod +x ./dotnet-install.sh
RUN ./dotnet-install.sh --channel 10.0 --install-dir /home/vintagestory/.dotnet
# Make the system see the .net
ENV DOTNET_ROOT=/home/vintagestory/.dotnet
USER root
RUN ln -s /home/vintagestory/.dotnet/dotnet /usr/bin/dotnet
USER vintagestory


# Add debug scripts
ADD ./debug ./debug

RUN wget https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_1.22.5.tar.gz
RUN mkdir server && tar -C server -xzf vs_server_linux-x64_*.*.*.tar.gz
# RUN rm vs_server_linux_*.*.*.tar.gz
RUN chmod +x server/server.sh

# Import previous data (if provided in the folder)
ADD ./data ./data

# Modify the server.sh file
RUN sed -i -e 's|^USERNAME=.*|USERNAME=vintagestory|' server/server.sh
RUN sed -i -e 's|^VSPATH=.*|VSPATH=/home/vintagestory/server|' server/server.sh
RUN sed -i -e 's|^DATAPATH=.*|DATAPATH=/home/vintagestory/data|' server/server.sh

# Add the server launch script
ADD ./entrypoint.sh ./server/entrypoint.sh

# Change ownership of the server files
USER root
RUN chown -R vintagestory:vintagestory ./data
RUN chown -R vintagestory:vintagestory ./server
USER vintagestory

EXPOSE 42420/tcp
EXPOSE 42420/udp

ENTRYPOINT ["./server/entrypoint.sh"]

