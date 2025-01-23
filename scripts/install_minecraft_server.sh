#!/bin/bash
# install_minecraft_server.sh


create_minecraft_script() {
    echo -e "Console > Creating Minecraft Server Start Script\n"
    cat << EOF > start_minecraft_server.sh
    echo -e "Console > Starting Minecraft Server\n"
    screen -S minecraft -d -m java -Xmx1024M -Xms1024M -jar server.jar nogui
EOF
}


install_minecraft_server() {
    echo -e "Console > Installing Minecraft Server\n"
    
    sudo add-apt-repository ppa:openjdk-r/ppa
    sudo apt update
    
    echo -e "Console > Installing Dependencies!!!\n"
    $iy screen wget openjdk-17-jre-headless openjdk-17-jdk ufw curl unzip libc6 libstdc++6 libssl-dev uuid-runtime tmux htop net-tools dnsutils
    
    
    echo -e "Console > Adding USER to System!!!"
    sudo useradd -m minecraft
    
    
    echo -e "Console > Configuring Firewall for: Minecraft Server\n"
    sudo ufw allow 25565
    sudo ufw allow 19132/udp
    sudo ufw allow 19133/udp
    sudo ufw enable
    
    echo -e "Console > Creating Minecraft Server Directory\n"
    mkdir -p /home/minecraft/minecraft-server
    cd /home/minecraft/minecraft-server
    
    echo -e "Console > Downloading Minecraft Server\n"
    wget https://piston-data.mojang.com/v1/objects/4707d00eb834b446575d89a61a11b5d548d8c001/server.jar
    
    
    echo "eula=true" > eula.txt
    
    
    sudo chmod 755 -R /home/minecraft/
    sudo chown minecraft -hR /home/minecraft/
    
    echo -e "Console > Minecraft Server installed successfully!!!\n"
    
    echo -e "Console > Maybe you want to configure the server.properties file!!!\n"
    echo -e "Enter: y|Y|yes|YES to configure the server.properties file || or: n|N|no|NO to Exit Minecraft-Installer!!!\n"
    
    read -p "Choice > " choice
    case $choice in
        y|Y|yes|YES) nano server.properties;;
        n|N|no|NO) echo -e "Console > Exiting!!!"; exit;;
        *) echo -e "Console > Please enter a valid choice!!!";;
    esac
    
    
    create_minecraft_script;
    
    echo -e "Console > Finished Installing Minecraft Bedrock Server!!!"
}

