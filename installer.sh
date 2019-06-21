#!/usr/bin/env bash

prefix="~/.lpcm"
prefix="./tmp"

if [[ ! -d "${prefix}" ]]; then

    mkdir "${prefix}" -p

fi

read -p "Where to save the template? (default ${prefix}/credentials/)" savePath
defaultSavePath="${prefix}/credentials"
if [[ ! -d "${savePath:=${defaultSavePath}}" ]]; then

    mkdir "${savePath}" -p


fi

echo "$(realpath "${savePath}")" > "${prefix}/include"

#Download Script
cp ./lpcm.sh "${prefix}/"
cp ./bash_completion.sh "${prefix}/"
alias lpcm="${prefix}/lpcm.sh"

. "${prefix}/bash_completion.sh"