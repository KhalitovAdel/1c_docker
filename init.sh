#!/bin/sh
SERVER_1C_PATH=$(echo $(find /opt/1C/ -name ras -type f  | sed -r "s/(.+)\/.+/\1/"))
init() {
  "$SERVER_1C_PATH"/ras --daemon cluster
  /etc/init.d/srv1cv83 start
  echo "$SERVER_1C_PATH"
#  tail -f /var/log/1C/**/*.log
  while true; do echo "$SERVER_1C_PATH";sleep 1s;done;
}

initDataBase() {
  # Bad regular
  cluster_id=$("$SERVER_1C_PATH"/rac cluster list | grep ^cluster | grep -o '\: .*' | sed -r 's/(\:|\s)//g')
  "$SERVER_1C_PATH"/rac infobase --cluster="$cluster_id" \
    create --create-database \
    --name=tkani \
    --dbms=PostgreSQL \
    --db-server=1c-postgres \
    --db-name=tkani \
    --locale=ru_RU.utf8 \
    --db-user=postgres \
    --db-pwd= \
    --license-distribution=allow
}
#docker network create -d bridge 1c-network
#docker run --name 1c-postgres \
#   --network 1c-network \
#   --expose 5432 \
#   -d rsyuzyov/docker-postgresql-pro-1c
if [ "$1" = "init" ]
then
  echo "$1"
  init
  "$@"
else
  echo not
  initDataBase
  "$@"
fi