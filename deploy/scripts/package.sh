#!/bin/bash

current_directory=${pwd}

apt-get update
apt-get -y install zip

cd ..
cd ..
cd ..

ls -ltr

export version=$(version/number)

mkdir -p artifacts
cd dist/

zip -r -X "shop-catalog-api.zip" src
mv "shop-catalog-api.zip" ./terraform
rm -rf src

zip -r -X "shop-catalog-api-v${version}.zip" *

ls -lh
mv "shop-catalog-api-v${version}.zip" ../artifacts/

ls -lh ../artifacts/
cd ..

