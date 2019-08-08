#!/bin/bash

current_directory=${pwd}

cd ..
cd ..

pip install -r ./test-requirements.txt -t ./dist/src
cp -R -v ./src ./temp
cp -R -v ./tests ./temp

cd ./temp

pytest
