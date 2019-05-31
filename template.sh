#!/usr/bin/env bash

# Should be obvious
SITE=\"{SITE}\"
LOGIN=\"{LOGIN}\"
SYMBOLS=${SYMBOLS}
LOWER=${LOWER}
UPPER=${UPPER}
DIGITS=${DIGITS}
LENGTH=${LENGTH}

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


#0=disable; 1=enabled; 2=only if masterpasspassword in arguments
REMOVE_FROM_HISTORY=${RM_HIST}


{PATH} generate \$SITE \$LOGIN \$SYMBOLS \$LOWER \$UPPER \$DIGITS \$LENGTH \$COPY_TO_CLIPBOARD \$SALT \$SALT_DELIMITER \$CHECK \$CUSTOM_CHECK \$SAVE_MASTER_PASSWORD \$CUSTOM_MASTER_PASSWORD_VAR \$REMOVE_FROM_HISTORY

