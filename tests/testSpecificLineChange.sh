source ./tests/messages.sh


function oneTimeSetUp() {
    script="./gitReposEditor.sh"

    echo "${mapExpectedMessages[5]}" > tests/sample2.txt
    mkdir tests/temp
    echo "${mapExpectedMessages[5]}" > tests/temp/sample3.txt
}

function setUp() {
    echo "${mapExpectedMessages[5]}" > tests/sample.txt
}

function testChangeSpecificLine() {
    
    textFromSample=$(cat tests/sample.txt)                        #the last word 
    assertEquals "${textFromSample}" "${mapExpectedMessages[5]}"  #in the index 5
                                                                  #is company

    textFromSample2=$(cat tests/sample2.txt)
    assertEquals "${textFromSample2}" "${mapExpectedMessages[5]}"

    scriptSpecificLineChangeResponse=$( {
        echo 6                  # the line which contains the desired text
        echo "company"          # the word which will be replaced
        echo "industry"         # the word whicl will replace the above selection
        echo "tests/sample.txt, tests/sample2.txt" # the path to files which will be edited
    } | $script --specificLine)

    editedTextFromSample=$(cat tests/sample.txt)                       #the last word
    assertEquals "${editedTextFromSample}" "${mapExpectedMessages[6]}" #in index 6 
                                                                       #is industry
    editedTextFromSample2=$(cat tests/sample2.txt)
    assertEquals "${editedTextFromSample2}" "${mapExpectedMessages[6]}"
}

function testChangeSpecificLineInTwoFilesInDifferentPath() {
    textFromSample=$(cat tests/sample.txt)
    assertEquals "${textFromSample}" "${mapExpectedMessages[5]}"

    textFromSample3=$(cat tests/temp/sample3.txt)
    assertEquals "${textFromSample3}" "${mapExpectedMessages[5]}"

    scriptSpecificLineChangeResponse=$( {
        echo 5                # the line which contains the desired text
        echo "1886"           # the word which will be replaced
        echo "1998"           # the word which will replace the above selection 
        echo "tests/sample.txt, tests/temp/sample3.txt" # the path to files which will be edited.
    } | $script --specificLine)                         # The paths are different in this test

    editedTextFromSample=$(cat tests/sample.txt)
    assertEquals "${editedTextFromSample}" "${mapExpectedMessages[7]}"

    editedTextFromSample3=$(cat tests/temp/sample3.txt)
    assertEquals "${editedTextFromSample3}" "${mapExpectedMessages[7]}"
}

function oneTimeTearDown() {
    rm tests/sample.txt tests/sample2.txt
    rm -r tests/temp
}


shift $#

source shunit2