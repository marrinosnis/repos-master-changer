source ./tests/messages.sh

function oneTimeSetUp() {
    script="./gitReposEditor.sh"
}

function testTouchFilesToManyFolders() {

    currentContentOfTestsFolder=$(ls -a tests)
    assertNotContains "${currentContentOfTestsFolder}" "removeFile.txt"
    
    response=$( {
        echo "touch removeFile.txt"
        echo "tests/"
    } | $script --customCommand)
    
    responseWithoutColors=$(echo "$response" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')

    assertEquals "${responseWithoutColors}" "${mapExpectedMessages[8]}"

    checkFileInTestsFolder=$(ls -a tests)
    assertContains "${checkFileInTestsFolder}" "removeFile.txt"
}


function testMakeOneOrMoreDirectoriesToManyPaths() {                                 # this test is related with the next one
                                                                                     # as the current test case, creates folders
    contentOfFolderTestsWithoutNewFolders=$(ls tests)                                # under the 'tests/' folder, which checks that
                                                                                     # the 'mkdir' command as expected. The next test
    assertNotContains "${contentOfFolderTestsWithoutNewFolders}" "removeFileFolder1" # uses these two folders to create file inside them 
    assertNotContains "${contentOfFolderTestsWithoutNewFolders}" "removeFileFolder2" # and then removes it, in order to check that the 'rm'
                                                                                     # command works as expected
    response=$( {
        echo "mkdir removeFileFolder1 removeFileFolder2 removeFileFolder3"
        echo "tests"
    } | $script --customCommand)


    contentOfFolderTestsWithNewFolders=$(ls tests)
    assertContains "${contentOfFolderTestsWithNewFolders}" "removeFileFolder1"
    assertContains "${contentOfFolderTestsWithNewFolders}" "removeFileFolder2"

}

# --------- the below function cannot move 1 file to many paths ---------#
function testMoveFileToManyFolders() {

    contentOfTestsFolder=$(ls -a tests)
    assertContains "${contentOfTestsFolder}" "removeFile.txt"
    assertContains "${contentOfTestsFolder}" "removeFileFolder1"
    assertContains "${contentOfTestsFolder}" "removeFileFolder2"
    assertContains "${contentOfTestsFolder}" "removeFileFolder3"

    response=$({
        echo "mv tests/removeFile.txt"
        echo "tests/removeFileFolder1"
    } | $script --customCommand)

    responseWithoutColors=$(echo "$response" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')

    assertContains "${responseWithoutColors}" "The command is: mv"

    checkFileInFolder1=$(ls tests/removeFileFolder1)
    assertEquals "${checkFileInFolder1}" "removeFile.txt"

    checkFileInFolder2=$(ls tests/removeFileFolder2)
    assertNull "${checkFileInFolder2}"

    checkFileInFolder3=$(ls tests/removeFileFolder3)
    assertNull "${checkFileInFolder3}"

}

function testCopyFileToManyFolders() {
    contentOfFile="This is temp file for testing in the root of the project"
    contentOfRemoveFileFolder1=$(ls tests/removeFileFolder1)

    assertEquals "${contentOfRemoveFileFolder1}" "removeFile.txt"
    
    contentOfRemoveFile=$(cat tests/removeFileFolder1/removeFile.txt)
    assertNull "${contentOfRemoveFile}"

    echo "${contentOfFile}" > tests/removeFileFolder1/removeFile.txt

    checkFileContentInFolder1=$(cat tests/removeFileFolder1/removeFile.txt)
    assertEquals "${checkFileContentInFolder1}" "${contentOfFile}"

    response=$( {
        echo "cp tests/removeFileFolder1/removeFile.txt"
        echo "tests/removeFileFolder2, tests/removeFileFolder3"
    } | $script --customCommand)

    responseWithoutColors=$(echo "$response" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')

    assertEquals "${responseWithoutColors}" "${mapExpectedMessages[9]}"

    checkFileContentInFolder2=$(cat tests/removeFileFolder2/removeFile.txt)
    assertEquals "${checkFileContentInFolder2}" "${contentOfFile}"

    checkFileContentInFolder3=$(cat tests/removeFileFolder3/removeFile.txt)
    assertEquals "${checkFileContentInFolder3}" "${contentOfFile}"

}

function testRemoveOneOrMoreFilesFromManyPaths() {
    nameOfTheFile="removeFile.txt"                                                                  # the folders 'removeFileFolder1' &
    contentOfRemoveFileFolder1=$(ls tests/removeFileFolder1)                                        # 'removeFileFolder2' are created 
    contentOfRemoveFileFolder2=$(ls tests/removeFileFolder2)                                        # from the above test case, and inside
    contentOfRemoveFileFolder3=$(ls tests/removeFileFolder3)                                        # them the 'removeFile' is created to 
                                                                                                    # check that 'rm' command is work correctly.
    assertEquals "${contentOfRemoveFileFolder1}" "${nameOfTheFile}"                                 # That means, these 2 tests are related each
    assertEquals "${contentOfRemoveFileFolder2}" "${nameOfTheFile}"                                 # other.
    assertEquals "${contentOfRemoveFileFolder3}" "${nameOfTheFile}"

    response=$( {                                                                                 
        echo "rm removeFile.txt"                                                                      
        echo "tests/removeFileFolder1, tests/removeFileFolder2, tests/removeFileFolder3"                            
    } | $script --customCommand)                                                                  

    responseWithoutColors=$(echo "$response" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')

    assertEquals "${responseWithoutColors}" "${mapExpectedMessages[10]}"

    contentOfRemoveFileFolder1=$(ls tests/removeFileFolder1)
    contentOfRemoveFileFolder2=$(ls tests/removeFileFolder2)
    contentOfRemoveFileFolder3=$(ls tests/removeFileFolder3)

    # asssertNull represents that the folder has zero-length string, which means it is empty.
    assertNull "${contentOfRemoveFileFolder1}"
    assertNull "${contentOfRemoveFileFolder2}"
    assertNull "${contentOfRemoveFileFolder3}"

}

function oneTimeTearDown() {

    rm -rf tests/removeFileFolder1 tests/removeFileFolder2 tests/removeFileFolder3
}

shift $#

source shunit2