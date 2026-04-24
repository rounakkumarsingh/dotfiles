#!/usr/bin/env bash
# install-nvim-tools.sh - Helper script for installing non-Mason Neovim dependencies
# Usage: ./install-nvim-tools.sh [check|install|list]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Tool definitions: name|install_method|check_command|install_command
# Install methods: npm, cargo, brew, pip, go, standalone

TOOLS=(
	"oxfmt|npm|oxfmt --version|npm install -g oxc@latest"
	"oxlint|npm|oxlint --version|npm install -g oxc@latest"
	"biome|npm|biome --version|npm install -g @biomejs/biome"
	"prettierd|npm|prettierd --version|npm install -g @fsouza/prettierd"
	"eslint_d|npm|eslint_d --version|npm install -g eslint_d"
	"yamlfmt|go|yamlfmt -version|go install github.com/google/yamlfmt/cmd/yamlfmt@latest"
	"mdformat|pip|mdformat --version|pip install mdformat"
	"dprint|standalone|dprint --version|curl -fsSL https://dprint.dev/install.sh | sh"
)

# Detect OS and package manager
detect_os() {
	case "$(uname -s)" in
		Linux*)
			if command -v apt-get &> /dev/null; then
				echo "debian"
			elif command -v dnf &> /dev/null; then
				echo "fedora"
			elif command -v pacman &> /dev/null; then
				echo "arch"
			elif command -v apk &> /dev/null; then
				echo "alpine"
			else
				echo "linux-unknown"
			fi
			;;
		Darwin*) echo "macos" ;;
		MINGW*|CYGWIN*|MSYS*) echo "windows" ;;
		*) echo "unknown" ;;
	esac
}

# Check if a command exists
command_exists() {
	command -v "$1" &> /dev/null
}

# Check tool availability
check_tool() {
	local name="$1"
	local check_cmd="$2"

	if eval "$check_cmd" &> /dev/null; then
		echo -e "${GREEN}✓${NC} $name"
		return 0
	else
		echo -e "${RED}✗${NC} $name"
		return 1
	fi
}

# Install a tool based on its method
install_tool() {
	local name="$1"
	local method="$2"
	local install_cmd="$3"
	local os

	echo -e "${BLUE}Installing $name...${NC}"

	case "$method" in
		npm)
			if command_exists npm; then
				eval "$install_cmd"
			else
				echo -e "${RED}npm not found. Please install Node.js${NC}"
				return 1
			fi
			;;
		cargo)
			if command_exists cargo; then
				eval "$install_cmd"
			else
				echo -e "${RED}cargo not found. Please install Rust${NC}"
				return 1
			fi
			;;
		brew)
			if command_exists brew; then
				eval "$install_cmd"
			else
				echo -e "${RED}brew not found. Please install Homebrew${NC}"
				return 1
			fi
			;;
		pip)
			if command_exists pip3; then
				eval "$install_cmd"
			else
				echo -e "${RED}pip not found. Please install Python${NC}"
				return 1
			fi
			;;
		go)
			if command_exists go; then
				eval "$install_cmd"
			else
				echo -e "${RED}go not found. Please install Go${NC}"
				return 1
			fi
			;;
		standalone)
			eval "$install_cmd"
			;;
		*)
			echo -e "${RED}Unknown install method: $method${NC}"
			return 1
			;;
	esac

	echo -e "${GREEN}✓ $name installed${NC}"
}

# Main check command
cmd_check() {
	local missing=()

	echo -e "${BLUE}Checking Neovim tool dependencies...${NC}"
	echo ""

	for tool_def in "${TOOLS[@]}"; do
		IFS='|' read -r name method check_cmd install_cmd <<< "$tool_def"
		if ! check_tool "$name" "$check_cmd"; then
			missing+=("$name|$method|$install_cmd")
		fi
	done

	echo ""
	if [ ${#missing[@]} -eq 0 ]; then
		echo -e "${GREEN}All tools are available!${NC}"
	else
		echo -e "${YELLOW}Missing tools: ${#missing[@]}${NC}"
		echo "Run '$0 install' to install missing tools"
	fi

	return ${#missing[@]}
}

# Main install command
cmd_install() {
	echo -e "${BLUE}Installing missing Neovim tools...${NC}"
	echo ""

	local installed=0
	local failed=0

	for tool_def in "${TOOLS[@]}"; do
		IFS='|' read -r name method check_cmd install_cmd <<< "$tool_def"

		if ! eval "$check_cmd" &> /dev/null; then
			if install_tool "$name" "$method" "$install_cmd"; then
				((installed++))
			else
				((failed++))
			fi
		else
			echo -e "${GREEN}✓ $name already installed${NC}"
		fi
	done

	echo ""
	if [ $failed -eq 0 ]; then
		echo -e "${GREEN}Successfully installed/verified $installed tools${NC}"
	else
		echo -e "${YELLOW}Installed $installed tools, $failed failed${NC}"
	fi
}

# List all tools and their status
cmd_list() {
	echo -e "${BLUE}Neovim Tool Status${NC}"
	echo ""
	printf "%-15s %-10s %-10s %s\n" "Tool" "Method" "Status" "Install Command"
	printf "%-15s %-10s %-10s %s\n" "----" "------" "------" "---------------"

	for tool_def in "${TOOLS[@]}"; do
		IFS='|' read -r name method check_cmd install_cmd <<< "$tool_def"
		if eval "$check_cmd" &> /dev/null; then
			printf "%-15s %-10s ${GREEN}%-10s${NC} %s\n" "$name" "$method" "installed" "$install_cmd"
		else
			printf "%-15s %-10s ${RED}%-10s${NC} %s\n" "$name" "$method" "missing" "$install_cmd"
		fi
	done
}

# Show help
cmd_help() {
	cat << 'EOF'
Neovim Tools Installation Helper

This script manages non-Mason tools required by your Neovim configuration.
These tools are NOT managed by :Mason because they are CLI formatters/linters,
not LSP servers.

USAGE:
    ./install-nvim-tools.sh [COMMAND]

COMMANDS:
    check   Check which tools are installed/missing (default)
    install Install all missing tools
    list    List all tools with installation commands
    help    Show this help message

EXAMPLES:
    ./install-nvim-tools.sh check     # Check current status
    ./install-nvim-tools.sh install   # Install everything
    ./install-nvim-tools.sh list      # Show tool list

MANUAL INSTALLATION:
    If you prefer to install manually:

    # Oxc toolchain (oxfmt + oxlint) - Recommended
    npm install -g oxc@latest

    # Alternative: Install via Cargo
    cargo install oxc_cli

    # Biome (fallback formatter/linter)
    npm install -g @biomejs/biome

    # Prettierd (daemonized prettier, faster)
    npm install -g @fsouza/prettierd

    # Or use corepack (Node.js 16.10+)
    corepack enable
    # Then in project: yarn dlx @biomejs/biome

CROSS-PLATFORM NOTES:
    - macOS: Use Homebrew where available: brew install biome
    - Linux: npm/cargo generally work everywhere
    - Windows: Use WSL2 or Git Bash for this script
EOF
}

# Main entry point
main() {
	local cmd="${1:-check}"

	case "$cmd" in
		check) cmd_check ;;
		install) cmd_install ;;
		list) cmd_list ;;
		help|--help|-h) cmd_help ;;
		*)
			echo -e "${RED}Unknown command: $cmd${NC}"
			cmd_help
			exit 1
			;;
	esac
}

main "$@"
