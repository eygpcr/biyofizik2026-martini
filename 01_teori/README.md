# Oturum 1 — Moleküler Dinamiğin Temelleri ve Ölçek Problemi

**09:00–09:45 (45 dakika) · Prof. Dr. Nazmi Yaraş, Doç. Dr. Mustafa Tekpınar**

---

## Oturumun kapsamı

Bu oturumda aşağıdaki sorular ele alınmaktadır:

1. Moleküler dinamik (MD) simülasyonu hangi büyüklüğü hesaplamaktadır?
2. Atomistik simülasyonların hücresel ölçeğe erişimini kısıtlayan etkenler
   nelerdir?
3. Kaba-taneli (coarse-grained) yaklaşım bu kısıtı nasıl aşmakta ve karşılığında
   hangi bilgi kaybedilmektedir?

---

## İçerik

### 1. Moleküler dinamiğin çalışma ilkesi (yaklaşık 15 dakika)

- **Kuvvet alanı.** Bir moleküler sistemin potansiyel enerjisinin atom
  koordinatlarının fonksiyonu olarak ifade edilmesi: bağ gerilmesi, açı bükülmesi,
  dihedral dönme, van der Waals ve elektrostatik terimleri.
- **Hareket denklemlerinin integrasyonu.** Newton denklemlerinin sonlu zaman
  adımlarıyla çözülmesi; leap-frog ve velocity Verlet algoritmaları.
- **Zaman adımı seçimi.** Sistemdeki en yüksek frekanslı hareket (C–H gerilmesi)
  zaman adımını belirlemektedir. LINCS ve SETTLE kısıtlama algoritmalarıyla bağ
  uzunluklarının sabitlenmesi zaman adımının büyütülmesine olanak vermektedir.
- **Periyodik sınır koşulları.** Sonlu bir simülasyon kutusu ile makroskobik
  sistemin temsil edilmesi.
- **Termostat ve barostat.** NVT ve NPT topluluklarında sıcaklık ve basıncın
  denetlenmesi.

### 2. Ölçek problemi (yaklaşık 15 dakika)

Atomistik simülasyonlar iki bağımsız kısıt altındadır:

| Kısıt | Nicel karşılığı |
|---|---|
| Zaman ölçeği | 2 fs'lik adımlarla 1 µs'ye ulaşmak 5 × 10⁸ integrasyon adımı gerektirmektedir |
| Uzunluk ölçeği | 40 nm genişliğinde bir membran yaması milyonlarca atom içermekte, bunların büyük kısmını çözücü oluşturmaktadır |

Biyolojik açıdan ilgi çekici süreçlerin önemli bir bölümü (protein
oligomerizasyonu, lipit alanlarının oluşumu, vezikül füzyonu) mikrosaniye–
milisaniye zaman ve 10–100 nm uzunluk aralığında gerçekleşmektedir. Bu aralık,
atomistik simülasyonların erişim sınırının dışında kalmaktadır.

### 3. Martini 3 kuvvet alanı (yaklaşık 15 dakika)

- **Haritalama ilkesi.** Tipik olarak dört ağır atom tek bir etkileşim
  merkezinde (bead) temsil edilmektedir; çözücü molekülleri de aynı şekilde
  gruplanmaktadır.
- **Kazanılan hesaplama hızı.** Parçacık sayısındaki yaklaşık on kat azalma,
  potansiyel yüzeyinin yumuşamasına bağlı daha büyük zaman adımı (20–30 fs) ve
  hızlanmış difüzyon birlikte üç–dört mertebelik hızlanma sağlamaktadır.
- **Parametrizasyon yaklaşımı.** Martini parametreleri kuantum kimyasal
  hesaplardan türetilmemekte, deneysel bölünme katsayılarına (partitioning free
  energies) göre kalibre edilmektedir. Bu tercih, modelin hem genelleştirilebilir
  olmasını sağlamakta hem de uygulanabilirlik sınırını belirlemektedir.
- **Kaybedilen bilgi.**
  - Atomik ayrıntı: yan zincir konformasyonu ve hidrojen bağı yönelimi
  - Protein ikincil ve üçüncül yapısı korunmamakta; elastik ağ (elastic network)
    ile dışarıdan kısıtlanmaktadır
  - Serbest enerji yüzeyinin yumuşaması nedeniyle gözlenen zaman ölçeği gerçek
    değil etkin (effective) zamandır

**Günün akışıyla ilişkisi.** Sabah oturumlarında atomistik, öğleden sonra ise
kaba-taneli modellerin girdileri hazırlanacaktır. Her iki model de aynı protein
(AT2R) üzerinde kurulacağından, iki yaklaşımın farkı doğrudan
karşılaştırılabilecektir.

---

## Kurs öncesi okuma listesi

Listenin tamamının okunması beklenmemektedir. Bir veya iki kaynağın incelenmesi,
kullanılacak terminolojinin tanıdık hâle gelmesi için yeterlidir.

### Giriş düzeyi

- [Martini 3'e giriş — cgmartini.nl](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/)
  (yalnızca giriş bölümü, yaklaşık 10 dakika)
- [GROMACS: What is molecular dynamics?](https://manual.gromacs.org/current/reference-manual/introduction.html)
  (yaklaşık 10 dakika)

### İleri düzey

- Souza, P. C. T. ve ark. (2021). *Martini 3: a general purpose force field for
  coarse-grained molecular dynamics.* Nature Methods, 18, 382–388.
  [doi:10.1038/s41592-021-01098-3](https://doi.org/10.1038/s41592-021-01098-3)
- Marrink, S. J., Tieleman, D. P. (2013). *Perspective on the Martini model.*
  Chemical Society Reviews, 42, 6801–6822.
  [doi:10.1039/C3CS60093A](https://doi.org/10.1039/C3CS60093A)

---

## Sunum

Oturumun sunum dosyası kurs günü bu klasöre eklenecektir (`slaytlar.pdf`).
