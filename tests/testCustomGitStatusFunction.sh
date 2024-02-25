source ./tests/messages.sh

function oneTimeSetUp(){
    script="./gitReposEditor.sh"

    git stash save -m "perform a temp save"
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
    git stash pop
}

shift $#

source shunit2