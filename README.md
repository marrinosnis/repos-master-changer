# repos-master-changer
A powerful bash script which can add-commit-push and edit the context of specific files using the `sed` tool. That script was created
for massive editing, committing and pushing **the same changes** to many repos simultaneously. In that way unexpected typos and possible
errors can be avoided. Also helps to reduce the times of doing the same steps.

The script was written in `3.2.57(1)-release (arm64-apple-darwin22)` bash version, but it will be updated in the future to use the
`4.3.46(1)-release (x86_64-apple-darwin14.5.0)`. To make sure that you have the correct version in your machine, open a terminal and execute
the command:`bash --version`. Most probably if you are using Linux or MacOS, it is already installed.

## Table of Contents
|    |                                                               |
|----|---------------------------------------------------------------|
| 1. | [Quick setup of the script](#quick-setup-of-the-script)       |
| 2. | [Ways of execution the script](#ways-of-execution-the-script) |
| 3. | [Specify paths](#specify-paths)                               |
| 4. | [Examples](#examples)                                         |
| 5. | [Supported commands](#supported-commands)                     |
| 6. | [Execute tests locally](#execute-tests-locally)               |

## Quick setup of the script
First clone the repo or download the code as zip file to your local machine. Open the `gitReposEditor.sh` with you favorite editor, and set the variable `rootFolder` with the folder
which contains all the folders/projects you want to edit and apply the same changes to them.
If there are some other folders in the same `rootFolder`, you can specify a <ins>search-pattern</ins> in order to look for the desired ones. To set the
search-pattern, modify the variable `searchPattern` with the appropriate match pattern so the script can find all the folders. Follow up to this 
[wildcards-link](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm) to find the appropriate combinations of wildcards in order to cover all the matching patterns.

> [!WARNING]
> *Once again, make sure that you have set up correctly the path to `rootFolder` variable where the script can find all the folders with the matching pattern.*

## Ways of execution the script
Now that everything is set up, there are several arguments that the script can be executed with, but first make sure the script has execution permission. If not,
enable it with the command `chmod +x gitReposEditor.sh`.

| **Arguments**        | **Command**                              | Description                                                                                                                                                                      |
|----------------------|------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| *none*               | ./gitReposEditor.sh                      | Shows a custom `git status` command of all the folders the pattern has found ([no arguments example](#no-arguments-example))                                                     |
| --setYAMLRunningMode | ./gitReposEditor.sh --setYAMLRunningMode | Change the running mode from `on:workflow_dispatch` to `on:push` ([YAML example](#yaml-example))                                                                                 |
| --git                | ./gitReposEditor.sh --git                | Allow user to perform any git command as if he was on terminal ([git command example](#git-command-example))                                                                     |                                                                                                                                                 
| --specific           | ./gitReposEditor.sh --specific           | Prompt the user to enter the specific`line` where the change will take place, the `old text` which will be replaced from the `new text`. ([specific example](#specific-example)) |
| --customCommand      | ./gitReposEditor.sh --customCommand      | Gives the ability to the user, to use a command that it not declared in the script ([custom-command example](#custom-command-example))                                           |

## Specify paths
After choosing an option, the user is asked to provide paths, where the previous selected option will be applied.\
e.g. The user has executed the script with the `--git` option
> ./gitReposEditor.sh --git

After the insertion of the git command, is asked to provide the paths where the changes will take place.
```commandline
You can provide which paths you want to apply changes, by separating them with comma (,).
If you leave it empty, the changes will be applied to all the project paths.
Enter paths or leave it empty to apply to all the project folders:
```
If none path provided, then the user is notified again that the selected action will be applied to all the root paths of the projects and
prompted to provide more specific path under the root path of the folder.
```commandline
You have not imported any specific path/s. The default path for each folder based on the search pattern, is the root folder.
Enter a more specific path inside the root folder. If you leave it empty, the changes will be applied to root folder of the project.
```
If it is also left empty then the selected option will be applied to the root path of all the path/folders that are found from the `searchPattern`
variable.

## Examples

### <ins>no arguments example</ins>
When no arguments are provided then it displays a custom status of each project. Of course, there is the option to
perform the `git status` command from the `--git` option (see below [git command example](#git-command-example))

### <ins>YAML example</ins>

### <ins>git command example</ins>
In order to perform any git action/command, execute the script with the `--git` option
```commandline
 ./gitReposEditor.sh --git
 Enter the git command:
```
At this point a git command is expected, as if it was written in a terminal e.g. `git commit -S -m "commit message"` or `git restore --staged .`.\
Then, the appropriate paths should be declared. Again, if none provided the git command will be applied to all the matching folders/paths.

### <ins>specific example</ins>
This option is for editing specific lines in files. The files **must** be the same, and have exactly the same lines and indentation. This is required as the `sed` tool
is very strict at this rule. For example lets say there are the 2 below files in the paths:
 
>Desktop/projects/<ins>alpha</ins>/.github/workflows/test.yaml
```yaml
1  name: GitHub action Test
2 
3  on:
4    push:
5 
6  permissions:
7   files: write
8
9  jobs:
10  create-test-job:
11    runs-on: ubuntu-latest
12    steps:
13     - name: Install pybind11
14        run: |
15          python3 -m pip install --upgrade pip
16          pip install pybind11
17          pip install pytest
18
19      - name: Checkout Code
20        uses: actions/checkout@v3
```

>Desktop/projects/<ins>beta</ins>/.github/workflows/test.yaml
```yaml
1  name: GitHub action Test
2 
3  on:
4    push:
5 
6  permissions:
7   files: write
8
9  jobs:
10  create-test-job:
11    runs-on: ubuntu-latest
12    steps:
13     - name: Set up Go
14       uses: actions/setup-go@v2
15       with:
16        go-version: 1.17
17          
18
19      - name: Checkout Code
20        uses: actions/checkout@v3
```
The 2 files have the same number of lines, but do different things. If I wanted to replace the name of the job at line `10` from `create-test-job` to `install-language-dependencies`
that can be done with the following steps:

```commandline
 ./gitReposEditor.sh --specific
 Insert the number of the line you want to edit
 10
 Insert the text you want to be replaced on this line
 create-test-job
 Insert the new/first text that will replace the old one
 install-language-dependencies
 You can provide which paths you want to apply changes, by separating them with comma (,).
 If you leave it empty, the changes will be applied to all the project paths.
 Enter paths or leave it empty to apply to all the project folders: Desktop/projects/alpha/.github/workflows/, Desktop/projects/beta/.github/workflows/
```
What the script will do is to find the files, and change the line `10`. The final result will be:

>Desktop/projects/alpha/.github/workflows/test.yaml
```commandline
9  jobs:
10  install-language-dependencies:  #this one was changed
11    runs-on: ubuntu-latest
12    steps:
13     - name: Install pybind11
14        run: |
15          python3 -m pip install --upgrade pip
16          pip install pybind11
17          pip install pytest
```

>Desktop/projects/beta/.github/workflows/test.yaml
```commandline
9  jobs:
10  install-language-dependencies:  #this one was changed
11    runs-on: ubuntu-latest
12    steps:
13     - name: Set up Go
14       uses: actions/setup-go@v2
15       with:
16        go-version: 1.17
```
> [!WARNING]
> 1) The change happened on the same line for the same element. If at line 10 of the `test.yaml` file that is in the `/beta/` path didn't have this text, the 
> replacement would have failed. So, that means the exactly same text has to be at the same line in order the replacement to be successful.
> 2) If the line doesn't exist at all, also the replacement would fail. For example if the change was about to happen in the 21st line of the files, that wouldn't be applicable
> as the 21st line doesn't exist.


### <ins>custom-command example</ins>

This option is used in order to cover as many as possible commands that are useful for managing files in multiple folders. For example, you may need to remove or create files
in many paths/folders, or you may need to copy the same file in many other folders. This option was created in order to facilitate these actions.

In order to use this command, run the script with the `customCommand` option: `./gitReposEditor --customCommand`. After that you type the command you want to perform as if it was
in the terminal, and then specify the path/s where this command should be applied.

>Create new file example.
```commandline
 ./gitReposEditor.sh --customCommand
 Enter the custom command that you want to apply: touch tempFile1
 You can provide which paths you want to apply changes, by separating them with comma (,).
 If you leave it empty, the changes will be applied to all the project paths.
 Enter paths or leave it empty to apply to all the project folders: /Users/marinosnisiotis/Desktop, /Users/marinosnisiotis/Desktop/testFolder
```
In the previous example, a new file `tempFile1` is created at the Desktop path/folder and at the test path/folder.
With the same approach other commands can be executed.

>Copy file from one path/folder to other/s
```commandline
 ./gitReposEditor.sh --customCommand
 Enter the custom command that you want to apply: cp /Users/marinosnisiotis/Desktop/tempFile1
 You can provide which paths you want to apply changes, by separating them with comma (,).
 If you leave it empty, the changes will be applied to all the project paths.
 Enter paths or leave it empty to apply to all the project folders: /Users/marinosnisiotis/Desktop/test1, /Users/marinosnisiotis/Desktop/test2, /Users/marinosnisiotis/Desktop/test3
```
In this example, the file `tempFile1` was copied to three other paths/folders. First was declared the copy command `cp` and then the paths where this command should be
applied.

## Supported commands

Currently, the supported commands that the script can handle are:

| **Command** | **Arguments**                   | **Purpose**                                       |
|-------------|---------------------------------|---------------------------------------------------|
| `cp`        | accepts one argument            | copies one file to many folders                   |
| `mv`        | accepts one argument            | moves one files to many folders                   |
| `rm`        | accepts one or more arguments   | remove one or more files from one or more folders |
| `touch`     | accepts one or more arguments   | creates one or more files to one or more folders  |
| `mkdir`     | accepts one or more arguments   | can create one or more folders to many paths      | 


## Execute tests locally

> [!WARNING]  
> In some files, the test scenarios are dependent on each other, and some test cases perform changes to the local repository
> e.g. create files, or change the current `git status` of the project. For this reason, the tests are implemented to create the files
> or change the status of the repository, but in the end are reverting these changes, in order to let the project in the state were it was
> before the tests ran. That's why when editing or creating new tests scenarios keep in mind to preserve the proper state of the project.

> [!IMPORTANT]  
> Some of the tests are checking that the `git status` command is returning the expected outcome. That means the appropriate messages have
> been created for a specific state of the project, e.g. the tests in the file `testCustomGitStatusFunction.sh` check the status of the
> project with the `custom created git status` command. If there are changes that are **<ins>uncommitted</ins>**, then the test saves the changes,
> run the test case scenarios, and in the end applies again the saved changes. If there **<ins>committed</ins>** changes that are not **<ins>pushed</ins>**
> on the remote branch, then the test scenarios will fail, as the assertions with the messages will not be the same because messages differ between git stages.\
> Also, the file `testGitCommandsFunction.sh` performs some git commands were the state of the project **<ins>must not contain committed & unpushed</ins>** changes.\
> To sum up, the previous 2 test files: `testCustomGitStatusFunction.sh` & `testGitCommandsFunction.sh` when there will be executed locally,
> the state of the repository must not have committed and unpushed changes. On `github actions`, this issue is not appearing as there are no committed and unpushed changes,
> and everything is already on remote branch-server.


The current project contains tests that have written with the `shunit2` tool. Every function that is in the `helper functions` folder, has test case, that 
can be found in the `tests` folder. If you want to run the tests locally make sure that you have the `shunit2` tool installed. To check if it is installed,
run:
```commandline
$ cat $(which shunit2) | grep "SHUNIT_VERSION"
```
If it is <ins>installed</ins> you will get the following message:
> command [ -n "${SHUNIT_VERSION:-}" ] && exit 0\
 SHUNIT_VERSION='2.1.8'

If it is <ins>not installed</ins> you will get the following message:
> shunit2 not found

In order to install it on Linux or MacOS software environment, you may use the following command in a new terminal window:\
`Linux`
```
$ sudo apt-get update
$ sudo apt-get -y install shunit2
```

`MacOS`
```
$ brew install shunit2
```

> [!IMPORTANT]  
> The tool `brew` is assumed that it is already installed in MacOS machine.

After the installation of the `shunit2` to run the tests you need to be at the `root` folder of the current project:
> /home/<ins>*username*</ins>/repos-master-changer

From this working directory, if you perform `ls` you should see the `tests` folder. In order to run the test files execute the following
line of code:
>./tests/*name_of_test_script_file.sh*

With the `name_of_test_script_file.sh` it is referred to any file from the `tests` folder that starts with *test* prefix:\
testCustomCommandsFunction.sh\
testGitCommandsFunction.sh\
testChangeSpecificLineFunction.sh\
testCustomGitStatusFunction.sh\

example:
> ./tests/testChangeSpecificLineFunction.sh

*possible outcome in Linux*
```commandline
1  testChangeSpecificLine
2  sed: can't read : No such file or directory
3  sed: can't read : No such file or directory
4  testChangeSpecificLineInTwoFilesInDifferentPath
5  sed: can't read : No such file or directory
6  sed: can't read : No such file or directory
7
8  Ran 2 tests.
9
10 OK
```
The lines `1` & `4` are indicating the 2 test scenarios that have run from the file.

> [!NOTE]
> The lines: 2,3 & 5,6 can be **ignored** as they are result from the actions inside the test scenarios, with the `sed` tool. If it shows 
> the word `OK` as it is at line `10`, then that means that everything was successful.\
> If the tests were failed then the respective message would be `FAILED (failures=2)`
sm