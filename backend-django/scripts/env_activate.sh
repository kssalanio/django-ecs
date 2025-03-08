# Command to activate poetry env
source "$( poetry env list --full-path | grep Activated | cut -d' ' -f1 )/bin/activate"