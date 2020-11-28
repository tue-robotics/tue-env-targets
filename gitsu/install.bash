#! /usr/bin/env bash

# gitsu is installed as a ruby gem
hash git-su 2> /dev/null || sudo gem install gitsu

gitsu_file=~/.gitsu
# install the authors file
if [ -L $gitsu_file ]
then
   if [ -e $gitsu_file ]
   then
      irohms-install-debug "gistu file: good link"
   else
      irohms-install-debug "gistu file: link is broken and will be replaced"
      rm $gitsu_file
      ln -s "$(dirname "${BASH_SOURCE[0]}")"/gitsu.txt $gitsu_file
   fi
elif [ -e $gitsu_file ]
then
    irohms-install-debug "gistu file: it is not a link"
else
    irohms-install-debug "gistu file: link doesn't exist, but will be created"
    ln -s "$(dirname "${BASH_SOURCE[0]}")"/gitsu.txt $gitsu_file
fi
