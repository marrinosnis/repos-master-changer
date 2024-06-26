#----IMPORTANT--- THE IDENTATION TO THIS FILE SHOULD NOT CHANGE, OTHERWISE THE TESTS ASSERTION WILL FAIL ------#
currentPath=$(pwd)
currentBranch=$(git rev-parse --abbrev-ref HEAD)
currentRemoteBranch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
mapExpectedMessages=(
    # 0 index: Git message for untracked file temp.txt
    "Untracked files:
  (use \"git add <file>...\" to include in what will be committed)
        temp.txt"
    
    # 1 index: Script message for provide paths
    "You can provide which paths you want to apply changes, by separating them with comma (,).
If you leave it empty, the changes will be applied to all the project paths. 
The specifiedPaths contains: .

The specific paths under the root folder is: "

    # 2 index: Git message for files to be committed.
    "Changes to be committed:
  (use \"git restore --staged <file>...\" to unstage)"

    # 3 index: Script check custom git status command result  with changes
"--------------------------------------------------------|
Checking if there are any changes in the repo/s         |
--------------------------------------------------------|


The changes in the path: "${currentPath}" in the branch "${currentBranch}" are

On branch "${currentBranch}"
Your branch is up to date with '"${currentRemoteBranch}"'.

Changes to be committed:
  (use \"git restore --staged <file>...\" to unstage)
	new file:   temp.txt

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------"

    # 4 index: Git message for nothing to commit, working tree clean ready for push
    "On branch "${currentBranch}"
Your branch is ahead of '"${currentRemoteBranch}"' by 1 commit.
  (use \"git push\" to publish your local commits)

nothing to commit, working tree clean"

    # 5 index: Create .txt file with this content
"This is a sample text file.
It contains a text about cars.
The first car was created in

1886 and his creator was the Carl Benz.
The today's famous Mercedes Benz company."

    # 6 index: Same context as above with changed the last word from company -> industry
"This is a sample text file.
It contains a text about cars.
The first car was created in

1886 and his creator was the Carl Benz.
The today's famous Mercedes Benz industry."

    # 7 index: Same context as the index 5, with changed the date from 1886 -> 1998
"This is a sample text file.
It contains a text about cars.
The first car was created in

1998 and his creator was the Carl Benz.
The today's famous Mercedes Benz company."

   # 8 index: Script message with the --customCommand option and 'touch' command
   "You can provide which paths you want to apply changes, by separating them with comma (,).
If you leave it empty, the changes will be applied to all the project paths. 
The specifiedPaths contains: tests/

The specific paths under the root folder is: 

The command is: touch"

  # 9 index: Script message with the --customCommand option and 'copy' command
  "You can provide which paths you want to apply changes, by separating them with comma (,).
If you leave it empty, the changes will be applied to all the project paths. 
The specifiedPaths contains: tests/removeFileFolder2 tests/removeFileFolder3

The specific paths under the root folder is: 

The command is: cp
The name of the package from gitReposEditor.sh is 
The command is: cp
The name of the package from gitReposEditor.sh is "

  # 10 index: Script message with the --customCommand option and 'rm' command
  "You can provide which paths you want to apply changes, by separating them with comma (,).
If you leave it empty, the changes will be applied to all the project paths. 
The specifiedPaths contains: tests/removeFileFolder1 tests/removeFileFolder2 tests/removeFileFolder3

The specific paths under the root folder is: 

The command is: rm
The command is: rm
The command is: rm"
)