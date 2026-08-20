# Moleküler Simülasyona Giriş: Sistem Kurulumu ve Analizi

**BÜYÜK VE KALABALIK HÜCRESEL SİSTEMLERİN MOLEKÜLER SİMÜLASYONU**

8. Uluslararası Katılımlı ve 37. Ulusal Biyofizik Kongresi öncesi düzenlenen kurs

- **Tarih:** 25 Ağustos 2026, Salı — 09:00–17:30
- **Yer:** Ankara Üniversitesi Tıp Fakültesi, Morfoloji Binası, Yeşil Salon

Bu depo kursun tüm eğitim materyalini içermektedir: oturum bazında uygulama
yönergeleri, Google Colab not defterleri, girdi ve çıktı dosyaları ile kurs
sonrası çalışma kaynakları.

---

## Eğitmenler

| Eğitmen | Kurum |
|---|---|
| Prof. Dr. Nazmi Yaraş | Akdeniz Üniversitesi, Biyofizik Anabilim Dalı |
| Doç. Dr. Mustafa Tekpınar | Van Yüzüncü Yıl Üniversitesi, Fen Fakültesi, Fizik Bölümü |
| Dr. Öğr. Üyesi Ekrem Yaşar | Erzincan Binali Yıldırım Üniversitesi, Biyofizik Anabilim Dalı |

---

## Kursun amacı ve kapsamı

Kurs boyunca tek bir model sistem üzerinde ilerlenmektedir: **anjiyotensin II
tip-2 reseptörü (AT2R)**, bir G proteinine kenetli reseptör (GPCR). Sabah
oturumlarında bu protein atomistik (all-atom) çözünürlükte hazırlanmakta,
öğleden sonra aynı protein Martini 3 kuvvet alanı ile kaba-taneli
(coarse-grained) modele dönüştürülerek lipit çift tabakasına yerleştirilmekte,
günün sonunda ise kalabalık bir hücresel sisteme aktarılmaktadır.

**Kapsam sınırı.** Kursta üretim simülasyonu koşulmamaktadır. Odak, simülasyona
girecek sistemin doğru biçimde kurulması (input hazırlama) ve elde edilmiş
trajektorilerin analizidir. Bu tercih, bir günlük süre kısıtı ve katılımcıların
önceden simülasyon deneyimi bulunmaması nedeniyle yapılmıştır.

### Öğrenim kazanımları

Kursun tamamlanmasının ardından katılımcıların aşağıdaki yetkinlikleri
kazanmaları hedeflenmektedir:

1. Bir Protein Veri Bankası (PDB) yapısını inceleyerek hangi zincirlerin
   incelenen proteine ait olduğunu, hangilerinin deneysel yardımcı bileşen
   olduğunu ayırt etmek
2. CHARMM-GUI kullanarak çözelti içi ve membrana gömülü sistemler kurmak
3. Protonasyon durumu, disülfit köprüsü, çözülmemiş rezidü ve nokta mutasyonu
   konularında gerekçelendirilmiş kararlar vermek
4. Komut satırı üzerinden `martinize2` ve `insane` araçlarıyla Martini 3
   girdileri üretmek
5. Atomistik ve kaba-taneli modellerde analiz yaklaşımlarının nerede ayrıştığını
   değerlendirmek
6. `bentopy` ile kalabalık hücresel sistem kurulumunun ilkelerini açıklamak

**Ön koşul.** Bulunmamaktadır. Katılımcıların daha önce moleküler dinamik
simülasyonu deneyimi olmadığı varsayılmaktadır.

---

## Başlangıç

1. [KURULUM.md](KURULUM.md) dosyasındaki hesap ve yazılım kontrol listesi kurs
   gününden önce tamamlanmalıdır. CHARMM-GUI hesap onayı bir iş günü
   sürebildiğinden bu adım geciktirilmemelidir.
2. Kurs günü her oturum, ilgili klasördeki yönerge dosyası takip edilerek
   yürütülecektir.

---

## Program — 25 Ağustos 2026

| Saat | Oturum | Eğitmen | Not defteri |
|---|---|---|---|
| 09:00–09:45 | [1. Moleküler dinamiğin temelleri ve ölçek problemi](01_teori/) | N. Yaraş, M. Tekpınar | |
| 09:45–10:00 | Ara | | |
| 10:00–10:45 | [2. CHARMM-GUI Solution Builder — PDB `1AKI`](02_charmm-gui_solution/) | E. Yaşar | tarayıcı |
| 10:45–11:00 | Ara | | |
| 11:00–12:15 | [3. CHARMM-GUI Membrane Builder — PDB `6JOD`](03_charmm-gui_membrane/) | E. Yaşar | tarayıcı |
| 12:15–13:30 | Öğle arası | | |
| 13:30–15:00 | [4. Martini 3 girdi hazırlama: `martinize2` ve `insane`](04_martini_input/) | E. Yaşar | [![Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/eygpcr/biyofizik2026-martini/blob/main/notebooks/04_martini_input.ipynb) |
| 15:00–15:20 | Ara | | |
| 15:20–16:00 | [5a. Atomistik trajektori analizi](05_analiz/allatom/) | M. Tekpınar | [![Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/eygpcr/biyofizik2026-martini/blob/main/notebooks/05a_allatom_analiz.ipynb) |
| 16:00–16:20 | [5b. Kaba-taneli modellerde analiz farklılıkları](05_analiz/martini/) | E. Yaşar | |
| 16:20–16:35 | Ara | | |
| 16:35–17:15 | [6. `bentopy` ile kalabalık hücresel sistemler](06_bentopy/) | E. Yaşar | [![Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/eygpcr/biyofizik2026-martini/blob/main/notebooks/06_bentopy.ipynb) |
| 17:15–17:30 | Değerlendirme ve [ileri okuma](ILERI_OKUMA.md) | Tüm eğitmenler | |

---

## Kullanılan yapılar

| PDB | Tanım | Kullanıldığı oturum |
|---|---|---|
| [1AKI](https://www.rcsb.org/structure/1AKI) | Tavuk yumurta akı lizozimi; X-ışını kırınımı, 1.5 Å; tek zincir, kofaktörsüz | Oturum 2 |
| [6JOD](https://www.rcsb.org/structure/6JOD) | Anjiyotensin II tip-2 reseptörü (AT2R), ligantlı; X-ışını kırınımı, 3.2 Å | Oturum 3 ve 4 |

### 6JOD yapısının zincir bileşimi

Yapı beş zincir içermekte olup bunların yalnızca ikisi incelenen sisteme aittir:

| Zincir | Uzunluk | Tanım | İşlem |
|---|---|---|---|
| A | 312 aa | Anjiyotensin II tip-2 reseptörü (AT2R) | Korunur |
| B | 8 aa | Anjiyotensin II — agonist peptit | Korunur |
| C | 86 aa | BRIL (çözünür sitokrom b562) — kristalizasyon füzyonu | Çıkarılır |
| H | 220 aa | 4A03 Fab ağır zincir — kristalizasyon yardımcısı | Çıkarılır |
| L | 212 aa | 4A03 Fab hafif zincir — kristalizasyon yardımcısı | Çıkarılır |

Bu ayrım, kursun ilk uygulamalı kazanımını oluşturmaktadır: PDB dosyasında yer
alan her zincir, incelenen biyolojik yapının bileşeni değildir.

---

## Hesaplama ortamı

Uygulamalar Google Colab üzerinde yürütülecektir. Katılımcıların kendi
bilgisayarlarına yazılım kurmaları gerekmemekte, güncel bir internet tarayıcısı
yeterli olmaktadır.

- Üretim simülasyonu koşulmadığından GPU gereksinimi bulunmamaktadır; ücretsiz
  CPU çalışma zamanı yeterlidir.
- Her uygulamanın önceden üretilmiş çıktıları ilgili klasörün `cikti/` dizininde
  bulunmaktadır. Bir adımda sorun yaşanması hâlinde bu dosyalardan devam
  edilebilir.

### Çıktıların saklanması

Colab çalışma zamanı sonlandığında üretilen dosyalar silinmektedir. Bu nedenle
not defterleri, çıktıları katılımcının kendi Google Drive hesabına
kaydetmektedir:

```
Drive'ım/
└── Biyofizik2026_Martini/
    ├── martini_input/              Oturum 4
    │   ├── girdi/
    │   ├── cikti/
    │   └── gorseller/
    └── bentopy/                    Oturum 6
        ├── uygulama1_kutu/
        ├── uygulama2_membran/
        ├── uygulama3_bolmeler/
        └── gorseller/
```

Klasörler not defterinin ilk hücresi çalıştırıldığında otomatik olarak
oluşturulmaktadır. Oturum 6'daki üç uygulama aynı dosya adlarını kullandığından
her biri ayrı alt klasöre kaydedilmekte, böylece çıktıların üst üste yazılması
önlenmektedir.
- Yerel kurulum yönergeleri [KURULUM.md](KURULUM.md) dosyasının sonunda yer
  almaktadır.

---

## Kaynaklar ve atıf

Kursun Martini bölümleri aşağıdaki açık erişimli materyallerden yararlanılarak
hazırlanmıştır. Bu depoda ilgili öğretim içerikleri çoğaltılmamış, doğrudan
kaynağına atıf yapılmıştır.

- [cgmartini.nl](https://cgmartini.nl/docs/tutorials/) — Martini 3 resmî öğretim
  materyalleri (Groningen Üniversitesi, Marrink grubu)
- [MARTINI Odyssey — Athens 2026](https://github.com/paulocts/martini-odyssey-2026) —
  P. C. T. Souza, R. Corey ve A. Kolocouris tarafından düzenlenen okulun
  uygulama materyali. Bu deponun yapısı anılan çalışmadan esinlenmiştir.
- [CHARMM-GUI](https://charmm-gui.org) — Jo, S., Kim, T., Iyer, V. G., Im, W.
  (2008). *Journal of Computational Chemistry*, 29(11), 1859–1865.
- [GROMACS](https://www.gromacs.org) · [bentopy](https://github.com/marrink-lab/bentopy)

Kurs materyali CC BY 4.0 lisansı ile sunulmaktadır; bkz. [LICENSE](LICENSE).

---

## İletişim

| | |
|---|---|
| Prof. Dr. Nazmi Yaraş | `nazmiyaras@akdeniz.edu.tr` |
| Kurs sekreteryası — Doç. Dr. Ayşegül Durak | `atoy@ankara.edu.tr` |

Depo içeriğine ilişkin teknik bildirimler için deponun *Issues* bölümü
kullanılabilir.
