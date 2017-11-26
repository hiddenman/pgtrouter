#!/bin/sh
# Receive file data and documents from main office and put it to SQL server



if [ ! -f /usr/local/bin/config.sh ]; then
    echo "Missing config file [config.sh]"
    my_exit 1
else
    source /usr/local/bin/config.sh
fi

if [ ! -f /usr/local/bin/functions.sh ]; then
    echo "Missing functions file [functions.sh]"
    my_exit 1
else
    source /usr/local/bin/functions.sh
fi


cd $TMPDIR

log ""
info "Starting"
	tmpfile="${data_pgt_off}.eml"
	info "Create file $tmpfile from MTA"
	echo -n>$tmpfile
	while read str; do
	    echo "$str">>$tmpfile
	done

	if [ -s $tmpfile ]; then
	    info "Unpacking $tmpfile"
	    file=`munpack -f -C $TMPDIR $tmpfile|cut -f1 -d" "`
	    info "File is $file"
		pgt=`echo $file|tr -d '[:alpha:]'|tr -d '[\-\.]'`
		old_data=`printf $old_data_pgt_off $pgt`
	    if [ -s "$file" ]; then
			info "Sending $file to $pgtsrvimp"
			start smbclient "$offsrvimp" -I "$offsrvip" -U "$offusr%$offpwd" -c "put $file $old_data"
			start rm -f $file
			start rm -f $tmpfile
	    fi
	else
	    error "File $tmpfile doesn't exist"
	fi
