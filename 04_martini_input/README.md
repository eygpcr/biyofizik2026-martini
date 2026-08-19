# Oturum 4 — Martini 3 Input Hazırlama

**🕜 13:30–15:00 · 90 dk · Dr. Öğr. Üyesi Ekrem Yaşar**
**Sistem: `6JOD` chain A (AT2R) — sabah hazırladığımız aynı protein**

📓 **Colab notebook:** [`notebooks/04_martini_input.ipynb`](../notebooks/04_martini_input.ipynb)

---

## Hedef

Sabah CHARMM-GUI'de tıklayarak yaptığımız işi, şimdi **terminalden** ve
**kaba-taneli (coarse-grained)** olarak yapıyoruz.

Üreteceğimiz şey sabahkiyle aynı üçlü:

| | Sabah (all-atom) | Şimdi (Martini) |
|---|---|---|
| Koordinat | `step5_input.gro` | `sistem.gro` |
| Topoloji | `topol.top` | `sistem.top` + `molecule_0.itp` |
| Ayarlar | `*.mdp` | `minimization.mdp` |

**Değişen sadece çözünürlük ve araç.** Mantık aynı.

---

## Bölüm A · CHARMM-GUI Martini Maker — ve neden kullanmıyoruz · ~15 dk

*(Ekrandan gösterim, uygulama yok)*

CHARMM-GUI'nin **Martini Maker** diye bir modülü de var. Sabahki arayüzü
öğrendiğiniz için kullanması kolay gelecek. Birlikte açıp bakacağız.

**Ama bu kursta onu kullanmıyoruz. Nedenleri:**

| Sınırlılık | Sonucu |
|---|---|
| Arayüz temelde **tek protein** üzerine kurgulanmış | Oligomer / çok bileşenli sistem kurmak zor |
| Lipid kompozisyonu ve kutu boyutu arayüzün sunduğuyla sınırlı | 40–50 nm'lik yamalar pratik değil |
| Elastic network parametreleri üzerinde **sınırlı kontrol** | Kuvvet sabiti ve kesme mesafesini ince ayarlayamazsınız |
| Her denemede **web arayüzünü baştan doldurmak** gerekir | Tekrarlanabilirlik ve otomasyon yok |
| Ara adımlar kapalı kutu | Bir şey ters giderse nerede olduğunu göremezsiniz |

> 🎓 **Asıl mesele tekrarlanabilirlik.** Terminaldeki bir komut, makaleye
> yazabileceğiniz, bir yıl sonra aynen tekrarlayabileceğiniz bir kayıttır.
> Web formunda yaptığınız 40 tıklama değildir.
>
> Martini Maker **kötü bir araç değil** — hızlı bir tek-protein testi için
> gayet iyi. Sadece bizim gitmek istediğimiz yere götürmüyor.

---

## Bölüm B · Terminalden input hazırlama · ~65 dk

Tüm bu bölüm Colab notebook'unda adım adım ilerliyor.
Aşağıdaki özet, kursta ne yaptığımızı sonradan hatırlamanız için.

### Kullanacağımız araçlar

| Araç | Ne yapar |
|---|---|
| **`martinize2`** | All-atom protein → Martini 3 kaba-taneli model + topoloji |
| **`insane`** | Membran inşa eder, proteini gömer, su ve iyon ekler |
| **`gmx grompp`** | Koordinat + topoloji + ayarları birleştirip `.tpr` üretir (doğrulama) |

### Adım 1 · Proteini hazırla

Sadece **chain A** ile çalışacağız (ligandsız, sade bir başlangıç):

```bash
# 6JOD'dan sadece chain A'yı al
grep '^ATOM' 6jod.pdb | awk '$0 ~ /^.{21}A/' > at2r.pdb
```

### Adım 2 · `martinize2` — proteini kaba-tanele

```bash
martinize2 \
  -f at2r.pdb \
  -o topol.top \
  -x at2r_cg.pdb \
  -ff martini3001 \
  -dssp \
  -elastic \
  -ef 700 -el 0.5 -eu 0.9 -ea 0 -ep 0
```

**Bayrakları birlikte açacağız:**

| Bayrak | Ne yapıyor | Neden önemli |
|---|---|---|
| `-ff martini3001` | Martini 3 kuvvet alanı | Martini 2 ile karıştırmayın |
| `-dssp` | İkincil yapıyı belirler | Martini'de bead tipleri ikincil yapıya bağlıdır |
| `-elastic` | Elastic network ekler | **Bunsuz protein açılır** |
| `-ef 700` | Yay kuvvet sabiti (kJ/mol/nm²) | Çok yüksek = protein taş gibi; çok düşük = açılır |
| `-el/-eu` | Yayların alt/üst mesafe sınırı (nm) | Hangi bead çiftleri birbirine bağlanacak |

> 🎓 **Elastic network neden gerekli?**
> Martini, proteinin ikincil ve üçüncül yapısını **koruyamaz** — bead'ler
> arasındaki etkileşimler bunu tutmaya yetmez. Çözüm: yapıyı bir yay ağıyla
> dışarıdan sabitlemek.
>
> Bedeli büyük: **proteininiz artık katlanamaz, açılamaz, büyük konformasyonel
> değişim yapamaz.** Martini ile bir GPCR'ın aktivasyon geçişini inceleyemezsiniz.
> İnceleyebileceğiniz şey: lipidlerle etkileşimi, oligomerleşmesi, difüzyonu.
>
> **Aracın ne yapamadığını bilmek, ne yapabildiğini bilmek kadar önemlidir.**

**Çıktılar:** `at2r_cg.pdb` (CG koordinatlar), `topol.top`, `molecule_0.itp`

> 🔍 Kaç atomdan kaç bead'e indik? Oranı hesaplayın.

### Adım 3 · `insane` — membran, su, iyon

```bash
insane \
  -f at2r_cg.pdb \
  -o sistem.gro \
  -p sistem.top \
  -pbc square \
  -box 12,12,14 \
  -l POPC:1 \
  -sol W \
  -salt 0.15 \
  -center
```

| Bayrak | Ne yapıyor |
|---|---|
| `-box 12,12,14` | Kutu boyutu (nm). Sabahki sistemle karşılaştırın |
| `-l POPC:1` | Lipid kompozisyonu. `-l POPC:7 -l POPE:2 -l CHOL:1` de yazılabilir |
| `-sol W` | Martini standart suyu (1 bead ≈ 4 su molekülü) |
| `-salt 0.15` | 0.15 M NaCl |
| `-center` | Proteini kutuya ortala |

> 🔍 **Karşılaştırma anı:** 12×12×14 nm'lik bu sistem kaç parçacık?
> Sabahki all-atom sistem aynı hacimde kaç atom olurdu?

### Adım 4 · Topolojiyi düzelt

`insane`, `sistem.top` dosyasını üretir ama Martini kuvvet alanı `#include`
satırlarını sizin eklemeniz gerekir. Bu **en sık takılınan adımdır** —
notebook'ta birlikte yapacağız.

```
#include "martini_v3.0.0.itp"
#include "martini_v3.0.0_solvents_v1.itp"
#include "martini_v3.0.0_ions_v1.itp"
#include "molecule_0.itp"      ← martinize2'nin ürettiği protein topolojisi
#include "martini_v3.0.0_phospholipids_v1.itp"
```

### Adım 5 · `gmx grompp` ile doğrula

```bash
gmx grompp -f minimization.mdp -c sistem.gro -p sistem.top -o em.tpr -maxwarn 1
```

**Bu adım simülasyon koşmuyor** — sadece "sisteminiz tutarlı mı?" diye soruyor.
`.tpr` dosyası üretilebildiyse input'unuz geçerli demektir.

> ⚠️ Hata alırsanız panik yok — Martini'de en sık görülen hatalar ve çözümleri
> notebook'un sonunda listelendi. Hata mesajını okumayı öğrenmek, işin yarısıdır.

### Adım 6 (opsiyonel) · Kısa enerji minimizasyonu

Vakit kalırsa, birkaç saniye süren bir EM koşup sistemin çökmediğini göreceğiz:

```bash
gmx mdrun -deffnm em -nsteps 500
```

---

## Bölüm C · Martini neyi doğru vermez? · ~10 dk

Kapanışta, aracın sınırlarını konuşuyoruz:

- ⏱️ **Zaman ölçeği "gerçek" değil.** Pürüzsüzleşmiş enerji manzarası nedeniyle
  dinamik ~4× hızlanır. Yayınlarda "efektif zaman" olarak belirtin.
- 🧊 **Protein katlanması / büyük konformasyonel değişim yok** (elastic network).
- 💧 **Standart Martini suyu donabilir.** Antifriz bead'i veya polarize su gerekebilir.
- ⚡ **Elektrostatik yaklaşıktır.** Yüksek yüklü sistemlerde dikkat.
- 🔬 **Hidrojen bağı yönelimi yok.** Spesifik H-bağı sorularına cevap veremez.

📖 Tamamı: [Notes and Limitations — cgmartini.nl](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut4.html)

---

## 📚 Bu oturumun dayandığı tutorial'lar

Aşağıdaki resmî tutorial'lardan uyarlanmıştır. Kurstan sonra tamamını
çalışmanızı öneririz:

- 🔗 [Martini Protein Model — Using Martinize2](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/Tut1.html)
- 🔗 [Modeling Complex Lipid Membranes — INSANE](https://cgmartini.nl/docs/tutorials/Martini3/LipidsII/)

---

## 🆘 Takılırsanız

Her adımın hazır çıktısı [`cikti/`](cikti/) klasöründe. Bir adımda
takılırsanız oradan devam edin — akışı kaçırmayın, sonra geri döneriz.
