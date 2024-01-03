@echo off
start /B cmd /c "ssh -o StrictHostKeyChecking=no -L 5901:localhost:5901 -N -f -i kali.pem kali@13.51.121.180"
start "" "C:\Program Files\RealVNC\VNC Viewer\vncviewer.exe"
"C:\Program Files\AutoHotkey\AutoHotKey.exe" "C:\Users\nfs\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\kali.ahk"
taskkill /F /IM cmd.exe
