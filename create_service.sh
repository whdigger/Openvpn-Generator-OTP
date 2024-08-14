#!/usr/bin/env bash

_config_name=$1
_user=$2
_password=$3
_key=$4
_conf=/etc/openvpn/${_config_name}.conf

[[ $(id -u) != 0 ]] && echo -e "\nNeed to be root!" && exit -1

[[ ! -x "$(which oathtool)" ]] && echo -e "\nNeed install package: oath-toolkit" && exit -1

[[ ! -x "$(which expect)" ]] && echo -e "\nNeed install package: expect" && exit -1

[[ -z "${_config_name}" || -z "${_user}" || -z "${_password}" || -z "${_key}" ]] && echo -e "\nNeed start with options:\n  sudo $0 configName username password base32SecretKey" && exit -1

[[ ! -f ${_conf} ]] && echo -e "\n${_conf} configuration file not exist.\n" && exit -1

cp wrapper.sh /usr/bin/openvpn_wrapper
chmod +x /usr/bin/openvpn_wrapper

cat << EOF > /etc/systemd/system/openvpn@${_config_name}.service
[Unit]
Description=OpenVPN connection to %i

[Service]
Environment="OPENVPN_USER=${_user}"
Environment="OPENVPN_PASSWORD=${_password}"
Environment="OPENVPN_OTPKEY=${_key}"
Environment="OPENVPN_CONFIG_NAME=${_config_name}"
Type=forking
ExecStart=/usr/bin/openvpn_wrapper
PIDFile=/run/openvpn@%i.pid
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

chmod 600 /etc/systemd/system/openvpn@${_config_name}.service

