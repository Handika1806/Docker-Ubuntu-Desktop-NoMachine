#!/bin/bash

# Script ngrok setup and Docker run
setup_ngrok() {
    ./ngrok tcp --region $1 4000 &>/dev/null &
    sleep 1
    if curl --silent --show-error http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1; then
        echo OK
    else
        echo "Ngrok Error! Please try again!" && sleep 1 && setup_ngrok $1
    fi
}

# Main script logic
main() {
    wget -O ng.sh https://github.com/Handika1806/Docker-Ubuntu-Desktop-NoMachine/raw/main/ngrok.sh > /dev/null 2>&1
    chmod +x ng.sh
    ./ng.sh

    clear
    echo "Go to: https://dashboard.ngrok.com/get-started/your-authtoken"
    read -p "Paste Ngrok Authtoken: " CRP
    ./ngrok config add-authtoken $CRP 
    clear
    echo "Repo: https://github.com/Handika1806/Docker-Ubuntu-Desktop-NoMachine"
    echo "======================="
    echo "choose ngrok region (for better connection)."
    echo "======================="
    echo "us - United States (Ohio)"
    echo "eu - Europe (Frankfurt)"
    echo "ap - Asia/Pacific (Singapore)"
    echo "au - Australia (Sydney)"
    echo "sa - South America (Sao Paulo)"
    echo "jp - Japan (Tokyo)"
    echo "in - India (Mumbai)"
    read -p "choose ngrok region: " CRP_REGION

    setup_ngrok $CRP_REGION

    docker run --rm -d --network host --privileged --name nomachine-xfce4 -e PASSWORD=123456 -e USER=user --cap-add=SYS_PTRACE --shm-size=1g --restart unless-stopped thuonghai2711/nomachine-ubuntu-desktop:windows10
    clear
    echo "NoMachine: https://www.nomachine.com/download"
    echo Done! NoMachine Information:
    echo IP Address:
    curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p' 
    echo User: user
    echo Passwd: 123456
    echo "VM can't connect? Restart Cloud Shell then Re-run script."

    # Trap to handle reconnection if script is interrupted
    trap 'echo "Script interrupted, trying to reconnect..."; setup_ngrok $CRP_REGION' SIGHUP SIGINT SIGTERM

    # Loop to keep script running
    seq 1 604800 | while read i; do 
        echo -en "\r Running .     $i s /604800 s";sleep 0.1
        echo -en "\r Running ..    $i s /604800 s";sleep 0.1
        echo -en "\r Running ...   $i s /604800 s";sleep 0.1
        echo -en "\r Running ....  $i s /604800 s";sleep 0.1
        echo -en "\r Running ..... $i s /604800 s";sleep 0.1
        echo -en "\r Running     . $i s /604800 s";sleep 0.1
        echo -en "\r Running  .... $i s /604800 s";sleep 0.1
        echo -en "\r Running   ... $i s /604800 s";sleep 0.1
        echo -en "\r Running    .. $i s /604800 s";sleep 0.1
        echo -en "\r Running     . $i s /604800 s";sleep 0.1
    done
}

main
