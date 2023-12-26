@echo off
start /B cmd /c "ssh -L 5901:localhost:5901 -N -f -i  C:\Users\nfs\kali.pem kali@16.16.201.235"
start "" "C:\Program Files\RealVNC\VNC Viewer\vncviewer.exe"
"C:\Program Files\AutoHotkey\AutoHotKey.exe" "C:\Users\nfs\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\kali.ahk"
taskkill /F /IM cmd.exe
