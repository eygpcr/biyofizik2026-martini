#!/usr/bin/env bash
#
# Kurulan sistemin simulasyona hazirlanmasi
# Biyofizik 2026 Kursu - Oturum 6
#
# Kaynak: https://cgmartini.nl/docs/tutorials/Martini3/Bentopy/
#
# NOT: Kursta uretim simulasyonu kosulmamaktadir. Bu betik, kurulan
# sistemin dogrudan kullanilabilir oldugunu gostermek amaciyla verilmistir.
#
set -euo pipefail

# --- Enerji minimizasyonu ----------------------------------------------------
gmx grompp -f mdp_files/em.mdp -c solvated_system.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em

# --- Indeks gruplarinin tanimlanmasi -----------------------------------------
gmx make_ndx -f em.gro -o index.ndx <<'NDX'
name 13 Lipid
r W | r ION
name 16 Solvent
q
NDX

# --- Dengeleme ---------------------------------------------------------------
gmx grompp -f mdp_files/eq.mdp -c em.gro -p topol.top -o eq.tpr -n index.ndx
gmx mdrun -v -deffnm eq

# --- Uretim simulasyonu ------------------------------------------------------
gmx grompp -f mdp_files/md.mdp -c eq.gro -p topol.top -o md.tpr -n index.ndx
gmx mdrun -v -deffnm md
