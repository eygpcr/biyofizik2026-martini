#!/usr/bin/env bash
#
# Oturum 6 - bentopy ile kalabalik hucresel sistem kurulumu
# Biyofizik 2026 Kursu
#
# Kaynak: https://cgmartini.nl/docs/tutorials/Martini3/Bentopy/
#
# Bu betik tutorial_files/ dizini icinden calistirilmalidir.
#
set -euo pipefail

# --- Kurulum (bir kez calistirilmasi yeterlidir) ------------------------------
# pip install bentopy
#
# Tutorial dosyalari:
# wget https://cgmartini-library.s3.ca-central-1.amazonaws.com/0_Tutorials/m3_tutorials/Bentopy/tutorial_files.tar.gz
# tar -xzf tutorial_files.tar.gz && cd tutorial_files

# =============================================================================
# UYGULAMA 1 - Kutu icinde protein paketleme
# =============================================================================
bentopy-pack simple_packing.bent placements.json
bentopy-render placements.json system.gro -t topol.top
bentopy-solvate -i system.gro -o solvated_system.gro \
    -s NA:0.15M -s CL:0.15M \
    --charge neutral \
    -t topol.top

# =============================================================================
# UYGULAMA 2 - Membran cevresinde konuma bagli paketleme
# =============================================================================
# Maskenin uretilmesi
bentopy-mask structures/membrane.gro --visualize-labels labels.gro
bentopy-mask structures/membrane.gro -l 1:membrane_mask.npz

bentopy-pack membrane_packing.bent placements.json
bentopy-render placements.json packed_proteins.gro -t topol.top
bentopy-merge packed_proteins.gro structures/membrane.gro -o system.gro

# Birlestirilen membranin lipit sayisi topolojiye elle eklenmelidir
echo "POPC    5408" >> topol.top

bentopy-solvate -i system.gro -o solvated_system.gro -t topol.top \
    -s NA:0.15M -s CL:0.15M --charge neutral

# =============================================================================
# UYGULAMA 3 - Cok bolmeli sistem
# =============================================================================
bentopy-mask structures/double_membrane.gro -b compartment_labels.gro
bentopy-mask structures/double_membrane.gro \
    -l  -1:A_mask.npz \
    -l  -2:B_mask.npz \
    -l 1,2:membrane_mask.npz

bentopy-pack compartment_packing.bent placements.json
bentopy-render placements.json packed_proteins.gro -t topol.top
bentopy-merge packed_proteins.gro structures/double_membrane.gro -o system.gro
echo "POPC    10816" >> topol.top
bentopy-solvate -i system.gro -o solvated_system.gro -t topol.top \
    -s NA:0.15M -s CL:0.15M --charge neutral
