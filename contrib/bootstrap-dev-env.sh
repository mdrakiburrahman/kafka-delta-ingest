#!/bin/bash
#
#
#       Sets up a dev env with all pre-reqs. This script is idempotent, it will
#       only attempt to install dependencies, if not exists.   
#
# ---------------------------------------------------------------------------------------
#

set -e
set -m

echo ""
echo "┌───────────────────────────────────┐"
echo "│ Checking for package dependencies │"
echo "└───────────────────────────────────┘"
echo ""

PACKAGES=""
if ! dpkg -l | grep -q build-essential; then PACKAGES="build-essential"; fi
if ! dpkg -l | grep -q pkg-config; then PACKAGES="$PACKAGES pkg-config"; fi
if ! dpkg -l | grep -q libssl-dev; then PACKAGES="$PACKAGES libssl-dev"; fi
if ! dpkg -l | grep -q kafkacat; then PACKAGES="$PACKAGES kafkacat"; fi
if ! command -v openssl &> /dev/null; then PACKAGES="$PACKAGES openssl"; fi
if [ ! -z "$PACKAGES" ]; then
    echo "Packages $PACKAGES not found - installing..."
    sudo apt-get update 2>&1 > /dev/null
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $PACKAGES 2>&1 > /dev/null
fi

echo ""
echo "┌────────────────────────────────────┐"
echo "│ Checking for language dependencies │"
echo "└────────────────────────────────────┘"
echo ""

if ! command -v cargo &> /dev/null; then
    echo "cargo not found - installing..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.bashrc
fi

echo ""
echo "┌────────────────────────┐"
echo "│ Checking for CLI tools │"
echo "└────────────────────────┘"
echo ""

if ! command -v docker &> /dev/null; then
    echo "docker not found - installing..."
    curl -sL https://get.docker.com | sudo bash
fi
sudo chmod 666 /var/run/docker.sock

if ! command -v az &> /dev/null; then
    echo "az not found - installing..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

echo ""
echo "┌──────────┐"
echo "│ Versions │"
echo "└──────────┘"
echo ""

echo "Docker: $(docker --version)"
echo "Cargo (Rust): $(cargo version)"
echo "Azure CLI: $(az version)"