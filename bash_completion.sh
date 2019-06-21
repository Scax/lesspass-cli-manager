#!/usr/bin/env bash
# Inspired from https://github.com/nvm-sh/nvm/blob/master/bash_completion

prefix="~/.lpcm"
prefix="./tmp"

__lpcm_generate_completion() {
  declare current_word
  current_word="${COMP_WORDS[COMP_CWORD]}"

  COMPREPLY=($(compgen -W "$1" -- "${current_word}"))
  return 0
}

__lpcm_ls_files(){

    local BASES=""
    local LAST_BASE
    local FILES=""
    local FILES_WITH_BASE=""
    local DOUBLES=""

    while [[ $# -ne 0 ]]; do
        #echo "#$(echo "$1" | grep -P "/.*?:" -o)#"
        if [[ "$1" == "$(echo "$1" | grep -P "/.*?:" -o)" ]];then

        BASES="$BASES $1"
        LAST_BASE="${1##*/}"
        LAST_BASE="${LAST_BASE:0:-1}"
        else

            FILES="$FILES $1"
            FILES_WITH_BASE="$FILES_WITH_BASE $LAST_BASE/$1"
              #echo "#$(echo "$FILES" | tr " " "\n" | sort | uniq -c)#"
              #echo "--$(echo "$FILES" | tr " " "\n" | sort | uniq -c | grep -P "      2 " -o)--"
              if [[ "$(echo "$FILES" | tr " " "\n" | sort | uniq -c | grep -P "      2 " -o)" == "      2 " ]];then

                DOUBLES="$DOUBLES $1"

                #echo "dubled $1"
                #echo "$LAST_BASE"

              fi

        fi



        shift
    done

    #echo "$FILES"
    #echo "$FILES_WITH_BASE"
    #echo "$DOUBLES"

    for double in $(echo "$DOUBLES" | tr " " "\n"); do
        for replacement in $(echo $FILES_WITH_BASE | tr " " "\n" | grep "/$double$");do

            FILES="$(echo " ${FILES/ $double/ $replacement}")"

        done

    done

    echo "$FILES"

}

__lpcm_create_include_list(){


    #TODO count includes; format files and sub dir
    local LS_LINE=""
    for includes in $(cat "$prefix/include"); do
        LS_LINE="$LS_LINE $(ls -R "$includes" | tr '\n' ' ')"
    done
    #echo "$LS_LINE"
    local FILES=$(__lpcm_ls_files $LS_LINE)
    echo "$FILES"

}

__lpcm_commands(){
    declare current_word
    declare command

    current_word="${COMP_WORDS[COMP_CWORD]}"

    COMMANDS='create generate create-template'

    COMMANDS="$COMMANDS $(__lpcm_create_include_list)"

    __lpcm_generate_completion "$COMMANDS"

}

__lpcm_existing_credentials(){

    __lpcm_generate_completion "$(__lpcm_create_include_list)"

}

__lpcm(){

    declare previous_word
    previous_word="${COMP_WORDS[COMP_CWORD - 1]}"

    case "${previous_word}" in
        generate) __lpcm_existing_credentials ;;
        create) __lpcm_existing_setting_templates;;
        create-template) __lpcm_template_options;;
        *) __lpcm_commands;;
    esac

}

# From https://github.com/nvm-sh/nvm/blob/master/bash_completion
# complete is a bash builtin, but recent versions of ZSH come with a function
# called bashcompinit that will create a complete in ZSH. If the user is in
# ZSH, load and run bashcompinit before calling the complete function.
if [[ -n ${ZSH_VERSION-} ]]; then
  autoload -U +X bashcompinit && bashcompinit
  autoload -U +X compinit && if [[ ${ZSH_DISABLE_COMPFIX-} = true ]]; then
    compinit -u
  else
    compinit
  fi
fi


complete -o default -F __lpcm lpcm