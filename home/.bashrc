if [ -f $HOME/.shell/.envs ]; 
then
	source $HOME/.shell/.envs
fi

if [ -f $HOME/.shell/.aliases ]; 
then
	source $HOME/.shell/.aliases
fi

if [ -f $HOME/.shell/.functions ]; 
then
	source $HOME/.shell/.functions
fi