#!/usr/bin/env bash
#
# Oturum 6 — bentopy ile kalabalik hucresel sistem kurulumu
# Biyofizik 2026 Kursu, 25 Agustos 2026
#
set -euo pipefail

# --- Kurulum (bir kez calistirilmasi yeterlidir) ------------------------------
# pip install bentopy
# apt-get install -y gromacs

# --- Girdinin hazirlanmasi ---------------------------------------------------
# Oturum 4'te uretilen kaba-taneli yapi GRO bicimine donusturulur
gmx editconf -f at2r_cg.pdb -o at2r_cg.gro -d 0.5

# --- 1. Yerlesim planinin uretilmesi -----------------------------------------
# Kutu boyutu ve kopya sayisi yerlesim.json dosyasinda tanimlidir
bentopy pack yerlesim.json -o plan.json

# --- 2. Plandan koordinatlarin uretilmesi ------------------------------------
bentopy render plan.json -o kalabalik.gro -t kalabalik.top

# --- 3. Boslugun cozucu ve iyonlarla doldurulmasi ----------------------------
bentopy solvate -f kalabalik.gro -o sistem_kalabalik.gro

echo "Islem tamamlandi. Toplam parcacik sayisi:"
sed -n '2p' sistem_kalabalik.gro
