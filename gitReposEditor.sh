#!/bin/bash

NO_CHANGES_COLOR="\033[4;36m"  # 35m is the Cyan color
CHANGES_COLOR="\033[4;91m"     # 91m is the Light Red
BRANCH_COLOR="\033[4;33m"      # 33m is the Yellow color
WARNING_COLOR="\033[31m"       # 31m is the Red color 
END_COLOR="\033[0m"            #  0m is to revert back to default color
basicCtpPath="Desktop/Camelot_Projects"
printOnce=false
specifiedPaths=""

# directories=$(find "$basicCtpPath" -maxdepth 1 -type d -name 'ctp-*' | wc -l)  # this command prints only the number of the folders, not the names
ctpDirectories=$(find "$basicCtpPath" -maxdepth 1 -type d -name 'ctp-*'  -exec sh -c 'cd "{}" && pwd' \;)

performAction() {
    local arguments=$1
    if [[ "$arguments" == *','* ]]; then
        IFS=',' read -ra argsArray <<< "$(echo "$arguments" | tr -d '[:space:]')" #create here the array for the arguments.
    else
        argsArray=("$arguments")
    fi
    shift

    local customInputPaths="${@:-$ctpDirectories}"
    paths=($customInputPaths)       #make it array, so I can access each element individual
    # changeSpecificLine "${paths[17]}" "${argsArray[@]}"
    for path in "${paths[@]}"; do
       changeSpecificLine "$path" "${argsArray[@]}"
    done
}

status(){
    local path=$1
    if [ "$printOnce" = false ]; then
        echo    "--------------------------------------------------------|"
        echo    "Checking if there are any changes in the repo/s         |"
        echo -e "--------------------------------------------------------|\n"
        printOnce=true
    fi

    defaultStatusWithoutChanges=$(git -C "$path" status -sb | head -n 1)
    currentRepoStatus=$(git -C "${path}" status --branch --porcelain)
    currentBranch=$(git -C "$path" rev-parse --abbrev-ref HEAD)

    if [ "$defaultStatusWithoutChanges" == "$currentRepoStatus" ]; then
        echo -e "The folder in the path:${NO_CHANGES_COLOR}"$path"${END_COLOR} has no changes in the current branch: ${BRANCH_COLOR}"$currentBranch"${END_COLOR}"
    else
        echo -e "\nThe changes in the path: ${CHANGES_COLOR}"$path"${END_COLOR} in the branch ${BRANCH_COLOR}"$currentBranch"${END_COLOR} are\n"
        git -C "$path" status
    echo "------------------------------------------------------------------------------------------------------------------------"
    echo "------------------------------------------------------------------------------------------------------------------------"
    fi
}

replaceCode(){ #specific block of code I mean
    echo -e "this is the replaceCode function"
}

commitCode(){
    local pathToApplyTheCommit=$1
    shift

    local messageArgument=("$@")
    gitCommitMessage="${messageArgument}"
    echo -e "the commit message is: $gitCommitMessage and it will be applies at the $pathToApplyTheCommit    path"
}

changeSpecificLine(){
    local pathDestination=$1 # I can take only the first one path, because from the loop I will retrieve each time only 1 path. So I'm ok! 
    shift

    local arguments=("$@")
    lineToChange="${arguments[0]}"
    oldText="${arguments[1]}"
    newText="${arguments[2]}"
    
    # directories=($ctpDirectories)  # make the 'ctpDirectories' to 'directories' array type
    # echo "the value of the ctpDirectories is ${directories[17]}"  # the ctpDirectories in this print has all the paths with the folders. If I do ctpDirectories[1]/.github/workflows/delete-specific-packages.yml

    sed -i '' -e "${lineToChange}s/${oldText}/${newText}/" ${pathDestination}/.github/workflows/delete-specific-packages.yml  # with this line, I change specific oldText with specific newText

    # if I want to change the whole line with new line, I have to put the first word of that specific line, in order to keep the indentation, and the newText. The command will be:
    # sed -i '' -e "${lineToChange}s/${oldText}.*/${newText}/" ${directories[17]}/.github/workflows/delete-specific-packages.yml
    # where the ${oldText} should be THE FIRST word of the ${lineToChange}, otherwise it change from the inputed word, until the end of the specific line.
}

# customFunc(){
#     local paths=("$@")

#     if [[ "${paths[@]}" -eq 0 ]]; then  
#         echo -e "${WARNING_COLOR}Empty paths variable given. Please try again${END_COLOR}"
#     else
#         for path in "${paths[@]}"; do
#             echo "the path is: $path"
#         done
#     fi
# }

setSpecificPaths(){
    
    echo -e "You can provide which paths you want to apply changes, by separating them with comma (,).\n${WARNING_COLOR}If you leave it empty, the changes will be applied to all the project paths.${END_COLOR} "
    read -p "Enter paths or leave it empty to apply to all the project folders: " inputPaths

    IFS=',' read -ra customPaths <<< "$(echo "$inputPaths" | tr -d '[:space:]')"
    specifiedPaths=${customPaths[@]}

    echo -e "The specifiedPaths contains: ${specifiedPaths[@]}\n"
}

if [[ $# -eq 0 ]]; then
    performAction "" # "/Users/marinosnisiotis/Desktop/Camelot_Projects/ctp-gradle-rpm-plugin /Users/marinosnisiotis/Desktop/Camelot_Projects/ctp-gradle-artifact-publishing-plugin"
fi
#                the $ ensures it is at end of the line.
# sed -i '' -e '/^on:$/s/$/\n  push:/' delete-specific-packages.yml   # adds the 'push' under the 'on:'. So with this command we change the status to 'on: push', and can run in every git push in the repo
#            the ^ ensures it is in the beginning of the line

# sed -i '' -e '/workflow_dispatch/,/default/s/^/#/' delete-specific-packages.yml   # from the 'workflow_dispatch' -until(,)- 'default' word in the .yml -add(s)- in the -beginning(^)- the character #


while [[ $# -gt 0 ]]; do
    case "$1" in
        --replace)
            replaceCode
            ;;

        --commit)  # should add to take the commit message, and do that for all, or, for the specified projects
            read -p "Enter the commit message:" commitMessage
            setSpecificPaths
            performAction "$commitMessage" "${specifiedPaths[@]}" # it gives the commitMessage as the first parameter to performAction. If the paths, are not set, it will apply to all the matches of the pattern
            ;;
        
        --specific)
            echo -e "Insert the number of the line you want to edit(14)"
            read line
            echo -e "Insert the text you want to be replaced on this line"
            read oldText
            echo -e "Insert the new/first word of this line you want to change"
            read newText
            specificReplaceDetails="$line, $oldText, $newText"
            setSpecificPaths
            performAction "$specificReplaceDetails" "${specifiedPaths[@]}"
            ;;

        --custom)
            setSpecificPaths
            performAction "" "${specifiedPaths[@]}"
            ;;
        
        --push)
            echo "Push the change to the remote branch/repo"
            ;;
        *)
            echo -e "${WARNING_COLOR}Not correct input flag. Try again\n${END_COLOR}"
            exit 1
            ;;
    esac
    shift
done




# the below probably will be uncommented

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
