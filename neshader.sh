#!/bin/bash

PATH_PROJECT="$(dirname "${0}")"

function print_error() {
    echo "${1}" >&2
}

function print_invalid_argument() {
    print_error "Invalid arguments passed. Use '${0} -h' for help"
}

if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
    echo "Utility to work with this shader"
    echo ""
    echo "Usage:"
    echo "    ${0} [ -h | --help ] <command> [<args>]"
    echo ""
    echo "Available commands:"
    echo "    ${0} install            Install the current shader in the Minecraft directory"
    echo "    ${0} new <shader-name>  Create a new shader file in the correct directory"

elif [[ "${1}" == "install" ]]; then
    SHADER_NAME="NeShader"
    PATH_OUTPUT="${HOME}/.minecraft/shaderpacks/${SHADER_NAME}.zip"
    zip -r "${PATH_OUTPUT}" "${PATH_PROJECT}/shaders"

elif [[ "${1}" == "new" && -n "${2}" ]]; then
    PATH_FILE="${PATH_PROJECT}/shaders/${2}"
    if [[ -e "${PATH_FILE}" ]]; then
        print_error "Shader file '${PATH_FILE}' already exists"
        exit 1
    fi
    mkdir -p "$(dirname "${PATH_FILE}")" || {
        print_error "Cannot create directories for the shader file '${PATH_FILE}'"
        exit 1
    }

    cat << EOT > "${PATH_FILE}"
// Settings
#include "/settings/settings.glsl"

// Libraries

// Ins

// Outs

// Uniforms

// Constants

// Functions

// Program
void main() {

}
EOT

else
    print_invalid_argument
    exit 1
fi
