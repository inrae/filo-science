#!/bin/bash
/opt/sonar-scanner/bin/sonar-scanner \
 -Dsonar.projectKey=filo \
 -Dsonar.sources=. \
 -Dsonar.host.url=https://sonarcloud.io \
 -Dsonar.organization=equinton-github \
 -Dsonar.login=../sonar.token \
 -Dsonar.exclusions=display/javascript/**,display/node_modules/**,vendor/**,database/**,install/**,param/**,plugins/**,test/**,doc/**,img/**,temp/** \
 -Dproject.settings=../sonar.properties

