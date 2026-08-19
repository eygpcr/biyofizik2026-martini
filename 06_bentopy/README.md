# Oturum 6 — `bentopy` ile Kalabalık Hücresel Sistemler

**Dr. Öğr. Üyesi Ekrem Yaşar**

Colab not defteri: [`notebooks/06_bentopy.ipynb`](../notebooks/06_bentopy.ipynb)
Uygulama kaydı: [`VIDEO.md`](VIDEO.md)

Bu oturumda Martini resmî öğretim materyali doğrudan uygulanmaktadır:
**[Bentopy Tutorial — cgmartini.nl](https://cgmartini.nl/docs/tutorials/Martini3/Bentopy/)**

---

## Kurs boyunca izlenen ölçek gelişimi

| Oturum | Sistem | Karakteristik uzunluk |
|---|---|---|
| 2 | Çözelti içinde tek lizozim molekülü | yaklaşık 5 nm |
| 3 | Membranda tek reseptör, atomistik | yaklaşık 10 nm |
| 4 | Membranda tek reseptör, kaba-taneli | yaklaşık 12 nm |
| 6 | Kalabalık, çok bölmeli hücresel sistem | 40 nm |

Kursun başlığında yer alan "büyük ve kalabalık hücresel sistemler" ifadesi bu
oturumun konusunu oluşturmaktadır.

Oturumda kullanılan model proteinlerden biri lizozimdir; Oturum 2'de atomistik
olarak hazırlanan sistemin kaba-taneli karşılığı burada yüzlerce kopya hâlinde
kullanılmaktadır.

---

## Kalabalık ortam koşullarının önemi

Moleküler simülasyonların büyük bölümü proteinleri seyreltik çözelti koşullarında
incelemektedir. Hücre içi ortam bu varsayımdan belirgin biçimde ayrılmaktadır:

- Sitoplazmada toplam makromolekül derişimi yaklaşık 300 g/L düzeyindedir; hacmin
  %20–30'u makromoleküller tarafından işgal edilmektedir.
- Biyolojik membranlarda protein/lipit oranı yüksektir; membran proteinleri
  birbirleriyle doğrudan temas edecek yoğunlukta bulunmaktadır.
- Kalabalık koşulları difüzyonu yavaşlatmakta, bağlanma dengelerini kaydırmakta,
  katlanma ve oligomerizasyon süreçlerini etkilemektedir.

**Yöntemsel güçlük.** Çok sayıda makromolekülün çakışma oluşturmadan, uygun
yönelimlerle, hedeflenen derişimde ve belirli hücresel bölmelere yerleştirilmesi
elle yapılabilecek bir işlem değildir.

**Çözüm.** [`bentopy`](https://github.com/marrink-lab/bentopy)

---

## `bentopy` bileşenleri

`bentopy` tek bir komut değil, birlikte kullanılan bir araç kümesidir:

| Komut | İşlevi |
|---|---|
| `bentopy-mask` | Var olan bir yapıdan (örneğin membran) bölme maskeleri üretilmesi |
| `bentopy-pack` | Yapıların tanımlanan bölmelere çakışmasız olarak yerleştirilmesi |
| `bentopy-render` | Yerleşim planından koordinat ve topoloji dosyalarının üretilmesi |
| `bentopy-merge` | Paketlenen yapıların var olan bir sistemle (membran) birleştirilmesi |
| `bentopy-solvate` | Kalan boşluğun çözücü ve iyonlarla doldurulması |

Yerleşim, `.bent` uzantılı bir yapılandırma dosyasıyla tanımlanmaktadır. Bu dosya
`[ general ]`, `[ space ]`, `[ includes ]`, `[ compartments ]` ve `[ segments ]`
bölümlerinden oluşmaktadır.

Söz dizimi başvurusu:
[Reference for `.bent` files](https://github.com/marrink-lab/bentopy/wiki/Reference-for-bent)

---

## Kurulum ve tutorial dosyaları

```bash
pip install bentopy
```

Önceden derlenmiş paketin kurulamaması hâlinde Rust derleyicisi
([rustup](https://rustup.rs/)) gerekmektedir.

Tutorial dosyaları (yapılar, topolojiler, `.mdp` dosyaları):

```bash
wget https://cgmartini-library.s3.ca-central-1.amazonaws.com/0_Tutorials/m3_tutorials/Bentopy/tutorial_files.tar.gz
tar -xzf tutorial_files.tar.gz
cd tutorial_files
```

Arşiv içeriği:

```
tutorial_files/
├── structures/     lysozyme.pdb, ubiquitin.pdb, membrane.gro, double_membrane.gro
├── topology/       Martini 3 kuvvet alanı dosyaları, lysozyme.itp, ubiquitin.itp
└── mdp_files/      em.mdp, eq.mdp, md.mdp
```

---

## Uygulama 1 — Kutu içinde protein paketleme

Sitoplazmik yoğunlukta, homojen dağılımlı bir protein sistemi kurulmaktadır.

**Yapılandırma dosyası** (`simple_packing.bent`):

```
[ general ]
title "Proteins in a box"
seed 0

[ space ]
dimensions 40, 40, 40
resolution 0.5

[ includes ]
"topology/martini_v3.0.0.itp"
"topology/martini_v3.0.0_ions_v1.itp"
"topology/martini_v3.0.0_solvents_v1.itp"
"topology/lysozyme.itp"

[ compartments ]
system is all

[ segments ]
LYZ 650 from "structures/lysozyme.pdb" in system
```

**Komutlar:**

```bash
bentopy-pack simple_packing.bent placements.json
bentopy-render placements.json system.gro -t topol.top
bentopy-solvate -i system.gro -o solvated_system.gro \
    -s NA:0.15M -s CL:0.15M \
    --charge neutral \
    -t topol.top
```

**Sonuç.** 40 × 40 × 40 nm boyutlarında bir kutu içinde 650 lizozim molekülü,
sitoplazmik derişime karşılık gelen yoğunlukta dağıtılmış olarak elde
edilmektedir.

**Tartışma sorusu.** Oturum 2'de tek bir lizozim molekülü için kurulan sistemin
atom sayısı ile bu sistemin parçacık sayısı karşılaştırıldığında hangi ölçek
farkı ortaya çıkmaktadır?

---

## Uygulama 2 — Membran çevresinde konuma bağlı paketleme

Bu uygulamada proteinler yalnızca sayıca değil, konumsal kurala göre de
yerleştirilmektedir: bir protein türü çözücü hacmine dağıtılırken, diğeri yalnızca
membran yüzeyine yakın bölgede konumlandırılmaktadır.

**Maskenin üretilmesi.** Var olan bir membran yapısından bölme maskesi
çıkarılmaktadır:

```bash
bentopy-mask structures/membrane.gro --visualize-labels labels.gro
bentopy-mask structures/membrane.gro -l 1:membrane_mask.npz
```

İlk komut etiketlemenin görsel olarak denetlenmesini sağlamakta, ikinci komut
kullanılacak maske dosyasını üretmektedir.

**Yapılandırma dosyası** (`membrane_packing.bent`):

```
[ general ]
title "Proteins around a membrane"
seed 0

[ space ]
dimensions 40, 40, 40
resolution 0.5

[ includes ]
"topology/martini_v3.0.0.itp"
"topology/martini_v3.0.0_ions_v1.itp"
"topology/martini_v3.0.0_solvents_v1.itp"
"topology/martini_v3.0.0_phospholipids_v1.itp"
"topology/lysozyme.itp"
"topology/ubiquitin.itp"

[ compartments ]
membrane from "membrane_mask.npz"
solvent combines not membrane
close-to-membrane around 5 of membrane

[ segments ]
LYZ:lyz 300 from "structures/lysozyme.pdb" in solvent
UBQ:ubq 100 from "structures/ubiquitin.pdb" in close-to-membrane
```

**Komutlar:**

```bash
bentopy-pack membrane_packing.bent placements.json
bentopy-render placements.json packed_proteins.gro -t topol.top
bentopy-merge packed_proteins.gro structures/membrane.gro -o system.gro
echo "POPC    5408" >> topol.top
bentopy-solvate -i system.gro -o solvated_system.gro -t topol.top \
    -s NA:0.15M -s CL:0.15M --charge neutral
```

**Dikkat.** `bentopy-merge` işleminden sonra lipit sayısının topoloji dosyasına
elle eklenmesi gerekmektedir; birleştirilen membran yapısı `bentopy` tarafından
üretilmediğinden topolojide otomatik olarak yer almamaktadır.

**Kavramsal not.** `[ compartments ]` bölümündeki `around 5 of membrane` tanımı,
membran yüzeyinden 5 nm mesafedeki hacmi ayrı bir bölme olarak tanımlamaktadır.
Bu yaklaşım, periferik membran proteinlerinin fizyolojik dağılımının
modellenmesine olanak vermektedir.

---

## Uygulama 3 — Çok bölmeli sistem

Çift membranla ayrılmış iki bölme tanımlanmakta ve her bölmeye farklı protein
yerleştirilmektedir. Süre elverdiği takdirde yürütülecektir.

**Maskelerin üretilmesi:**

```bash
bentopy-mask structures/double_membrane.gro -b compartment_labels.gro
bentopy-mask structures/double_membrane.gro \
    -l  -1:A_mask.npz \
    -l  -2:B_mask.npz \
    -l 1,2:membrane_mask.npz
```

**Yapılandırma dosyası** (`compartment_packing.bent`):

```
[ general ]
title "Proteins in different compartments"
seed 0

[ space ]
dimensions 40, 40, 40
resolution 0.5

[ includes ]
"topology/martini_v3.0.0.itp"
"topology/martini_v3.0.0_ions_v1.itp"
"topology/martini_v3.0.0_solvents_v1.itp"
"topology/martini_v3.0.0_phospholipids_v1.itp"
"topology/lysozyme.itp"
"topology/ubiquitin.itp"

[ compartments ]
membrane from "membrane_mask.npz"
A from "A_mask.npz"
B from "B_mask.npz"
membrane-neighborhood around 4 of membrane
B-close-to-membrane combines membrane-neighborhood and B

[ segments ]
LYZ:lyz 200 from "structures/lysozyme.pdb" in A
UBQ:ubq 100 from "structures/ubiquitin.pdb" in B-close-to-membrane
```

**Komutlar:**

```bash
bentopy-pack compartment_packing.bent placements.json
bentopy-render placements.json packed_proteins.gro -t topol.top
bentopy-merge packed_proteins.gro structures/double_membrane.gro -o system.gro
echo "POPC    10816" >> topol.top
bentopy-solvate -i system.gro -o solvated_system.gro -t topol.top \
    -s NA:0.15M -s CL:0.15M --charge neutral
```

---

## Kurulan sistemin simülasyona hazırlanması

Kursta üretim simülasyonu koşulmamaktadır. Tutorial'da yer alan simülasyon
adımları, kurulan sistemin doğrudan kullanılabilir olduğunu göstermek amacıyla
[`kodlar/simulasyon.sh`](kodlar/simulasyon.sh) dosyasında verilmiştir:
enerji minimizasyonu, indeks grubu tanımlanması, dengeleme ve üretim aşamaları.

---

## Uygulama planı

`bentopy` kurulumunda ortam kaynaklı sorunlar oluşabilmektedir. Bu nedenle iki
senaryo öngörülmüştür:

**Birinci senaryo.** Kurulum sorunsuz tamamlanırsa Uygulama 1 ve Uygulama 2
birlikte yürütülecek, süre elverdiği takdirde Uygulama 3'e geçilecektir.

**İkinci senaryo.** Sorun yaşanması hâlinde uygulama sonlandırılarak aşağıdaki
materyaller katılımcılarla paylaşılacaktır:

- Tüm komutlar ve `.bent` yapılandırma dosyaları: [`kodlar/`](kodlar/)
- Uygulamanın tam kaydı: [`VIDEO.md`](VIDEO.md)
- Önceden üretilmiş çıktı dosyaları

Her iki durumda da katılımcılar çalışan bir örnek ile kursu tamamlayacaklardır.

---

## Kaynaklar

- [Bentopy Tutorial — cgmartini.nl](https://cgmartini.nl/docs/tutorials/Martini3/Bentopy/)
- [bentopy deposu](https://github.com/marrink-lab/bentopy) ve
  [wiki](https://github.com/marrink-lab/bentopy/wiki)
- [`.bent` dosya biçimi başvurusu](https://github.com/marrink-lab/bentopy/wiki/Reference-for-bent)
- [`bentopy-solvate` belgelendirmesi](https://github.com/marrink-lab/bentopy/blob/main/src/solvate/README.md)
- [Protein kompleksleri — Martini](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsIIb/)
- [TS2CG v2.0](https://github.com/weria-pezeshkian/TS2CG-v2.0/wiki/Tutorial) —
  vezikül, tübül ve karmaşık geometrili yapılar

Ayrıca bkz. [`ILERI_OKUMA.md`](../ILERI_OKUMA.md)
