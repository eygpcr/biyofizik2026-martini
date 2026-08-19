# `martinize2` — komut referansı

All-atom protein → Martini 3 kaba-taneli model + topoloji.

## Kurstaki komut

```bash
martinize2 \
  -f at2r.pdb \
  -o topol.top \
  -x at2r_cg.pdb \
  -ff martini3001 \
  -dssp \
  -elastic -ef 700 -el 0.5 -eu 0.9 -ea 0 -ep 0 \
  -maxwarn 10
```

## Bayraklar

| Bayrak | Ne yapar |
|---|---|
| `-f` | girdi (all-atom PDB) |
| `-x` | çıktı (kaba-taneli PDB) |
| `-o` | çıktı topolojisi (`.top`) |
| `-ff martini3001` | Martini 3 kuvvet alanı |
| `-dssp` | ikincil yapıyı DSSP ile belirle |
| `-ss <dizi>` | ikincil yapıyı elle ver (`-dssp` çalışmazsa) |
| `-elastic` | elastic network ekle |
| `-ef` | yay kuvvet sabiti (kJ/mol/nm²) — tipik 500–1000 |
| `-el` / `-eu` | yay mesafe alt/üst sınırı (nm) |
| `-ea` / `-ep` | açı/dihedral cezaları |
| `-p backbone` | omurga pozisyon kısıtı ekle |
| `-cys auto` | disülfitleri otomatik bul |

## Çıktılar

| Dosya | İçerik |
|---|---|
| `at2r_cg.pdb` | kaba-taneli koordinatlar |
| `topol.top` | ana topoloji (`#include` satırları) |
| `molecule_0.itp` | proteinin topolojisi — elastic network burada |

## Elastic network ayarı

`-ef` değerini seçerken:

| Değer | Sonuç |
|---|---|
| < 300 | yapı açılabilir |
| **500–1000** | tipik aralık — kursta 700 kullandık |
| > 1500 | protein neredeyse rijit; esneklik bilgisi kaybolur |

> ⚠️ Elastic network protein yapısını **dondurur**. Katlanma, açılma ve büyük
> konformasyonel değişim çalışamazsınız. Bu, Martini'nin bilinçli bir ödünüdür.

📖 [Resmî tutorial](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut1.html)
