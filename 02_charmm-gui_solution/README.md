# Oturum 2 — CHARMM-GUI Solution Builder

**10:00–10:45 (45 dakika) · Dr. Öğr. Üyesi Ekrem Yaşar**
**Model sistem: PDB [1AKI](https://www.rcsb.org/structure/1AKI), tavuk yumurta akı lizozimi**

---

## Oturumun amacı

Bu oturumda aşağıdaki soruya uygulamalı olarak yanıt aranmaktadır:

> Bir moleküler dinamik simülasyonunun başlatılabilmesi için hangi dosyaların
> hazırlanmış olması gerekmektedir?

Yanıt, bir protein üzerinde baştan sona sistem kurulumu yapılarak
oluşturulacaktır.

## Model sistemin seçim gerekçesi

| Özellik | Eğitim açısından katkısı |
|---|---|
| Tek zincir (129 rezidü) | Zincir seçimi kararı gerektirmemektedir |
| Kofaktör ve ligant içermemesi | Hetero grup parametrizasyonu sorunu doğmamaktadır |
| Yüksek çözünürlük (1.5 Å) | Çözülmemiş atom sayısı ihmal edilebilir düzeydedir |
| Küçük sistem boyutu | 45 dakikalık oturuma uygun işlem süresi |

Lizozim, moleküler dinamik literatüründe standart başlangıç sistemi olarak
kullanılmaktadır. Bu oturumda kasıtlı olarak basit bir sistem seçilmiş olup,
karar gerektiren durumlar Oturum 3'te ele alınacaktır.

Yapı dosyası: [`girdi/1aki.pdb`](girdi/1aki.pdb)

---

## Uygulama adımları

### 1. Yapının yüklenmesi

1. https://charmm-gui.org adresine giriş yapılır
2. *Input Generator → Solution Builder* seçilir
3. *PDB ID* alanına `1AKI` yazılır veya [`girdi/1aki.pdb`](girdi/1aki.pdb)
   dosyası yüklenir
4. *Next Step* ile devam edilir

**Tartışma sorusu.** Yüklenen yapıda kaç zincir ve kaç kristalografik su
molekülü bulunmaktadır? Kristal suları sistemde tutulmalı mıdır?

### 2. Yapı düzenlemeleri (Manipulate PDB)

- **Zincir seçimi.** Yapı tek zincir içermektedir; seçim değiştirilmez.
- **Kristal suları.** Çıkarılır; çözücü kutusu ayrıca oluşturulacaktır.
- **Terminal gruplar.** Öntanımlı NTER/CTER yapılandırması kullanılır.
- **Disülfit köprüleri.** Lizozim dört disülfit köprüsü içermektedir. CHARMM-GUI
  bu bağları otomatik olarak tanımlamakta olup, listenin doğrulanması
  gerekmektedir.

**Kavramsal not.** Disülfit köprüleri kovalent bağlardır ve kuvvet alanında
ayrıca tanımlanmaları gerekmektedir. Tanımlamanın atlanması hâlinde protein
simülasyon sırasında yapısal bütünlüğünü kaybedebilmektedir.

### 3. Protonasyon durumlarının belirlenmesi

- pH 7.0 için öntanımlı değerlerle devam edilir
- Histidin rezidüleri için HSD, HSE ve HSP seçeneklerinin anlamı incelenir

**Kavramsal not.** Kuvvet alanları pH değişkenini doğrudan içermez. Ortam pH'ı,
titre edilebilir grupların protonasyon durumlarının seçilmesi yoluyla sisteme
aktarılmaktadır. Bu kararın önemi Oturum 3'te belirginleşecektir.

### 4. Kutu tanımı ve solvatasyon

- **Kutu tipi:** *Rectangular* veya *Octahedron*
  Tartışma: kesik oktahedron geometrisi aynı minimum görüntü mesafesini neden
  daha az çözücü molekülüyle sağlamaktadır?
- **Kenar mesafesi:** 10 Å
  Tartışma: periyodik sınır koşulları altında proteinin kendi görüntüsüyle
  etkileşmemesi için gereken asgari mesafe nasıl belirlenir?
- **İyon derişimi:** 0.15 M KCl, Monte Carlo yerleştirme yöntemi

### 5. Kuvvet alanı ve çıktı seçenekleri

- **Kuvvet alanı:** CHARMM36m
- **Çıktı formatı:** GROMACS
- İşlem tamamlandığında `charmm-gui.tgz` arşivi indirilir

---

## Çıktı dosyalarının yapısı

Oturumun bu bölümü, üretilen dosyaların işlevlerinin incelenmesine ayrılmıştır.

```
charmm-gui-XXXX/
├── gromacs/
│   ├── step5_input.gro            koordinatlar (protein, çözücü, iyonlar)
│   ├── topol.top                  topoloji: molekül sayıları ve kuvvet alanı
│   ├── index.ndx                  atom grupları (Protein, SOL, ION)
│   ├── toppar/                    kuvvet alanı parametre dosyaları
│   ├── step6.0_minimization.mdp   enerji minimizasyonu parametreleri
│   ├── step6.1_equilibration.mdp  dengeleme parametreleri
│   └── step7_production.mdp       üretim simülasyonu parametreleri
└── step3_input.pdb                solvatlanmış sistem, PDB formatında
```

### Temel dosya üçlüsü

| Dosya | İçerdiği bilgi |
|---|---|
| `.gro` | Atomların uzaysal konumları |
| `.top` | Atomlar arası bağlantı topolojisi ve parametreler |
| `.mdp` | Simülasyonun yürütülme koşulları (süre, sıcaklık, zaman adımı) |

GROMACS bu üç dosyayı `gmx grompp` komutuyla birleştirerek tek bir çalıştırma
girdisi (`.tpr`) üretmektedir.

**Oturum 4 ile ilişkisi.** Aynı dosya üçlüsü, öğleden sonraki oturumda komut
satırı araçlarıyla ve Martini kuvvet alanı için yeniden üretilecektir. Grafik
arayüzde gerçekleştirilen işlemler ile komut satırı iş akışı yapısal olarak
örtüşmektedir.

---

## `topol.top` dosyasının incelenmesi

```
#include "toppar/forcefield.itp"     kuvvet alanı tanımı
#include "toppar/PROA.itp"           protein topolojisi
#include "toppar/TIP3.itp"           su modeli

[ system ]
Title

[ molecules ]
PROA    1        protein
TIP3    5842     su molekülü
POT     14       potasyum iyonu
CLA     22       klorür iyonu
```

**Tartışma sorusu.** Sistemin net yükü sıfır mıdır? Katyon ve anyon sayılarının
eşit olmamasının nedeni nedir?

---

## Sorun giderme

CHARMM-GUI işleminin uzaması veya hata vermesi durumunda, önceden üretilmiş
çıktı dosyaları [`cikti/`](cikti/) klasöründe bulunmaktadır. Oturum akışının
kesintiye uğramaması için bu dosyalardan devam edilmesi önerilmektedir.

---

## Sonraki oturum

Oturum 3'te beş zincirli, ligant içeren ve kısmen çözülmemiş bir GPCR yapısı
lipit çift tabakasına yerleştirilecektir. Bu oturumda öğrenilen her adım orada
tekrar ele alınacak, ancak her adımda gerekçelendirilmiş bir karar verilmesi
gerekecektir.
