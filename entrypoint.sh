CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_STARTED_PLACEHOLDER"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    echo "-- First container startup --"
    php db/create_tables.php
else
    echo "-- Not first container startup --"
fi

env | egrep -v "^(HOME=|USER=|MAIL=|LC_ALL=|LS_COLORS=|LANG=|HOSTNAME=|PWD=|TERM=|SHLVL=|LANGUAGE=|_=)" >> /etc/environment
service ssh start


RUN_PROGRAM="RUN_PROGRAM"
if [ ! -e $RUN_PROGRAM ]; then
    tail -f /dev/null
else
    npm install --legacy-peer-deps && mvn install -DskipTests
    ./init_env.sh
    
    npm run watch &
    sh run_webserver.sh

   
fi

