customCommandFunction(){  # change the name of the function. Is not very representative
    local pathToFolder=$1
    shift

    local arguments=("$@")
    command="${arguments[0]}"

    echo "The command is: $command"
    case "$command" in
    rm | touch | mkdir)
        for arg in "${arguments[@]:1}"; do  # this loop is working for 'rm' and 'mkdir' commands. It is in loop, because for one path I might have multiple argumnets. e.g. mkdir ../Desktop/dir1 ../Desktop/dir2 ../Desktop/dir3
            "$command" "$pathToFolder/$arg"
        done
        ;;
    
    cp | mv) 
        fromDir="${arguments[1]}"
        fileName=$(basename "$fromDir")
        
        "$command" "$fromDir" ${pathToFolder}

        packageName=$(curl -L "${githubUrl}" | bash -s "${pathToFolder}" "${owner}" "${inputToken}") #use the repo directly from the Github.
        echo "The name of the package from gitReposEditor.sh is ${packageName}"
        sed -i '' -e "/packageName: /s/[^:]*$/ '$packageName'/" "${pathToFolder}/${fileName}"
        ;;
    
    *)
        echo "Unknown command"
        exit 1
        ;;
    
    esac
}