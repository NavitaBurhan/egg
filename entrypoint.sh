#!/bin/bash

# ================================
#     SkyNest Cloud Server Startup
# ================================

# Warna Neon
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[1;93m'
BLUE='\033[1;94m'
MAGENTA='\033[1;95m'
CYAN='\033[1;96m'
WHITE='\033[1;97m'
NC='\033[0m' # No Color

# Typing effect function
type_out() {
    text="$1"
    delay=${2:-0.03}
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo ""
}

# Clear screen dan banner
clear
echo -e "${RED}========================================="
type_out "      ${MAGENTA}Welcome to SkyNest Cloud${RED}"
echo -e "=========================================${NC}"
sleep 1

# Loading Animasi dengan progress bar
echo -e "${CYAN}Loading system information...${NC}"
progress_bar() {
    local duration=${1:-5}
    local interval=0.05
    local total=$((duration / interval))
    echo -n "["
    for ((i=0; i<total; i++)); do
        echo -ne "${GREEN}#${NC}"
        sleep $interval
    done
    echo "] Done!"
}
progress_bar 3

# Ambil informasi sistem
OS=$(lsb_release -d | awk -F'\t' '{print $2}')
IP=$(hostname -I | awk '{print $1}')
CPU=$(grep -m1 'model name' /proc/cpuinfo | awk -F': ' '{print $2}')
RAM=$(awk '/MemTotal/ {printf "%.2f GB", $2/1024/1024}' /proc/meminfo)
DISK=$(df -h / | awk '/\/$/ {print $2}')
TIMEZONE=$(cat /etc/timezone)
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Display Info Sistem dengan animasi
echo ""
type_out "${BLUE}Fetching system details...${NC}" 0.05
sleep 0.5
type_out "${MAGENTA}OS        : ${CYAN}$OS" 0.02
type_out "${YELLOW}IP Address: ${CYAN}$IP" 0.02
type_out "${GREEN}CPU       : ${CYAN}$CPU" 0.02
type_out "${MAGENTA}RAM       : ${CYAN}$RAM" 0.02
type_out "${YELLOW}SSD       : ${CYAN}$DISK" 0.02
type_out "${CYAN}Timezone  : ${MAGENTA}$TIMEZONE" 0.02
type_out "${BLUE}Date      : ${WHITE}$DATE" 0.02

# Banner Penutupan Info
echo -e "${RED}=========================================${NC}"
sleep 1

# Set environment container
cd /home/container
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Node.js Version
type_out "${GREEN}Node.js Version:${NC} $(node -v)" 0.02
sleep 0.5

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
type_out "${CYAN}Modified Startup Command:${NC}" 0.02
echo ":/home/container$ ${MODIFIED_STARTUP}"
sleep 1

# Jalankan Server
type_out "${YELLOW}Starting the server...${NC}" 0.03
sleep 1
eval ${MODIFIED_STARTUP}

# Jalankan perintah bawaan container
exec "$@"
