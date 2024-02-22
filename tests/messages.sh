
#----IMPORTANT--- THE IDENTATION TO THIS FILE SHOULD NOT CHANGE, OTHERWISE THE TESTS ASSERTION WILL FAIL ------#
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


The changes in the path: /Users/marinosnisiotis/repos-master-changer in the branch create-helper-functions are

On branch create-helper-functions
Your branch is up to date with 'origin/create-helper-functions'.

Changes to be committed:
  (use \"git restore --staged <file>...\" to unstage)
	new file:   temp.txt

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------"

    # 4 index: Git message for nothing to commit, working tree clean ready for push
    "On branch create-helper-functions
Your branch is ahead of 'origin/create-helper-functions' by 1 commits.
  (use \"git push\" to publish your local commits)

nothing to commit, working tree clean"
)