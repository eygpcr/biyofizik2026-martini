# Oturum 6 — `bentopy` ile Kalabalık Hücresel Sistemler

**Dr. Öğr. Üyesi Ekrem Yaşar**

[![Colab'da Aç](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/eygpcr/biyofizik2026-martini/blob/main/notebooks/06_bentopy.ipynb)

Colab not defteri: [`notebooks/06_bentopy.ipynb`](../notebooks/06_bentopy.ipynb)
Uygulama kaydı: [`VIDEO.md`](VIDEO.md)

> Yukarıdaki düğme not defterini doğrudan Google Colab'da açmaktadır; dosya
> indirmeye gerek yoktur. Not defteri çalıştırıldığında Google Drive'ınızda
> `Biyofizik2026_Martini/bentopy/` klasörü oluşturulmaktadır. Üç uygulama aynı
> dosya adlarını kullandığından her biri kendi alt klasörüne
> (`uygulama1_kutu/`, `uygulama2_membran/`, `uygulama3_bolmeler/`)
> kaydedilmekte; çizimler `gorseller/`, GROMACS ile çalıştırılabilir eksiksiz
> paket ise `simulasyon/` klasörüne konmaktadır.

Bu oturumda Martini resmî öğretim materyali uygulanmaktadır:
**[Bentopy Tutorial — cgmartini.nl](https://cgmartini.nl/docs/tutorials/Martini3/Bentopy/)**

---

## Kurs boyunca izlenen ölçek gelişimi

| Oturum | Sistem | Karakteristik uzunluk |
|---|---|---|
| 2 | Çözelti içinde tek lizozim molekülü | yaklaşık 5 nm |
| 3 | Membranda tek reseptör, atomistik | yaklaşık 10 nm |
| 4 | Membranda tek reseptör, kaba-taneli | yaklaşık 12 nm |
| **6** | **Kalabalık, çok bölmeli sistem** | **40 nm** |

Kursun başlığında yer alan "büyük ve kalabalık hücresel sistemler" ifadesi bu
oturumun konusunu oluşturmaktadır. Kullanılan model proteinlerden biri
lizozimdir; Oturum 2'de atomistik olarak hazırlanan proteinin kaba-taneli
karşılığı burada yüzlerce kopya hâlinde kullanılmaktadır.

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
| `bentopy-merge` | Paketlenen yapıların var olan bir sistemle birleştirilmesi |
| `bentopy-solvate` | Kalan boşluğun çözücü ve iyonlarla doldurulması |

### İş akışı

```
  .bent  ──bentopy-pack──▶  placements.json  ──bentopy-render──▶  .gro + .top
                                                                      │
                              (membran varsa) bentopy-merge ◀─────────┘
                                                                      │
                                          bentopy-solvate ◀───────────┘
```

`bentopy-pack` yalnızca **nereye ne konacağını** hesaplar; koordinat üretmez.

### `.bent` yapılandırma biçimi

| Bölüm | İçeriği |
|---|---|
| `[ general ]` | Sistem başlığı ve rastgelelik tohumu |
| `[ space ]` | Kutu boyutları ve paketleme ızgara çözünürlüğü |
| `[ includes ]` | Topolojiye eklenecek kuvvet alanı dosyaları |
| `[ compartments ]` | Yerleştirmenin yapılacağı hacimlerin tanımı |
| `[ segments ]` | Hangi yapıdan kaç kopyanın hangi bölmeye konacağı |

**Bölme tanımlama dili** bu aracın en ayırt edici özelliğidir:

| İfade | Anlamı |
|---|---|
| `system is all` | Kutunun tamamı |
| `membrane from "maske.npz"` | Maske dosyasından tanımlanan hacim |
| `solvent combines not membrane` | Membran dışında kalan hacim |
| `yakin around 5 of membrane` | Membran yüzeyinden 5 nm mesafedeki kabuk |
| `X combines A and B` | İki hacmin kesişimi |

Söz dizimi başvurusu:
[Reference for `.bent` files](https://github.com/marrink-lab/bentopy/wiki/Reference-for-bent)

---

## Kurulum ve öğretim dosyaları

```bash
pip install bentopy
```

`bentopy` Rust ile yazılmış olup PyPI'da yalnızca Linux x86_64 için önceden
derlenmiş paket sunmaktadır. Colab bu platformda çalıştığından kurulum hızlı
tamamlanır. Kendi bilgisayarınızda (özellikle macOS'ta) kaynaktan derleme
gerekebilir; bu durumda [rustup](https://rustup.rs/) ile Rust derleyicisi
kurulmalıdır.

Öğretim dosyaları:

```bash
wget https://cgmartini-library.s3.ca-central-1.amazonaws.com/0_Tutorials/m3_tutorials/Bentopy/tutorial_files.tar.gz
tar -xzf tutorial_files.tar.gz
cd tutorial_files
```

```
tutorial_files/
├── structures/     lysozyme.pdb, ubiquitin.pdb, membrane.gro, double_membrane.gro
├── topology/       Martini 3 kuvvet alanı dosyaları, lysozyme.itp, ubiquitin.itp
└── mdp_files/      em.mdp, eq.mdp, md.mdp
```

---

## Uygulama 1 — Kutu içinde homojen paketleme

40 × 40 × 40 nm boyutlarında bir kutuya **650 lizozim** molekülü, sitoplazmik
derişime karşılık gelen yoğunlukta yerleştirilmektedir.

```bash
bentopy-pack simple_packing.bent placements.json
bentopy-render placements.json system.gro -t topol.top
bentopy-solvate -i system.gro -o solvated_system.gro \
    -s NA:0.15M -s CL:0.15M --charge neutral -t topol.top
```

**Beklenen sonuç.** Protein z ekseni boyunca düzgün dağılmış olmalıdır; herhangi
bir bölgede zenginleşme görülmemelidir. Not defteri bunu dağılımın bağıl
değişimini hesaplayarak niceliksel olarak sınamaktadır.

---

## Uygulama 2 — Membran çevresinde konuma bağlı paketleme

Proteinler yalnızca sayıca değil, **konumsal kurala göre** de
yerleştirilmektedir: lizozim çözücü hacmine dağıtılırken, ubikitin yalnızca
membran yüzeyine yakın bölgede konumlandırılmaktadır.

```bash
bentopy-mask structures/membrane.gro --visualize-labels labels.gro
bentopy-mask structures/membrane.gro -l 1:membrane_mask.npz

bentopy-pack membrane_packing.bent placements.json
bentopy-render placements.json packed_proteins.gro -t topol.top
bentopy-merge packed_proteins.gro structures/membrane.gro -o system.gro
echo "POPC    5408" >> topol.top
bentopy-solvate -i system.gro -o solvated_system.gro -t topol.top \
    -s NA:0.15M -s CL:0.15M --charge neutral
```

**Dikkat.** `bentopy-merge` işleminden sonra lipit sayısının topolojiye elle
eklenmesi gerekmektedir; birleştirilen membran `bentopy` tarafından
üretilmediğinden topolojide otomatik olarak yer almamaktadır. Bu adım
atlanırsa `gmx grompp`, koordinat ile topoloji sayılarının uyuşmadığı hatasını
verir.

**Beklenen sonuç.** Protein dağılımı membran çevresinde belirgin biçimde
zenginleşmelidir. Not defteri, membrana yakın ve uzak hacimlerdeki protein
yoğunluklarını karşılaştırarak `close-to-membrane` bölme tanımının işlediğini
sayısal olarak doğrulamaktadır.

---

## Uygulama 3 — Çok bölmeli sistem

Çift membranla ayrılmış iki bölme tanımlanmakta ve her bölmeye farklı protein
yerleştirilmektedir. Süre elverdiği takdirde yürütülecektir.

```bash
bentopy-mask structures/double_membrane.gro -b compartment_labels.gro
bentopy-mask structures/double_membrane.gro \
    -l  -1:A_mask.npz -l  -2:B_mask.npz -l 1,2:membrane_mask.npz
```

Bölme tanımlarında bir **kesişim** kullanılmaktadır:

```
membrane-neighborhood around 4 of membrane
B-close-to-membrane combines membrane-neighborhood and B
```

Böylece ubikitin yalnızca B tarafındaki membran yüzeyine yerleşmekte, A tarafına
geçmemektedir.

---

## Yapıların görselleştirilmesi

Oturum 4'teki sistem 17 bin parçacıktı ve doğrudan etkileşimli
gösterilebiliyordu. Bu oturumdaki sistemler milyonlarca parçacık içerdiğinden
aynı yöntem tarayıcıyı kilitler. Not defteri bu nedenle her yapıyı üç şekilde
sunmaktadır:

| Yöntem | Ne gösterir |
|---|---|
| Etkileşimli seyreltilmiş görünüm | Proteinlerden omurga, lipitlerden fosfat merkezleri örneklenerek küçültülmüş sistem; döndürülebilir |
| Üç boyutlu perspektif | Molekül ağırlık merkezleri; kalabalık kutunun bütünü tek bakışta |
| İki boyutlu kesit ve z profili | Tam sistem üzerinde niceliksel denetim |
| **Referans karşılaştırma** | Kurulan sistem, cgmartini.nl sayfasındaki VMD render'ının **yanına** konarak gösterilir |

Girdi yapıları (lizozim, ubikitin, membran) küçük olduğundan doğrudan
etkileşimli olarak incelenmektedir.

### Referans karşılaştırma

Öğretim materyalindeki görüntüler VMD ile üretilmiş yüksek kaliteli
render'lardır. Colab ortamında VMD bulunmadığından ve sistemler milyonlarca
parçacık içerdiğinden aynı kalitede render üretilememektedir. Bunun yerine her
uygulamanın sonunda kurulan sistemin iki boyutlu kesiti, öğretim materyalindeki
referans görüntünün yanına konmaktadır; böylece **neyin görülmesi gerektiği**
açıkça anlaşılmaktadır.

Karşılaştırmanın anlamlı olması için kesit çizimi öğretim materyalindeki renk
düzenine göre yapılmaktadır: yeşil lizozim, mavi ubikitin, gri membran, açık
mavi su.

---

## Çıktılar

Not defteri, GROMACS ile doğrudan çalıştırılabilecek eksiksiz bir paketi Google
Drive'a kaydetmektedir. Paket **Uygulama 2** sistemi üzerine kurulmaktadır; üç
uygulama arasında hem membran hem çözünür protein içeren en temsili sistem
budur.

```
Biyofizik2026_Martini/bentopy/
├── uygulama1_kutu/
├── uygulama2_membran/
├── uygulama3_bolmeler/
├── gorseller/
└── simulasyon/        solvated_system.gro, topol.top, topology/*.itp,
                       mdp_files/*.mdp, index.ndx, calistir.sh, OKUBENI.md
```

Not defteri bu paketin gerçekten çalıştığını `gmx grompp` ile ayrıca
sınamaktadır.

> **Dosya boyutu.** Solvatlanmış 40 nm'lik sistemler 100 MB'ı aşabilmektedir.
> Üçünü birden kaydetmek hem yavaş hem gereksiz olduğundan, büyük koordinat
> dosyalarından yalnızca Uygulama 2'ninki saklanmaktadır. Hepsini kaydetmek
> isteyenler not defterindeki `BUYUK_DOSYA_KAYDET` değişkenini `True`
> yapabilirler.

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
