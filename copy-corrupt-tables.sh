#!/bin/bash

TPATH='/var/lib/mysql/foo-db'
TABLES='foo bar'
SUFFIX='_rescue'
DATABASE='foo-db'

for i in $TABLES; do
	echo "copying frm file [$i] ..."

	# table file bit
	cp $TPATH/$i.frm $TPATH/$i$SUFFIX.frm

	echo "setting correct owner [$i$SUFFIX] ..."
	chown mysql. $TPATH/$i$SUFFIX.frm

	echo "creating MYI/MYD [$i$SUFFIX] ..."
	touch $TPATH/$i$SUFFIX.MYI
	chown mysql. $TPATH/$i$SUFFIX.MYI
	touch $TPATH/$i$SUFFIX.MYD
	chown mysql. $TPATH/$i$SUFFIX.MYD

	echo "doing repair table [$i$SUFFIX] ..."
	mysql --database=$DATABASE --execute="repair table $i$SUFFIX use_frm"

	echo "done"
done

echo "all done"
