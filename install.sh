#!/bin/bash
# install.sh


reset;






# ANSI-Farbcodes
RED="\033[31m"
YELLOW="\033[33m"


# EXPORTING VARIABLES

# APT-GET VARIABLES
export u="sudo apt-get update"
export ug="sudo apt-get upgrade -y"
export i="sudo apt-get install -y "
export ia="sudo apt-get install "
export r="sudo apt-get remove -y "
export rp="sudo apt-get remove -y $pkg --purge"
export dug="sudo apt-get dist-upgrade -y"
export ar="sudo apt-get autoremove -y"
export ac="sudo apt-get autoclean"
# END APT-GET VARIABLES

# GIT VARIABLES
export gcl="git clone"

# RASPBERRY PI VARIABLES
export rpiu="sudo rpi-update"
export rpieo="sudo rpi-eeprom-update"
# END RASPBERRY PI VARIABLES

# SHORTCUTZ
export s="sleep "




me=$(whoami) # Current User

# APPLICATION FOLDERS
PACKAGE_DIR="packages_lists"
REPOSITORYS_DIR="repositorys_lists"
SCRIPTS_DIR="scripts"


# FOLDERS TO CREATE
GPIO_LIBS_DIR="/usr/share/libarys/gpio"
WIRINGPI_LIBS_DIR="/usr/share/libarys/gpio/wiringpi"



STATUS=${STATUS:-"start"}
# END EXPORTING VARIABLES






# CHECK FOR ROOT PRIVILEGES
check() {
    if [ "$EUID" -ne 0 ]; then
        console_echo "PLEASE RUN AS SUDO OR ROOT, EXITING!!!"
        exit 1
    else
        console_echo "SCRIPT RUNS AS SUDO OR ROOT, CONITNUE!!!"
    fi
}

# ECHO COLORED CONSOLE
console_echo() {
    echo -e "\033[31mConsole > \033[33m$1"
}



# SLEEP BETWEEN FUNCTIONS
s() {
    local time="$1"
    $s $time
}



# OWN AND GRANT PERMISSIONS
own_and_grant() {
    console_echo "Changing Ownership and Granting Permissions!!!"
    sudo chmod 755 -R ./*
    sudo chown $me -hR ./*
}


# CREATE FOLDERS
create_folders() {
    console_echo "Creating Folders..."
    sudo mkdir -p $GPIO_LIBS_DIR
    sudo mkdir -p $WIRINGPI_LIBS_DIR
}


# DEFINE WRAPPER FUNCTIONS

# APT-GET UPDATE
u() {
    console_echo "Starting Update..."
    $u
    console_echo "Update finished."
}

# APT-GET UPGRADE -Y
ug() {
    console_echo "Starting Upgrade..."
    $ug
    console_echo "Update finished."
}

# APT-GET DIST-UPGRADE
dug() {
    console_echo "Starting Dist-Upgrade..."
    $dug
    console_echo "Dist-Upgrade finished."
}

# APT-GET INSTALL (wait for user input)
i() {
    local paketname="${1:-default-paket}"
    console_echo "Starting installation of: $paketname"
    $i $paketname
    console_echo "Installation finished!"
}

# APT-GET REMOVE
r() {
    if [ -z "$1" ]; then
        echo "${RED}ERROR: ${YELLOW} NO PACKAGE SELECTED."
        echo "${RED}USAGE: ${YELLOW} r <paketname>"
        return 1
    fi
    
    local pkg="$1"
    echo "${RED}REMOVING: ${YELLOW} $pkg"
    $r $pkg
    echo "${RED}PACKAGE:${YELLOW} $pkg REMOVED!"
}

# APT-GET REMOVE --PURGE
rp() {
    if [ -z "$1" ]; then
        echo "${RED}ERROR: ${YELLOW} NO PACKAGE CHOOSED."
        echo "${RED}USAGE: ${YELLOW} rp <paketname>"
        return 1
    fi
    
    local pkg="$1"
    echo "${RED}REMOVING: ${YELLOW} $pkg (incl. config-files)"
    
    echo "${RED}PACKAGE: ${YELLOW} $pkg REMOVED COMPLETLY!"
}











# INSTALLS PACKAGES FROM LISTS
install_from_packages_list() {
    console_echo "Installing Packages from Lists!!!"
    s "0.5"

    if [ ! -d "$PACKAGE_DIR" ]; then
        console_echo "THE DIRECTORY: $PACKAGE_DIR DOSENT EXIST."
        exit 1
    fi

    for file in "$PACKAGE_DIR"/*; do
        if [ -f "$file" ]; then
            console_echo "WORKING ON: $file"
        
            while IFS= read -r package || [ -n "$package" ]; do
                if [[ -n "$package" ]]; then
                    console_echo "INSTALLING: $package"
                    i "$package"
                
                fi
            done < "$file"
        else
            console_echo " $file ISNT A REGULAR FILE, SKIPPING!"
          
        fi
    done

    console_echo "INSTALLATION FINISHED!!!"
}






# CLONE REPOSITORYS FROM LISTS
clone_repos_from_folder() {
    keywords=("-Node" "-Python" "-Ruby" "-PHP" "-Perl")

    console_echo "Installing Repositorys from Lists!!!"
    s "0.5"

    if [ ! -d "$REPOSITORYS_DIR" ]; then
        console_echo "THE DIRECTORY: $REPOSITORYS_DIR DOSENT EXIST."
        s "0.5"
        exit 1
    fi
    
    for file_path in "$REPOSITORYS_DIR"/*; do
        if [[ -f "$file_path" ]]; then
            console_echo "WORKING ON: $file_path"
            
            while IFS= read -r repo_url; do
                if [[ -z "$repo_url" || "$repo_url" =~ ^# ]]; then
                    continue
                fi

                console_echo "CLONING REPOSITORY: $repo_url"
               
                

                if [[ "$repo_url" == *"WiringPi"* ]]; then
                   cd $WIRINGPI_LIBS_DIR
                   $gcl "$repo_url"
                else
                   cd $GPIO_LIBS_DIR
                   $gcl "$repo_url"
                fi




                
            done < "$file_path"
        fi
    done
}








# AUTO INSTALLER
auto_install() {
    console_echo "Starting Auto-Installer!!!"
    s "0.5"

    # APT - PROCEDURE
    $u;
    s "0.5"
    $ug;
    s "0.5"
    $dug;
    s "0.5"
    $ar;
    s "0.5"
    # END APT - PROCEDURE


    # INSTALLING PACKAGES, CLONING REPOSITORYS & MORE
    install_from_packages_list;  # Installing packages
    clone_repos_from_folder;     # Clone repositories

}

install_minecraft_server() {
    console_echo "Installing Minecraft Server!!!"
    s "0.5"

    if [! -d "$SCRIPTS_DIR" ]; then
        console_echo "THE DIRECTORY: $SCRIPTS_DIR DOSENT EXIST."
        exit 1
    fi

    cd $SCRIPTS_DIR
    ./install_minecraft_server.sh
}



main_menu() {
    while true;
    do
        
        echo "====================================================="
        echo "==|| RASPBERRY PI | DEV-BOARD INSTALLER v0.1     ||=="
        echo "====================================================="
        echo "== 1:(A)uto Install      | 2:(M)inecraft Server    =="
        echo "== 3:(R)PI-UPDATE        | 4:(U)pdate-rpi-eeprom   =="
        echo "====================================================="
        echo "==||       q|Q = Quit or Ctrl + C/X              ||=="
        echo "====================================================="
        
        read -p "Console > " x
        
        case $x in
            1|A|a) auto_install; continue;;
            2|M|m) manual_install; continue;;
            q|Q) console_echo " Exiting!!!"; exit;;
            *) console_echo "Please enter an option matching the menu!"; continue;;
        esac
    done
    
}



initalize() {
    check;
    create_folders;
    own_and_grant;
    s "1"

    main_menu;

}



initalize;