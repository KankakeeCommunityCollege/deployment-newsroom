#!/bin/bash

if  [[ $TRAVIS_PULL_REQUEST = "false" ]]
then
    ncftp -u "$USERNAME" -p "$PASSWORD" "$HOST"<<EOF
    cp site/wwwroot old/site/wwwroot
    rm -rf site/wwwroot
    mkdir site/wwwroot
    cp old/site/wwwroot/web.config site/wwwroot/web.config
    cp -r old/site/wwwroot/aspnet_client/ site/wwwroot/apsnet_client/
    rm -rf old/site/wwwroot
    quit
EOF

    cd _site || exit
    ncftpput -R -v -u "$USERNAME" -p "$PASSWORD" "$HOST" /site/wwwroot .
fi
