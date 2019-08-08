#!/bin/bash

current_directory=${pwd}

cd ..
cd ..

pip install -r ./requirements.txt -t ./dist/src
cp -R -v ./src ./dist/src
cp -R -v ./terraform ./dist/terraform

ls -ltr ./dist

