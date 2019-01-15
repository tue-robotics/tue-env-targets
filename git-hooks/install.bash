# install the global hooks
git config --global core.hooksPath $(dirname "${BASH_SOURCE[0]}")/git_hooks/

if dpkg --compare-versions $(git --version | awk '{print $3}') lt 2.9; then
    tue-install-warning "Please perform a
    sudo apt install git
afterwards to upgrade the git version to allow git-hooks"
fi
