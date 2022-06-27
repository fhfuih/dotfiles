all:
	echo "Stowing dotfiles into ${HOME}"
	stow --verbose --target=$$HOME --restow */
