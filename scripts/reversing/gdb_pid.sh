#!/usr/bin/zsh

Process=$1
if [[ -z $Process ]]; then
	echo "No process name entered. Usage: $0 <Process name>"
else
	PID=$(ps aux | grep [.]\/$Process | head -n 1 | awk '{print $2}')
	echo $PID

	if [[ -z $PID ]]; then

		echo "No binary with name $Process found, make sure the binary $Process first and try again. Or change the binary name if you are not debugging $Process"
	else

		gdb -p $PID
	fi

fi
