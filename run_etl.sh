#!/bin/bash

# Virtual Environment Path
VENV_PATH="/home/istywhyerlina/datastorage/week3/venv/bin/activate"

# Activate venv
source "$VENV_PATH"

# set python script
PYTHON_SCRIPT="/home/istywhyerlina/datastorage/week3/pipeline/transform.py"

# run python script
python "$PYTHON_SCRIPT" >> /home/istywhyerlina/datastorage/week3/pipeline/logs/logs.log 2>&1

# logging simple
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "Luigi Started at ${dt}" >> /home/istywhyerlina/datastorage/week3/pipeline/logs/luigi-info.log