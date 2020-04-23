# Openvpn Generator OTP
Create systemd unit for automatic up vpn service without enter username password and key from Google Authenticator 

Getting started
------------
To use it automatically, you need to install dependencies and create a service, which are described in the dependencies and installation section

Dependency
-----------
For use need install next packages: oath-toolkit, expect
```
# Arch linux
yay -S community/oath-toolkit
sudo pacman -S expect

# Debian/Ubuntu
sudo apt-get install oath-toolkit expect
```

Installation service
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
