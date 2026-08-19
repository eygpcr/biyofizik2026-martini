#!/usr/bin/env bash
# Oturum 6 - bentopy ile kalabalik sistem kurulumu
# Biyofizik 2026 Kursu
set -euo pipefail

# --- Kurulum (bir kez) -------------------------------------------------------
# pip install bentopy
# apt-get install -y gromacs

# --- Girdi -------------------------------------------------------------------
# Oturum 4'te uretilen kaba-taneli yapiyi .gro formatina cevir
gmx editconf -f at2r_cg.pdb -o at2r_cg.gro -d 0.5

# --- 1. Yerlesim planini uret ------------------------------------------------
# yerlesim.json icinde kutu boyutu ve kopya sayisi tanimli
bentopy pack yerlesim.json -o plan.json

# --- 2. Plandan koordinatlari uret -------------------------------------------
bentopy render plan.json -o kalabalik.gro -t kalabalik.top

# --- 3. Boslugu su ve iyonla doldur ------------------------------------------
bentopy solvate -f kalabalik.gro -o sistem_kalabalik.gro

echo "Bitti. Toplam parcacik:"
sed -n '2p' sistem_kalabalik.gro
