# repos-master-changer
A powerful bash script which can add&commit, push, edit the context of specific files using the `sed` tool. That script was created for massive editing\
committing and pushing **the same changes** to many repos simultaneously.\
In that way I managed to avoid doing the same steps many times and reduce the possibility of errors.

The script was written in `3.2.57(1)-release (arm64-apple-darwin22)` bash version, but it will be updated in the future to use the\
`4.3.46(1)-release (x86_64-apple-darwin14.5.0)`. To make sure you have the correct version in your machine, open a terminal and execute\
the command, open a terminal and execute the command:`bash --version`. Most probably if you are using Linux or MacOS, it is already installed.

## Quick setup of the script
First clone the repo to your local machine. Open the `gitReposEditor.sh` with you favorite editor, and set the variable `rootFolder` with the folder\
which contains all the folders/projects you want to edit and apply the same changes.\
If there are some other folders in the same `rootFolder`, you can specify a search-pattern in order to look for the desired ones. To set the\
search-pattern, modify the variable `searchPattern` with the appropriate match pattern so the script can find all the folders. Follow up to this\
[wildcards-link](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm) to find the appropriate combinations of wildcards in order to cover all the matching patterns.\
*Once again, make sure that you have set up correctly the path to `rootFolder` variable where the script can find all the folders with the matching pattern.*


## Ways of execution the script
Now that everything is set up, there are several arguments that the script can be executed\

| **Arguments**        | **Command**                              | Description                                                                                                                                                                                                                                                                            |
|----------------------|------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| *none*               | ./gitReposEditor.sh                      | Shows the git status of all the folders the pattern has found                                                                                                                                                                                                                          |
| --setYAMLRunningMode | ./gitReposEditor.sh --setYAMLRunningMode | Change the running mode from `on:workflow_dispatch` to `on:push` to check the functionality of workflow.                                                                                                                                                                               |
| --commit             | ./gitReposEditor.sh --commit             | Prompt the user to first enter the commit message and then set the manually the paths of the projects where this command will be applied.<br> If no paths are given it will be applied to all the matching pattern folders.                                                            |
| --push               | ./gitReposEditor.sh --push               | Pushes the committed changes to all the previous specified repositories                                                                                                                                                                                                                |
| --specific           | ./gitReposEditor.sh --specific           | Prompt the user to enter the specific`line` where the change will take place, the `old text` which will be replaced from the `new text`.<br> Manually input the paths where this change will be applied. If no paths are given it will be applied to all the matching pattern folders. |
| --customCommand      | ./gitReposEditor.sh --customCommand      | Gives the ability to the user, to use a command that it not declared in the script, and can be applied to all the paths.                                                                                                                                                               |