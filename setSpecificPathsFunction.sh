setSpecificPaths(){
    
    echo -e "You can provide which paths you want to apply changes, by separating them with comma (,).\n${WARNING_COLOR}If you leave it empty, the changes will be applied to all the project paths.${END_COLOR} "
    read -p "Enter paths or leave it empty to apply to all the project folders: " inputPaths

    IFS=',' read -ra customPaths <<< "$(echo "$inputPaths" | tr -d '[:space:]')"
    specifiedPaths=${customPaths[@]}

    if [[ -z "$inputPaths" ]]; then
        echo -e "You have not imported any specific path/s. The default path for each folder based on the search pattern, is the root folder."
        read -p "Enter a more specific path inside the root folder. If you leave it empty, the changes will be applied to root folder of the project." specificPathAfterRoot
    fi

    extendSpecifiedPaths=${specificPathAfterRoot}
    echo -e "The specifiedPaths contains: ${specifiedPaths[@]}\n"
    echo -e "The specific paths under the root folder is: ${extendSpecifiedPaths}\n"
}