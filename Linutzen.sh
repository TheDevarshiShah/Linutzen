#!/bin/bash
##### cosmetic functions #####
print_stars() { # print a line of stars matching the terminal width
    printf '%*s' "$(tput cols)" '' | tr ' ' '*'
}
print_underscores() {
    printf '%*s' "$(tput cols)" '' | tr ' ' '_'
}
redecho() {
    local input_string=$1
    echo -e "\e[31m${input_string}\e[0m"
}
brownecho() {
    local input_string=$1
    echo -e "\e[33m${input_string}\e[0m"
}





##### OS Type checker #####
# Default to no OS selected
OS_TYPE=""

# Parse command-line arguments
for arg in "$@"; do
    case $arg in
        --fedora)
            OS_TYPE="FEDORA"
            shift
            ;;
        --ubuntu)
            OS_TYPE="UBUNTU"
            shift
            ;;
        --update)  
            OS_TYPE="UPDATES"
            ### HARD CODED TO UBUNTU FOR NOW
            redecho "---> apt update && apt upgrade"
            redecho "---> flatpak update"
            print_underscores
            echo ""
            apt update && apt upgrade
            print_underscores
            flatpak update
            print_stars
            redecho "A reboot must be done if updates are applied!"
            exit
            ;;
        *)
            echo -e "\e[31mError: Please specify OS type using --fedora or --ubuntu (or --update)\e[0m"
            echo "Usage: sudo bash $0 --fedora | --ubuntu | --update"
            exit 1
            ;;
    esac
done

# Verify OS flag was provided
if [[ -z "$OS_TYPE" ]]; then
    echo -e "\e[31mError: Please specify OS type using --fedora or --ubuntu (or --update)\e[0m"
    echo "Usage: sudo bash $0 --fedora | --ubuntu | --update"
    exit 1
fi





##### logical functions #####
enter_to_proceed() {
    echo ""
    printf "Press Enter for next step..."
    read
    echo ""
}
get_integer_input() {
    local input
    while true; do
        read -p "> Enter an integer: " input
        if [[ "$input" =~ ^[0-9]$ ]]; then
            echo "$input"
            return
#        else
#            echo "Invalid input! Please enter an integer."
        fi
    done
}
get_flag_input() {
    local input
    while true; do
        read -p "> Enter your choice (Y or N): " input
        if [[ "${input^^}" =~ ^[YN]$ ]]; then
            echo "${input^^}" # return valid input in uppercase
            return
 #       else
 #           echo "Invalid input! Please enter 'Y' or 'N'."
        fi
    done
}
print_menu() {
    print_stars
    echo "Select an option:"
    echo "0. Initial Things"
    echo "1. Check Updates"
    echo "2. Install Apps"
    echo "3. Setup Dev Environment"
    echo "4. Battery Optimizations"
    echo "9. Exit"
}
initial() {
    clear
    echo ">> Initial one-time thing(s) to be performed:"


    if [[ "$OS_TYPE" == "FEDORA" ]]; then
        echo ">>> 1. DNF modifications"
        echo "DO:--------------------------------------------"
        brownecho "cp /etc/dnf/dnf.conf /etc/dnf/dnf-original.conf"
        brownecho "# Add following in /etc/dnf/dnf.conf"
        brownecho "fastestmirror=True"
        brownecho "max_parallel_downloads=5"
        echo "-----------------------------------------------"
        redecho "A reboot must be done before next step!"
        
        enter_to_proceed
        echo ">>> 2. Install Gnome Tweaks"
        redecho "---> dnf install gnome-tweaks"    
        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            dnf install gnome-tweaks
        fi


    elif [[ "$OS_TYPE" == "UBUNTU" ]]; then
        echo ">>> 1. Setting up Flathub"
        redecho "---> apt install flatpak"
        redecho "---> apt install gnome-software-plugin-flatpak"
        redecho "---> flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"
        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            apt install flatpak
            apt install gnome-software-plugin-flatpak
            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            redecho "A reboot must be done!" # before next step!"
        fi

        enter_to_proceed
        echo ">>> 2. Install Gnome Tweaks"
        redecho "---> apt install gnome-tweaks"
        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            apt install gnome-tweaks
        fi
    fi
	

    print_underscores
    echo "Done!"
}
updates() {
    clear
    echo ">> Performing updates..."


    if [[ "$OS_TYPE" == "FEDORA" ]]; then
        redecho "---> dnf update"
        redecho "---> flatpak update"
        dnf update
        flatpak update
        redecho "A reboot must be done if updates are applied!" 

    
    elif [[ "$OS_TYPE" == "UBUNTU" ]]; then
        redecho "---> apt update && apt upgrade"
        redecho "---> flatpak update -y"
        apt update && apt upgrade
        flatpak update
        redecho "A reboot must be done if updates are applied!" 
    fi
	

    print_underscores
    echo "Done!"
}
apps() {
    clear
    echo ">> Installing Apps:"
    redecho "# Confirm the command: https://brave.com/linux/"
    redecho "--> curl -fsS https://dl.brave.com/install.sh | sh"
    user_flag=$(get_flag_input)
    if [[ "$user_flag" == 'Y' ]]; then
        curl -fsS https://dl.brave.com/install.sh | sh
    fi
    enter_to_proceed


    if [[ "$OS_TYPE" == "FEDORA" ]]; then
        redecho "--> flatpak install flathub firefox"
        redecho "-->                         vscodium"
        redecho "-->                         meld"
        redecho "-->                         Thunderbird"
        redecho "-->                         LibreOffice"
        redecho "-->                         Zoom"
        redecho "-->                         FreeTube"
        redecho "-->                         VLC"
        redecho "-->                         bottles"
        redecho "-->                         ExtensionManager"
        redecho "-->                         Flatseal"
        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            flatpak install flathub org.mozilla.firefox
            flatpak install flathub com.vscodium.codium
            flatpak install flathub org.gnome.meld
            flatpak install flathub org.mozilla.Thunderbird
            flatpak install flathub org.libreoffice.LibreOffice
            flatpak install flathub us.zoom.Zoom
            flatpak install flathub io.freetubeapp.FreeTube
            flatpak install flathub org.videolan.VLC
            flatpak install flathub com.usebottles.bottles
            flatpak install flathub com.mattjakeman.ExtensionManager
            flatpak install flathub com.github.tchx84.Flatseal
        fi


    elif [[ "$OS_TYPE" == "UBUNTU" ]]; then
        redecho "--> snap install codium --classic"
        redecho "-->             thunderbird"
        redecho "-->             telegram-desktop"
        redecho "-->             libreoffice"
        redecho "-->             dialect"
        redecho "-->             freetube"
        redecho "-->             vlc"
        redecho "--> apt insatll torbrowser-launcher  #deb"
        redecho "--> apt insatll gnome-maps  #deb"
        redecho "--> apt insatll syncthing  #deb"
        redecho "--> flatpak install flathub com.usebottles.bottles"
        #redecho "-->flatpak install flathub org.gnome.meld # no snap"
        #redecho "-->flatpak install flathub us.zoom.Zoom # no snap"
        #redecho "-->flatpak install flathub com.mattjakeman.ExtensionManager # no snap"

        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            snap install codium --classic
            snap install thunderbird
            snap install libreoffice
            snap install dialect
            snap install freetube
            snap install vlc
            apt insatll gnome-maps
            apt insatll syncthing
            flatpak install flathub com.usebottles.bottles
            echo ">>> Get Samsung Magician: https://semiconductor.samsung.com/emea/consumer-storage/support/tools/"
            
            #flatpak install flathub org.gnome.meld # no snap
            #flatpak install flathub us.zoom.Zoom # no snap
            #flatpak install flathub com.mattjakeman.ExtensionManager # no snap

        fi
    fi


    print_underscores
    echo "Done!"
}
dev_tools() {
    clear
    echo ">> Setting Dev environment:"
    
    echo ">>> 0. Code repo; Setup GitHub Username"
    echo "DO:----------"
    brownecho "cd ~"
    brownecho "mkdir -p Code"
    echo "-------------"
    if ! command -v git &> /dev/null; then
        redecho ">>>> Git is not installed!"
        redecho "----> apt install git"
        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            apt install git
            print_underscores
        fi
    fi
    brownecho "git config --global user.name \"Devarshi\""
    brownecho "git config --global user.email \"68741497+TheDevarshiShah@users.noreply.github.com\""
    echo "----------------------------------------------------------------------------------"
    enter_to_proceed

    echo ">>> 1. SSH Key-gen for Git"
    echo "DO:--------------------------------------------------------------------------------------------------------------"
    brownecho "ssh-keygen -t rsa -b 4096 -C '68741497+TheDevarshiShah@users.noreply.github.com' -f '/home/stark/.ssh/github_key'"
    brownecho "cat /home/stark/.ssh/github_key.pub"
    echo ""
    brownecho "# Add this to the portal: https://github.com/settings/keys"
    brownecho "# Start clonning!: https://github.com/TheDevarshiShah?tab=repositories"
    echo "-----------------------------------------------------------------------------------------------------------------"
    enter_to_proceed

    echo ">>> 2. Conda"
    if [[ "$OS_TYPE" == "UBUNTU" ]]; then
        redecho "Curl is required; install it first?"
        redecho "---> apt install curl"
        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            apt install curl
        fi  
    fi
    echo "DO:-----------------------------------------------------------------------------"
    brownecho "cd ~"
    brownecho "curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    brownecho "bash ~/Miniconda3-latest-Linux-x86_64.sh"
    echo "-----------------------------------------------------------------------------"
    enter_to_proceed

	
    if [[ "$OS_TYPE" == "FEDORA" ]]; then
        echo ">>> 3. Docker: https://docs.docker.com/engine/install/fedora/"
        echo "DO:----------------------------------------------------------------------------------------------"
        brownecho "# Remove existing and installing fresh"
        brownecho "sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine"
        brownecho "sudo dnf -y install dnf-plugins-core"
        brownecho "sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo"
        brownecho "sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
        brownecho "sudo systemctl enable --now docker"
        brownecho "sudo docker run hello-world"
        echo ""
        brownecho "# Run docker without sudo"
        brownecho "sudo groupadd docker"
        brownecho "sudo usermod -aG docker \$USER"
        brownecho "newgrp docker"
        brownecho "docker run hello-world"
        echo "-------------------------------------------------------------------------------------------------"


    elif [[ "$OS_TYPE" == "UBUNTU" ]]; then
        echo ">>> 3. Docker: https://docs.docker.com/engine/install/ubuntu/"
        echo "DO:-------------------------------------------------------------------------------------------------------------"
        brownecho "# Remove existing and installing fresh"
        brownecho "for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done"
        brownecho "sudo apt-get update"
        brownecho "sudo apt-get install ca-certificates curl"
        brownecho "sudo install -m 0755 -d /etc/apt/keyrings"
        brownecho "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc"
        brownecho "sudo chmod a+r /etc/apt/keyrings/docker.asc"
        echo ""
        brownecho "# Add the repository to Apt sources: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository"
        enter_to_proceed
        brownecho "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
        brownecho "sudo docker run hello-world"
        echo ""
        brownecho "# Run docker without sudo"
        brownecho "sudo groupadd docker"
        brownecho "sudo usermod -aG docker \$USER"
        brownecho "newgrp docker"
        brownecho "docker run hello-world"
        echo "----------------------------------------------------------------------------------------------------------------"
    fi


    print_underscores
    echo "Done!"
}
battery() {
    clear
    echo ">> Battery Life optimizations:"
    
    #echo ">>> 1. Disable Bluetooth to be turned on startup"
    #echo "DO:---------------------------------------------------------------" 
    #brownecho "sudo cp /etc/bluetooth/main.conf /etc/bluetooth/main-original.conf"
    #brownecho "# Change to 'AutoEnable=false' flag in /etc/bluetooth/main.conf"
    #echo "------------------------------------------------------------------"
    #enter_to_proceed

    echo ">>> 1. Auto-CPUFrequency"
    if ! git --version &> /dev/null; then
        redecho "Git is required; exit and setup Dev env. first?"
        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            exit
        fi    
    fi
    echo ">>> Confirm and run these commands: https://github.com/AdnanHodzic/auto-cpufreq"
    echo ">>>> 2.1. Install"
    echo "DO:------------------------------------------------------"
    brownecho "cd ~"
    brownecho "mkdir -p Apps"
    brownecho "cd ~/Apps"
    brownecho "git clone https://github.com/AdnanHodzic/auto-cpufreq.git"
    brownecho "cd auto-cpufreq && sudo ./auto-cpufreq-installer"
    echo "---------------------------------------------------------"
    enter_to_proceed

    echo ">>>> 2.2. Install the daemon using GUI: https://github.com/AdnanHodzic/auto-cpufreq?tab=readme-ov-file#install---auto-cpufreq-daemon"
    brownecho "# Open auto-cpufreq app and install the deamon"
    enter_to_proceed


    print_underscores
    echo "Done!"
}





##### start #####
clear
echo "Welcome to Linutzen v1.0 for $OS_TYPE"
print_menu

#    print_stars
#    echo "Select an option:"
#    echo "0. Initial Things"
#    echo "1. Check Updates"
#    echo "2. Install Apps"
#    echo "3. Setup Dev Environment"
#    echo "4. Battery Optimizations"
#    echo "9. Exit"

while true; do	
    user_integer=$(get_integer_input)
    if [[ "$user_integer" == 0 ]]; then
        initial "$OS_TYPE"
        print_menu
    elif [[ "$user_integer" == 1 ]]; then
        updates "$OS_TYPE"
        print_menu
    elif [[ "$user_integer" == 2 ]]; then
        apps "$OS_TYPE"
        print_menu
    elif [[ "$user_integer" == 3 ]]; then
        dev_tools "$OS_TYPE"
        print_menu
    elif [[ "$user_integer" == 4 ]]; then
        battery "$OS_TYPE"
        print_menu
    elif [[ "$user_integer" == 9 ]]; then
        print_underscores
        echo "Tschüs!"
        print_stars
        echo ""
        exit
	fi
done
