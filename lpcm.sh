#!/usr/bin/env bash

METHOD=$1

if [[ ${METHOD} == "create" ]]; then


    if [[ $2 == "template" ]]; then

        #DEFAULTS
        SYMBOLS=1
        LOWER=1
        UPPER=1
        DIGITS=1
        LENGTH=16

        COPY=0

        SALT=0
        DELIMITER=""

        CHECK=0
        CHECK_P=""

        MASTERPASSWORD=1
        MPW_ENV="lpmpw"

        read -p "Change default options (lower,upper,digits,length,symbols, copy) (y/N)? " -n 1 -r CONFIG
        echo

        if [[  ${CONFIG} =~ ^[Yy]$  ]]; then

            read -p "Enable symbols (Y/n)? " -n 1 -r
            echo
            SYMBOLS=1
            if [[ ! $REPLY =~ ^[Yy]$ && $REPLY != "" ]]; then
                SYMBOLS=0
            fi

            read -p "Enable lowercase (Y/n)? " -n 1 -r
            echo
            LOWER=1
            if [[ ! $REPLY =~ ^[Yy]$ && $REPLY != "" ]]; then
                LOWER=0
            fi

            read -p "Enable uppercase (Y/n)? " -n 1 -r
            echo
            UPPER=1
            if [[ ! $REPLY =~ ^[Yy]$ && $REPLY != "" ]]; then
                UPPER=0
            fi

            read -p "Enable digits (Y/n)? " -n 1 -r
            echo
            DIGITS=1
            if [[ ! $REPLY =~ ^[Yy]$ && $REPLY != "" ]]; then
                DIGITS=0
            fi

            read -p "Set length (Y/n)? " -n 1 -r
            echo
            LENGTH=16
            if [[ ! $REPLY =~ ^[Yy]$ && $REPLY != "" ]]; then

                read -p "Password length [5-35] (default 16)? " -r LENGTH

            fi

            read -p "Enable copy to clipboard (y/N)? " -n 1 -r
            echo
            COPY=0
            if [[ $REPLY =~ ^[Yy]$ && $REPLY != "" ]]; then
                DIGITS=1
            fi

        fi


        read -p "Change extra options (salt, check, save masterpassword in env)(y/N)? " -n 1 -r E_CONFIG
        echo

        if [[  ${E_CONFIG} =~ ^[Yy]$  ]]; then

            read -p "Enable salt (y/N)? " -n 1 -r
            echo
            SALT=0
            DELIMITER=""
            if [[ $REPLY =~ ^[Yy]$ && $REPLY != "" ]]; then
                SALT=1

                read -p "Set delimiter (press enter for no limiter): "
                DELIMITER=$REPLY

            fi

            read -p "Enable check (y/N)? " -n 1 -r
            echo
            CHECK=0
            CHECK_P=""
            if [[ $REPLY =~ ^[Yy]$ && $REPLY != "" ]]; then
                CHECK=1
                read -p "Please enter you master password: " -s
                CHECK_P=$(lesspass check check "$REPLY" -d -L 5 )
                echo "The check pin is $CHECK_P"


            fi


            read -p "Save masterpassword in env? (y/N)" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ && $REPLY != "" ]]; then
                MASTERPASSWORD=1

                read -p "Set custom name for env (press enter for no): "
                MP_NAME=$REPLY
                if [[ $MP_NAME == "" ]]; then

                    MP_NAME="lpmpw"

                fi

            fi

            read -p "Remove from history? (0=disable; 1=enabled; 2=only if masterpasspassword in arguments; 3=remove masterpassword from history) (default:3): " -r
            echo

            RM_HIST=3

            if [[ $REPLY =~ ^[012]$ ]]; then

                RM_HIST=$REPLY

            fi


            read -p "Pipe the password into a command? (0=disabled; 1=only pipe, ignores copy; 2=pipe and terminal out) (default:0)" -r

          if [[ $REPLY =~ ^[012]$ ]]; then

            PIPE=$REPLY

            read -p "Enter command: " -r
            PIPE_COMMAND=$REPLY

          fi


        fi

        #echo "The check pin is $CHECK_P"

        read -p "Enter template name: "

        template="
#!/usr/bin/env bash

# Should be obvious
SITE=\"{SITE}\"
LOGIN=\"{LOGIN}\"
SYMBOLS=${SYMBOLS}
LOWER=${LOWER}
UPPER=${UPPER}
DIGITS=${DIGITS}
LENGTH=${LENGTH}

COUNT=${COUNT}

COPY_TO_CLIPBOARD=${COPY}


# If enabled you will be have to enter your salt, after masterpassword check
# then the site passed to lesspass will be SITE + DELIMITER + SALT
# So that even if some on reads your templates,
# or asses a console with a saved masterpassword,
# they can't reproduce your password

SALT=${SALT}
SALT_DELIMITER=\"${DELIMITER}\"

CHECK=${CHECK}
CHECK_PIN=\"${CHECK_P}\"


#save masterpassword in env default = lpmpw
SAVE_MASTER_PASSWORD=${MASTERPASSWORD}
CUSTOM_MASTER_PASSWORD_VAR=\"${MPW_ENV}\"


#0=disable; 1=enabled; 2=only if masterpasspassword in arguments; 3=remove masterpassword from history
REMOVE_FROM_HISTORY=${RM_HIST}


#0=disabled; 1=only pipe; 2=pipe and terminal out
#1 disables copy

PIPE_OUTPUT=${PIPE}
PIPE_COMMAND=${PIPE_COMMAND}

. {PATH} generate \$SITE \$LOGIN \$SYMBOLS \$LOWER \$UPPER \$DIGITS \$LENGTH \$COPY_TO_CLIPBOARD \$SALT \"\$SALT_DELIMITER\" \$CHECK \"\$CHECK_PIN\" \$SAVE_MASTER_PASSWORD \$CUSTOM_MASTER_PASSWORD_VAR \"\$1\" \$REMOVE_FROM_HISTORY \$PIPE_OUTPUT \"\$PIPE_COMMAND\"


"
        if [[ ! -d "./templates" ]]; then
        mkdir "templates"
        fi
        printf "%s" "$template" > "./templates/$REPLY"


    else

        LPCM_PATH=$(realpath $0)
        LPCM_DIR=$(dirname ${LPCM_PATH})

        #echo "PATH:$LPCM_PATH"
        #echo "DIR:$LPCM_DIR"

        if  [[  -f "$LPCM_DIR/templates/$2" ]]; then

        SITE=$3
        LOGIN=$4
        SAVE_PATH=$5

        if [[ $3 == "" ]];then

            read -p "Enter site name: " SITE


        else

            SITE=$3

        fi

        if [[ $4 == "" ]]; then

            read -p "Enter login: " LOGIN

        else

            LOGIN=$4

        fi

        if [[ $5 == "" ]]; then

            read -p "Save path: " SAVE_PATH

        else
            test
            #SAVE_PATH=$(echo $5 | sed 's_/_\\/_g')

        fi

        SAVE_PATH_TMP="${SAVE_PATH}.tmp"

        parent_dir=$(dirname ${SAVE_PATH})

        if [[ ! -d "$parent_dir" ]]; then
            echo "$parent_dir"
            mkdir -p "$parent_dir"

        fi

        cp "$LPCM_DIR/templates/$2" "./"${SAVE_PATH_TMP}

        sed -i "s/{SITE}/$SITE/g" ${SAVE_PATH_TMP}
        sed -i "s/{LOGIN}/$LOGIN/g" ${SAVE_PATH_TMP}

        #echo "PATH $LPCM_PATH"



        sed -i "s#{PATH}#$LPCM_PATH#g" ${SAVE_PATH_TMP}

        parent_dir=$(dirname ${SAVE_PATH})


        cp ${SAVE_PATH_TMP} ${SAVE_PATH}
        rm ${SAVE_PATH_TMP}
        chmod u+x ${SAVE_PATH}
        chmod o-rwx ${SAVE_PATH}

        else

        echo "not template named $2"

        fi
    fi


elif [[ ${METHOD} == "generate" ]]; then


    SITE=$2
    LOGIN=$3
    SYMBOLS=$4
    LOWER=$5
    UPPER=$6
    DIGITS=$7
    LENGTH=$8
    COPY=$9
    SALT=${10}
    DELIMITER=${11}
    CHECK=${12}
    CHECK_P=${13}

    SAVE_MPWD=${14}
    MPWD_VAR=${15}
    MPWD=${16}

    RM_HIST=${17}

    PIPE=${18}
    PIPE_COMMAND=${19}

    if [[ $RM_HIST != 0 ]]; then

        CUR_HIST_ENTRY_INDEX=$(history 1 | awk '{print $1}')
        CUR_HIST_ENTRY_START=$(history 1 | cut --delimiter=' ' -f 5-6)
        CUR_HIST_ENTRY_END=$(history 1 | cut --delimiter=' ' -f 7-)
        if [[ $CUR_HIST_ENTRY_END != "" ]]; then

            CUR_HIST_ENTRY_END=$(echo "$CUR_HIST_ENTRY_END" | replace $MPWD "")

        fi


        if [[ $RM_HIST == 2 && $MPWD != "" ||   $RM_HIST =~ ^[13]$ ]]; then
            history -d $CUR_HIST_ENTRY_INDEX

            if [[ $RM_HIST == 3 ]]; then

                #TODO FIX
                history -s ". $CUR_HIST_ENTRY_START$CUR_HIST_ENTRY_END"

            fi

        fi



    fi


       GMPWD=""

    if [[ $SAVE_MPWD == 1 ]]; then
        GMPWD="${!MPWD_VAR}"

        if [[ $MPWD == "" ]]; then
            #GMPWD==?
            MPWD=$GMPWD

        elif [[ $GMPWD == "" ]]; then
            #MPWD!="" GMPWD==""
            GMPWD=$MPWD
            set "$MPW_ENV" "$GMPWD"
        else
            #MPWD!="" GMPWD!=""

            if [[ $MPWD!=$GMPWD ]]; then

                read -p "Override global password? (y/N): " -r -n 1
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then

                    GMPWD=$MPWD

                fi


            fi



        fi


    fi

     if [[ $MPWD == "" ]]; then


            read -p "Enter masterpassword: " -s MPWD
            echo

        fi

    CHECKED=$(lesspass check check "$MPWD" -L5 -d)


    CONT=1

    if [[ $CHECK == 1 && $CHECKED != $CHECK_P ]]; then

       echo "Check failed"
       #exit 1
       CONT=0
    fi



    if [[ $CONT == 1 ]]; then

        if [[ $SAVE_MPWD == 1 ]]; then


            export $MPWD_VAR="$MPWD"

        fi



        if [[ $SALT == 1 ]]; then

            read -p "Enter salt: " -s
            echo
            SITE=$SITE$DELIMITER$REPLY
            #echo "$SITE"
        fi

        LESSPASS_ARGS=""
        #LESSPASS_ARGS="$SITE $LOGIN \"$MPWD\""

        if [[ $SYMBOLS == 1 ]]; then
            LESSPASS_ARGS="$LESSPASS_ARGS -s"
        fi
        if [[ $LOWER == 1 ]]; then
            LESSPASS_ARGS="$LESSPASS_ARGS -l"
        fi
        if [[ $UPPER == 1 ]]; then
            LESSPASS_ARGS="$LESSPASS_ARGS -u"
        fi
        if [[ $DIGITS == 1 ]]; then
            LESSPASS_ARGS="$LESSPASS_ARGS -d"
        fi
        if [[ $LENGTH != "" ]]; then
            LESSPASS_ARGS="$LESSPASS_ARGS -L$LENGTH"
        fi


        LESSPASS_ARGS_NO_COPY="$LESSPASS_ARGS"

        if [[ $COPY == 1 ]]; then
            LESSPASS_ARGS="$LESSPASS_ARGS -c"
        fi


        if [[ $PIPE == 0 || $PIPE == 2 || $PIPE == "" ]]; then
            #echo "$LESSPASS_ARGS_NO_COPY"
            lesspass "$SITE" "$LOGIN" "$MPWD" $LESSPASS_ARGS


        fi

        if [[ $PIPE == 1 || $PIPE == 2 ]]; then
                #echo "$LESSPASS_ARGS_NO_COPY"
                lesspass "$SITE" "$LOGIN" "$MPWD" $LESSPASS_ARGS_NO_COPY | $PIPE_COMMAND

        fi


    fi




else

    test
    #echo "Path:"$(realpath $0)


fi