#!/bin/bash -x

if [[ ${GIT_BRANCH} == *develop ]] 
then
        URLS=("35.231.92.12" "34.73.24.245")
elif [[ ${GIT_BRANCH} == *release* ]]
then
        URLS=("34.73.24.245")    
else 
   exit 1
fi

#URLS=("pub1-dev1.ncw.webapps.rr.com")
SALESCHANNELS=("DS")

ARTIFACT_NAME="apache-tomcat-8.5.9.tar.gz"
ARTIFACT_PATH="dist/tomcat/tomcat-8/v8.5.9/bin/"
SERVERS=( "${URLS[@]}" )

for SALESCHANNEL in "${SALESCHANNELS[@]}"
do
if [ $SALESCHANNEL == "DS" ]
    then
        APP_HOME="/opt/apps/www/mobile-token-generator-https"
        CONFIG_NAME="apache-tomcat-8.5.9.tar.gz"
      else 
                exit 1
    # else
    #     APP_HOME="/data/apps/www/retail-mobile-token-generator-https"
    #     CONFIG_NAME="config.development.retail.js"
fi
done
UI__HOME_TEMP="${APP_HOME}/tmp"

for SERVER in "${SERVERS[@]}"
do
echo "Deploying to $SERVER"
#ssh -o StrictHostKeyChecking=no jayasimhaiit@${SERVER} << END_CONNECTION
ssh jenkins@${SERVER} << END_CONNECTION
    # Clear the old version
    echo ${APP_HOME}
    sudo rm -rf ${APP_HOME}/*

    # Build an expansion directory
    sudo mkdir -p ${UI__HOME_TEMP}

    # Get and expand the new version
    sudo wget --no-check-certificate --no-verbose -P ${UI__HOME_TEMP} https://archive.apache.org/${ARTIFACT_PATH}/${ARTIFACT_NAME}
    sudo tar -xzf ${UI__HOME_TEMP}/${ARTIFACT_NAME} -C ${UI__HOME_TEMP}

    # Move the needed files from the temp folder to the root
    sudo mv ${UI__HOME_TEMP}/* ${APP_HOME}
    sudo rm -rf ${UI__HOME_TEMP}

    # Use correct config version
    sudo mv ${APP_HOME}/${CONFIG_NAME} ${APP_HOME}/config.tar.gz

    # Make sure owner is correct
    sudo chown -R jayasimhaiit:jayasimhaiit ${APP_HOME}/

END_CONNECTION
done
