# İleri Okuma — Kurstan Sonra Nereden Devam Edilir?

Tek günde her şeyi yapmak mümkün değildi. Bu sayfa, kursta **kasıtlı olarak
kapsam dışı bıraktığımız** konuları ve bunlara nereden devam edebileceğinizi
topluyor.

Neyi neden çıkardığımızı da yazdık — böylece hangisinin sizin işinize
yarayacağına kendiniz karar verebilirsiniz.

---

## ⭐ Önce buradan başlayın

### GPCR–ligand bağlanma simülasyonları (Martini 3)
Kursta AT2R'yi membrana gömdük ama **bağlanma sürecini** simüle etmedik.
Doğal bir sonraki adım tam olarak bu:

- 🔗 [Adenozin A2 reseptörüne kafein bağlanması](https://github.com/M2BMI-Lab/Workshop-MartiniOdyssey/blob/main/Tutorial-Simulation-with-GPCR-AutoMartiniM3-MartiniOdyssey.md)

Kursta öğrendiğiniz `martinize2` + `insane` akışının üzerine doğrudan oturuyor.
Bir GPCR ile çalışıyorsanız buradan devam edin.

### Martini'nin sınırlılıkları
Kursta 10 dakika değindik. Tamamını okumak, ilerideki birçok hatadan kurtarır:

- 🔗 [Notes and Limitations](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut4.html)

---

## 🧪 Simülasyon koşmayı öğrenmek

Kursun kapsamı input hazırlamaydı. Simülasyonu gerçekten koşmak isterseniz:

- 🔗 [Membran kendiliğinden oluşumu (self-assembly)](https://cgmartini.nl/docs/tutorials/Martini3/LipidsI/) —
  Martini'nin en görsel demosu: dağınık lipidlerden çift tabaka oluşumu. Mikrosaniye
  mertebesinde CG simülasyon gerektirir.
- 🔗 [Transmembran peptit simülasyonları](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsIIa/) —
  `martinize2` + `insane`'i birleştiren en küçük uçtan uca örnek. Kursta yedek
  senaryomuzdu; kendi başınıza koşmak için ideal boyutta.
- 🔗 [GROMACS resmî tutorial'ları](https://tutorials.gromacs.org/) — all-atom tarafı için

---

## 🧬 Protein modellemede derinleşme

- 🔗 [Martini protein modeline giriş](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/) —
  Oturum 4'ün teorik arka planı
- 🔗 [Protein modelinin kalitesini değerlendirme](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut2.html) —
  elastic network parametrelerinizin makul olup olmadığını nasıl anlarsınız
- 🔗 [Protein kompleksleri](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsIIb/) —
  **GPCR oligomerizasyonu** ile ilgileniyorsanız buraya bakın
- 🔗 [Düzensiz bölgeler (IDR)](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut3.html) —
  elastic network'ün işe yaramadığı durumlar

---

## 🧫 Membran ve lipid sistemleri

- 🔗 [COBY](https://github.com/MikkelDA/COBY/tree/master/Tutorial) — `insane`'e modern
  alternatif. Daha esnek, daha çok lipid desteği. Kursta ikinci bir araç öğretmek
  kafa karıştırıcı olacağı için çıkardık; `insane`'i öğrendikten sonra geçiş kolay.
- 🔗 [TS2CG v2.0](https://github.com/weria-pezeshkian/TS2CG-v2.0/wiki/Tutorial) —
  vezikül, tübül, karmaşık membran şekilleri
- 🔗 [Lipid nanopartikül (LNP) modelleme](https://zenodo.org/records/19632806) —
  ilaç taşıyıcı sistemlerle çalışıyorsanız

---

## 📊 Analiz araçları

Oturum 5'te temel `gmx` analizlerini gördük. Lipid–protein etkileşimlerine
odaklanan özel araçlar:

- 🔗 [ProLint2](https://cgmartini.nl/docs/tutorials/Martini3/ProLint/) —
  lipid–protein temas analizi, interaktif web arayüzü. Kurulumu biraz ağır olduğu
  için kursta sadece gösterdik.
- 🔗 [PyLipID](https://pylipid.readthedocs.io/en/master/tutorial.html) —
  Jupyter tabanlı, bağlanma bölgesi ve rezidans süresi analizi
- 🔗 [MartiniGlass](https://martiniglass.readthedocs.io/) —
  CG yapıları VMD'de **doğru** görselleştirmek için. Kısacık ama vazgeçilmez.

---

## ⚗️ Küçük molekül parametrizasyonu

Kendi ligandınızın Martini modelini kurmanız gerekiyorsa:

- 🔗 [Manuel parametrizasyon](https://cgmartini.nl/docs/tutorials/Martini3/Small_Molecule_Parametrization/) —
  mantığı öğrenmek için
- 🔗 [Auto-MartiniM3](https://github.com/M2BMI-Lab/Workshop-MartiniOdyssey/blob/main/Tutorial-Parametrization-AutoMartiniM3-MartiniOdyssey.md) —
  otomatik yol

---

## 🎯 İleri seviye

- 🔗 [Serbest enerji teknikleri](https://cgmartini.nl/docs/tutorials/Martini3/Free_Energy_Techniques/) —
  bağlanma serbest enerjisi, membran geçiş bariyerleri
- 🔗 [bentopy](https://cgmartini.nl/docs/tutorials/Martini3/Bentopy/) — Oturum 6'nın
  tam tutorial'ı, kursta değinemediğimiz kısımlarıyla

---

## 📖 Genel kaynaklar

| | |
|---|---|
| [cgmartini.nl](https://cgmartini.nl/) | Martini'nin resmî sitesi — tutorial, kuvvet alanı dosyaları, forum |
| [Martini 3 makalesi](https://doi.org/10.1038/s41592-021-01098-3) | Souza et al., *Nature Methods* (2021) |
| [CHARMM-GUI](https://charmm-gui.org) | Tüm builder'ların dokümantasyonu |
| [GROMACS kılavuzu](https://manual.gromacs.org/) | Komut referansı |
| [MARTINI Odyssey Athens 2026](https://github.com/paulocts/martini-odyssey-2026) | Bu kursun materyal seçiminde referans aldığımız okul |

---

*Kendi araştırmanıza uygun bir yol haritası isterseniz eğitmenlere yazabilirsiniz —
ön toplantıda konuştuğumuz ilgi alanlarına göre buraya ekleme yapabiliriz.*
