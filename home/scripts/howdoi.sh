#/usr/bin/env bash

if [[ $# -eq 0 ]]
then
    echo "Usage: howdoi <question>"
    return 1
else
    # gh copilot explain "How do I $@ ?"
    gh copilot suggest -t shell "How do I $@ ?"
        
fi
