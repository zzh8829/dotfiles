CONDA_TMP=$(mktemp)
if [[ $OS == linux ]]; then
	CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
elif [[ $OS == macos ]]; then
	CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
fi 

curl -L $CONDA_URL -o $CONDA_TMP
bash $CONDA_TMP -b
rm -rf $CONDA_TMP
