#!/usr/bin/env bash

# ====================================================================
# Running this script will:
# 1. Install VS Code's Python extension.
# 2. Install poetry for the current user, if not already installed.
# 3. Install dependencies defined in pyproject.toml and activate new environment.
#
# Usage: ./start.sh
# ======================================================================

function log {
    local PURPLE='\033[0;35m'
    local NOCOLOR='\033[m'
    local BOLD='\033[1m'
    local NOBOLD='\033[0m'
    echo -e -n "${PURPLE}${BOLD}$1${NOBOLD}${NOCOLOR}" >&2
}

function install_vscode_extensions {
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    if [ -x "$(command -v code)" ]
    then
        log "Installing VS Code's Python extension...\\n"
        code --install-extension ms-python.python --force
        code --install-extension ms-python.vscode-pylance --force
        log "Done!\\n"
    else
        log "VS Code CLI not found, skipping installation of extensions..."
    fi
}


function install_poetry {
    if ! [ -x "$(command -v poetry)" ]
    then
        log "Installing poetry... "
        curl -sSL https://install.python-poetry.org | python3 -
        # Export for current shell
        export PATH=${HOME}/.local/bin:$PATH
        # Add to bashrc to persist change for new shells
        echo 'export PATH=${HOME}/.local/bin:$PATH' >> ~/.bashrc
        log "You may need to restart your shell in order for these changes to take effect."
        log "Done!\\n"
    fi
}

function install_env {
    log "Disabling keyring backend.."
    export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
    poetry install
    log "Starting the virtual environment.."
    poetry shell
    log "Done!\\n"
}

function run_command {
    local COMMAND=$1
    case $COMMAND in
    help|--help)
        cat << EOF
Usage: ./setup.sh

Running this script will:

  1. Install VS Code's Python extension.
  2. Install poetry for the current user, if not already installed.
  3. Install dependencies defined in pyproject.toml and activate new environment.
EOF
        ;;
    devcontainer|--devcontainer)
        install_env
        ;;
    *)
        install_vscode_extensions
        install_poetry
        install_env
        ;;
    esac
}

run_command "$@"
