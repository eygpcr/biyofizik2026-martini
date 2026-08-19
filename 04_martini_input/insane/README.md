# `insane` — komut referansı

Membran inşa eder, proteini gömer, su ve iyon ekler.
*(INSert membrANE)*

## Kurstaki komut

```bash
insane \
  -f at2r_cg.pdb \
  -o sistem.gro \
  -p sistem_insane.top \
  -pbc square \
  -box 12,12,14 \
  -l POPC:1 \
  -sol W \
  -salt 0.15 \
  -center \
  -dm 0
```

## Bayraklar

| Bayrak | Ne yapar |
|---|---|
| `-f` | gömülecek protein (kaba-taneli) |
| `-o` | çıktı koordinat dosyası |
| `-p` | çıktı topolojisi *(eksik `#include`'ları siz ekleyeceksiniz)* |
| `-box x,y,z` | kutu boyutu (nm) |
| `-pbc` | kutu tipi: `square`, `rectangular`, `hexagonal`, `cubic` |
| `-l LIPID:oran` | lipid kompozisyonu — birden çok kez yazılabilir |
| `-u LIPID:oran` | **üst** yaprakçık (asimetrik membran için) |
| `-sol W` | çözücü — `W` standart Martini suyu |
| `-salt 0.15` | tuz derişimi (M) |
| `-center` | proteini kutuya ortala |
| `-dm` | proteinin membrana göre z kayması (nm) |
| `-d` | protein ile kutu kenarı arası mesafe (nm) |

## Lipid kompozisyonu örnekleri

```bash
# Basit, standart membran
-l POPC:1

# Plazma membranına daha yakın
-l POPC:7 -l POPE:2 -l CHOL:1

# Asimetrik çift tabaka (alt / üst yaprakçık farklı)
-l POPC:7 -l POPS:3  -u POPC:9 -l CHOL:1
```

## ⚠️ En sık yapılan hata

`insane`'in ürettiği `.top` dosyası **eksiktir** — kuvvet alanı `#include`
satırları yoktur, protein molekülünün adı `martinize2`nin ürettiğiyle
uyuşmayabilir. Doğrusunu elle yazmanız gerekir:

```
#include "martini_v3.0.0.itp"
#include "martini_v3.0.0_solvents_v1.itp"
#include "martini_v3.0.0_ions_v1.itp"
#include "martini_v3.0.0_phospholipids_v1.itp"
#include "molecule_0.itp"

[ system ]
AT2R in POPC membrane (Martini 3)

[ molecules ]
molecule_0    1
POPC        256
W          8000
NA           25
CL           25
```

> 💡 Notebook'taki 6. bölüm bu düzeltmeyi otomatik yapıyor.

📖 [Resmî tutorial](https://cgmartini.nl/docs/tutorials/Martini3/LipidsII/)
