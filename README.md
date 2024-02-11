# repos-master-changer
A powerful bash script which can add&commit, push, edit the context of specific files using the `sed` tool. That script was created
for massive editing committing and pushing **the same changes** to many repos simultaneously. In that way unexpected typos and possible
errors were avoided. Also reduce the times of doing the same steps.

The script was written in `3.2.57(1)-release (arm64-apple-darwin22)` bash version, but it will be updated in the future to use the
`4.3.46(1)-release (x86_64-apple-darwin14.5.0)`. To make sure you have the correct version in your machine, open a terminal and execute
the command:`bash --version`. Most probably if you are using Linux or MacOS, it is already installed.

## Quick setup of the script
First clone the repo to your local machine. Open the `gitReposEditor.sh` with you favorite editor, and set the variable `rootFolder` with the folder
which contains all the folders/projects you want to edit and apply the same changes.
If there are some other folders in the same `rootFolder`, you can specify a search-pattern in order to look for the desired ones. To set the
search-pattern, modify the variable `searchPattern` with the appropriate match pattern so the script can find all the folders. Follow up to this 
[wildcards-link](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm) to find the appropriate combinations of wildcards in order to cover all the matching patterns.

> [!WARNING]
> *Once again, make sure that you have set up correctly the path to `rootFolder` variable where the script can find all the folders with the matching pattern.*

## Ways of execution the script
Now that everything is set up, there are several arguments that the script can be executed with, but first make sure the script has execution permission. If not
enable it with the command `chmod +x gitReposEditor.sh`.

| **Arguments**        | **Command**                              | Description                                                                                                                                                                                                                                                                                                                      |
|----------------------|------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| *none*               | ./gitReposEditor.sh                      | Shows the git status of all the folders the pattern has found                                                                                                                                                                                                                                                                    |
| --setYAMLRunningMode | ./gitReposEditor.sh --setYAMLRunningMode | Change the running mode from `on:workflow_dispatch` to `on:push` to check the functionality of workflow.   ( [YAML example](#yaml-example) )                                                                                                                                                                                     |
| --specific           | ./gitReposEditor.sh --specific           | Prompt the user to enter the specific`line` where the change will take place, the `old text` which will be replaced from the `new text`.<br> Manually input the paths where this change will be applied. If no paths are given it will be applied to all the matching pattern folders. ( [Specific example](#specific-example) ) |
| --customCommand      | ./gitReposEditor.sh --customCommand      | Gives the ability to the user, to use a command that it not declared in the script, and can be applied to all the paths. ( [Custom-command example](#custom-command-example) )                                                                                                                                                   |

## Examples

### YAML example

### Commit example
 First execute the script with the `--commit` parameter: `./gitReposEditor.sh --commit`. After that it will ask to input the desired commit message you want.
 After entering the commit message, it will ask to provide the folders/paths you want to commit the changes to your local repo/s. If it is left empty it will be applied to all
 the matching folders/paths based on the value of the `searchPattern` variable.
 Press one more time Enter, and you should see the changes to be committed.

```commandline
 ./gitReposEditor.sh --commit
 Enter the commit message: This is a test commit message
 
 You can provide which paths you want to apply changes, by separating them with comma (,).
 If you leave it empty, the changes will be applied to all the project paths.
 Enter paths or leave it empty to apply to all the project folders: /Users/marinosnisiotis/Desktop/check, /Users/marinosnisiotis/Desktop/test, /Users/marinosnisiotis/Desktop/temp1 
```


### Push example
 After you have committed the changes to the desired folders/paths, you might want to push those changes to the remote branch on GitHub. The process is
 the same. Again, execute the script, but this time with the `--push` parameter: `./gitReposEditor.sh --push`. You have to declare again the folders/paths
 where you want to push the changes. If it is left empty it will be applied to all the matching folders/paths based on the value of the `searchPattern` variable.

```commandline
 ./gitReposEditor.sh --push
 You can provide which paths you want to apply changes, by separating them with comma (,).
 If you leave it empty, the changes will be applied to all the project paths.
 Enter paths or leave it empty to apply to all the project folders: /Users/marinosnisiotis/Desktop/check, /Users/marinosnisiotis/Desktop/test, /Users/marinosnisiotis/Desktop/temp1
```
 As you may notice in this example, I want to push the committed changes from all the previous declared folders/paths. If I wanted **not** to push a repo
 I simply wouldn't declare it in the `push` paths.

### Specific example
 This option is for editing specific lines in files. The files **must** be the same, and have exactly the same lines and indentation. This is required as the `sed` tool
 is very strict to this. For example lets say there are the 2 below files in the paths:
 
>Desktop/projects/alpha/.github/workflows/test.yaml
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

>Desktop/projects/beta/.github/workflows/test.yaml
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
> replacement would have failed. So, that means the exactly same text has to be at the same line in order the replacement 
> 2) If the line doesn't exist at all, also the replacement would fail. For example if the change was about to happen in the 21st line of the files, that wouldn't be applicable
> as the 21st line doesn't exist.


### Custom-command example

This option is used in order to cover as many as possible commands that are useful for managing files in multiple folders. For example, you may need to remove or create files
in many paths/folders, or you may need to copy the same file in many other folders. This option was created in order to facilitate these actions.

In order to use this command, run the script with the `customCommand` option: `./gitReposEditor --customCommand`. After that you type the command you want to perform as it was
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
In the previous example, the file `tempFile1` was copied to three other paths/folders. First was declared the copy command `cp` and then the paths where this command should be
applied.

### Supported commands

Currently the supported commands that the script can handle are:

| **Command** | **Arguments**                   | **Purpose**                                       |
|-------------|---------------------------------|---------------------------------------------------|
| `cp`        | accepts one argument            | copies one file to many folders                   |
| `mv`        | accepts one argument            | moves one files to many folders                   |
| `rm`        | accepts one or more arguments   | remove one or more files from one or more folders |
| `touch`     | accepts one or more arguments   | creates one or more files to one or more folders  |
| `mkdir`     | accepts one or more arguments   | can create one or more folders to many paths      | 
