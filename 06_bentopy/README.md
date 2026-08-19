# Oturum 6 — Bentopy: Kalabalık Hücresel Sistemler

**🕟 16:35–17:15 · 40 dk · Dr. Öğr. Üyesi Ekrem Yaşar**

📓 **Colab notebook:** [`notebooks/06_bentopy.ipynb`](../notebooks/06_bentopy.ipynb)
🎬 **Uygulama videosu:** [`VIDEO.md`](VIDEO.md)

---

## Kursun geldiği yer

Bugün nereden nereye geldiğimize bakalım:

| Oturum | Sistem | Ölçek |
|---|---|---|
| 2 | Suda 1 lizozim | ~5 nm |
| 3 | Membranda 1 GPCR (all-atom) | ~10 nm |
| 4 | Membranda 1 GPCR (Martini) | ~12 nm |
| **6** | **Kalabalık membran + sitozol** | **40–100 nm** |

Kursun adı **"büyük ve kalabalık hücresel sistemler"**. İşte o kısım burası.

---

## Neden "kalabalık"?

Simülasyonlarımızın çoğu proteini **seyreltik çözeltide** inceler. Ama hücre
öyle değil:

- Sitoplazmada protein derişimi **~300 g/L** — hacmin %20–30'u makromolekül
- Membranda protein/lipid oranı çok yüksek; proteinler birbirine değer
- Bu kalabalık **difüzyonu yavaşlatır**, **bağlanma dengelerini kaydırır**,
  katlanmayı ve oligomerleşmeyi etkiler

Yani seyreltik simülasyonlarımız, hücrede olan biteni sistematik olarak
kaçırıyor olabilir.

**Sorun:** 100 tane proteini bir kutuya elle yerleştirmek imkânsız. Çakışmadan,
doğru yönelimle, doğru derişimde nasıl yerleştirilir?

**Cevap:** [`bentopy`](https://github.com/marrink-lab/bentopy)

---

## bentopy ne yapar?

Üç aşamalı bir araç:

| Aşama | Komut | Ne yapar |
|---|---|---|
| **1. Pack** | `bentopy pack` | Verdiğiniz yapıları, verdiğiniz derişimde, çakışmadan bir kutuya yerleştirir |
| **2. Render** | `bentopy render` | Yerleşim planından gerçek koordinat dosyasını (`.gro`) üretir |
| **3. Solvate** | `bentopy solvate` | Kalan boşluğu su ve iyonla doldurur |

Çıktı: doğrudan GROMACS'e verilebilecek bir sistem.

---

## Kursta ne yapacağız?

Oturum 4'te ürettiğimiz **kaba-taneli AT2R**'yi alıp, bir membranda
**çok kopyalı** bir sistem kuracağız.

> 🎯 Bu, kongre sitesindeki kurs tanıtımında geçen **"GPCR oligomerizasyonu"**
> konusunun kapısını açan adımdır: reseptörleri gerçekçi bir yoğunlukta yan yana
> koyup birbirlerini bulmalarını izleyebilirsiniz.

### Kaba akış

```bash
# 1. Yerleşim tanımı (JSON) hazırla: kutu boyutu, hangi yapıdan kaç tane
bentopy pack yerlesim.json -o plan.json

# 2. Plandan koordinatları üret
bentopy render plan.json -o kalabalik.gro

# 3. Boşluğu doldur
bentopy solvate -f kalabalik.gro -o sistem.gro
```

Ayrıntılar ve tam JSON şablonu notebook'ta.

---

## İki senaryo

Bu oturum için 40 dakikamız var ve `bentopy` kurulumu bazen sürprizli olabiliyor.

**Senaryo A — kurulum sorunsuz:** Notebook'u birlikte çalıştırıp kendi
kalabalık sistemimizi kuruyoruz.

**Senaryo B — takılırsak:** Zaman kaybetmeden geçiyoruz. Elinizde kalanlar:
- ✅ Tüm komutlar ve JSON şablonu → [`kodlar/`](kodlar/)
- ✅ Baştan sona uygulama videosu → [`VIDEO.md`](VIDEO.md)
- ✅ Hazır çıktı dosyaları

Her iki durumda da kurstan **çalışan bir örnekle** ayrılıyorsunuz.

---

## Buradan sonrası

Kalabalık sistem kurmak işin sadece başlangıcı. Devam etmek isterseniz:

- 🔗 [bentopy resmî tutorial'ı](https://cgmartini.nl/docs/tutorials/Martini3/Bentopy/) —
  kursta değinemediğimiz tüm ayrıntılar
- 🔗 [bentopy GitHub](https://github.com/marrink-lab/bentopy) — dokümantasyon, örnekler
- 🔗 [Protein kompleksleri — Martini](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsIIb/) —
  oligomerizasyonu analiz etmek için
- 🔗 [TS2CG v2.0](https://github.com/weria-pezeshkian/TS2CG-v2.0/wiki/Tutorial) —
  düz yama yerine vezikül, tübül, karmaşık şekiller

Ve tabii: [`../ILERI_OKUMA.md`](../ILERI_OKUMA.md)
