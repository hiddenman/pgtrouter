#!/bin/sh
# Get file with documents and send it by e-mail to main office

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
info "Start"
info "Receiving export file from $offsrvexp"
for pgt in $pgts; do
	old_docs=`printf $old_docs_off_pgt $pgt`
	docs=`printf $docs_off_pgt $pgt`
	dst=`printf $docs_dst_pgt $pgt`
	start smbclient $offsrvexp -U "$offusr%$offpwd" -I $offsrvip -c "cd shops;get $old_docs $docs;exit"
	if [ -f $docs ]; then
		info "Sending export file to $dst"
		start mutt -a $docs -s "exported documents: [office->pgt$pgt]" $dst <<EOF
				    Please, import it!
EOF
		start rm -f $docs
	else
		error "File $docs doesn't exist"
	fi
done
				
info "End"
