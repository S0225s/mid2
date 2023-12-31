#!/bin/bash
set -e -u -o pipefail

if [ $# -lt 1 ]; then
  echo 'version is required'
  exit 1
fi

VERSION=$1
ARCH=amd64

if [ $# -ge 2 ]; then
  ARCH=$2
fi

JAR_FILE_COUNT=$(find "../target/" -maxdepth 1 -name '*.jar' | wc -l)
if [ $JAR_FILE_COUNT == 0  ]; then
    echo "jar file not found, please execute: mvn clean package"
    exit 1
fi

cp ../target/*.jar ./app.jar
ls -l ./app.jar

docker build . -t midjourney-proxy:${VERSION}
rm -rf ./app.jar

docker tag midjourney-proxy:${VERSION} novicezk/midjourney-proxy-${ARCH}:${VERSION}
docker push novicezk/midjourney-proxy-${ARCH}:${VERSION}