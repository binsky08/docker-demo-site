#!/bin/bash
### BEGIN INIT INFO
# Provides:          demo_site
# Required-Start:	 mysql
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start demo docker daemon engine at boot time
# Description:       Enable daemon functions (create docker instances, opening ports, ...)
### END INIT INFO

NAME=demo_site

RUNDIR=/var/run
PIDFILE=$RUNDIR/demo_server.pid

DAEMON=DAEMON_PATH
DAEMON_ARGS="daemon pidfile $PIDFILE"

case "$1" in
  start)
	echo -n "Starting $DESC: "
	mkdir -p $RUNDIR
	touch $PIDFILE
	chown root:root $PIDFILE

	if start-stop-daemon --start --oknodo --background --pidfile $PIDFILE --chuid root:root --exec $DAEMON -- $DAEMON_ARGS
	then
		echo "$NAME. Started"
	else
		echo "failed"
	fi
    ;;
  stop)
    echo -n "Stopping $NAME: "
	
	if [ -s $PIDFILE ]
	then
		kill $(pstree -p `cat $PIDFILE` | tr "\n" " " |sed "s/[^0-9]/ /g" |sed "s/\s\s*/ /g")
		echo "$NAME. Stopped"
	else
		echo "Failed to stop daemon, no such pid file, is daemon running?"
	fi

	rm -f $PIDFILE
    ;;
  restart|reload|force-reload)
    $0 stop
    sleep 1
    $0 start
    ;;
  status)
	status_of_proc -p ${PIDFILE} ${DAEMON} ${NAME}
    ;;
  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|restart|force-reload|status}" >&2
	exit 1
esac