#! /usr/bin/env bash

# Check if either both 'set -e' and 'set +e' are used or none

bad_files=""
files=$(find . -type f \( -iname "setup" -o -iname "*.bash" -o -iname "*.sh" \))
for file in $files
do
  if ! grep -Eqz ".*set -e.*set \+e.*" "$file" && (grep -Eqz "set -e" "$file" || grep -Eqz "set \+e" "$file")
  then
      bad_files=${bad_files:+${bad_files} }$file
  fi
done

if [ -n "$bad_files" ]
then
  echo -e "\033[38;5;1mFollowing file(s) have only \"set -e\" or \"set +e\", use both or none:\033[0m"
  for bad_file in $bad_files
  do
      echo -e "\033[38;5;1m   $bad_file\033[0m"
  done
  exit 1
fi
