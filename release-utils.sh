#!/bin/bash

REQUIRED_BASH_VERSION=3.0.0

if [[ $BASH_VERSION < $REQUIRED_BASH_VERSION ]]; then
  echo "You must use Bash version 3 or newer to run this script"
  exit
fi

DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)


# DEFINE

VERSION_REGEX='([0-9]*)\.([0-9]*)([a-zA-Z0-9\.]*)'

# SCRIPT

usage()
{
cat << EOF
usage: $0 options

This script aids in releasing the cdi-spec.org site 

OPTIONS:
   -u      Updates version numbers in all POMs, used with -o and -n      
   -o      Old version number to update from
   -n      New version number to update to
   -h      Shows this message
EOF
}

parse_git_branch() {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

update()
{
   cd $DIR/
   echo "Updating versions from $OLDVERSION TO $NEWVERSION for all Java and XML files under $PWD"
   perl -pi -e "s/version: ${OLDVERSION}/version: ${NEWVERSION}/g" _config/site.yml 
}

OLDVERSION="1.0.0-SNAPSHOT"
NEWVERSION="1.0.0-SNAPSHOT"
VERSION="1.0.0-SNAPSHOT"
CMD="usage"

while getopts “uo:n:” OPTION

do
     case $OPTION in
         u)
             CMD="update"
             ;;
         h)
             usage
             exit
             ;;
         o)
             OLDVERSION=$OPTARG
             ;;
         n)
             NEWVERSION=$OPTARG
             ;;
         [?])
             usage
             exit
             ;;
     esac
done

$CMD

