source ./tests/messages.sh

function oneTimeSetUp(){
    script="./gitReposEditor.sh"

    statusResponse=$(git status)                                                       # Perfrom a 'git status' in order to check if there are any changes
                                                                                       # if NOT, there is no need for 'git stash' to save the possible changes. 
    if [[ ! "${statusResponse}" == *"nothing to commit, working tree clean"* ]]; then  # But if there are changes,a temp stash is essential to save the current
        git stash save -m "perform a temp save"                                        # changes, in order to run the tests, with the expected messages in the assertions. 
    fi                                                                                 # The current scenario, is supposed to run on CI/CD where no changes would be, as 
}                                                                                      # everything will be commited. Locally, instead, there might be differences, so in order to run
                                                                                       # the test locally successfully, a stash must be done.
function testCustomGitStatusFunctionUntrackedAndTrackedFile(){
    touch temp.txt
    
    listOfFiles=$(ls -a)
    assertContains "${listOfFiles}" "temp.txt"

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
                                                                                       # If there are no changes as in the beggining of the test, then it's crucial to ensure that NO stashes
    if [[ ! "${statusResponse}" == *"nothing to commit, working tree clean"* ]]; then  # are applied for two reasons: a) if a stash already exists, it should not be applied, preserving the current state
        git stash pop                                                                  # as it was in the latest commit, b) if there are no stashes, pop action would result in failure
    fi
}

shift $#

source /usr/bin/shunit2