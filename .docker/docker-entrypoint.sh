#!/bin/bash

set -eui

export RAILS_ENV=${RAILS_ENV:-development}
export AUTO_START=${AUTO_START_AGENCY:-false}

while ! ( echo -e "$MYSQL_PORT" | xargs -i nc -w 1 -zv $MYSQL_HOSTNAME {} ) ; do
  echo "Waiting for mysql to come up at '$MYSQL_HOSTNAME:MYSQL_PORT'..."
  while ! ( mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -h $MYSQL_HOSTNAME -e 'select 1' ) ; do
    echo "Waiting for MySQL server to authorize this host to authenticate as user '$MYSQL_USERNAME'..."
    sleep 1
  done
  sleep 5
done

while ! ( echo -e "$REDIS_PORT" | xargs -i nc -w 1 -zv $REDIS_HOSTNAME {} ) ; do
  echo "Waiting for redis to come up at '$REDIS_HOSTNAME:$REDIS_PORT'..."
  sleep 5
done

if [ $RAILS_ENV == "development" ]; then
  bundle
fi

bundle exec rails db:create db:migrate db:seed

if [ $RAILS_ENV == "development" ]; then
  RAILS_ENV=test bundle exec rails db:schema:load db:migrate
fi

echo "------------------- $(pwd) UP ------------------"

if [ $AUTO_START == "true" ]; then
  foreman start
else
  tail -f /dev/null
fi
