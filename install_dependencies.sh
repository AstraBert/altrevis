#!/bin/bash

# Function to identify the Linux distribution
get_linux_distribution() {
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    echo "$ID"
  elif [ -f /etc/issue ]; then
    if grep -iq "debian" /etc/issue; then
      echo "debian"
    elif grep -iq "ubuntu" /etc/issue; then
      echo "ubuntu"
    elif grep -iq "centos" /etc/issue; then
      echo "centos"
    elif grep -iq "fedora" /etc/issue; then
      echo "fedora"
    elif grep -iq "opensuse" /etc/issue; then
      echo "opensuse"
    else
      echo "unknown"
    fi
  else
    echo "unknown"
  fi
}

# Function to install needed dependencies based on the Linux distribution
install_dependencies() {
  local distro
  distro=$(get_linux_distribution)

  case "$distro" in
    "ubuntu" | "debian")
      sudo apt-get update
      sudo apt-get install seaview
      sudo apt-get install mafft
      sudo apt-get install muscle
      sudo apt-get install fasttree
      ;;
    "centos")
      sudo yum install seaview
      sudo yum install mafft
      sudo yum install muscle
      sudo yum install fasttree
      ;;
    "fedora")
      sudo dnf install seaview
      sudo dnf install mafft
      sudo dnf install muscle
      sudo dnf install fasttree
      ;;
    "opensuse")
      sudo zypper install seaview
      sudo zypper install mafft
      sudo zypper install muscle
      sudo zypper install fasttree
      ;;
    "arch")
      sudo pacman -S install seaview
      sudo pacman -S install mafft
      sudo pacman -S install muscle
      sudo pacman -S install fasttree
      ;;
    *)
      echo "Unsupported or unknown Linux distribution."
      exit 1
      ;;
  esac
}

# Main script
echo "Checking Linux distribution..."
linux_distro=$(get_linux_distribution)

if [ "$linux_distro" == "unknown" ]; then
  echo "Unable to determine your Linux distribution."
  exit 1
else
  echo "Detected Linux distribution: $linux_distro"
fi

echo "Installing needed dependencies..."
install_dependencies

echo "Dependencies installation completed."
