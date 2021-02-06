#!/usr/bin/env bash

# This script will run stacks-dump against
# an active stacks-node miner's data and
# output the results to a a Discord web
# hook to show basic stats.

########
# INIT #
########

set -o errexit
set -o pipefail
set -o nounset

# timestamp in UTC
# __timestamp=$(date -u +"%Y%m%d-%H%M%S")

# read input for loop (optional)
__sleeptime="${1:-}"

## UPDATE VARIABLES BELOW FOR YOUR SYSTEM

# directory for working_dir data from stacks-node
__stacksnode="/tmp/stacks-testnet-62fac7d03db72274/"

# directory for running stacks-dump
__stacksdump="/mnt/volume_nyc1_05/stacks-dump"
# directory for repo to publish results
# __publishdir="/home/ubuntu/pub-stacks-dump"
# file name for saving stacks-node data
# __outputfile="stacks-dump.txt"
# file name for saving stacks-node data as json
# __outputjsonfile="stacks-dump.json"
# file name for saving stacks-node data as csv
# __outputcsvfile="stacks-dump.csv"
# website to access data after published
# __website="https://friedger.github.io/pub-stacks-dump/"
# twitter account used for twitter card in SEO
# __twitter="@fmdroid"

##########
# SCRIPT #
##########

# Verify all directories exist before starting
if [ ! -d "$__stacksnode" ]; then
  printf "stacks-node working directory not found, please check the variable in the script."
  exit
elif [ ! -d "$__stacksdump" ]; then
  printf "stacks-dump directory not found, please check the variable in the script or download from GitHub.\n\nhttps://github.com/psq/stacks-dump"
  exit
# elif [ ! -d "$__publishdir" ]; then
#   printf "publishing directory not found, please check the variable in the script."
# exit
fi

function publish() {

# Run stacks-dump and save output to file
cd "$__stacksdump" || exit
git pull
node report -b -g -l -z "$__stacksnode"
# node report "$__stacksnode" -j -l > "$__publishdir"/"$__outputjsonfile"
# node report "$__stacksnode" -c > "$__publishdir"/"$__outputcsvfile"

}

if [ "$__sleeptime" == "" ]; then
  publish
  exit
else
  while true
  do
    # __timestamp=$(date -u +"%Y%m%d-%H%M%S")
    publish
    sleep "$__sleeptime"
    # printf "Published at: %s", "$__timestamp"
  done
fi
