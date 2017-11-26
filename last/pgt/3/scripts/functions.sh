if [ ! -f /usr/local/bin/config.sh ]; then
    echo "Отсутствует файл конфигурации [config.sh]"
    exit 1
else
    source /usr/local/bin/config.sh
fi
function log()
{
    echo `date +'%D %T'` "$@" >>$logdir/`basename $0`.log
}

function error()
{
    log "error $@"
    curdate="`date +'%D %T'`"
    # FIXME. I CAN'T add newline to end of each string ;-/ Nothing can
    errormsg="$errormsg $curdate $@\n"
}

function info()
{
    log "info  $@"
}

function debug()
{
    if [ $debug -eq 1 ]; then
	log "debug $@"
    fi
}

function warning()
{
    log "warn  $@"
}

function log_stdin()
{
    while read str; do
	info $str
    done
}


function mail_errors()
{
    process=`basename $0`
    subj=`printf "$errsubj" "$process"`
    host=`hostname`
    from=`printf "$srcaddr" "$process" "$host"`
    fname=`printf "$srcname" "$process"`
    info "Отправка почты $dstaddr"
    start email -r "$smtp" -s "$subj" -f "$from" -n "$fname" $dstaddr <<EOF

    Привет!
Произошли ошибки во время выполнения задачи $process. Вот они:
`echo -e $errormsg`
EOF
    return $?

}

function started()
{
    # stupid. FIXME
    ps ax |grep "$0"|grep -v grep|egrep -v "[[:space:]]$$[[:space:]]"
    return $?
}

function locked()
{
    # stupid. FIXME
    [ -f "$lockdir/$0.lock" ]; 
    return $?
}


function lock()
{
    # FIXME.    
#    if [ `locked "$0"` -eq "0" ] && [ `started "$0"` -eq "0" ] && [ "`getpid`" -ne "$$" ]; then
    if  locked && started; then
	error "Данный процесс уже запущен и заблокирован. Продолжение работы невозможно"
	return 1
    fi
#    if [ `locked "$0"` -eq "0" ] && [ `started "$0"` -ne "0" ]; then
    if locked && ! started; then
	warning "Данный процесс заблокирован, но не запущен. Продолжение работы возможно"
    fi
    echo $$ >$lockdir/"$0".lock
    return 0
}

function unlock()
{
    if [ ! -f "$lockdir/$0.lock" ]; then
	warning "Данный процесс не заблокирован"
    fi
    rm -f "$lockdir/$0.lock"
    return $?
}

function start()
{
    debug "Запуск $@"
    "$@" 2>&1 | log_stdin 
    return $PIPESTATUS
}


function my_exit()
{
    # FIXME
    # Add sending email with errors
    if [ ! -z "$errormsg" ]; then
	mail_errors
    fi
    info "Выход"
    log ""
    exit $@
}


