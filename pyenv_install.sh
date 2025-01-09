#!/usr/bin/bash
export PATH="/home/$USER/.pyenv/bin:$PATH"
eval "$(/home/$USER/.pyenv/bin/pyenv init -)"
eval "$(/home/$USER/.pyenv/bin/pyenv virtualenv-init -)"
echo '######## Installing Python 3.12.0 and set as global #######'
echo '##########################################################'
echo '     ###############################################'
username=$(logname)
pyenv install 3.12.0
pyenv global 3.12.0
