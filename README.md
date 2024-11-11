# Openvpn Generator OTP
Create systemd unit for automatic up vpn service without enter username password and key from Google Authenticator 

Getting started
------------
To use it automatically, you need to follow these steps

1. Open Google Authenticator and transfer your account by saving the QR image and reading the OTP migration code from it.
2. Get the base32_secret_key for otp you can use this program https://github.com/krissrex/google-authenticator-exporter and get totpSecret
3. Install [dependency](#Dependency)
4. [Installation service](#Create service)

# <span style="color: red;"> Attention</span>
Environment variables should not contain %, if it does, it must be escaped %% in the configuration file /etc/systemd/system/openvpn@<name>.service

Dependency
-----------
For use need install next packages: oath-toolkit, expect
```
# Arch
yay -S community/oath-toolkit
sudo pacman -S expect

# Debian/Ubuntu
sudo apt-get install oath-toolkit expect

# Centos
sudo dnf install -y oath-toolkit expect
```

Create service
------------
For create service use next command, replace config_name username password base32_secret_key replace it with your own
```
sudo ./create_service.sh config_name username password base32_secret_key
sudo systemctl enable openvpn@config_name.service
sudo systemctl start openvpn@config_name.service
```

Manual use
------------
Used only script, who create daemon process
```
sudo ./wrapper.sh config_name username password base32_secret_key
```

Other
------------
For Mac
https://ifritltd.com/2018/01/15/automating-vpn-connection-when-using-multifactor-authentication-with-tunnelblick-on-macos/
