[[mgr.prepend_keymap]]
on   = "<Right>"
run  = "plugin smart-enter"
desc = "Enter the child directory, or open the file"

[[mgr.prepend_keymap]]
on   = "b"
run  = "plugin jump-to-char"
desc = "Jump to char"

[[mgr.prepend_keymap]]
on  = "M"
run = "plugin mount"
desc = "Mount filesystem"

[[mgr.prepend_keymap]]
on   = "F"
run  = "plugin smart-filter"
desc = "Smart filter"

[[mgr.prepend_keymap]]
on   = [ "c", "m" ]
run  = "plugin chmod"
desc = "Chmod on selected files"

[[mgr.prepend_keymap]]
on   = "p"
run  = "plugin smart-paste"
desc = "Paste into the hovered directory or CWD"

[[mgr.prepend_keymap]]
on   = "<C-d>"
run  = "plugin diff"
desc = "Diff the selected with the hovered file"

[[mgr.prepend_keymap]]
on   = "t"
run  = "plugin smart-tab"
desc = "Create a tab and enter the hovered directory"

[[mgr.prepend_keymap]]
on   = "T"
run  = "plugin toggle-pane min-preview"
desc = "Show or hide the preview pane"

[[mgr.prepend_keymap]]
on   = "P"
run  = "plugin toggle-pane max-preview"
desc = "Maximize or restore the preview pane"

[[mgr.prepend_keymap]]
on  = "<C-Down>"
run = "plugin parent-arrow 1"
desc = "Scroll down in parent directory"

[[mgr.prepend_keymap]]
on  = "<C-Up>"
run = "plugin parent-arrow -1"
desc = "Scroll up in parent directory"


[[input.prepend_keymap]]
on   = "<Esc>"
run  = "close"
desc = "Cancel input"

[[mgr.prepend_keymap]]
on = "<C-q>"
run = "shell -- cat \"$@\" | xclip -selection clipboard"
desc = "Copy file content to clipboard"

[[mgr.prepend_keymap]]
on = "<C-w>"
run = "shell -- realpath \"$1\" | xclip -selection clipboard"
desc = "Copy path to clipboard"

[[mgr.prepend_keymap]]
on = "<C-x>"
run = "shell -- ripdrag \"$@\" -x 2>/dev/null & --confirm"
desc = "Open the file in a GUI menu"



[[mgr.prepend_keymap]]
on = "<S-Down>"
run = "seek 1"
desc = "Seek down 5 units in the preview"

[[mgr.prepend_keymap]]
on = "<S-Up>"
run = "seek -1"
desc = "Seek up 5 units in the preview"

[[mgr.prepend_keymap]]
on = "<S-PageDown>"
run = "seek 100%"
desc = "Seek down a page in the preview"

[[mgr.prepend_keymap]]
on = "<S-PageUp>"
run = "seek -100%"
desc = "Seek up a page in the preview"



