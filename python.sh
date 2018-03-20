#!/usr/bin/env bash

# Removed user's cached credentials
# This script might be run with .dots, which uses elevated privileges
sudo -K

###############################################################################
# Virtual Enviroments                                                         #
###############################################################################

echo "------------------------------"
echo "Setting up virtual environments."

pip3 install virtualenv
pip3 install virtualenvwrapper

source /usr/local/bin/virtualenvwrapper.sh

###############################################################################
# Python 2 Virtual Enviroment                                                 #
###############################################################################

# echo "------------------------------"
# echo "Setting up py2-data virtual environment."

# # Create a Python2 data environment
# mkvirtualenv --python=$(which python2) py2
# workon py2

# # Install Python data modules
# pip install numpy
# pip install scipy
# pip install matplotlib
# pip install pandas
# pip install sympy
# pip install nose
# pip install unittest2
# pip install seaborn
# pip install scikit-learn
# pip install "ipython[all]"
# pip install bokeh
# pip install Flask
# pip install sqlalchemy
# pip install mysql-python

###############################################################################
# Python 3 Virtual Enviroment                                                 #
###############################################################################

echo "------------------------------"
echo "Setting up py3 virtual environment."

# Create a Python3 data environment
mkvirtualenv --python=$(which python3) py3
workon py3

# Install Python data modules
pip install bokeh
pip install ipython
pip install matplotlib
pip install numpy
pip install pandas
pip install scikit-learn
pip install scipy
pip install seaborn
pip install sympy

pip install pillow
pip install jupyter

pip install tensorflow
pip install keras

pip install requests
pip install bs4
pip install Flask

pip install pytesseract
pip install opencv-python

pip install pyobjc
pip install pyautogui

pip install progress

echo "------------------------------"
echo "Script completed."
# echo "Usage: workon py2 for Python2"
echo "Usage: workon py3 for Python3"
