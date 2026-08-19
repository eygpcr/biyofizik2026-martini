# Oturum 5b — Martini'de Analiz Nasıl Değişir?

**🕓 16:00–16:20 · 20 dk · Dr. Öğr. Üyesi Ekrem Yaşar**

---

## Hedef

5a'da all-atom trajektoriye baktık. Aynı analizleri Martini'ye uyguladığımızda
**neyin aynı kaldığını, neyin değiştiğini ve neyin tamamen anlamsızlaştığını**
göreceğiz.

---

## Analiz analiz karşılaştırma

| Analiz | Martini'de durum | Not |
|---|---|---|
| **RMSD** | ⚠️ Çalışır ama **yorumu farklı** | Elastic network yapıyı zaten sabitliyor; düşük RMSD "protein kararlı" demek değil, "yaylar işini yapıyor" demek |
| **RMSF** | ✅ Anlamlı | Hangi bölgelerin esnek olduğu hâlâ bilgi verir — ama elastic network'ün etkisi altında |
| **Rg** | ✅ Çalışır | Elastic network yüzünden neredeyse sabit çıkar |
| **Hidrojen bağı** | ❌ **Mümkün değil** | Martini'de hidrojen yok. `gmx hbond` çalıştıramazsınız |
| **Yoğunluk profili** | ✅ Çok iyi çalışır | Membran analizi Martini'nin en güçlü olduğu alan |
| **Lipid–protein teması** | ⭐ **Asıl güçlü yanı** | Uzun sürelere erişebildiğiniz için istatistik anlamlı hale gelir |
| **Difüzyon / MSD** | ⚠️ Çalışır ama ölçek düzeltmesi gerekir | Martini dinamiği ~4× hızlıdır |

> 🎓 **Ana fikir:** Martini'de aynı komutları koşabilirsiniz — ama bazı
> soruların **cevabı artık anlamlı değildir**. Aracı seçerken sorunuzu
> seçmiş olursunuz.

---

## 1 · Görselleştirme: MartiniGlass · ~7 dk

CG yapıyı doğrudan VMD'de açarsanız **bağlar görünmez** — çünkü `.gro` dosyası
bağ bilgisi taşımaz, VMD de bead'ler arası mesafeden bağ tahmin edemez.
Protein bir "nokta bulutu" gibi görünür.

**Çözüm:** [MartiniGlass](https://martiniglass.readthedocs.io/) — topolojiden
bağ bilgisini okuyup VMD'nin anlayacağı dosyaları üretir.

```bash
pip install martiniglass
martiniglass -p sistem.top
```

> 💡 Küçük bir araç ama Martini ile çalışacaksanız **her gün** kullanacaksınız.
> Bir sistemi gözle kontrol edemiyorsanız, hata yaptığınızı da göremezsiniz.

---

## 2 · Lipid–protein etkileşim haritaları · ~10 dk

Martini'nin gerçekten parladığı yer burası. All-atom'da 100 ns'de birkaç lipid
değişimi görürsünüz — istatistik yapmak için yeterli değil. Martini'de 10 μs
koşup, hangi lipidin proteinin hangi bölgesinde ne kadar kaldığını
**sayısal olarak** söyleyebilirsiniz.

**Basit yol — `gmx` ile:**

```bash
# Protein çevresindeki lipid baş gruplarının temas sayısı
gmx select -s md.tpr -f md.xtc -select 'resname POPC and within 0.6 of group "Protein"' -os temas.xvg
```

**Özel araçlar (kurulum ağır, kursta göstereceğiz sadece):**

- 🔗 [ProLint2](https://cgmartini.nl/docs/tutorials/Martini3/ProLint/) —
  interaktif web arayüzü, temas süreleri, bağlanma bölgeleri
- 🔗 [PyLipID](https://pylipid.readthedocs.io/) — rezidans süresi, bağlanma
  bölgesi kümeleme

---

## 3 · Zaman ölçeği düzeltmesi · ~3 dk

Martini'nin pürüzsüz enerji manzarası dinamiği hızlandırır. Su difüzyonuna
kalibre edilmiş kabaca **4×** çarpanı yaygın kullanılır.

| | |
|---|---|
| Simülasyon zamanı | 10 μs |
| Efektif zaman | ~40 μs |

> ⚠️ Bu çarpan **evrensel değildir** — sisteme ve incelenen sürece bağlıdır.
> Yayında hangi zamanı raporladığınızı açıkça yazın.

---

## Özet: hangi soru için hangi araç?

| Sorunuz | Araç |
|---|---|
| Bir yan zincirin tam konformasyonu | **All-atom** |
| Spesifik hidrojen bağı ağı | **All-atom** |
| Ligand bağlanma pozunun detayı | **All-atom** |
| Protein oligomerleşiyor mu? | **Martini** |
| Hangi lipid proteine yapışıyor? | **Martini** |
| 40 nm'lik membranda ne oluyor? | **Martini** |
| Hücresel kalabalıkta difüzyon | **Martini** |

**En iyisi:** ikisini birlikte kullanmak. Martini ile geniş tarama yapıp ilginç
durumu bulun, sonra o durumu all-atom'a geri haritalayıp (backmapping) detaylı
inceleyin.
