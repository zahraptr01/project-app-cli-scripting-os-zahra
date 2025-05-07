#!/bin/bash

# Warna output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Array untuk menyimpan daftar tugas
declare -a todo_list

# Fungsi untuk menampilkan menu
function show_menu() {
    echo -e "${BLUE}====== Aplikasi To-Do List ======${NC}"
    echo "1. Tambah Tugas"
    echo "2. Tampilkan Tugas"
    echo "3. Hapus Tugas"
    echo "4. Keluar"
}

# Fungsi untuk menambahkan tugas
function add_task() {
    read -p "Masukkan nama tugas: " task

    # Validasi input tidak boleh kosong
    if [[ -z "$task" ]]; then
        echo -e "${RED}Tugas tidak boleh kosong!${NC}"
        return
    fi

    # Cek duplikat
    for i in "${todo_list[@]}"; do
        if [[ "$i" == "$task" ]]; then
            echo -e "${YELLOW}Tugas sudah ada di daftar!${NC}"
            return
        fi
    done

    todo_list+=("$task")
    echo -e "${GREEN}Tugas berhasil ditambahkan!${NC}"
}

# Fungsi untuk menampilkan semua tugas
function show_tasks() {
    echo -e "${BLUE}===== Daftar Tugas =====${NC}"
    if [[ ${#todo_list[@]} -eq 0 ]]; then
        echo -e "${YELLOW}Belum ada tugas.${NC}"
        return
    fi

    for i in "${!todo_list[@]}"; do
        echo -e "$((i+1)). ${todo_list[$i]}"
    done
}

# Fungsi untuk menghapus tugas
function delete_task() {
    read -p "Masukkan nomor tugas yang ingin dihapus: " num

    if ! [[ "$num" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Input harus berupa angka!${NC}"
        return
    fi

    index=$((num-1))

    if [[ $index -lt 0 || $index -ge ${#todo_list[@]} ]]; then
        echo -e "${RED}Nomor tugas tidak valid.${NC}"
        return
    fi

    unset todo_list[$index]

    # Re-index array agar tidak ada gap
    todo_list=("${todo_list[@]}")

    echo -e "${GREEN}Tugas berhasil dihapus.${NC}"
}

# Program utama (loop menu)
while true; do
    show_menu
    read -p "Pilih menu [1-4]: " choice

    case $choice in
        1) add_task ;;
        2) show_tasks ;;
        3) delete_task ;;
        4) echo -e "${YELLOW}Terima kasih telah menggunakan aplikasi!${NC}"; break ;;
        *) echo -e "${RED}Pilihan tidak valid.${NC}" ;;
    esac
    echo ""
done
