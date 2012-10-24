#!/bin/bash

mkdir "$HOME/src"
mkdir "$HOME/lib"
mkdir "$HOME/bin"
mkdir "$HOME/usr"
mkdir "$HOME/www"
mkdir "$HOME/tmp"
mkdir "$HOME/www/hosts"
mkdir "$HOME/www/sites"

olddotfiles="$HOME/tmp/old-dotfiles"

# Create directory to store old dotfiles
if [ ! -d $olddotfiles ]
then
	mkdir $olddotfiles
fi

# Array of dotfiles to symlink
dotfiles[0]=".aliases"
dotfiles[1]=".bash_profile"
dotfiles[2]=".bash_prompt"
dotfiles[3]=".bashrc"
dotfiles[4]=".exports"
dotfiles[5]=".functions"
dotfiles[6]=".gitattributes"
dotfiles[7]=".gitconfig"
dotfiles[8]=".gitignore"
dotfiles[9]=".hushlogin"
dotfiles[10]=".inputrc"
dotfiles[11]=".screenrc"
dotfiles[12]=".vimrc"
dotfiles[13]=".wgetrc"
dotfiles[14]=".vim"

# Iterate over dotfiles array
for dotfile in ${dotfiles[*]}
do
	thispath="$HOME/${dotfile}"
	
	# If the dotfile already exists, move it to the old-dotfiles dir
	# then symlink the dotfile to the one in the dotfiles git repo
	if [ -e "$HOME/$dotfile" ] 
	then

		echo "$dotfile moved to $olddotfiles/$dotfile"
		mv "$HOME/$dotfile" "$olddotfiles/$dotfile"

		echo "$dotfile symlinked to $HOME/lib/dotfiles/$dotfile"
		ln -s "$HOME/lib/dotfiles/$dotfile" "$HOME/$dotfile"
	fi
done

source .bash_profile
