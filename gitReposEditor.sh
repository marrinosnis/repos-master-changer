#!/bin/bash

NO_CHANGES_COLOR="\033[4;36m"  # 35m is the Cyan color
CHANGES_COLOR="\033[4;91m"     # 91m is the Light Red
BRANCH_COLOR="\033[4;33m"      # 33m is the Yellow color
WARNING_COLOR="\033[31m"       # 31m is the Red color 
END_COLOR="\033[0m"            #  0m is to revert back to default color

rootFolder=$(dirname "$(pwd)")
searchPattern=(-name 'repos-master-changer')
printOnce=false
specifiedPaths=""
extendSpecifiedPaths=""
mapChoices=(
    "status::customGitStatus"
    "git::gitFunction"
    "specific::changeSpecificLine"
    "customCommand::customCommandsFunction"
)

githubUrl="https://raw.githubusercontent.com/marrinosnis/repository-package-name/master/findRepoPackageName.sh"
inputToken="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"  # here replace this token with new one
owner="marrinosnis"

source ./helper-functions/customGitStatusFunction.sh
source ./helper-functions/gitCommandsFunction.sh
source ./helper-functions/changeSpecificLineFunction.sh
source ./helper-functions/setSpecificPathsFunction.sh
source ./helper-functions/customCommandsFunction.sh

directories=$(find "$rootFolder" -maxdepth 1 -type d \( "${searchPattern[@]}" \) -exec sh -c 'cd "{}" && pwd' \;)

performAction() {
    local userChoice=$1

    for choice in "${mapChoices[@]}"; do
        keyChoiceOption="${choice%%::*}"
        valueChoiceFunctionName="${choice##*::}"
        if [ "$keyChoiceOption" == "$userChoice" ]; then
            break
        fi
    done

    local arguments=$2
    if [[ "$arguments" == *','* ]]; then
        IFS=',' read -ra argsArray <<< "$(echo "$arguments" | tr -d '[:space:]')" #create here the array for the arguments.
    else
        argsArray=("$arguments")
    fi
    shift
    shift


    local customInputPaths="${@:-$directories}"
    [[ -z "$customInputPaths" ]] && customInputPaths="$directories"
    paths=($customInputPaths)       #make it array, so I can access each element individual

    for path in "${paths[@]}"; do
       "$valueChoiceFunctionName" "$path" "${argsArray[@]}"
    done
}

if [[ $# -eq 0 ]]; then
    performAction "status" ""
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --git)
            read -p "Enter the git command: " cmd
            setSpecificPaths
            performAction "git" "$cmd" "${specifiedPaths[@]}"
            ;;

        --specificLine)
            echo -e "Insert the number of the line you want to edit"
            read line
            echo -e "Insert the text you want to be replaced on this line"
            read oldText
            echo -e "Insert the new/first text that will replace the old one"
            read newText
            specificReplaceDetails="$line, $oldText, $newText"
            setSpecificPaths
            performAction "specific" "$specificReplaceDetails" "${specifiedPaths[@]}"
            ;;

        --customCommand)  # change the name of the parameter. Is not very representative
            read -p "Enter the custom command that you want to apply: " inputCmd
            command=$(echo "$inputCmd" | tr ' ' ',')
            setSpecificPaths

            performAction "customCommand" "$command" "${specifiedPaths[@]}"
            ;;
        
        *)
            echo -e "${WARNING_COLOR}Not correct input flag. Try again\n${END_COLOR}"
            exit 1
            ;;
    esac
    shift
done