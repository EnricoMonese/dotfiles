#!/bin/zsh
# using zsh as scripting lang, only runs if zsh is available

##
# set default shell to zshell
echo -n "Switch to zsh [y/N]? "; read dothis; [ "$dothis" = "y" ] && {
  chsh -s `which zsh`
}

##
# check dependencies
p="ssh-keygen"; if ! which $p >/dev/null;then echo "[MISSING] $p";return 1;fi
p="wget";       if ! which $p >/dev/null;then echo "[MISSING] $p";return 1;fi
p="git";        if ! which $p >/dev/null;then echo "[MISSING] $p";return 1;fi
if ! cat ~/.gitconfig|grep token >/dev/null; then echo '[MISSING] github token'; fi

##
# what should we do?
# @TODO check for --all argument
echo -n "Set up ssh keys [y/N]? ";                    read do_ssh;
echo -n "Set up git and github [y/N]? ";              read do_git;
echo -n "Set up zsh [y/N]? ";                         read do_zsh;
echo -n "Symlink .cvsignore (used by rsync) [y/N]? "; read do_cvsignore;
echo -n "Set up vim [y/N]? ";                         read do_vim;

# @TODO: determine if osx
# @TODO: check for macports
#sudo port install ant-contrib
#sudo port install apache-ant
#sudo port install apache2
#sudo port install curl
#sudo port install git-core +svn
#sudo port install macvim
#sudo port install openssh
#sudo port install openssl
#sudo port install php5
#sudo port install php5-soap
#sudo port install rsync
#sudo port install wget

##
# set up ssh key pairs
# from https://gist.github.com/1454081
[ "$do_ssh:l" = "y" ] && {
  mkdir ~/.ssh
  [ ! -e "$HOME/.ssh/id_rsa.pub" ] && {
    echo "Generating ssh key..."
    read -p "Please enter the email you want to associate with your ssh key: " email
    ssh-keygen -t rsa -C "$email"
  }
}

##
# setup your ssh keys for github
# from https://gist.github.com/1454081
[ "$do_git:l" = "y" ] && {
  echo "You can run this again if you mess up."
  read -p "Please enter your full name: " fullname
  read -p "Please enter your github username: " githubuser
  read -p "Please enter your github api token: " githubtoken
  [[ $fullname    != '' ]] && git config --global user.name "$fullname"
  [[ $email       != '' ]] && git config --global user.email "$email"
  [[ $githubuser  != '' ]] && git config --global github.user "$githubuser"
  [[ $githubtoken != '' ]] && git config --global github.token "$githubtoken"
  git config --global color.ui auto
  git config --global core.excludesfiles ~/.dotfiles/.cvsignore # use cvsignore (symlink)
}

##
# set up zsh
# @TODO should this go into ~/.zsh/install.sh?
[ "$do_zsh:l" = "y" ] && {
  mv ~/.zsh ~/.zsh.old
  echo "Moved old ~/.zsh folder into ~/.zsh.old (just in case)"
  git clone --recursive git@github.com:davidosomething/dotfiles-zsh.git ~/.zsh && ~/.zsh/install.sh
  /usr/bin/env zsh
  source ~/.zshrc
}

[ "$do_cvsignore:l" = "y" ] && {
  ln -s ~/.dotfiles/.cvsignore ~/.cvsignore
}

# set up vim
# @TODO should this go into ~/.vim/install.sh?
[ "$do_vim:l" = "y" ] && {
  mv ~/.vim ~/.vim.old
  echo "Moved old ~/.vim folder into ~/.vim.old (just in case)"
  git clone --recursive git@github.com:davidosomething/dotfiles-vim ~/.vim && ~/.vim/install.sh
}
