python
import sys
sys.path.insert(0, '~/tools/gdb/rizin/venv/lib/python3.13/site-packages')
import rzpipe
end

define init-peda
source ~/tools/gdb/peda/peda.py
end
document init-peda
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework
end

define init-peda-arm
source ~/tools/gdb/peda-arm/peda-arm.py
end
document init-peda-arm
Initializes the PEDA framework for ARM
end

define init-peda-intel
source ~/tools/gdb/peda-arm/peda-intel.py
end
document init-peda-intel
Initializes the PEDA framework for Intel
end

define init-pwndbg
source ~/tools/gdb/pwndbg/gdbinit.py
end
document init-pwndbg
Initializes pwndbg
end

define init-gef
source ~/tools/gdb/gef/gef.py
end
document init-gef
Initializes GEF (GDB Enhanced Features)
end


init-peda
