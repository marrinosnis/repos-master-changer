customGitStatus(){
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