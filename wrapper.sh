#!/usr/bin/env bash

_name=${OPENVPN_CONFIG_NAME:-$1}
_user=${OPENVPN_USER:-$2}
_password=${OPENVPN_PASSWORD:-$3}
_key=${OPENVPN_OTPKEY:-$4}

_expect_user=${OPENVPN_EXPECT_USER:-"Enter Auth Username*"}
_expect_password=${OPENVPN_EXPECT_PASSWORD:-"Enter Auth Password*"}
_expect_otpkey=${OPENVPN_EXPECT_OTPKEY:-"*Enter One Time Password*"}

[[ $(id -u) != 0 ]] && echo "\nNeed to be root!" && exit -1

[[ -z "${_name}" || -z "${_user}" || -z "${_password}" || -z "${_key}" ]] && echo -e "\nNeed start with options:\n  sudo $0 configName username password base32SecretKey" && exit -1

_path=/etc/openvpn
_conf=${_path}/${_name}.conf
_daemon=openvpn@${_name}
_writepid=/run/openvpn@${_name}.pid
_totp=$(oathtool --base32 --totp ${_key})
_ssec=2

[[ ! -f ${_conf} ]] && echo -e "\n${_conf} configuration file not exist.\n" && exit -1

[[ -f /proc/$(cat ${_writepid})/status ]] && echo -e "\nProcess exist." && exit -1

/usr/bin/expect <<EOD
spawn openvpn --cd ${_path} --script-security ${_ssec} --config ${_conf} --writepid ${_writepid} --auth-user-pass --daemon ${_daemon}

expect "${_expect_user}" {send -- "${_user}\r"}
expect "${_expect_password}" {send -- "${_password}\r"}
expect "${_expect_otpkey}" {send -- "${_totp}\r"}
expect eof
EOD
