#!/bin/bash

current_directory=${pwd}

apt-get update
apt-get -y install unzip

cd ..
cd ..
cd ..

ls -ltr s3-artifacts/
export version=$(version/number)

unzip "s3-artifacts/shop-catalog-api-v${version}.zip" -d dist

ls -ltr