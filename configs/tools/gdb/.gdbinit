python
import sys
import os
from glob import glob

venv = os.path.expanduser('~/tools/rizin/venv')
site_dir_pattern = os.path.join(venv, 'lib', 'python*/site-packages')
site_dirs = glob(site_dir_pattern)
sys.path.insert(0, site_dirs[0])
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


set context-ghidra always
set r2decompiler rizin
set context-sections regs disasm code ghidra stack backtrace expressions threads heap_tracker
set syntax-highlight-style lightbulb
