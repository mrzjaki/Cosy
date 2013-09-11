if [ -f $HOME/.shell/.envs ]; 
then
	source $HOME/.shell/.envs
fi

if [ -f $HOME/.shell/.prompt ]; 
then
	source $HOME/.shell/.prompt
fi

if [ -f $HOME/.shell/.aliases ]; 
then
	source $HOME/.shell/.aliases
fi

if [ -f $HOME/.shell/.functions ]; 
then
	source $HOME/.shell/.functions
fi

if [ -f `brew --prefix`/etc/bash_completion ]; 
then
	source `brew --prefix`/etc/bash_completion
fi