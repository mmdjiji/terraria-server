#!/bin/bash

# launch
split() {
  string=$1
  separator=$2
  echo ${string//$separator/ }
}

regex() {
  echo $1 | sed -E -e 's/.*([0-9]{4}).*/\1/g'
}

get_version() {
  version=$(curl https://terraria.org/api/get/dedicated-servers-names)
  version_arr=($(split $version ','))
  version_pc=$(regex ${version_arr[0]})
  echo $version_pc
}

# the latest terraria server version (/^[0-9]{4}$/)
terraria_version=$(get_version)

echo The latest Terraria version is $terraria_version

cd /opt/terraria/

GAME_DIR=bin/$terraria_version

if [ -d "$GAME_DIR" ]; then
  echo "bin exist, pass"
else # auto pull the latest game server
  echo "bin does not exist, download it now"
  curl https://terraria.org/api/download/pc-dedicated-server/terraria-server-$terraria_version.zip -o $terraria_version.zip
  unzip $terraria_version.zip
  mkdir bin
  mv $terraria_version bin/
  rm bin/$terraria_version/Mac -r
  rm bin/$terraria_version/Windows -r
  rm $terraria_version.zip
fi

# launch ok

USERNAME='root'
SCNAME='terraria'
TERA_VER=$terraria_version # for example, '1449'
BIN_PATH="/opt/terraria/bin/$TERA_VER/Linux/"
SERVICE='TerrariaServer.bin.x86_64'
CONFIG='/opt/terraria/serverconfig.txt'

ME=`whoami`

if [ $ME != $USERNAME ] ; then
  echo "Please run the $USERNAME user."
  exit
fi

start() {
  if pgrep -u $USERNAME -f $SERVICE > /dev/null ; then
    echo "$SERVICE is already running!"
    exit
  fi
  chmod +x $BIN_PATH$SERVICE

  echo "Starting $SERVICE..."
  screen -AmdS $SCNAME $BIN_PATH$SERVICE -config $CONFIG
  tail -f /dev/null
  exit
}

stop() {
  if pgrep -u $USERNAME -f $SERVICE > /dev/null ; then
    echo "Stopping $SERVICE "
  else
    echo "$SERVICE is not running!"
    exit
  fi
  screen -p 0 -S $SCNAME -X eval 'stuff "say SERVER SHUTTING DOWN IN 10 SECONDS. "\015'
  sleep 10
  screen -p 0 -S $SCNAME -X eval 'stuff "exit"\015'
  exit
}

save() {
  echo 'World data saving...'
  screen -p 0 -S $SCNAME -X eval 'stuff "say World saveing..."\015'
  screen -p 0 -S $SCNAME -X eval 'stuff "save"\015'
  exit
}

status() {
  if pgrep -u $USERNAME -f $SERVICE > /dev/null ; then
    echo "$SERVICE is already running!"
    exit
  else
    echo "$SERVICE is not running!"
    exit
  fi
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  save)
    save
    ;;
  status)
    status
    ;;
  *)
    echo  $"Usage: $0 {start|stop|status|save}"
esac
