#!/bin/bash
path_from=$1/*
path_to=$2
path_log=$3

date >> $3/processing.log  ;
if [ "$(ls -A $1)" ]; then

	for f in $path_from
	do
	  truncate -s 0 result.txn	
	  echo "Processing $f file..." >> $3/processing.log ;
	  echo "Processing $f file..."	
	  read PAYOUTS < $f
	  /usr/local/bin/electrum -w .electrum/wallets/wallet_22_06_17 paytomany -W JjEDMht2Nwpt5Kux "$PAYOUTS"  > result.txn 2>>$3/processing.log ;
	  cat result.txn >> $3/processing.log ;
	  cat result.txn | /usr/local/bin/electrum -w .electrum/wallets/wallet_22_06_17   broadcast - >> $3/processing.log 2>>$3/processing.log ;
	  tail -n 4 $3/processing.log;	

	if tail -n 4 $3/processing.log | grep -q true ; then
	        mv $f $path_to 2>> $3/processing.log
		  
        	tail -n 4  $3/processing.log | mail -s 'Successful payment '$f  log14@qq.com,estvincere@yandex.ru,cons@yandex.ru
		sleep 30s;
	else
		tail -n 11 $3/processing.log | grep error  | mail -s 'Error in file '$f  log14@qq.com,estvincere@yandex.ru,cons@yandex.ru
		echo "File not migrated." >>$3/processing.log;
	fi

	
	done

else

    echo "$1 is Empty" >>$3/processing.log;
fi



