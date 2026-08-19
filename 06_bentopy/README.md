# Oturum 6 — `bentopy` ile Kalabalık Hücresel Sistemler

**16:35–17:15 (40 dakika) · Dr. Öğr. Üyesi Ekrem Yaşar**

Colab not defteri: [`notebooks/06_bentopy.ipynb`](../notebooks/06_bentopy.ipynb)
Uygulama kaydı: [`VIDEO.md`](VIDEO.md)

---

## Kurs boyunca izlenen ölçek gelişimi

| Oturum | Sistem | Karakteristik uzunluk |
|---|---|---|
| 2 | Çözelti içinde tek lizozim molekülü | yaklaşık 5 nm |
| 3 | Membranda tek reseptör, atomistik | yaklaşık 10 nm |
| 4 | Membranda tek reseptör, kaba-taneli | yaklaşık 12 nm |
| 6 | Kalabalık membran ve sitozol | 40–100 nm |

Kursun başlığında yer alan "büyük ve kalabalık hücresel sistemler" ifadesi bu
oturumun konusunu oluşturmaktadır.

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

Bu nedenle seyreltik koşullarda yürütülen simülasyonlar, hücre içi süreçleri
sistematik biçimde eksik temsil edebilmektedir.

**Yöntemsel güçlük.** Çok sayıda makromolekülün çakışma oluşturmadan, uygun
yönelimlerle ve hedeflenen derişimde bir simülasyon kutusuna yerleştirilmesi elle
yapılabilecek bir işlem değildir.

**Çözüm.** [`bentopy`](https://github.com/marrink-lab/bentopy)

---

## `bentopy` iş akışı

| Aşama | Komut | İşlev |
|---|---|---|
| 1 | `bentopy pack` | Tanımlanan yapıların, belirtilen derişimde ve çakışmasız biçimde kutuya yerleştirilmesi |
| 2 | `bentopy render` | Yerleşim planından koordinat dosyasının üretilmesi |
| 3 | `bentopy solvate` | Kalan boşluğun çözücü ve iyonlarla doldurulması |

Elde edilen sistem doğrudan GROMACS girdisi olarak kullanılabilmektedir.

---

## Oturumda yürütülecek uygulama

Oturum 4'te üretilen kaba-taneli AT2R modeli kullanılarak, çok sayıda reseptör
kopyası içeren bir membran sistemi kurulacaktır.

Bu uygulama, kongre programında duyurulan GPCR oligomerizasyonu konusunun
yöntemsel ön koşulunu oluşturmaktadır: reseptörlerin fizyolojik yoğunluğa yakın
bir dağılımda yerleştirilmesi, oligomerleşme süreçlerinin izlenebilmesini
sağlamaktadır.

### İşlem sırası

```bash
# 1. Yerleşim tanımının hazırlanması (kutu boyutu, kopya sayısı)
bentopy pack yerlesim.json -o plan.json

# 2. Plandan koordinatların üretilmesi
bentopy render plan.json -o kalabalik.gro

# 3. Boşluğun çözücü ile doldurulması
bentopy solvate -f kalabalik.gro -o sistem.gro
```

Ayrıntılar ve tam yapılandırma şablonu Colab not defterinde yer almaktadır.

---

## Uygulama planı

Oturum için ayrılan süre 40 dakika olup, `bentopy` kurulumunda ortam kaynaklı
sorunlar oluşabilmektedir. Bu nedenle iki senaryo öngörülmüştür:

**Birinci senaryo.** Kurulum sorunsuz tamamlanırsa not defteri birlikte
çalıştırılarak sistem kurulumu yapılacaktır.

**İkinci senaryo.** Sorun yaşanması hâlinde uygulama sonlandırılarak aşağıdaki
materyaller katılımcılarla paylaşılacaktır:

- Tüm komutlar ve yapılandırma şablonu: [`kodlar/`](kodlar/)
- Uygulamanın tam kaydı: [`VIDEO.md`](VIDEO.md)
- Önceden üretilmiş çıktı dosyaları

Her iki durumda da katılımcılar çalışan bir örnek ile kursu tamamlayacaklardır.

---

## İleri çalışma kaynakları

- [bentopy resmî öğretim materyali](https://cgmartini.nl/docs/tutorials/Martini3/Bentopy/)
- [bentopy deposu ve belgelendirmesi](https://github.com/marrink-lab/bentopy)
- [Protein kompleksleri — Martini](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsIIb/) —
  oligomerizasyon analizi
- [TS2CG v2.0](https://github.com/weria-pezeshkian/TS2CG-v2.0/wiki/Tutorial) —
  vezikül, tübül ve karmaşık geometrili yapılar

Ayrıca bkz. [`ILERI_OKUMA.md`](../ILERI_OKUMA.md)
