#!/bin/sh
# React on SMB messages and do work ;-)

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


egrep CALL$ $1;

if [ $? -eq 0 ]; then
		info "Calling Office"
		start sudo killpppd.sh;
		start /usr/sbin/pppd call office
		if [ $? -eq 0 ]; then
				start smbclient -M $pgtwks01 -I $pgtwks01ip <<EOF
		ВНИМАНИЕ!
Связь с офисом установлена, начинайте проведение накладных.
После окончания не забудьте прервать соединение!
EOF
				start smbclient -M $pgtwks02 -I $pgtwks02ip <<EOF
		ВНИМАНИЕ!
Связь с офисом установлена, начинайте проведение накладных.
После окончания не забудьте прервать соединение!
EOF
		else
				start smbclient -M $pgtwks01 -I $pgtwks01ip <<EOF
		ВНИМАНИЕ!
Связь с офисом НЕ установлена, повторите попытку.
EOF
				start smbclient -M $pgtwks02 -I $pgtwks02ip <<EOF
		ВНИМАНИЕ!
Связь с офисом НЕ установлена, повторите попытку.
EOF
		fi
		exit
fi

egrep HANGUP$ $1;
if [ $? -eq 0 ]; then
	info "Hanging up"
	start sudo killpppd.sh;
	if [ $? -eq 0 ]; then
			smbclient -M $pgtwks01 -I $pgtwks01ip <<EOF
		ВНИМАНИЕ!
Связь с офисом прервана, можно пользоваться телефоном.
EOF
			smbclient -M $pgtwks02 -I $pgtwks02ip <<EOF
		ВНИМАНИЕ!
Связь с офисом прервана, можно пользоваться телефоном.
EOF

	fi

	exit
fi

grep ^MAIL$ $1;
if [ $? -eq 0 ]; then
		info "Checking mail"
		start sudo killuucico.sh;
		start /usr/local/bin/callmail.sh
		if [ $? -eq 0 ]; then
				smbclient -M $pgtwks01 -I $pgtwks01ip <<EOF
		ВНИМАНИЕ!
Проверка почты закончена, нажмите в почтовой программе кнопку "Получить"
для проверки новой почты
EOF
				smbclient -M $pgtwks02 -I $pgtwks02ip <<EOF
		ВНИМАНИЕ!
Проверка почты закончена, нажмите в почтовой программе кнопку "Получить"
для проверки новой почты
EOF
		else
				smbclient -M $pgtwks01 -I $pgtwks01ip <<EOF
		ВНИМАНИЕ!
Ошибка проверка почты, повторите попытку.
EOF
				smbclient -M $pgtwks02 -I $pgtwks02ip <<EOF
		ВНИМАНИЕ!
Ошибка проверка почты, повторите попытку.
EOF
		fi
		exit

fi


grep HANGUPMAIL$ $1;
if [ $? -eq 0 ]; then
	info "Hanging up mail"
	start sudo killuucico.sh;
	if [ $? -eq 0 ]; then
			smbclient -M $pgtwks01 -I $pgtwks01ip <<EOF
		ВНИМАНИЕ!
Получение почты прервано, можно пользоваться телефоном.
EOF
			smbclient -M $pgtwks02 -I $pgtwks02ip <<EOF
		ВНИМАНИЕ!
Получение почты прервано, можно пользоваться телефоном.
EOF

	fi
	exit

fi

exit

