# Moleküler Simülasyona Giriş — Biyofizik 2026 Kursu

> **BÜYÜK ve KALABALIK HÜCRESEL SİSTEMLERİN MOLEKÜLER SİMÜLASYONU**
> 8. Uluslararası Katılımlı ve 37. Ulusal Biyofizik Kongresi öncesi kurs
> 📅 **25 Ağustos 2026, Salı · 09:00–17:30**
> 📍 Ankara Üniversitesi Tıp Fakültesi, Morfoloji Binası — Yeşil Salon

Bu depo kursun tüm materyalini içerir: adım adım Türkçe anlatımlar, Google Colab
notebook'ları, girdi/çıktı dosyaları ve kurs sonrası devam edebileceğiniz kaynaklar.

---

## 👩‍🏫 Eğitmenler

| | |
|---|---|
| **Prof. Dr. Nazmi Yaraş** | Akdeniz Üniversitesi, Biyofizik AD |
| **Doç. Dr. Mustafa Tekpınar** | |
| **Dr. Öğr. Üyesi Ekrem Yaşar** | Erzincan Binali Yıldırım Üniversitesi, Biyofizik AD |

---

## 🎯 Bu kurs ne öğretiyor?

Kurs boyunca **tek bir protein** üzerinden ilerliyoruz: **Anjiyotensin II tip-2
reseptörü (AT2R)** — bir GPCR. Sabah onu all-atom (atomistik) olarak hazırlıyoruz,
öğleden sonra aynı proteini Martini 3 ile kaba-taneli (coarse-grained) hale getirip
bir membrana gömüyoruz, günün sonunda ise kalabalık bir hücresel sisteme taşıyoruz.

**Kursun kapsamı: input hazırlama.** Uzun simülasyonlar koşmuyoruz — çünkü asıl zor
ve asıl öğretici kısım, simülasyona *girecek* sistemi doğru kurmaktır. Analiz
oturumunda hazır trajektoriler kullanılacak.

Kurs sonunda şunları yapabiliyor olacaksınız:

- Bir PDB yapısına bakıp **hangi zincirlerin gerçekten proteine ait olduğunu** ayırt etmek
- CHARMM-GUI ile **suda çözünmüş** ve **membrana gömülü** sistemler kurmak
- Protonasyon durumları, disülfitler, eksik loop'lar ve mutasyonlar hakkında bilinçli karar vermek
- Terminalden `martinize2` ve `insane` ile **Martini 3 girdileri** üretmek
- All-atom ve Martini analizlerinin nerede ayrıştığını görmek
- `bentopy` ile kalabalık/hücresel ölçekte sistem kurmanın mantığını kavramak

**Ön koşul yok.** Daha önce hiç simülasyon yapmamış olmanız beklenir.

---

## 🚀 Hızlı başlangıç

1. **[KURULUM.md](KURULUM.md)** dosyasındaki kontrol listesini kursten önce tamamlayın.
   *(Özellikle CHARMM-GUI hesabı — onayı bir iş günü sürebiliyor.)*
2. **[ON_TOPLANTI.md](ON_TOPLANTI.md)** — 21 Ağustos Cuma öğleden sonraki hazırlık
   toplantısının gündemi.
3. Kurs günü her oturumun kendi klasöründeki `README.md` dosyasını takip edin.

---

## 📅 Program — 25 Ağustos 2026, Salı

| Saat | Oturum | Eğitmen |
|---|---|---|
| 09:00–09:45 | **[1 · Teori: MD'nin temelleri ve ölçek problemi](01_teori/)** | NY + MT |
| 09:45–10:00 | ☕ ara | |
| 10:00–10:45 | **[2 · CHARMM-GUI Solution Builder](02_charmm-gui_solution/)** — PDB `1AKI` | EY |
| 10:45–11:00 | ☕ ara | |
| 11:00–12:15 | **[3 · CHARMM-GUI Membrane Builder](03_charmm-gui_membrane/)** — PDB `6JOD` | EY |
| 12:15–13:30 | 🍽️ öğle arası | |
| 13:30–15:00 | **[4 · Martini 3 input hazırlama](04_martini_input/)** — `martinize2` + `insane` | EY |
| 15:00–15:20 | ☕ ara | |
| 15:20–16:00 | **[5a · All-atom trajektori analizi](05_analiz/allatom/)** | MT |
| 16:00–16:20 | **[5b · Martini'de analiz nasıl değişir?](05_analiz/martini/)** | EY |
| 16:20–16:35 | ☕ ara | |
| 16:35–17:15 | **[6 · Bentopy: kalabalık hücresel sistemler](06_bentopy/)** | EY |
| 17:15–17:30 | Kapanış, soru-cevap, **[ileri okuma](ILERI_OKUMA.md)** | Hepsi |

---

## 🧬 Kullanılan yapılar

| PDB | Ne | Nerede |
|---|---|---|
| [**1AKI**](https://www.rcsb.org/structure/1AKI) | Tavuk yumurta akı lizozimi · X-ray 1.5 Å · tek zincir, kofaktörsüz | Oturum 2 |
| [**6JOD**](https://www.rcsb.org/structure/6JOD) | Anjiyotensin II tip-2 reseptörü (AT2R) + ligand · X-ray 3.2 Å | Oturum 3 ve 4 |

**6JOD neden seçildi?** İçinde 5 zincir var ama bunların yalnız ikisi bizi ilgilendiriyor:

| Zincir | Ne | Karar |
|---|---|---|
| **A** (312 aa) | Anjiyotensin II tip-2 reseptörü — asıl GPCR | ✅ tutulacak |
| **B** (8 aa) | Anjiyotensin II — agonist peptit | ✅ tutulacak |
| **C** (86 aa) | BRIL (çözünür sitokrom b562) — kristalizasyon füzyonu | ❌ silinecek |
| **H** (220 aa) | 4A03 Fab ağır zincir | ❌ silinecek |
| **L** (212 aa) | 4A03 Fab hafif zincir | ❌ silinecek |

Yani daha ilk adımda şunu öğreniyoruz: **PDB'de gördüğünüz her zincir proteinin
parçası değildir.**

---

## 💻 Hesaplama ortamı

Uygulamalar **Google Colab** üzerinde yapılacak — bilgisayarınıza hiçbir şey
kurmanıza gerek yok, modern bir tarayıcı yeterli.

- Simülasyon koşmadığımız için **GPU gerekmiyor**; ücretsiz CPU runtime yeterli.
- Her uygulamanın **hazır çıktısı** ilgili klasörün `cikti/` dizininde duruyor —
  Colab'da bir yere takılırsanız oradan devam edebilirsiniz.
- Kendi makinenize kurmak isterseniz talimatlar [KURULUM.md](KURULUM.md) sonunda.

---

## 📚 Kaynaklar ve atıf

Bu kursun Martini bölümleri, aşağıdaki açık kaynaklı materyallerden yararlanılarak
hazırlanmıştır. Depomuzda tutorial içerikleri **kopyalanmamış**, doğrudan
kaynağına link verilmiştir:

- **[cgmartini.nl](https://cgmartini.nl/docs/tutorials/)** — Martini 3 resmî tutorial'ları
  (Groningen Üniversitesi, Marrink grubu)
- **[MARTINI Odyssey — Athens 2026](https://github.com/paulocts/martini-odyssey-2026)** —
  Paulo C. T. Souza, Robin Corey, Antonios Kolocouris ve ekibinin düzenlediği okulun
  hands-on materyali. Bu deponun yapısı ondan esinlenmiştir.
- **[CHARMM-GUI](https://charmm-gui.org)** — Jo, Kim, Iyer & Im (2008), *J. Comput. Chem.*
- **[GROMACS](https://www.gromacs.org)** · **[bentopy](https://github.com/marrink-lab/bentopy)**

Kurs materyalinin kendisi **CC BY 4.0** ile lisanslıdır — bkz. [LICENSE](LICENSE).

---

## ❓ Sorularınız için

Kurs sekreteryası: Doç. Dr. Ayşegül Durak — `atoy@ankara.edu.tr`
Depo ile ilgili teknik sorunlar için bu deponun **Issues** sekmesini kullanabilirsiniz.
