# 
offusr=aid
offpwd=""
offsrvexp='//fileserver/dbexport'
offsrvimp='//fileserver/dbimport'
offsrvip='192.168.1.210'

offuucico="eva.dp.ua"

pgtusr=aid
pgtpwd=""
pgtsrvexp='//srvdb/dbexport'
pgtsrvimp='//srvdb/dbimport'
pgtsrvip='192.168.XXX.2'

pgtwks01='wks01'
pgtwks01ip='192.168.XXX.3'
pgtwks02='wks02'
pgtwks02='192.168.XXX.4'

pgts="`seq 2`"
# Docs
docs_dst_off=imp-docs-pgt-office@eva.dp.ua
docs_dst_pgt=imp-docs-office-pgt%d@pgt.com.ua
# Data
data_dst_off=imp-data-pgt-office@eva.dp.ua
data_dst_pgt=imp-data-office-pgt%d@pgt.com.ua

docs_pgt_off=exp-docs-pgt%d-office.zip
docs_off_pgt=exp-docs-office-pgt%d.zip

data_pgt_off=exp-data-pgt%d-office.zip
data_off_pgt=exp-data-office-pgt%d.zip

old_docs_pgt_off=docs_rtc_%02d_out.zip
old_docs_off_pgt=docs_rtc_%02d.zip

#old_data_pgt_off=docs_rtc_%02d_out.zip
old_data_off_pgt=export_rtc.zip

# some variables
debug=1

# error message text to send
errormsg="";

# smtp server
smtp="smtp.office.eva.dp.ua"

# emails of recipients (errors and successes)
dstaddr="andy@eva.dp.ua"

# src name
srcname="%s-robot"

# src addr
srcaddr="%s-robot@%s.%s.pgt.com.ua"

# error subject
errsubj="There are errors during %s process"

# log dir
logdir="/var/log/import-export"
#logdir="`pwd`/log"

# lock dir
lockdir="/var/lock"

