#!/bin/bash
#######################################################
# Name: example.sh

# A bash script example for a component in the digital
# Rube Goldberg Machine.

# Usage: example.sh

# Author: WillowTree Inc.
# Date: 2019/03/07
#######################################################

# Note: This program is incomplete. There are 4 TODOs for you to address!

set -o errexit -o nounset -o pipefail

# TRIGGER_FILE will store the name of a file whose presence
# will trigger this component in the Rube Goldberg Machine.
#
# note: declare -r is a fancy way in bash to declare a read-only variable
declare -r TRIGGER_FILE='trigger.txt'

# usage: 
#   checkTrigger <TEAM> <PATTERN>
# 
# description: 
#   checkTrigger will check every 5 seconds whether the TEAM.json file
#   in firebase contains the specified PATTERN. When a match is detected,
#   it will create ${TRIGGER_FILE} and return. We run it as a background
#   job and wait for ${TRIGGER_FILE} to appear to know that it's finished.
#
# example:
#   checkTrigger dukes '{"isWinning": 1}' will create ${TRIGGER_FILE} and
#   return as soon as dukes.json in firebase contains {"isWinning": 1}
checkTrigger ()
{
    declare -r TEAM=${1}
    declare -r PATTERN=${2}

    while true; do
    
        # curl is a popular command line utility to make a network http request,
        # backticks (``) in bash allow you to run a command in a subshell,
        # and the 2>/dev/null part redirects curl's STDERR output into a black hole
        # so we don't have to look at it
        local TRIGGER=`curl \
                            -H 'Accept: application/json' \
                            -H 'Cache-Control: no-cache' \
                            "https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata/${TEAM}.json" 2>/dev/null`
        
        ##### TODO: Test whether ${TRIGGER} matches the specified ${PATTERN}
        #
        #     This may be helpful ;)
        #     https://stackoverflow.com/questions/2237080/how-to-compare-strings-in-bash
        #
        #     Also, just so you know, jq (https://stedolan.github.io/jq/) is a good command-line
        #     utility for processing json data (but you probably won't need to use it here)
        #
        # if . . .; then
        #     touch ${TRIGGER_FILE} # IMPORTANT: This is how we notify our main process that the trigger has fired!
        #     return                # exit the loop
        # fi

        sleep 5
    done
  
}

# usage:
#   sendTrigger <TEAM> <JSON>
#
# description:
#   sendTrigger writes the provided JSON data to the file TEAM.json in firebase.
#   Use this to trigger the next component in the Rube Goldberg Machine!
#
# example:
#   sendTrigger 'bison' '{"isWinning":1}' will update the bison.json file in
#   firebase to hold the JSON data {"isWinning":1}
sendTrigger ()
{
    declare -r TEAM=${1}
    declare -r JSON=${2}

    curl -X PUT \
        "https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata/${TEAM}.json" \
        -H 'Content-Type: application/json' \
        -d "${JSON}"
}

### START
#   This is where the program starts! The functions above don't run
#   until we call them.

# Ampersand (&) is how you create a background job in bash.
# Here, we're kicking off our checkTrigger polling loop in the background.
### TODO: Specify TEAM and PATTERN parameters
checkTrigger 'TEAM' '{"KEY":"VALUE"}'&

# Also, we set a trap in case this program gets interrupted or terminated
# to give ourselves a chance to kill the checkTrigger background job before
# this program exits. Note: $! returns the job id of the most recent background
# job, which is checkTrigger in this case.
trap "echo 'CLEANING UP BACKGROUND JOB: $!' && kill $!" INT TERM

# Show spinning indicator until checkTrigger finishes, which we'll
# know b/c it creates the ${TRIGGER_FILE}.
# Note: [ -f FILE ] is a way to test for file existence in bash 
declare -r PREFIX='waiting . . . '
until [ -f ${TRIGGER_FILE} ]; do
    echo -n -e "\r${PREFIX}| "
    sleep 0.1
    echo -n -e "\r${PREFIX}/ "
    sleep 0.1
    echo -n -e "\r${PREFIX}- "
    sleep 0.1
    echo -n -e "\r${PREFIX}\\ "
    sleep 0.1
done
echo -n -e "\b \n\n"

# Clean up by immediately removing the ${TRIGGER_FILE} that was just created
# now that it's served its purpose of signaling us to continue . . .
rm ${TRIGGER_FILE}

### TODO: GO CRAZY HERE!!!
# echo "DO SOMETHING FUN!"

### TODO: Notify the next component in the Rube Goldberg Machine.
# sendTrigger 'TEAM' '{"KEY":"VALUE"}'

echo "done for real"
