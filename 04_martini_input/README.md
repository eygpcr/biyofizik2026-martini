# Oturum 4 — Martini 3 Girdi Hazırlama

**Dr. Öğr. Üyesi Ekrem Yaşar**
**Model sistem: 6JOD A zinciri (AT2R) — sabah oturumunda kullanılan protein**

[![Colab'da Aç](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/eygpcr/biyofizik2026-martini/blob/main/notebooks/04_martini_input.ipynb)

Colab not defteri: [`notebooks/04_martini_input.ipynb`](../notebooks/04_martini_input.ipynb)

> Yukarıdaki düğme not defterini doğrudan Google Colab'da açmaktadır; dosya
> indirmeye gerek yoktur. Not defteri çalıştırıldığında Google Drive'ınızda
> `Biyofizik2026_Martini/martini_input/` klasörü oluşturulmakta ve tüm çıktılar
> (`girdi/`, `cikti/`, `gorseller/`) buraya kaydedilmektedir.
>
> Her adımın sonunda üretilen yapı not defteri içinde etkileşimli olarak
> görüntülenmekte (döndürülebilir, yakınlaştırılabilir) ve statik bir çizimi
> `gorseller/` klasörüne PNG olarak kaydedilmektedir.

---

## Oturumun amacı

Sabah oturumlarında grafik arayüz üzerinden gerçekleştirilen sistem kurulumu, bu
oturumda komut satırı araçlarıyla ve kaba-taneli çözünürlükte yeniden
yürütülmektedir.

Üretilecek dosya kümesi sabahki ile yapısal olarak aynıdır:

| Bileşen | Atomistik (Oturum 2–3) | Kaba-taneli (bu oturum) |
|---|---|---|
| Koordinatlar | `step5_input.gro` | `sistem.gro` |
| Topoloji | `topol.top` | `sistem.top` ve `molecule_0.itp` |
| Çalıştırma parametreleri | `*.mdp` | `minimization.mdp` |

Değişen unsurlar model çözünürlüğü ve kullanılan araçlardır; iş akışının mantığı
korunmaktadır.

---

## Bölüm A. CHARMM-GUI Martini Maker ve kullanım sınırları

*Ekran üzerinden tanıtım; uygulama yapılmayacaktır.*

CHARMM-GUI, Martini Maker adı verilen bir modül aracılığıyla kaba-taneli sistem
kurulumu da sunmaktadır. Modül, sabah kullanılan arayüzle aynı mantıkta
çalışmaktadır.

Bu kursta anılan modülün kullanılmama gerekçeleri aşağıda sıralanmıştır:

| Kısıt | Sonucu |
|---|---|
| Arayüzün tek protein üzerine yapılandırılmış olması | Oligomerik veya çok bileşenli sistem kurulumu güçleşmektedir |
| Lipit bileşimi ve kutu boyutunun arayüzle sınırlı olması | 40–50 nm ölçeğindeki yamalar pratik değildir |
| Elastik ağ parametreleri üzerinde sınırlı denetim | Kuvvet sabiti ve kesme mesafesi ayrıntılı biçimde ayarlanamamaktadır |
| Her denemede arayüzün yeniden doldurulması gerekliliği | Tekrarlanabilirlik ve otomasyon sağlanamamaktadır |
| Ara adımların kullanıcıya kapalı olması | Hata kaynağının belirlenmesi güçleşmektedir |

**Kavramsal not.** Belirleyici ölçüt tekrarlanabilirliktir. Komut satırında
yürütülen bir işlem, yayında raporlanabilen ve sonradan aynı biçimde
tekrarlanabilen bir kayıt oluşturmaktadır; grafik arayüzde yapılan seçimler bu
niteliği taşımamaktadır.

Martini Maker modülü, tek proteinli hızlı denemeler için uygun bir araçtır;
kursun hedeflediği ölçeğe uygun değildir.

---

## Bölüm B. Komut satırı ile girdi hazırlama

Uygulamanın tamamı Colab not defterinde adım adım yürütülmektedir. Aşağıdaki
özet, işlemlerin sonradan izlenebilmesi amacıyla verilmiştir.

### Kullanılan araçlar

| Araç | İşlevi |
|---|---|
| `martinize2` | Atomistik proteinin Martini 3 modeline ve topolojisine dönüştürülmesi |
| `insane` | Membran inşası, proteinin yerleştirilmesi, çözücü ve iyon eklenmesi |
| `gmx grompp` | Koordinat, topoloji ve parametre dosyalarının tutarlılığının sınanması |

### Adım 1. Membrana göre yönlendirme

Bu, komut satırı iş akışındaki **en kritik ve en sık atlanan** adımdır.

PDB dosyasındaki koordinatlar kristal biriminin çerçevesinde verilmektedir; bu
çerçevenin membran düzlemiyle bir ilişkisi yoktur. `insane` aracı proteini kutuya
**ortalamakta**, ancak **döndürmemektedir**. Yönlendirme yapılmazsa protein
membrana yatık gömülür ve transmembran heliksleri çift tabakaya dik olmaz.

6JOD için ölçüm: kristal çerçevesinde proteinin uzun ekseni z ekseniyle yaklaşık
**80 derece** açı yapmaktadır. [OPM](https://opm.phar.umich.edu/) veritabanındaki
yönlendirilmiş hâlde bu açı **11 dereceye** düşmektedir.

```bash
wget https://opm-assets.storage.googleapis.com/pdb/6jod.pdb -O 6jod_opm.pdb
```

Ardından yalnızca A zinciri ayıklanır (`DUM` membran işaretçileri hariç).

> **Sabah oturumuyla bağlantı.** CHARMM-GUI Membrane Builder da aynı işlemi
> PPM/OPM sunucusunu çağırarak yapmaktadır. Grafik arayüzde arka planda
> gerçekleşen bu adım, komut satırında açıkça yürütülmelidir.

### Adım 2. `martinize2` ile kaba-taneli modele dönüştürme

```bash
martinize2 \
  -f at2r.pdb \
  -o topol.top \
  -x at2r_cg.pdb \
  -ff martini3001 \
  -ss $SS \
  -elastic -ef 700 -el 0.5 -eu 0.9 -ea 0 -ep 0 \
  -cys auto
```

**İkincil yapı neden `-dssp` ile belirlenmiyor?** Ubuntu depolarındaki güncel
`mkdssp` sürümü (4.x) girdi dosyasında `CRYST1` kaydı aramakta, `vermouth`
tarafından üretilen geçici dosyada ise bu kayıt bulunmamaktadır. Bu nedenle
`-dssp` kullanımı şu hatayı vermektedir:

```
DSSPError: DSSP encountered an error. Expected record CRYST1 but found ATOM
```

Bunun yerine ikincil yapı, kristal yapının kendi `HELIX` ve `SHEET`
kayıtlarından çıkarılıp `-ss` seçeneği ile verilmektedir. 6JOD A zinciri için
elde edilen dize 306 karakter uzunluğunda olup heliks oranı yaklaşık %84'tür;
bu dağılım yedi transmembran heliksli bir GPCR için beklenen değerdir. Hücre
dışı ikinci ilmikteki (ECL2) kısa β-firkete de doğru biçimde yakalanmaktadır.

> Deneysel yapı yerine bir model (örneğin AlphaFold çıktısı) kullanılıyorsa bu
> kayıtlar bulunmayacaktır; o durumda uyumlu bir DSSP sürümü kurulmalı veya
> ikincil yapı `mdtraj` gibi bir kütüphaneyle hesaplanmalıdır.

| Parametre | İşlevi | Önemi |
|---|---|---|
| `-ff martini3001` | Martini 3 kuvvet alanı seçimi | Martini 2 ile karıştırılmamalıdır |
| `-dssp` | İkincil yapının belirlenmesi | Etkileşim merkezi tipleri ikincil yapıya bağlıdır |
| `-elastic` | Elastik ağ tanımlanması | Uygulanmaması hâlinde protein yapısal bütünlüğünü kaybetmektedir |
| `-ef 700` | Yay kuvvet sabiti (kJ mol⁻¹ nm⁻²) | Yüksek değerler proteini aşırı rijitleştirmekte, düşük değerler yapıyı koruyamamaktadır |
| `-el` / `-eu` | Yay tanımlanacak mesafe aralığı (nm) | Hangi merkez çiftlerinin bağlanacağını belirlemektedir |

**Kavramsal not: elastik ağın gerekliliği.** Martini kuvvet alanı, etkileşim
merkezleri arasındaki potansiyeller aracılığıyla proteinin ikincil ve üçüncül
yapısını koruyamamaktadır. Yapı, harmonik yaylardan oluşan bir ağ ile
kısıtlanmaktadır.

Bu yaklaşımın bedeli önemlidir: model protein katlanma, açılma ve büyük ölçekli
konformasyonel değişim gösteremez. Dolayısıyla Martini ile bir GPCR'ın
aktivasyon geçişi incelenemez. İncelenebilecek süreçler lipit etkileşimleri,
oligomerizasyon ve difüzyondur.

Bir modelleme aracının uygulanamayacağı sorulara ilişkin farkındalık,
uygulanabileceği sorulara ilişkin bilgi kadar belirleyicidir.

**Çıktılar:** `at2r_cg.pdb`, `topol.top`, `molecule_0.itp`

**Tartışma sorusu.** Atom sayısından etkileşim merkezi sayısına indirgeme oranı
nedir?

### Adım 3. `insane` ile membran, çözücü ve iyon eklenmesi

```bash
insane \
  -f at2r_cg.pdb \
  -o sistem.gro \
  -p sistem.top \
  -pbc square \
  -box 12,12,14 \
  -l POPC:1 \
  -sol W \
  -salt 0.15 \
  -center
```

| Parametre | İşlevi |
|---|---|
| `-box 12,12,14` | Kutu boyutları (nm) |
| `-l POPC:1` | Lipit bileşimi; çok bileşenli tanım için `-l POPC:7 -l POPE:2 -l CHOL:1` |
| `-sol W` | Martini standart su modeli (bir merkez yaklaşık dört su molekülünü temsil etmektedir) |
| `-salt 0.15` | 0.15 M NaCl |
| `-center` | Proteinin kutu merkezine yerleştirilmesi |

**Tartışma sorusu.** Bu sistemin parçacık sayısı nedir? Aynı hacimdeki atomistik
bir sistem kaç atom içerecekti?

### Adım 4. İyon adlarının düzeltilmesi

**Bu adım atlanırsa `gmx grompp` şu hatayı verir:**

```
ERROR 1 [file sistem.top]:
  No such moleculetype NA+
```

`insane` aracı Martini 2 döneminde geliştirilmiş olup iyonları `NA+` ve `CL-`
adlarıyla üretmektedir. Martini 3 kuvvet alanı ise aynı iyonları `NA` ve `CL`
adlarıyla tanımlamaktadır. Adlar eşleşmediğinden GROMACS molekül tipini
bulamamaktadır.

Çözüm, hem koordinat dosyasındaki hem topolojideki adların dönüştürülmesidir;
not defterinin 10. bölümü bu işlemi yapmaktadır. Bu, `insane` ile Martini 3'ün
birlikte kullanımında karşılaşılan en yaygın sorundur.

### Adım 5. Topoloji dosyasının düzeltilmesi

`insane` aracı topoloji dosyasını üretmekte, ancak kuvvet alanı `#include`
satırlarının kullanıcı tarafından eklenmesi gerekmektedir. Bu adım, iş akışında
en sık hata alınan noktadır.

```
#include "martini_v3.0.0.itp"
#include "martini_v3.0.0_solvents_v1.itp"
#include "martini_v3.0.0_ions_v1.itp"
#include "molecule_0.itp"
#include "martini_v3.0.0_phospholipids_v1.itp"
```

### Adım 6. `gmx grompp` ile doğrulama

```bash
gmx grompp -f minimization.mdp -c sistem.gro -p sistem.top -o em.tpr -maxwarn 1
```

Bu adımda simülasyon yürütülmemekte, koordinat, topoloji ve parametre
dosyalarının birbiriyle tutarlılığı sınanmaktadır. `.tpr` dosyasının
üretilebilmesi girdinin geçerli olduğunu göstermektedir.

Sık karşılaşılan hata iletileri ve çözümleri not defterinin sonunda
listelenmiştir.

### Adım 7 (isteğe bağlı). Kısa enerji minimizasyonu

```bash
gmx mdrun -deffnm em -nsteps 500
```

---

## Yapısal kısıt modelleri

Martini kuvvet alanı proteinin üçüncül yapısını kendi başına koruyamamaktadır;
yapıya dışarıdan bir kısıt eklenmesi zorunludur. Alanda üç yaklaşım
kullanılmaktadır ve not defterinde üçü de aynı protein üzerinde uygulanıp
karşılaştırılmaktadır.

| | **Elastik ağ** | **Gō-Martini** | **OLIVES** |
|---|---|---|---|
| Kısıtın türü | Harmonik yaylar | LJ kontakları (sanal bölgeler) | LJ kontakları |
| Kontak ölçütü | Mesafe (0.5–0.9 nm) | Yapısal kontak haritası | Hidrojen bağı ağı |
| Neyi bağlar? | Yalnızca omurga | Yalnızca omurga | Omurga **ve yan zincirler** |
| Kısıt kopabilir mi? | Hayır | Evet | Evet |
| İkincil yapı | Sabit (`-ss`) | Sabit (`-ss`) | Dinamik (`-ss` gerekmez) |
| Uygulama | `martinize2 -elastic` | `martinize2 -go` | Ayrı betik |

6JOD A zinciri için üretilen kısıt sayıları: elastik ağ **1289** yay,
Gō-Martini **566** kontak, OLIVES **393** kontak.

**Hangisi ne zaman?**

- **Elastik ağ** — protein yapısının sabit kalmasının beklendiği, ilgi odağının
  çevre olduğu çalışmalar: lipit–protein etkileşimleri, difüzyon, oligomerleşme.
  Kursun ana akışında kullanılan yöntem budur.
- **Gō-Martini** — kısıtların kopabilmesinin gerektiği durumlar: mekanik açılma,
  alt birim ayrışması.
- **OLIVES** — ikincil yapının kendisinin değişebilmesi gereken çalışmalar,
  protein kompleksleri, nükleik asitler.

Not defteri üç modelin kısıt ağını dört panel hâlinde çizmektedir; bu gösterim
Pedersen ve ark. (2024) makalesinin 3. şeklinin 6JOD için üretilmiş hâlidir.

## Martini modelinin sınırlılıkları

- **Zaman ölçeği.** Yumuşatılmış serbest enerji yüzeyi nedeniyle dinamik
  yaklaşık dört kat hızlanmaktadır. Yayınlarda etkin zaman olarak
  belirtilmelidir.
- **Konformasyonel değişim.** Elastik ağ nedeniyle katlanma ve büyük ölçekli
  yapısal geçişler incelenememektedir.
- **Çözücü modeli.** Standart Martini suyu donma eğilimi göstermektedir;
  antifriz parçacığı veya polarize su modeli gerekebilmektedir.
- **Elektrostatik etkileşimler.** Yaklaşık olarak ele alınmaktadır; yüksek yük
  yoğunluklu sistemlerde dikkatli değerlendirme gerekmektedir.
- **Hidrojen bağları.** Yönelim bilgisi bulunmadığından hidrojen bağı ağına
  ilişkin sorular yanıtlanamamaktadır.

Ayrıntılı liste: [Notes and Limitations](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut4.html)

---

## Kaynaklar

Bu oturum aşağıdaki resmî öğretim materyallerinden uyarlanmıştır:

- [Martini Protein Model — Using Martinize2](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut1.html)
- [Modeling Complex Lipid Membranes — INSANE](https://cgmartini.nl/docs/tutorials/Martini3/LipidsII/)
- [OPM — Orientations of Proteins in Membranes](https://opm.phar.umich.edu/)
- Souza ve ark. (2025). *GōMartini 3.* Nature Communications, 16.
  [doi:10.1038/s41467-025-58719-0](https://doi.org/10.1038/s41467-025-58719-0)
- Pedersen ve ark. (2024). *OLIVES.* J. Chem. Theory Comput.
  [doi:10.1021/acs.jctc.4c00553](https://doi.org/10.1021/acs.jctc.4c00553)

---

## Çıktılar

Not defteri, GROMACS ile doğrudan çalıştırılabilecek eksiksiz bir paketi
Google Drive'a kaydetmektedir:

```
Biyofizik2026_Martini/martini_input/
├── girdi/        ham ve yönlendirilmiş yapılar
├── cikti/        ara çıktılar, üç modelin topolojileri
├── gorseller/    çizimler (PNG)
└── simulasyon/   sistem.gro, sistem.top, molecule_0.itp,
                  martini_v3.0.0*.itp, em/eq/md.mdp, index.ndx,
                  calistir.sh, OKUBENI.md
```

`simulasyon/` klasörü kendi kendine yeterlidir; kuvvet alanı dosyaları dâhil
olduğundan dışarıdan hiçbir dosyaya bağımlı değildir. Not defteri bu paketin
gerçekten çalıştığını `gmx grompp` ile ayrıca sınamaktadır.

---

## Sorun giderme

Her adımın önceden üretilmiş çıktısı [`cikti/`](cikti/) klasöründe
bulunmaktadır. Bir adımda sorun yaşanması hâlinde oturum akışının kesintiye
uğramaması için bu dosyalardan devam edilmesi önerilmektedir.
