#! /usr/bin/env bash

script_dir=$(dirname "${BASH_SOURCE[0]}")
# gitsu is installed as a ruby gem
hash gem 2> /dev/null || tue-install-system-now ruby
hash git-su 2> /dev/null || sudo gem install gitsu

gitsu_file=~/.gitsu
# install the authors file
if [ -L $gitsu_file ]
then
   if [ -e $gitsu_file ]
   then
      tue-install-debug "gistu file: good link"
   else
      tue-install-debug "gistu file: link is broken and will be replaced"
      rm $gitsu_file
      ln -s $script_dir/gitsu.txt $gitsu_file
   fi
elif [ -e $gitsu_file ]
then
    tue-install-debug "gistu file: it is not a link"
else
    tue-install-debug "gistu file: link doesn't exist, but will be created"
    ln -s $script_dir/gitsu.txt $gitsu_file
fi
