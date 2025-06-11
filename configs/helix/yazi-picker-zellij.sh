#!/usr/bin/env bash

paths=$(yazi "$1" --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)

if [[ -n "$paths" ]]; then
	zellij action toggle-floating-panes
	zellij action write 27
	zellij action write-chars ":$1 $paths"
	zellij action write 13
else
	zellij action toggle-floating-panes
fi



# #!/usr/bin/env bash

# zellij action move-pane right

# while true; do
#     paths=$(yazi --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)

#     if [[ -n "$paths" ]]; then
#         zellij action focus-next-pane
#         zellij action write 27 # send <Escape> key
#         zellij action write-chars ":open $paths"
#         zellij action write 13 # send <Enter> key
#         zellij action focus-previous-pane
#     fi
# done
