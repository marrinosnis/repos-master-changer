commitCode(){
    local pathToFolder=$1
    shift

    local messageArgument=("$@")
    gitCommitMessage="${messageArgument}"
    git -C "$pathToFolder" commit -S -m "$gitCommitMessage"
}

gitFunction(){
    local pathToFolder=$1
    shift

    local arguments=("$@")
    IFS=' ' read -ra gitCommand <<< "$(echo "$arguments")"

    if [[ "${gitCommand[1]}" == "commit" ]]; then
        
        for i in "${!gitCommand[@]}"; do
            if [[ ${gitCommand[i]} == *"\""* ]]; then   #find the first occurance of the '"' and
                first_quote_index=$i                    #keep the index
                break
            fi
        done
    
        commitMessage="${gitCommand[@]:$first_quote_index}"  # store the commit message, from that index till the end of the string
        commitMessage=$(echo "$commitMessage" | tr -d '"')   # remove the double quotes ' " ' from the beginning and the end of the string, in order to save it in a correct form
        commitCode "$pathToFolder" "$commitMessage"          # call the commitCode function, to perform the commit action
    
    else
        gitCommandExecution="${gitCommand[0]} -C "${pathToFolder}" ${gitCommand[@]:1}"
        ${gitCommand[0]} -C ${pathToFolder} ${gitCommand[@]:1}
    fi
}