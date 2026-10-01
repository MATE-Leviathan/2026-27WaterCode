#!/bin/bash

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ "$EUID" -eq 0 ]; then
    print_error "Run this script as your normal user, without sudo."
    exit 1
fi
if ! command -v apt >/dev/null 2>&1; then
    print_error "This simulation installer requires Ubuntu. See SETUP_GUIDE.md for manual setup."
    exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
    print_error "Install Docker Engine and Docker Compose first. See docker/SETUP_GUIDE.md."
    exit 1
fi
# ============================================================================
# 3. Check and install NVIDIA Container Toolkit (optional)
# ============================================================================
print_header "Step 3: NVIDIA Container Toolkit (Optional)"
echo ""

if command -v nvidia-smi &> /dev/null; then
    print_success "NVIDIA drivers detected"

    if command -v nvidia-ctk &> /dev/null; then
        print_success "NVIDIA Container Toolkit is already installed"
    else
        print_info "Installing NVIDIA Container Toolkit..."

        # Add NVIDIA repository
        curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
            sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

        curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null

        sudo apt update -qq
        sudo apt install -y nvidia-container-toolkit > /dev/null 2>&1

        # Configure Docker
        sudo nvidia-ctk runtime configure --runtime=docker > /dev/null 2>&1
        sudo systemctl restart docker

        print_success "NVIDIA Container Toolkit installed successfully"
    fi
else
    print_warning "NVIDIA drivers not detected. Skipping NVIDIA Container Toolkit installation."
    print_info "You can still run the containers without GPU support using the -N flag."
fi
echo ""

# ============================================================================
# 4. Clone repositories
# ============================================================================
print_header "Step 4: Cloning Repositories"
echo ""

CODE_DIR="$(cd "$script_dir/../../.." && pwd)"
mkdir -p "$CODE_DIR"

# Clone holoocean-ros
if [ -d "$CODE_DIR/holoocean-ros" ]; then
    print_success "holoocean-ros repository already exists"
else
    print_info "Cloning holoocean-ros..."
    git clone git@github.com:MATE-Leviathan/holoocean-ros.git "$CODE_DIR/holoocean-ros"
    print_success "holoocean-ros cloned successfully"
fi
echo ""

# ============================================================================
# 5. Install HoloOcean
# ============================================================================
print_header "Step 5: Installing HoloOcean"
echo ""

print_warning "IMPORTANT: You must link your GitHub account with Unreal Engine!"
print_info "1. Go to: https://www.unrealengine.com/en-US/ue-on-github"
print_info "2. Link your GitHub account"
print_info "3. Accept the Unreal Engine EULA"
echo ""
read -p "Have you completed the above steps? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Please complete the Unreal Engine GitHub linking before continuing."
    exit 1
fi

# Clone HoloOcean
if [ -d "$CODE_DIR/HoloOcean" ]; then
    print_success "HoloOcean repository already exists at $CODE_DIR/HoloOcean"
else
    print_info "Cloning HoloOcean..."
    cd "$CODE_DIR"
    git clone https://github.com/byu-holoocean/HoloOcean.git
    print_success "HoloOcean cloned successfully"
fi

# Install HoloOcean client
print_info "Installing HoloOcean Python client..."
cd "$CODE_DIR/HoloOcean/client"
python3 -m venv .venv
.venv/bin/python -m pip install -e .
print_success "HoloOcean client installed"

# Install Ocean world package
print_info "Installing Ocean world package (this may take a while)..."
.venv/bin/python -c "import holoocean; holoocean.install('Ocean')"
print_success "Ocean world package installed to ~/.local/share/holoocean/"
echo ""

print_success "Simulation dependencies installed."
print_info "Start: bash $script_dir/setup.sh -H (NVIDIA) or -N (without NVIDIA)."
