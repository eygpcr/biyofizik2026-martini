# Oturum 4 — Martini 3 Girdi Hazırlama

**13:30–15:00 (90 dakika) · Dr. Öğr. Üyesi Ekrem Yaşar**
**Model sistem: 6JOD A zinciri (AT2R) — sabah oturumunda kullanılan protein**

Colab not defteri: [`notebooks/04_martini_input.ipynb`](../notebooks/04_martini_input.ipynb)

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

## Bölüm A. CHARMM-GUI Martini Maker ve kullanım sınırları (yaklaşık 15 dakika)

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

## Bölüm B. Komut satırı ile girdi hazırlama (yaklaşık 65 dakika)

Uygulamanın tamamı Colab not defterinde adım adım yürütülmektedir. Aşağıdaki
özet, işlemlerin sonradan izlenebilmesi amacıyla verilmiştir.

### Kullanılan araçlar

| Araç | İşlevi |
|---|---|
| `martinize2` | Atomistik proteinin Martini 3 modeline ve topolojisine dönüştürülmesi |
| `insane` | Membran inşası, proteinin yerleştirilmesi, çözücü ve iyon eklenmesi |
| `gmx grompp` | Koordinat, topoloji ve parametre dosyalarının tutarlılığının sınanması |

### Adım 1. Yapının hazırlanması

Yalnızca A zinciri kullanılacaktır:

```bash
grep '^ATOM' 6jod.pdb | awk '$0 ~ /^.{21}A/' > at2r.pdb
```

### Adım 2. `martinize2` ile kaba-taneli modele dönüştürme

```bash
martinize2 \
  -f at2r.pdb \
  -o topol.top \
  -x at2r_cg.pdb \
  -ff martini3001 \
  -dssp \
  -elastic \
  -ef 700 -el 0.5 -eu 0.9 -ea 0 -ep 0
```

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

### Adım 4. Topoloji dosyasının düzeltilmesi

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

### Adım 5. `gmx grompp` ile doğrulama

```bash
gmx grompp -f minimization.mdp -c sistem.gro -p sistem.top -o em.tpr -maxwarn 1
```

Bu adımda simülasyon yürütülmemekte, koordinat, topoloji ve parametre
dosyalarının birbiriyle tutarlılığı sınanmaktadır. `.tpr` dosyasının
üretilebilmesi girdinin geçerli olduğunu göstermektedir.

Sık karşılaşılan hata iletileri ve çözümleri not defterinin sonunda
listelenmiştir.

### Adım 6 (isteğe bağlı). Kısa enerji minimizasyonu

```bash
gmx mdrun -deffnm em -nsteps 500
```

---

## Bölüm C. Martini modelinin sınırlılıkları (yaklaşık 10 dakika)

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

---

## Sorun giderme

Her adımın önceden üretilmiş çıktısı [`cikti/`](cikti/) klasöründe
bulunmaktadır. Bir adımda sorun yaşanması hâlinde oturum akışının kesintiye
uğramaması için bu dosyalardan devam edilmesi önerilmektedir.
