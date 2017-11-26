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
info "Receiving export file from $pgtsrvexp"
for pgt in $pgts; do
	old_docs=`printf $old_docs_pgt_off $pgt`
	docs=`printf $docs_pgt_off $pgt`
	dst=`printf $docs_dst_off`
	start smbclient $pgtsrvexp -U "$pgtusr%$pgtpwd" -I $pgtsrvip -c "get $old_docs $docs;exit"
	if [ -f $docs ]; then
		info "Sending export file to $dst"
		start mutt -a $docs -s "exported documents: [pgt$pgt->office]" $dst <<EOF
				    Please, import it!
EOF
		start rm -f $docs
else
		error "File $docs doesn't exist"

	fi
done				
info "End"
