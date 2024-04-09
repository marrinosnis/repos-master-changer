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
                                                                                  #the below line of code was added, because for a very strange reason, in github actions the script was executed twice
    if [ -n "$defaultStatusWithoutChanges" ] && [ -n "$currentRepoStatus" ]; then #with the first time NOT HAVING any details about the repo, branch or the remote and local status. That was causing the test
        if [ "$defaultStatusWithoutChanges" == "$currentRepoStatus" ]; then       #to fail, as the assertions were not correct. Adding this extra check, to avoid null or empty values, the test pass successfully.
            echo -e "The folder in the path:${NO_CHANGES_COLOR}"$pathToFolder"${END_COLOR} has no changes in the current branch: ${BRANCH_COLOR}"$currentBranch"${END_COLOR}"
        else
            echo -e "\nThe changes in the path: ${CHANGES_COLOR}"$pathToFolder"${END_COLOR} in the branch ${BRANCH_COLOR}"$currentBranch"${END_COLOR} are\n"
            git -C "$pathToFolder" status
        echo "------------------------------------------------------------------------------------------------------------------------"
        echo "------------------------------------------------------------------------------------------------------------------------"
        fi
    fi
}