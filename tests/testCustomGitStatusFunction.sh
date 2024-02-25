source ./tests/messages.sh

function oneTimeSetUp(){
    script="./gitReposEditor.sh"

    statusResponse=$(git status)

    if [[ "${statusResponse}" == *"nothing to commit, working tree clean"* ]]; then
        continue
    else
        git stash save -m "perform a temp save"
    fi
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

function oneTimeTearDown() {
    
    if [[ "${statusResponse}" == *"nothing to commit, working tree clean"* ]]; then
        continue
    else
        git stash pop
    fi
}

shift $#

source shunit2