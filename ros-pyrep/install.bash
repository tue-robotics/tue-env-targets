#! /usr/bin/env bash
# shellcheck disable=SC1090


if [ ! -d ~/PyRep/ ]
then
	cucr-install-debug "Installing PyRep"
	git clone git@github.com:stepjam/PyRep.git ~/PyRep
	cd ~/PyRep/
	pip3 install -r requirements.txt
	source ~/.bashrc
	pip3 install .
fi