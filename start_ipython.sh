#!/bin/bash

if [ -z "$1" ]
then
	env=py35
else
	env=$1
fi

cd /c/Users/<User>/Anaconda3/envs/$env/Scripts

winpty ./ipython3.exe --InteractiveShell.colors=linux --TerminalInteractiveShell.highlighting_style=friendly
