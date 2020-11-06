# Name of config file
CONFIG_NAME="awsconfiguration"

# Extension of config file
CONFIG_EXT=".json"

# Expected name of the config file
CONFIG_FILE=${CONFIG_NAME}${CONFIG_EXT}

# Parent directory of environment config files 
ENV_CONFIG_SOURCE=${PROJECT_DIR}/buildscripts/env_configs

# Check and copy files
if [ "${ENV_NAME}" == "development" ]
then
 
    SOURCE_CONFIG_FILE=${CONFIG_NAME}-dev${CONFIG_EXT}
    SOURCE_FILE_PATH="${ENV_CONFIG_SOURCE}/${SOURCE_CONFIG_FILE}"
    echo "Source: $SOURCE_FILE_PATH"
 
    if [ ! -f $SOURCE_FILE_PATH ]
    then
        echo "Unable to locate Development config file '${SOURCE_CONFIG_FILE}'. Aborting!"
        exit 1
    else
        echo "Copying ${SOURCE_CONFIG_FILE}"
        cp "${SOURCE_FILE_PATH}" "${PROJECT_DIR}/${CONFIG_FILE}"
    fi
 
elif [ "${ENV_NAME}" == "staging" ]
then
 
    SOURCE_CONFIG_FILE=${CONFIG_NAME}-stg${CONFIG_EXT}
    SOURCE_FILE_PATH="${ENV_CONFIG_SOURCE}/${SOURCE_CONFIG_FILE}"
    echo "Source: $SOURCE_FILE_PATH"
 
    if [ ! -f $SOURCE_FILE_PATH ]
    then
        echo "Unable to locate Staging config file '${SOURCE_CONFIG_FILE}'. Aborting!"
        exit 1
    else
        cp "${SOURCE_FILE_PATH}" "${PROJECT_DIR}/${CONFIG_FILE}"
        cp "${SOURCE_FILE_PATH}" "${PROJECT_DIR}/${CONFIG_FILE}"
    fi
 
else

    SOURCE_CONFIG_FILE=${CONFIG_NAME}-prod${CONFIG_EXT}
    SOURCE_FILE_PATH="${ENV_CONFIG_SOURCE}/${SOURCE_CONFIG_FILE}"
    echo "Source: $SOURCE_FILE_PATH"
 
    if [ ! -f $SOURCE_FILE_PATH ]
    then
        echo "Unable to locate Production config file '${SOURCE_CONFIG_FILE}'. Aborting!"
        exit 1
    else
        echo "Copying ${SOURCE_CONFIG_FILE}"
        cp "${SOURCE_FILE_PATH}" "${PROJECT_DIR}/${CONFIG_FILE}"
    fi
fi
