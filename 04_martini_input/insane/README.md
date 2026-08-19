# `insane` — Komut Referansı

Lipit çift tabakasının inşası, proteinin yerleştirilmesi, çözücü ve iyon
eklenmesi. *(INSert membrANE)*

## Oturumda kullanılan komut

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

## Parametreler

| Parametre | İşlevi |
|---|---|
| `-f` | Yerleştirilecek protein (kaba-taneli) |
| `-o` | Çıktı koordinat dosyası |
| `-p` | Çıktı topolojisi (`#include` yönergeleri kullanıcı tarafından eklenmelidir) |
| `-box x,y,z` | Kutu boyutları (nm) |
| `-pbc` | Kutu geometrisi: `square`, `rectangular`, `hexagonal`, `cubic` |
| `-l LIPİT:oran` | Lipit bileşimi; birden çok kez tanımlanabilir |
| `-u LIPİT:oran` | Üst yaprakçık bileşimi (asimetrik çift tabaka için) |
| `-sol W` | Çözücü modeli; `W` standart Martini suyunu belirtmektedir |
| `-salt 0.15` | Tuz derişimi (M) |
| `-center` | Proteinin kutu merkezine yerleştirilmesi |
| `-dm` | Proteinin membran düzlemine göre z ekseninde ötelenmesi (nm) |
| `-d` | Protein ile kutu sınırı arasındaki asgari mesafe (nm) |

## Lipit bileşimi örnekleri

```bash
# Tek bileşenli referans membran
-l POPC:1

# Plazma membranı bileşimine yaklaştırılmış karışım
-l POPC:7 -l POPE:2 -l CHOL:1

# Asimetrik çift tabaka (alt ve üst yaprakçık farklı bileşimde)
-l POPC:7 -l POPS:3 -u POPC:9 -u CHOL:1
```

## Sık karşılaşılan sorun

`insane` tarafından üretilen topoloji dosyası eksiktir. Kuvvet alanı `#include`
yönergeleri bulunmamakta ve protein molekülünün adı `martinize2` çıktısıyla
uyuşmayabilmektedir. Dosyanın aşağıdaki biçimde tamamlanması gerekmektedir:

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

Colab not defterinin altıncı bölümü bu düzeltmeyi otomatik olarak
gerçekleştirmektedir.

## Kaynak

[Modeling Complex Lipid Membranes — INSANE](https://cgmartini.nl/docs/tutorials/Martini3/LipidsII/)
