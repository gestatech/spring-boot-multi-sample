#!/usr/bin/env bash

git pull

# get artifact version
VERSION=`mvn clean | grep 'Building.*Samples [0-9].*' | sed -e 's/^.*Building.*Samples //g'`
CURRENT_DIR=`pwd`

# install artifacts
mvn -U install
buildResult=$?
if test ${buildResult} -ne 0 ; then
    echo "[ERROR] Failed a build."
    exit ${buildResult}
fi

# copy artifacts to deploy dir
chmod u+w services/*-${VERSION}.*
cp database/target/database-${VERSION}.jar services/.
cp screen-thymeleaf/target/screen-thymeleaf-${VERSION}.jar services/.
cp screen-freemarker/target/screen-freemarker-${VERSION}.jar services/.
cp screen-jsp/target/screen-jsp-${VERSION}.war services/.
cp api-auth/target/api-auth-${VERSION}.jar services/.
cp api-resource/target/api-resource-${VERSION}.jar services/.
cp api-client/target/api-client-${VERSION}.jar services/.

# change permission
chmod 500 services/database-${VERSION}.jar
chmod 500 services/screen-thymeleaf-${VERSION}.jar
chmod 500 services/screen-freemarker-${VERSION}.jar
chmod 500 services/screen-jsp-${VERSION}.war
chmod 500 services/api-auth-${VERSION}.jar
chmod 500 services/api-resource-${VERSION}.jar
chmod 500 services/api-client-${VERSION}.jar

# replace link
sudo ln -f -s ${CURRENT_DIR}/services/database-${VERSION}.jar /etc/init.d/boot-db
sudo ln -f -s ${CURRENT_DIR}/services/screen-thymeleaf-${VERSION}.jar /etc/init.d/boot-screen-t
sudo ln -f -s ${CURRENT_DIR}/services/screen-freemarker-${VERSION}.jar /etc/init.d/boot-screen-f
sudo ln -f -s ${CURRENT_DIR}/services/screen-jsp-${VERSION}.war /etc/init.d/boot-screen-j
sudo ln -f -s ${CURRENT_DIR}/services/api-auth-${VERSION}.jar /etc/init.d/boot-api-a
sudo ln -f -s ${CURRENT_DIR}/services/api-resource-${VERSION}.jar /etc/init.d/boot-api-r
sudo ln -f -s ${CURRENT_DIR}/services/api-client-${VERSION}.jar /etc/init.d/boot-api-c
