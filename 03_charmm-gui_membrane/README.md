# Oturum 3 — CHARMM-GUI Membrane Builder

**🕚 11:00–12:15 · 75 dk · Dr. Öğr. Üyesi Ekrem Yaşar**
**Sistem: PDB [`6JOD`](https://www.rcsb.org/structure/6JOD) — Anjiyotensin II tip-2 reseptörü (AT2R)**

---

## Hedef

Oturum 2'de her şey kolaydı: tek zincir, kofaktör yok, karar yok.
Şimdi **gerçek bir yapıyla** çalışıyoruz. Bu oturumda öğreneceğiniz asıl şey
tıklama sırası değil, **her adımda verilecek kararlar**.

---

## Önce yapıya bakalım

`6JOD` içinde **5 zincir** var. Ama bunların yalnız ikisi bizim proteinimiz:

| Zincir | Uzunluk | Ne | Karar |
|---|---|---|---|
| **A** | 312 aa | **Anjiyotensin II tip-2 reseptörü (AT2R)** — asıl GPCR | ✅ **tut** |
| **B** | 8 aa | **Anjiyotensin II** — agonist peptit (ligand) | ✅ **tut** |
| **C** | 86 aa | **BRIL** (çözünür sitokrom b562) — kristalizasyon füzyonu | ❌ **sil** |
| **H** | 220 aa | 4A03 Fab ağır zincir — kristalizasyon yardımcısı | ❌ **sil** |
| **L** | 212 aa | 4A03 Fab hafif zincir | ❌ **sil** |

> 🎓 **Günün en önemli dersi olabilir:**
> **PDB'de gördüğünüz her zincir proteinin parçası değildir.**
>
> GPCR'ler kristalleşmeye direnir. Araştırmacılar bunu aşmak için ya proteine
> **BRIL/T4-lizozim gibi bir füzyon** ekler, ya da **Fab fragmanıyla** komplekse
> sokar. Bunlar deneysel araçlardır — hücrede yoktur. Simülasyona koyarsanız,
> olmayan bir şeyi simüle etmiş olursunuz.
>
> Burada işimiz kolay: BRIL ayrı bir zincir (C) olarak deposit edilmiş, silmek
> yeterli. **Bazı yapılarda BRIL doğrudan ICL3 loop'unun içine yerleştirilmiştir**
> — o zaman zinciri silemezsiniz, dizinin ortasından kesip çıkarmanız gerekir.
> Yapının makalesine bakmadan bunu anlayamazsınız.

📁 Ham yapı: [`girdi/6jod.pdb`](girdi/6jod.pdb)
📁 Zincirleri ayıklanmış hâli (yedek): [`girdi/6jod_chainAB.pdb`](girdi/6jod_chainAB.pdb)

---

## Yapının bize söyledikleri

Kursta bu bilgileri birlikte çıkaracağız — ama önce elimizde ne olduğunu bilelim:

| | |
|---|---|
| **Çözünürlük** | 3.2 Å (X-ray) — düşük sayılır, yan zincirlere fazla güvenmeyin |
| **Chain A'da çözülmüş rezidüler** | **35–340** arası, 306 rezidü |
| **Eksik rezidüler** | **341–346** (C-terminal kuyruk, 6 rezidü) |
| **İç loop boşluğu** | **Yok** — şanslıyız |
| **Chain A disülfitleri** | **Cys35–Cys290** ve **Cys117–Cys195** |
| **Kofaktör / küçük molekül** | Yok (ligand bir peptit, ayrı zincir) |

> 🔍 **Tartışma:** Eksik olan 6 rezidü C-terminal kuyrukta. Bunları modellemek
> zorunda mıyız? Peki eksik olan bir **iç loop** olsaydı ne yapardık?
> *(Cevap: iç boşluk topolojiyi kopardığı için mutlaka modellenmeli —
> MODELLER, AlphaFold veya CHARMM-GUI'nin kendi loop modelleme aracıyla.)*

---

## Adım adım

### 1 · Yapıyı yükle ve zincirleri ayıkla
1. **Input Generator → Membrane Builder → Bilayer Builder**
2. **PDB ID:** `6JOD` *(veya `girdi/6jod.pdb`'yi yükleyin)*
3. Zincir listesinde **A ve B'yi işaretli bırakın; C, H, L'yi kaldırın**
4. Kristal sularını atın

> ⚠️ Bu adımı yanlış yaparsanız geri kalan 70 dakika boşa gider. İki kez kontrol edin.

### 2 · Model kararları (Manipulate PDB)

**a) Terminal grupları.** Chain A 35'ten başlayıp 340'ta bitiyor — yani hem N hem
C ucu "kesik". Standart NTER/CTER (yüklü uçlar) mı, yoksa nötr uçlar (ACE/CT3) mi?

> 🎓 Kesilmiş bir dizinin ucuna yüklü grup koymak, orada olmayan bir yükü
> sisteme sokar. Membran içine yakın bir uç için bu ciddi bir yapaylıktır.

**b) Disülfitler.** Cys35–Cys290 ve Cys117–Cys195 listede görünüyor mu?
Cys35–Cys290 bağı, GPCR ailesinde N-terminusu ECL3'e bağlayan korunmuş bir bağdır.

**c) Ligand.** Chain B (Anjiyotensin II) 8 rezidülük bir **peptit** — yani
CHARMM-GUI onu normal bir protein zinciri gibi işleyebiliyor.

> 🎓 Şanslıyız. Ligand küçük bir **organik molekül** olsaydı, kuvvet alanı
> parametrelerini ayrıca üretmemiz gerekirdi (CGenFF / Ligand Reader & Modeler).

**d) Mutasyon.** CHARMM-GUI arayüzünden nokta mutasyonu nasıl girilir —
birlikte deneyeceğiz. *(Kendi araştırmanızda bir varyantı çalışacaksanız
başlangıç noktanız burasıdır.)*

### 3 · Protonasyon durumları ve pH

Oturum 2'de hızlıca geçtiğimiz konu burada kritik hale geliyor.

- **Histidinler:** HSD (Nδ), HSE (Nε), HSP (çift protonlu, +1 yüklü).
  Varsayılan genelde HSE'dir — ama doğru mu?
- **Membrana gömülü Asp/Glu:** Suyun olmadığı hidrofobik ortamda bir karboksil
  grubun protonlu (nötr) kalması çok olağandır. Varsayılan ise deprotone (yüklü).

> 🎓 **Kuvvet alanı pH bilmez.** pH'ı sisteme, protonasyon durumlarını seçerek
> siz söylersiniz. Yanlış seçim, simülasyon boyunca *sessizce* yanlış kalır —
> hata mesajı almazsınız.
>
> 💡 Ciddi bir çalışmada bu kararı tahminle değil, `PROPKA` / `H++` gibi
> araçlarla verirsiniz.

### 4 · Membrana yerleştirme (Orientation)

- **PPM / OPM** ile otomatik yerleştirme: protein membran normaline göre
  nasıl hizalanır
- Sonucu **gözle kontrol edin**: TM heliksleri gerçekten membranın içinde mi?
  Hidrofobik kuşak lipid kuyruklarıyla örtüşüyor mu?

> ⚠️ Otomatik yerleştirmeye körü körüne güvenmeyin. Görselleştirmeden
> bir sonraki adıma geçmeyin.

### 5 · Lipid kompozisyonu

Burada gerçek bir bilimsel karar veriyorsunuz:

| Seçenek | Ne zaman |
|---|---|
| Saf **POPC** | Basit, hızlı, karşılaştırılabilir. "Standart" membran |
| **POPC/POPE/CHOL** | Plazma membranına daha yakın |
| Asimetrik çift tabaka | İç ve dış yaprakçık farklı — gerçekçi ama kurulumu zor |

Kursta **POPC** ile devam edip, kolesterol eklemenin sonucu nasıl değiştireceğini
tartışacağız.

- **Kutu boyutu:** protein çevresinde en az ~20 Å lipid olsun
- **Su tabakası:** membranın her iki yanında ≥ 22.5 Å
- **İyonlar:** 0.15 M KCl

### 6 · Kuvvet alanı ve çıktı

- **Force field:** CHARMM36m
- **Input generation:** **GROMACS**
- İş bitince `charmm-gui.tgz` indirin

---

## Ne indirdik?

Oturum 2'deki yapının aynısı — ama artık `topol.top` içinde lipidler de var:

```
[ molecules ]
PROA     1        ← AT2R
PROB     1        ← Anjiyotensin II
POPC   256        ← lipidler
TIP3  12000+      ← su
POT/CLA  ...      ← iyonlar
```

> 🔍 Sistem kaç atom oldu? Oturum 2'deki lizozim sistemiyle karşılaştırın.
> Bu boyutta bir sistemi 1 μs koşmak ne kadar sürer?
>
> **İşte tam bu noktada Martini devreye giriyor** — öğleden sonraki oturum.

---

## Kapanış: Büyük sistemlerde bu iş nasıl ölçeklenir?

Bugün tek bir GPCR ile çalıştık. Ya araştırmanız şunu gerektiriyorsa:

- **10 kopya** GPCR (oligomerizasyon çalışmak için)
- **40–50 nm** genişlikte bir membran yaması
- Gerçekçi, çok bileşenli bir lipid karışımı
- Sitozolik kalabalık (crowding)

CHARMM-GUI bu ölçekte **pratik değildir**: iş süresi patlar, arayüzde
yönetilemez hale gelir. Bu yüzden öğleden sonra **komut satırına** geçiyoruz —
ve çözünürlüğü düşürüyoruz (Martini).

---

## 🆘 Takılırsanız

Hazır CHARMM-GUI çıktısı [`cikti/`](cikti/) klasöründe. Zincir ayıklamada
takıldıysanız [`girdi/6jod_chainAB.pdb`](girdi/6jod_chainAB.pdb) dosyasını
doğrudan yükleyebilirsiniz — C, H ve L zincirleri zaten çıkarılmış.
