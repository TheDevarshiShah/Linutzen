#!/bin/bash
##### functions #####
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
enter_to_proceed() {
    echo ""
    echo "Press Enter for next step..."
    echo ""
    read
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
    echo "0. Initial things BEFORE updates (Fedora only)"
    echo "1. Check Updates"
    echo "2. Setup Flathub (Ubuntu only)"
    echo "3. Install Flatpak apps"
    echo "4. Setup Devtools"
    echo "5. Battery Life optimizations"
    echo "9. Exit"
}
initial(){
    clear
    echo ">> Initial one-time things to be performed BEFORE updates (Fedora only)"
    echo ">>> 1. DNF modifications (manual)"
    echo "-----------------------------------------------"
    redecho "cp /etc/dnf/dnf.conf /etc/dnf/dnf-original.conf"
    redecho "# Add following in /etc/dnf/dnf.conf"
    redecho "fastestmirror=True"
    redecho "max_parallel_downloads=5"
    echo "-----------------------------------------------"
    enter_to_proceed

    echo ">>> 2. Add Flathub repo"
    echo "---> flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"
    user_sub_flag=$(get_flag_input)
    if [[ "$user_sub_flag" == 'Y' ]]; then
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    fi
    enter_to_proceed
	
    echo ">>> 3. Install Gnome Tweaks"
    echo "---> dnf install gnome-tweaks -y"    
    user_sub_flag=$(get_flag_input)
    if [[ "$user_sub_flag" == 'Y' ]]; then
        dnf install gnome-tweaks -y
    fi
    print_underscores
    echo "Done!"
}
updates() {
    clear
    echo ">> Performing updates"
    #echo "---- apt update -y && apt upgrade -y && apt autoremove -y"
    echo "---> dnf update -y"
    echo "---> flatpak update -y"
    while true; do
        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            dnf update -y
            #apt update -y && apt upgrade -y && apt autoremove -y
            flatpak update -y
            print_underscores
            echo "Successfully performed the task!"
            echo "A reboot must be done if updates are applied!"
            return
        elif [[ "$user_flag" == 'N' ]]; then
            clear
            return
        fi
    done
}
setup_flathub() {
    clear
    echo ">> Setting up Flathub repo (Ubuntu only)"
    echo "--> apt install flatpak"
    echo "--> apt install gnome-software-plugin-flatpak"
    echo "--> flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"
    while true; do
        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            apt install flatpak
            apt install gnome-software-plugin-flatpak
            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            print_underscores
            echo "Successfully performed the task!"
            echo "A reboot must be done!"
            return
        elif [[ "$user_flag" == 'N' ]]; then
            clear
            return
        fi
    done
}
flatpak_apps() {
    clear
    echo ">> Installing Flatpak apps"
    echo "--> flatpak install flathub com.brave.Browser -y"
    echo "-->                         firefox"
    echo "-->                         vscodium"
    echo "-->                         meld"
    echo "-->                         Thunderbird"
    echo "-->                         Tangram"
    echo "-->                         LibreOffice"
    echo "-->                         Zoom"
    echo "-->                         FreeTube"
    echo "-->                         VLC"
    echo "-->                         bottles"
    echo "-->                         ExtensionManager"
    echo "-->                         Flatseal"
    while true; do
        user_flag=$(get_flag_input)
        if [[ "$user_flag" == 'Y' ]]; then
            flatpak install flathub com.brave.Browser -y
            flatpak install flathub org.mozilla.firefox -y
            flatpak install flathub com.vscodium.codium -y
            flatpak install flathub org.gnome.meld -y
            flatpak install flathub org.mozilla.Thunderbird -y
            flatpak install flathub re.sonny.Tangram -y
            flatpak install flathub org.libreoffice.LibreOffice -y
            flatpak install flathub us.zoom.Zoom -y
            flatpak install flathub io.freetubeapp.FreeTube -y
            flatpak install flathub org.videolan.VLC -y
            flatpak install flathub com.usebottles.bottles -y
            flatpak install flathub com.mattjakeman.ExtensionManager -y
            flatpak install flathub com.github.tchx84.Flatseal -y
            print_underscores
            echo "Successfully performed the task!"
            return
        elif [[ "$user_flag" == 'N' ]]; then
            clear
            return
        fi
    done
}
dev_tools() {
    clear
    echo ">> Setting up Development Environment"
    echo "A. Git"
    echo "B. Git SSH Key"
    echo "C. Conda"
    echo "D. Docker"
    echo ""
    echo ">>> A. Git (Ubuntu Only)"
    echo "---> apt install git"
    user_sub_flag=$(get_flag_input)
    if [[ "$user_sub_flag" == 'Y' ]]; then
        apt install git
    fi
    enter_to_proceed

    echo ">>> B. Git SSH Key (manual)"
    redecho "-----------------------------------------------------------------------------------------------------------------"
    redecho "cd ~"
    redecho "mkdir -p Code"
    redecho "git config --global user.name 'Devarshi K. Shah'"
    redecho "git config --global user.email '68741497+TheDevarshiShah@users.noreply.github.com'"
    redecho "ssh-keygen -t rsa -b 4096 -C '68741497+TheDevarshiShah@users.noreply.github.com' -f '/home/stark/.ssh/github_key'"
    redecho "cat /home/stark/.ssh/github_key.pub # Add this to the portal: https://github.com/settings/keys"
    redecho "-----------------------------------------------------------------------------------------------------------------"
    enter_to_proceed    
    echo ">>> C. Conda (manual): https://docs.anaconda.com/miniconda/install/"
    redecho "-----------------------------------------------------------------------------"
    redecho "cd ~"
    redecho "curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    redecho "bash ~/Miniconda3-latest-Linux-x86_64.sh"
    redecho "-----------------------------------------------------------------------------"
    enter_to_proceed

    echo ">>> D. Docker (manual): https://docs.docker.com/engine/install/fedora/"
    echo ">>> Is it Fedora(Y) or Ubuntu(N)?"
    user_sub_flag=$(get_flag_input)
    if [[ "$user_sub_flag" == 'Y' ]]; then
        redecho "-------------------------------------------------------------------------------------------------"
        redecho "# Remove existing and installing fresh"
        redecho "sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine"
        redecho "sudo dnf -y install dnf-plugins-core"
        redecho "sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo"
        redecho "sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
        redecho "sudo systemctl enable --now docker"
        echo ""
        redecho "# Run docker without sudo"
        redecho "sudo docker run hello-world"
        redecho "sudo groupadd docker"
        redecho "sudo usermod -aG docker $USER"
        redecho "newgrp docker"
        redecho "docker run hello-world"
        redecho "-------------------------------------------------------------------------------------------------"
    elif [[ "$user_sub_flag" == 'N' ]]; then
        redecho "----------------------------------------------------------------------------------------------------------------"
        redecho "# Remove existing and installing fresh"
        redecho "for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done"
        redecho "sudo apt-get update"
        redecho "sudo apt-get install ca-certificates curl"
        redecho "sudo install -m 0755 -d /etc/apt/keyrings"
        redecho "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc"
        redecho "sudo chmod a+r /etc/apt/keyrings/docker.asc"
        echo ""
        redecho "# Add the repository to Apt sources: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository"
        redecho "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
        redecho "sudo docker run hello-world"
        redecho "sudo groupadd docker"
        redecho "sudo usermod -aG docker $USER"
        redecho "newgrp docker"
        redecho "docker run hello-world"
        redecho "----------------------------------------------------------------------------------------------------------------"
    fi
    enter_to_proceed

    print_underscores
    echo "Done!"
}
battery() {
    clear
    echo ">> Battery Life optimizations"
    echo ">>> 1. Disable Bluetooth to be turned on startup (manual):"
    redecho "------------------------------------------------------------------" 
    redecho "sudo cp /etc/bluetooth/main.conf /etc/bluetooth/main-original.conf"
    redecho "#Change to 'AutoEnable=false' flag in /etc/bluetooth/main.conf"
    redecho "------------------------------------------------------------------"
    enter_to_proceed

    echo ">>> 2. Auto-CPUFrequency:"
    echo ">>> Confirm and run these commands: https://github.com/AdnanHodzic/auto-cpufreq"
    echo ">>>> 2.1. Install with following commands (manual):"
    redecho "---------------------------------------------------------"
    redecho "cd ~"
    redecho "mkdir -p Apps"
    redecho "cd ~/Apps"
    redecho "git clone https://github.com/AdnanHodzic/auto-cpufreq.git"
    redecho "cd auto-cpufreq && sudo ./auto-cpufreq-installer"
    redecho "---------------------------------------------------------"
    enter_to_proceed

    echo ">>>> 2.2. Install the daemon using GUI (manual): https://github.com/AdnanHodzic/auto-cpufreq?tab=readme-ov-file#install---auto-cpufreq-daemon"
    redecho "#Open auto-cpufreq app and install the deamon"
    enter_to_proceed

    echo ">>>> 2.3. Battery charging thresholds in this conf file (manual): https://github.com/AdnanHodzic/auto-cpufreq/#example-config-file-contents"
    redecho "---------------------------------" 
    redecho "sudo touch /etc/auto-cpufreq.conf"
    redecho "#uncomment stop_threshold = 80"
    redecho "---------------------------------" 
    enter_to_proceed

    print_underscores
    echo "Done!"
}





##### start #####
clear
echo "Welcome to Linutzen v1.0"
print_menu
#echo "0. Initial things BEFORE updates (Fedora only)"
#echo "1. Check Updates"
#echo "2. Setup Flathub (Ubuntu only)"
#echo "3. Install Flatpak apps"
#echo "4. Setup Devtools"
#echo "5. Battery Life optimizations"
#echo "9. Exit"

while true; do	
    user_integer=$(get_integer_input)
    if [[ "$user_integer" == 0 ]]; then
        initial
        print_menu
    elif [[ "$user_integer" == 1 ]]; then
        updates
        print_menu
    elif [[ "$user_integer" == 2 ]]; then
        setup_flathub
        print_menu
    elif [[ "$user_integer" == 3 ]]; then
        flatpak_apps
        print_menu
    elif [[ "$user_integer" == 4 ]]; then
        dev_tools
        print_menu
    elif [[ "$user_integer" == 5 ]]; then
        battery
        print_menu
    elif [[ "$user_integer" == 9 ]]; then
        print_stars
        echo "Tschüs!"
        print_underscores
        echo ""
        exit
	fi
done
