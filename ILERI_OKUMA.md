# İleri Okuma ve Çalışma Kaynakları

Bir günlük kurs süresi içinde ele alınması mümkün olmayan konular bu belgede
derlenmiştir. Her başlık için kapsam dışı bırakılma gerekçesi belirtilmiş olup,
katılımcıların kendi araştırma alanlarına göre seçim yapabilmeleri
amaçlanmıştır.

---

## 1. Öncelikli olarak önerilen konular

### 1.1. GPCR–ligant bağlanma simülasyonları (Martini 3)

Kursta AT2R lipit çift tabakasına yerleştirilmiş, ancak bağlanma süreci
simüle edilmemiştir. Doğrudan devam niteliğindeki kaynak:

- [Adenozin A2 reseptörüne kafein bağlanması](https://github.com/M2BMI-Lab/Workshop-MartiniOdyssey/blob/main/Tutorial-Simulation-with-GPCR-AutoMartiniM3-MartiniOdyssey.md)

Bu materyal, kursta öğrenilen `martinize2` ve `insane` iş akışı üzerine
kurulmaktadır. GPCR sistemleriyle çalışan katılımcılar için en uygun devam
noktasıdır.

### 1.2. Martini modelinin sınırlılıkları

Oturum 4'te özet olarak ele alınmıştır. Tam metnin incelenmesi, ileride
karşılaşılabilecek yorumlama hatalarının önlenmesi açısından önerilmektedir.

- [Notes and Limitations](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut4.html)

---

## 2. Simülasyon yürütme

Kursun kapsamı girdi hazırlama ile sınırlı tutulmuştur. Simülasyon yürütmeye
ilişkin kaynaklar:

- [Membran kendiliğinden oluşumu](https://cgmartini.nl/docs/tutorials/Martini3/LipidsI/) —
  dağınık lipitlerden çift tabaka oluşumu. Mikrosaniye mertebesinde kaba-taneli
  simülasyon gerektirdiğinden kapsam dışı bırakılmıştır.
- [Transmembran peptit simülasyonları](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsIIa/) —
  `martinize2` ve `insane` araçlarını birleştiren en küçük ölçekli uçtan uca
  örnek. Kursta yedek uygulama olarak öngörülmüştür.
- [GROMACS öğretim materyalleri](https://tutorials.gromacs.org/) — atomistik
  simülasyonlar için

---

## 3. Protein modellemesinde derinleşme

- [Martini protein modeline giriş](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/) —
  Oturum 4'ün kuramsal arka planı
- [Protein modelinin niteliğinin değerlendirilmesi](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut2.html) —
  elastik ağ parametrelerinin uygunluğunun sınanması
- [Protein kompleksleri](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsIIb/) —
  GPCR oligomerizasyonu üzerine çalışan katılımcılar için
- [Düzensiz bölgeler (IDR)](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut3.html) —
  elastik ağ yaklaşımının uygulanamadığı durumlar

---

## 4. Membran ve lipit sistemleri

- [COBY](https://github.com/MikkelDA/COBY/tree/master/Tutorial) — `insane`
  aracına güncel bir alternatif; daha esnek yapılandırma ve daha geniş lipit
  desteği sunmaktadır. Kursta ikinci bir aracın öğretilmesi bilişsel yükü
  artıracağı için kapsam dışı bırakılmıştır.
- [TS2CG v2.0](https://github.com/weria-pezeshkian/TS2CG-v2.0/wiki/Tutorial) —
  vezikül, tübül ve karmaşık geometrili membran yapıları
- [Lipit nanopartikül modellemesi](https://zenodo.org/records/19632806) — ilaç
  taşıyıcı sistemler

---

## 5. Analiz araçları

Oturum 5'te temel GROMACS analiz araçları ele alınmıştır. Lipit–protein
etkileşimlerine özelleşmiş araçlar:

- [ProLint2](https://cgmartini.nl/docs/tutorials/Martini3/ProLint/) —
  lipit–protein temas analizi ve etkileşimli görselleştirme arayüzü. Kurulum
  gereksinimleri nedeniyle kursta yalnızca tanıtılmıştır.
- [PyLipID](https://pylipid.readthedocs.io/en/master/tutorial.html) — bağlanma
  bölgesi belirleme ve rezidans süresi analizi
- [MartiniGlass](https://martiniglass.readthedocs.io/) — kaba-taneli yapıların
  VMD ortamında doğru görselleştirilmesi

---

## 6. Küçük molekül parametrizasyonu

Kendi ligandının Martini modelini oluşturması gereken katılımcılar için:

- [Elle parametrizasyon](https://cgmartini.nl/docs/tutorials/Martini3/Small_Molecule_Parametrization/) —
  yöntemin ilkelerini kavramak amacıyla
- [Auto-MartiniM3](https://github.com/M2BMI-Lab/Workshop-MartiniOdyssey/blob/main/Tutorial-Parametrization-AutoMartiniM3-MartiniOdyssey.md) —
  otomatik parametrizasyon

---

## 7. İleri düzey konular

- [Serbest enerji teknikleri](https://cgmartini.nl/docs/tutorials/Martini3/Free_Energy_Techniques/) —
  bağlanma serbest enerjisi ve membran geçiş bariyerlerinin hesaplanması
- [bentopy](https://cgmartini.nl/docs/tutorials/Martini3/Bentopy/) — Oturum 6'nın
  tam öğretim materyali

---

## 8. Genel başvuru kaynakları

| Kaynak | Açıklama |
|---|---|
| [cgmartini.nl](https://cgmartini.nl/) | Martini kuvvet alanının resmî sitesi; öğretim materyalleri, parametre dosyaları ve tartışma forumu |
| Souza ve ark. (2021) | *Martini 3: a general purpose force field for coarse-grained molecular dynamics.* Nature Methods, 18, 382–388. [doi:10.1038/s41592-021-01098-3](https://doi.org/10.1038/s41592-021-01098-3) |
| [CHARMM-GUI](https://charmm-gui.org) | Tüm modüllerin belgelendirmesi |
| [GROMACS kılavuzu](https://manual.gromacs.org/) | Komut referansı |

---

Kendi araştırma konusuna uygun bir çalışma programı talep eden katılımcılar
eğitmenlerle iletişime geçebilirler.
