#!/bin/bash
clear

# bismillah bisa buat
# variable
file=bangkalan

# perintah masukan
echo -e ""
echo -e "MENU DELETE IZIN IP BY ALAWIVPN"
echo -e ""
read -rp "Masukkan ip: " ip
echo -e ""

# proses deleting
sed -i "/$ip/d" $file
echo -e "Ip $ip berhasil dihapus"
