#!/bin/bash
clear
function hasil_penemuan() {
mapfile -t lines < bangkalan
found=0
tgl_lama=""
wkwk=""
for (( i=0; i<${#lines[@]}; i++ )); do
    line="${lines[$i]}"
    # Mengekstrak nama, tanggal, dan IP dari baris
    name=$(echo "$line" | awk '{print $2}')
    date_lama=$(echo "$line" | awk '{print $3}')
    ip_lama=$(echo "$line" | awk '{print $4}')
    if [[ "$ip_lama" == "$ip" ]]; then
        wkwk=$(date -d "$date_lama + 0 days" +%Y-%m-%d)
        found=1
        tgl_lama=$date_lama
        break
    fi
done
echo -e "### $name $wkwk $ip_lama"
}

# Membaca IP dari pengguna
echo -e ""
echo -e "MENU RENEW IZIN IP"
echo -e ""
read -p "Masukkan IP: " ip
hasil_penemuan
read -p "Masukkan jumlah hari pengurangan: " days

# Menyimpan konten file ke dalam array
mapfile -t lines < bangkalan

# Menandai apakah IP ditemukan atau tidak
found=0
old_date=""
new_date=""

# Loop melalui setiap baris dalam array
for (( i=0; i<${#lines[@]}; i++ )); do
    line="${lines[$i]}"
    # Mengekstrak nama, tanggal, dan IP dari baris
    name=$(echo "$line" | awk '{print $2}')
    current_date=$(echo "$line" | awk '{print $3}')
    current_ip=$(echo "$line" | awk '{print $4}')

    # Memeriksa apakah IP cocok dengan IP yang diberikan
    if [[ "$current_ip" == "$ip" ]]; then
        # Mengubah tanggal dengan menambahkan jumlah hari
        new_date=$(date -d "$current_date - $days days" +%Y-%m-%d)
        # Mengganti tanggal pada baris
        lines[$i]="${lines[$i]/$current_date/$new_date}"
        found=1
        old_date=$current_date
        break
    fi
done

# Menulis kembali konten yang telah diubah ke file
printf "%s\n" "${lines[@]}" > bangkalan

if [[ $found -eq 1 ]]; then
    echo "Tanggal berhasil diubah untuk IP $ip."
    echo "Tanggal lama: $old_date"
    echo "Tanggal baru: $new_date"
else
    echo "IP $ip tidak ditemukan dalam file."
fi
