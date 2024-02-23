source ./tests/messages.sh

function oneTimeSetUp(){
    script="./gitReposEditor.sh"
}

function testGitAddCommand(){
    touch temp.txt
    untrackedNewFile=$(git status)
    assertContains "${untrackedNewFile}" "${mapExpectedMessages[0]}"

    response=$( {
        echo "git add ."
        echo "."
        } | $script --git)
                                                                                #I had to remove the colors from the response, that are declared in the 'setSpecificPathsFunction.sh' file, at line 3
    responseWithoutColors=$(echo "$response" | sed 's/\x1B\[[0-9;]*[JKmsu]//g') #because the function 'assertEquals' was failing due to that.
                                                                                #After removing the colors from the response the assertion was successful.
    assertEquals "${responseWithoutColors}" "${mapExpectedMessages[1]}"
   
    trackedFile=$(git status)
   
    assertContains "${trackedFile}" "${mapExpectedMessages[2]}"
    assertNotContains "${trackedFile}" "${mapExpectedMessages[0]}"

    git restore --staged temp.txt
    rm temp.txt
}


function testGitCommitCommand() {
    commitMessage="test commit message"
    touch temp.txt
    
    git add .
    gitStatus=$(git status)
    assertContains "${gitStatus}" "${mapExpectedMessages[2]}"
    assertContains "${gitStatus}" "new file:   temp.txt"

    gitCommitResponse=$( {
        echo "git commit -S -m \"${commitMessage}\" "
        echo "."
        } | $script --git)
    
    gitLogCommitMessage=$(git log --oneline -1)

    gitStatus=$(git status)

    assertEquals "${gitStatus}" "${mapExpectedMessages[4]}"

    assertContains "${gitLogCommitMessage}" "${commitMessage}"
    
    git reset --mixed HEAD~1
    rm temp.txt
}

function testCustomGitStatusFunction(){
    touch temp.txt
    
    responseUntracked="$($script)"
    responseUntrackedWithoutColors=$(echo "$responseUntracked" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')
    assertContains "${responseUntrackedWithoutColors}" "${mapExpectedMessages[0]}"

    git add .
    responseTracked="$($script)"
    responseTrackedWithoutColors=$(echo "$responseTracked" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')
    assertEquals "${responseTrackedWithoutColors}" "${mapExpectedMessages[3]}"

    git restore --staged temp.txt
    rm temp.txt
}

shift $#

source shunit2