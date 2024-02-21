changeYAMLRunningMode(){ #specific block of code I mean
    local pathToFolder=$1

            #          the $ ensures it is at end of the line.
    sed -i '' -e "/^on:$/s/$/\n  push:/" ${pathToFolder}   # adds the 'push' under the 'on:'. So with this command we change the status to 'on: push', and can run in every git push in the repo
            #  the ^ ensures it is in the beginning of the line

    sed -i '' -e "/workflow_dispatch/,/default/s/^/#/" ${pathToFolder}   # from the 'workflow_dispatch' -until(,)- 'default' word in the .yml -add(s)- in the -beginning(^)- the character #
}