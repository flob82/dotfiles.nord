#!/bin/bash

set -e

#GLOBALS VARS

declare INSTALL_DIR="$(cd "$(dirname "$0")" && echo "$PWD")"                                                                                                                                  
source "$INSTALL_DIR"/lib/install.sh

#DEFINE VARS

declare BACKUP_EXT=".bak.install"                                                                                                                                                             
declare GIT_DIR="/home/git/github/"
declare HOME_DIR="/home/flo/"

#
# Packages to install
#
declare -r PACKAGES=(   \
    git
    neovim
    )

#
# Repo to clone
#

declare -r GIT=(                                          \
    "https://github.com/vim-airline/vim-airline.git"
    )

#
# Directories to create
#
declare -r DIRECTORIES=(                      \
    "/usr/share/nvim/runtime/pack/dist/start" \
    )

#
# Files to copy [src];[dest]
#
declare -r FILES=(          \
    )

#
# Links [src];[dest]
#
declare -r LINKS=(                                                                                                 \
    "${INSTALL_DIR}/konsole/nord.colorscheme;${HOME_DIR}.local/share/konsole/nord.colorscheme"                     \
    "${INSTALL_DIR}/dircolors/dir_colors;/etc/dircolors"                                                    \
    "${INSTALL_DIR}/tmux/.tmux.conf;${HOME_DIR}.tmux.conf"                                                         \
    "${INSTALL_DIR}/mutt/colors;${HOME_DIR}.mutt/colors"                                                           \
    "${INSTALL_DIR}/neovim/sysinit.vim;/usr/share/nvim/sysinit.vim"                                                \
    "${INSTALL_DIR}/neovim/colors/nord.vim;/usr/share/nvim/runtime/colors/nord.vim"                                \
    "${GIT_DIR}vim-airline;/usr/share/nvim/runtime/pack/dist/start/vim-airline"                                    \
    "${INSTALL_DIR}/neovim/autoload/airline/theme/nord.vim;${GIT_DIR}vim-airline/autoload/airline/themes/nord.vim" \
    "${INSTALL_DIR}/terminator/config;${HOME_DIR}.config/terminator/config"
    )

USAGE() {
  cat << _EOS_
$(_PRINT_INFO Usage:)
  ${_SCRIPT_NAME} [OPTIONS]

OPTIONS :
  -h|--help                    Full help
  -i                           Install
  -u                           Uninstall
  -V|--version                 Show version

_EOS_
}

USAGE_FULL() {
USAGE
  cat << _EOS_
PACKAGES TO INSTALL :
  git neovim
GIT :
  clone https://github.com/vim-airline/vim-airline.git
LINKS :
  konsole/ :
  $(_PRINT_COLOR green nord.colorscheme)                -> ${HOME_DIR}.local/share/konsole/nord.colorscheme
  dircolors/ :
  $(_PRINT_COLOR green dir_colors)                      -> ${HOME_DIR}.dircolors 
  tmux/ :
  $(_PRINT_COLOR green .tmux.conf)                      -> ${HOME_DIR}.tmux.conf
  mutt/ :
  $(_PRINT_COLOR green colors)                          -> ${HOME_DIR}.mutt/colors
  neovim/ :
  $(_PRINT_COLOR green sysinit.vim)                     -> /usr/share/nvim/sysinit.vim
  $(_PRINT_COLOR green colors/nord.vim)                 -> /usr/share/nvim/runtime/colors/nord.vim
  $(_PRINT_COLOR green autoload/airline/theme/nord.vim) -> ${GIT_DIR}vim-airline/autoload/airline/themes/nord.vim
  ${GIT_DIR} :
  $(_PRINT_COLOR green vim-airline)                     -> /usr/share/nvim/runtime/pack/dist/start/vim-airline

_EOS_
}

INSTALL_SCRIPT() {
COUNT=0

  if [[ ${#PACKAGES[@]} -ge 1 ]]; then
    for package in ${PACKAGES[@]}; do
      dpkg-query -W $package &> /dev/null && true
      if [[ $? -ne 0 ]]; then
        COUNT=$(( COUNT + 1 ))
        if [[ $COUNT -eq 1 ]]; then
          _PRINT_INFO "INSTALLING PACKAGE..."
        fi
        _PRINT_INFO "["$package"]"
        apt-get install $package
      fi
    done
    # Affiche d'un retour a la ligne
    if [[ ( $package == ${PACKAGES[-1]} ) && $COUNT -ne 0 ]]; then
      _PRINT
    fi
  fi

COUNT=0

  if [[ ${#GIT[@]} -ge 1 ]]; then
    for repo in ${GIT[@]}; do
      NAME=$(echo "$repo" | awk -F"/" '{print $NF}' | sed 's/.git//')
      if [[ ! -d $GIT_DIR$NAME ]]; then
        COUNT=$(( COUNT + 1 ))
        if [[ $COUNT -eq 1 ]]; then
          _PRINT_INFO "CLONING..."
        fi
        _PRINT_INFO "[" $repo "]"
        git clone $repo $GIT_DIR$NAME
        chown -R $SUDO_UID:$SUDO_GID $GIT_DIR$NAME
      fi
    done
  fi

  if [[ ${#DIRECTORIES[@]} -ge 1 ]]; then
    _PRINT_INFO "DOING MKDIR..."
    for dir in ${DIRECTORIES[@]}; do
      if [[ ! -d $dir ]]; then
        _PRINT_INFO "[ mkdir -p" $dir "]"
        mkdir -p $dir 2> >(sed $'s,.*,\e[31m&\e[m,'>&1)
      else
        _PRINT_WARN "[" $(_PRINT $dir)$(_PRINT_COLOR byellow "] DIR EXISTS")
      fi
      # Affiche d'un retour a la ligne
      if [[ ( $dir == ${DIRECTORIES[-1]} ) ]]; then
        _PRINT
      fi
    done
  fi

  if [[ ${#FILES[@]} -ge 1 ]]; then
    _PRINT_INFO "DOING COPY..."
    for file in ${FILES[@]}; do
      SRC=$(echo "$file" | awk -F";" '{print $1}')
      DST=$(echo "$file" | awk -F";" '{print $2}')
      if [[ -e "$DST" && $(_CHECK_MD5 ${SRC}) != $(_CHECK_MD5 ${DST}) ]]; then
        _PRINT_WARN "[" $(_PRINT "mv $DST $DST$BACKUP_EXT")$(_PRINT_COLOR byellow "]")
        mv $DST $DST$BACKUP_EXT 2> >(sed $'s,.*,\e[31m&\e[m,'>&1)
      fi
      if [[ ( ! -f "$DST" ) || ( ( -f "$DST" ) && ( $(_CHECK_MD5 ${SRC}) != $(_CHECK_MD5 ${DST}) ) ) ]]; then
        _PRINT_INFO "[ cp " $SRC $DST "]"
        cp $SRC $DST 2> >(sed $'s,.*,\e[31m&\e[m,'>&1)
      else
        _PRINT_WARN "[" $(_PRINT $DST)$(_PRINT_COLOR byellow "] FILE EXISTS")
      fi
      # Affiche d'un retour a la ligne
      #if [[ ( $file == ${FILES[-1]} ) ]]; then
      if [[ ( $file == ${FILES[-1]} ) ]]; then
        _PRINT
      fi
    done
  fi

  if [[ ${#LINKS[@]} -ge 1 ]]; then
    _PRINT_INFO "DOING LINK..."
    for link in ${LINKS[@]}; do
      SRC=$(echo "$link" | awk -F";" '{print $1}')
      DST=$(echo "$link" | awk -F";" '{print $2}')
      FILENAME=$(echo "$SRC" | awk -F"/" '{print $NF}')

      if [[ -d $(dirname "${DST:-${(%):-%N}}") ]]; then
        if [[ -e "$DST" && ! -L "$DST" ]]; then
          _PRINT_WARN "FILE EXISTS [ mv" $DST $DST$BACKUP_EXT "]"
          mv $DST $DST$BACKUP_EXT 2> >(sed $'s,.*,\e[31m&\e[m,'>&1)
        fi
        if [[ ! -L "$DST" ]]; then
          _PRINT_INFO "[ ln -s" $SRC $DST "]"
          #_PRINT_INFO $(_PRINT $(ln -vis $INSTALL_DIR"/"$SRC $DST 2> >(sed $'s,.*,\e[31m&\e[m,'>&1)))
          ln -s $SRC $DST 2> >(sed $'s,.*,\e[31m&\e[m,'>&1) 
        else
          _PRINT_WARN "[" $(_PRINT $DST)$(_PRINT_COLOR byellow "] LINK EXISTS")
        fi
      else
        _PRINT_WARN "[" $(_PRINT $(dirname "${DST:-${(%):-%N}}"))$(_PRINT_COLOR byellow "] NOT EXISTS")
      fi
    done
  fi
}

UNINSTALL_SCRIPT() {
  if [[ ${#FILES[@]} -ge 1 ]]; then
    _PRINT_INFO "REMOVE FILE..."
    for file in ${FILES[@]}; do
      SRC=$(echo "$file" | awk -F";" '{print $1}')
      DST=$(echo "$file" | awk -F";" '{print $2}')

      if [[ -f "$DST" && $(_CHECK_MD5 ${SRC}) == $(_CHECK_MD5 ${DST}) ]]; then
        _PRINT_INFO "[ rm" $DST "]"
        rm -i $DST 2> >(sed $'s,.*,\e[31m&\e[m,'>&1)
        if [[ -e "$DST$BACKUP_EXT" ]]; then
          _PRINT_INFO "[ mv" $DST$BACKUP_EXT $DST "]"
          mv $DST$BACKUP_EXT $DST 2> >(sed $'s,.*,\e[31m&\e[m,'>&1)
        fi
      else
        _PRINT_WARN "[" $(_PRINT $DST)$(_PRINT_COLOR byellow "] NO FILE FOUND")
      fi
      #if [[ ( $file == ${FILES[-1]} ) ]]; then
      if [[ ( $file == ${FILES[-1]} ) ]]; then
        _PRINT
      fi
    done
  fi

  if [[ ${#LINKS[@]} -ge 1 ]]; then
    _PRINT_INFO "REMOVE LINK..."
    for link in ${LINKS[@]}; do
      SRC=$(echo "$link" | awk -F";" '{print $1}')
      DST=$(echo "$link" | awk -F";" '{print $2}')
      FILENAME=$(echo "$SRC" | awk -F"/" '{print $NF}')

      if [[ -L "$DST" ]]; then
        _PRINT_INFO "[ rm" $DST "]"
        rm -i $DST 2> >(sed $'s,.*,\e[31m&\e[m,'>&1)
        if [[ -e "$DST$BACKUP_EXT" ]]; then
          _PRINT_INFO "[ mv" $DST$BACKUP_EXT $DST "]"
          mv $DST$BACKUP_EXT $DST 2> >(sed $'s,.*,\e[31m&\e[m,'>&1)
        fi
      else
        _PRINT_WARN "[" $(_PRINT $DST)$(_PRINT_COLOR byellow "] NO LINK FOUND")
      fi
      #if [[ ( $link == ${LINKS[-1]} ) ]]; then
      if [[ ( $link == ${LINKS[-1]} ) ]]; then
        _PRINT
      fi
    done
  fi

  if [[ ${#DIRECTORIES[@]} -ge 1 ]]; then
    _PRINT_INFO "REMOVE DIR..."
    for dir in ${DIRECTORIES[@]}; do
      if [[ -d $dir ]]; then
        _PRINT_INFO "[ rmdir" $dir "]"
        rmdir $dir 2> >(sed $'s,.*,\e[31m&\e[m,'>&1)
      else
        _PRINT_WARN "[" $(_PRINT $dir)$(_PRINT_COLOR byellow "] NO DIR FOUND")
      fi
    done
  fi
}

TMUX_CONF() {
cat > ${INSTALL_DIR}/tmux/.tmux.conf << EOF
run-shell "${INSTALL_DIR}/tmux/nord.tmux"
EOF
chown $SUDO_UID:$SUDO_GID ${INSTALL_DIR}/tmux/.tmux.conf
}

BASHRC_ADD() {
grep '## Perso (install)' /etc/bash.bashrc &> /dev/null && true
if [[ $? -ne 0 ]]; then
  cat ${INSTALL_DIR}/bash/bash.bashrc >> /etc/bash.bashrc
fi
}

######
###### MAIN
######

  if [[ $EUID -ne 0 ]]; then
    _PRINT_ERROR "You must be a root user."
    exit 1
  fi

  BASHRC_ADD
  TMUX_CONF
  _ARGS_OPT "${1+"$@"}"
