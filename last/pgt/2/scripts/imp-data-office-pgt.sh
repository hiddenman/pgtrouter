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
for pgt in $pgts; do
	tmpfile=`printf ${data_off_pgt}.eml $pgt`
	old_data=`printf $old_data_off_pgt $pgt`
	info "Create file $tmpfile from MTA"
	echo -n>$tmpfile
	while read str; do
	    echo "$str">>$tmpfile
	done

	if [ -s $tmpfile ]; then
	    info "Unpacking $tmpfile"
	    file=`munpack -f -C $TMPDIR $tmpfile|cut -f1 -d" "`
	    info "File is $file"
	    if [ -s "$file" ]; then
			info "Sending $file to $pgtsrvimp"
			start smbclient "$pgtsrvimp" -I "$pgtsrvip" -U "$pgtusr%$pgtpwd" -c "put $file $old_data"
			start rm -f $file
			start rm -f $tmpfile
	    fi
	else
	    error "File $tmpfile doesn't exist"
	fi
done
