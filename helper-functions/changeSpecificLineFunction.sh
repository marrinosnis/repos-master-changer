changeSpecificLine(){
    local pathToFolder=$1 
    shift

    local arguments=("$@")
    lineToChange="${arguments[0]}"
    oldText="${arguments[1]}"
    newText="${arguments[2]}"

    sed -i '' -e "${lineToChange}s/${oldText}/${newText}/" ${pathToFolder}${extendSpecifiedPaths}  # with this line, I change specific oldText with specific newText
    # if I want to change the whole line with new line, I have to put the first word of that specific line, in order to keep the indentation, and the newText. The command will be:
    # sed -i '' -e "${lineToChange}s/${oldText}.*/${newText}/" ${directories[17]}/.github/workflows/delete-specific-packages.yml
    # where the ${oldText} should be THE FIRST word of the ${lineToChange}, otherwise it change from the inputed word, until the end of the specific line.
}