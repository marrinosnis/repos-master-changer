#!/bin/bash

NO_CHANGES_COLOR="\033[4;36m"  # 35m is the Cyan color
CHANGES_COLOR="\033[4;91m"     # 91m is the Light Red
BRANCH_COLOR="\033[4;33m"      # 33m is the Yellow color
WARNING_COLOR="\033[31m"       # 31m is the Red color 
END_COLOR="\033[0m"            #  0m is to revert back to default color
rootFolder="../Desktop/Camelot_Projects"
searchPattern=(-name 'ctp-*' -o -name 'ctp.*')
printOnce=false
specifiedPaths=""
mapChoices=(
    "status::statusCode"
    "setYAMLRunningMode::changeYAMLRunningMode"
    "commit::commitCode"
    "push::pushCode"
    "specific::changeSpecificLine"
    "customCommand::customCommandFunction"
)

# directories=$(find "$rootFolder" -maxdepth 1 -type d \( -name 'ctp-*' -o -name 'ctp.*' \) | wc -l)  # this command prints only the number of the folders, not the names, with the patter 'ctp-' or 'ctp.'
ctpDirectories=$(find "$rootFolder" -maxdepth 1 -type d \( "${searchPattern[@]}" \) -exec sh -c 'cd "{}" && pwd' \;)

performAction() {
    local userChoice=$1

    for choice in "${mapChoices[@]}"; do
        parameter="${choice%%::*}"
        functionName="${choice##*::}"
        if [ "$parameter" == "$userChoice" ]; then
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


    local customInputPaths="${@:-$ctpDirectories}"
    paths=($customInputPaths)       #make it array, so I can access each element individual
    for path in "${paths[@]}"; do
       "$functionName" "$path" "${argsArray[@]}"
    done
}

statusCode(){
    local pathToFolder=$1
    if [[ "$printOnce" == false ]]; then
        echo    "--------------------------------------------------------|"
        echo    "Checking if there are any changes in the repo/s         |"
        echo -e "--------------------------------------------------------|\n"
        printOnce=true
    fi

    defaultStatusWithoutChanges=$(git -C "${pathToFolder}" status -sb | head -n 1)
    currentRepoStatus=$(git -C "${pathToFolder}" status --branch --porcelain)
    currentBranch=$(git -C "${pathToFolder}" rev-parse --abbrev-ref HEAD)

    if [ "$defaultStatusWithoutChanges" == "$currentRepoStatus" ]; then
        echo -e "The folder in the path:${NO_CHANGES_COLOR}"$path"${END_COLOR} has no changes in the current branch: ${BRANCH_COLOR}"$currentBranch"${END_COLOR}"
    else
        echo -e "\nThe changes in the path: ${CHANGES_COLOR}"$path"${END_COLOR} in the branch ${BRANCH_COLOR}"$currentBranch"${END_COLOR} are\n"
        git -C "$pathToFolder" status
    echo "------------------------------------------------------------------------------------------------------------------------"
    echo "------------------------------------------------------------------------------------------------------------------------"
    fi
}

commitCode(){
    local pathToFolder=$1
    shift

    local messageArgument=("$@")
    gitCommitMessage="${messageArgument}"
    git -C "$pathToFolder" commit -S -m "$gitCommitMessage"
}

pushCode(){
    local pathToFolder=$1
    git -C "$pathToFolder" push 
}

changeYAMLRunningMode(){ #specific block of code I mean
    local pathToFolder=$1

            #          the $ ensures it is at end of the line.
    sed -i '' -e "/^on:$/s/$/\n  push:/" ${pathToFolder}/.github/workflows/delete-specific-packages.yml   # adds the 'push' under the 'on:'. So with this command we change the status to 'on: push', and can run in every git push in the repo
            #  the ^ ensures it is in the beginning of the line

    sed -i '' -e "/workflow_dispatch/,/default/s/^/#/" ${pathToFolder}/.github/workflows/delete-specific-packages.yml   # from the 'workflow_dispatch' -until(,)- 'default' word in the .yml -add(s)- in the -beginning(^)- the character #
}

changeSpecificLine(){
    local pathToFolder=$1 # I can take only the first one path, because from the loop I will retrieve each time, only 1 path. So I'm ok! 
    shift

    local arguments=("$@")
    lineToChange="${arguments[0]}"
    oldText="${arguments[1]}"
    newText="${arguments[2]}"

    sed -i '' -e "${lineToChange}s/${oldText}/${newText}/" ${pathToFolder}/.github/workflows/delete-specific-packages.yml  # with this line, I change specific oldText with specific newText
    # if I want to change the whole line with new line, I have to put the first word of that specific line, in order to keep the indentation, and the newText. The command will be:
    # sed -i '' -e "${lineToChange}s/${oldText}.*/${newText}/" ${directories[17]}/.github/workflows/delete-specific-packages.yml
    # where the ${oldText} should be THE FIRST word of the ${lineToChange}, otherwise it change from the inputed word, until the end of the specific line.
}

customCommandFunction(){  # change the name of the function. Is not very representative
    local pathToFolder=$1
    shift

    local arguments=("$@")
    command="${arguments[0]}"

    echo "The command is: $command"
    case "$command" in
    rm | touch | mkdir)
        for arg in "${arguments[@]:1}"; do  # this loop is working for 'rm' and 'mkdir' commands. It is in loop, because for one path I might have multiple argumnets. e.g. mkdir ../Desktop/dir1 ../Desktop/dir2 ../Desktop/dir3
            "$command" "$pathToFolder/$arg"
        done
        ;;
    
    cp | mv) 
        fromDir="${arguments[1]}"
        fileName=$(basename "$fromDir")
        
        packageName=$(. ./findPackageNameWithGraphQL.sh) #source the graphql.sh file, which find the packge name. SOS There must be only 'echo' and should be in last line, otherwise this solution doesn't work
        # other solution is to source the ./graphql.sh file, and declare an emtpy variable: name="", which will be updated from the graphql file. I chose the above approach as it is more declerative
        
        echo "The name of the package from gitReposEditor.sh is ${packageName}"
        
        "$command" "$fromDir" ${pathToFolder}

        sed -i '' -e "/packageName: /s/[^:]*$/ '$packageName'/" "${pathToFolder}/${fileName}"
        ;;
    
    *)
        echo "Unknown command"
        exit 1
        ;;
    
    esac
}

setSpecificPaths(){
    
    echo -e "You can provide which paths you want to apply changes, by separating them with comma (,).\n${WARNING_COLOR}If you leave it empty, the changes will be applied to all the project paths.${END_COLOR} "
    read -p "Enter paths or leave it empty to apply to all the project folders: " inputPaths

    IFS=',' read -ra customPaths <<< "$(echo "$inputPaths" | tr -d '[:space:]')"
    specifiedPaths=${customPaths[@]}

    echo -e "The specifiedPaths contains: ${specifiedPaths[@]}\n"
}

# "/Users/marinosnisiotis/Desktop/Camelot_Projects/ctp-gradle-artifact-publishing-plugin, /Users/marinosnisiotis/Desktop/Camelot_Projects/ctp-gradle-module-conventions-plugin"

if [[ $# -eq 0 ]]; then
    performAction "status" ""
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --setYAMLRunningMode)
            setSpecificPaths
            performAction "setYAMLRunningMode" "" "${specifiedPaths[@]}"
            ;;

        --commit)  # should add to take the commit message, and do that for all, or, for the specified projects
            read -p "Enter the commit message: " commitMessage
            setSpecificPaths
            performAction "commit" "$commitMessage" "${specifiedPaths[@]}" # it gives the commitMessage as the first parameter to performAction. If the paths, are not set, it will apply to all the matches of the pattern
            ;;
        
        --push)
            setSpecificPaths
            echo "Push the change to the remote branch/repo"
            performAction "push" "" "${specifiedPaths[@]}"
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

# echo "From the "$path1" the changes are:"
# echo
# git -C "$path1" status

# echo "From the "$path2" the changes are:"
# echo
# git -C "$path2" status

# git $path11 status  # another way to perform the above printing
# git $path22 status  # another way to perform the above printing

# echo "Enter the commit message"
# read message
# git add .
# git commit -m"${message}"
