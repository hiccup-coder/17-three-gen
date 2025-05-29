#!/bin/bash

# Stop the script on any error
set -e

VENV_DIR=".venv"  # <--- Change this to your desired venv path

# Create virtual environment
python3.10 -m venv $VENV_DIR

# Activate the virtual environment
source $VENV_DIR/bin/activate

# Upgrade pip
# pip install --upgrade pip

echo -e "\n\n[INFO] Installing gaussian-rasterization package\n"
pip install git+https://github.com/nerfstudio-project/gsplat.git@v1.4.0

echo -e "\n\n[INFO] Installing MVDream package\n"
pip install ./generation/extras/MVDream

echo -e "\n\n[INFO] Installing ImageDream package\n"
pip install ./generation/extras/ImageDream

# Store the path of the venv Python interpreter
VENV_INTERPRETER_PATH=$(which python)

# Generate the generation.config.js file for PM2 with specified configurations
cat <<EOF > generation.config.js
module.exports = {
  apps : [{
    name: 'generation',
    script: 'serve.py',
    interpreter: '${VENV_INTERPRETER_PATH}',
    args: '--port 8093'
  }]
};
EOF

echo -e "\n\n[INFO] generation.config.js generated for PM2."
