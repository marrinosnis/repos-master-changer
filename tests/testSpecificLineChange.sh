source ./tests/messages.sh


function oneTimeSetUp() {
    script="./gitReposEditor.sh"

    echo "${mapExpectedMessages[5]}" > tests/sample.txt
    echo "${mapExpectedMessages[5]}" > tests/sample2.txt
}

function testChangeSpecificLine() {
    
    textFromFile=$(cat tests/sample.txt)                        #the last word 
    assertEquals "${textFromFile}" "${mapExpectedMessages[5]}"  #in the index 5
                                                                #is company
    scriptSpecificLineChangeResponse=$( {
        echo 6                  # the line which will contains the desired text
        echo "company"          # the word which will be replaced
        echo "industry"         # the word whicl will replace the above one
        echo "tests/sample.txt, tests/sample2.txt" # the path to the file which will be edited
    } | $script --specificLine)

    newTextFromFile=$(cat tests/sample.txt)                       #the last word
    assertEquals "${newTextFromFile}" "${mapExpectedMessages[6]}" #in index 6 
                                                                  #is industry
}

function oneTimeTearDown() {
    rm tests/sample.txt tests/sample2.txt
}

shift $#

source shunit2