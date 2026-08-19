# `martinize2` — Komut Referansı

Atomistik protein yapısının Martini 3 kaba-taneli modeline ve topolojisine
dönüştürülmesi.

## Oturumda kullanılan komut

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

## Parametreler

| Parametre | İşlevi |
|---|---|
| `-f` | Girdi dosyası (atomistik PDB) |
| `-x` | Çıktı dosyası (kaba-taneli PDB) |
| `-o` | Çıktı topolojisi (`.top`) |
| `-ff martini3001` | Martini 3 kuvvet alanı |
| `-dssp` | İkincil yapının DSSP ile belirlenmesi |
| `-ss <dizi>` | İkincil yapının doğrudan tanımlanması (`-dssp` kullanılamadığında) |
| `-elastic` | Elastik ağ tanımlanması |
| `-ef` | Yay kuvvet sabiti (kJ mol⁻¹ nm⁻²) |
| `-el` / `-eu` | Yay tanımlanacak mesafe aralığının alt ve üst sınırı (nm) |
| `-ea` / `-ep` | Açı ve dihedral ceza terimleri |
| `-p backbone` | Omurga üzerinde konum kısıtı tanımlanması |
| `-cys auto` | Disülfit köprülerinin otomatik belirlenmesi |

## Çıktı dosyaları

| Dosya | İçeriği |
|---|---|
| `at2r_cg.pdb` | Kaba-taneli koordinatlar |
| `topol.top` | Ana topoloji dosyası (`#include` yönergeleri) |
| `molecule_0.itp` | Protein topolojisi; elastik ağ tanımı bu dosyada yer almaktadır |

## Elastik ağ kuvvet sabitinin seçimi

| `-ef` değeri | Beklenen davranış |
|---|---|
| < 300 | Yapısal bütünlük korunamayabilir |
| 500–1000 | Yaygın kullanılan aralık; oturumda 700 değeri kullanılmıştır |
| > 1500 | Model neredeyse rijit hâle gelmekte, esneklik bilgisi kaybolmaktadır |

**Dikkat.** Elastik ağ protein yapısını kısıtlamaktadır. Katlanma, açılma ve
büyük ölçekli konformasyonel değişim süreçleri bu yaklaşımla incelenememektedir.
Bu, Martini modelinin bilinçli bir yöntemsel ödünüdür.

## Kaynak

[Martini Protein Model — Using Martinize2](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut1.html)
