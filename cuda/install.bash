ubuntu_version=$(lsb_release -rs)
ubuntu_version="${ubuntu_version//./}"
cuda_version="9.2.148-1"
cuda_version_local=$(cat /usr/local/cuda/version.txt | cut -d ' ' -f 3-)
install_cuda=false

if [ $(uname -p) == "x86_64" ]
then
    architecture="amd64"
else
    architecture="ppc64el"
fi

if [ -e /usr/local/cuda ]
then
		if [ $cuda_version_local == cuda_version ]
		then
			return
		else
			sudo apt-get purge -y cuda*
			sudo apt-get purge libcudnn*
			sudo apt-get purge libcudnn*-dev
			install_cuda=true
		fi
else
	install_cuda=true
fi

if [[ $install_cuda==true ]]
then
	tue-install-debug "Installing cuda with following configuration:\nUbuntu version: ${ubuntu_version}\nCuda version: ${cuda_version}\nArchitecture: ${architecture}"

	return
	cuda_file="cuda-repo-ubuntu${ubuntu_version}_${cuda_version}_${architecture}.deb"
	cuda_url="""https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${ubuntu_version}/$(uname -p)/${cuda_file}"

	if [ -f /tmp/$cuda_file ]
	then
		tue-install-debug "Removing old cuda debian: /tmp/$cuda_file"
		rm -f /tmp/$cuda_file
	fi

	tue-install-debug "wget $cuda_url"
	wget $cuda_url -P /tmp

	tue-install-debug "sudo dpkg -i /tmp/$cuda_file"
	sudo dpkg -i /tmp/$cuda_file

	tue-install-debug "sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu${ubuntu_version}/$(uname -p)/7fa2af80.pub"
	sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu${ubuntu_version}/$(uname -p)/7fa2af80.pub

	tue-install-debug "sudo apt-get update -qq"
	sudo apt-get update -qq

	tue-install-system cuda
fi
