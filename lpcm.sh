#!/usr/bin/env bash

LPCM_PREFIX="~/.lpcm"
LPCM_PREFIX="./tmp"

lpcm_create_setting_template(){

    # Settings
    # --no-check dont ask to check all settings
    # Show all settings at once


    echo "lpcm_create_setting_template"
    echo "$@"
}

lpcm_generate_password(){
    echo "lpcm_generate_password"
    echo "$@"
}

lpcm_create_template(){
    echo "lpcm_create_template"
    echo "$@"
}

lpcm_process_parameter() {

    case "$1" in
        generate)
            shift
            lpcm_generate_password "$@" ;;
        create-template)
            shift
            lpcm_create_setting_template "$@" ;;
        create)
            shift
            lpcm_create_template "$@" ;;
        *)
            lpcm_generate_password_from_profile "$@" ;;

    esac
}
lpcm_process_parameter "$@"