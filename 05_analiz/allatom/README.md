# Oturum 5a — All-Atom Trajektori Analizi

**🕝 15:20–16:00 · 40 dk · Doç. Dr. Mustafa Tekpınar**

📓 **Colab notebook:** [`notebooks/05a_allatom_analiz.ipynb`](../../notebooks/05a_allatom_analiz.ipynb)

---

## Hedef

Bugüne kadar hep **girdi** hazırladık. Şimdi çıktıya bakıyoruz:
bir trajektori elimize geldiğinde ona hangi soruları sorarız?

> ⚠️ Kursta uzun simülasyon koşmadığımız için **hazır bir trajektori**
> kullanacağız. Dosyalar: [`../trajektori/`](../trajektori/)

---

## Analizler

### 1 · Önce trajektoriyi düzelt (PBC)

Analiz yapmadan önce yapılması gereken, sık atlanan adım. Periyodik sınır
koşulları yüzünden protein kutunun kenarından çıkıp öbür taraftan girer;
düzeltilmezse RMSD saçmalar.

```bash
gmx trjconv -s md.tpr -f md.xtc -o md_nojump.xtc -pbc nojump
gmx trjconv -s md.tpr -f md_nojump.xtc -o md_fit.xtc -fit rot+trans
```

### 2 · RMSD — sistem dengelendi mi?

```bash
gmx rms -s md.tpr -f md_fit.xtc -o rmsd.xvg
```

**Nasıl okunur:** Eğri bir platoya oturmuşsa sistem dengelenmiştir. Sürekli
tırmanıyorsa ya daha uzun koşmalısınız ya da yapı bozuluyordur.

> 🔍 Referans olarak ilk kareyi mi, yoksa kristal yapıyı mı almalıyız? Fark eder mi?

### 3 · RMSF — hangi bölgeler esnek?

```bash
gmx rmsf -s md.tpr -f md_fit.xtc -o rmsf.xvg -res
```

**Nasıl okunur:** Loop'lar ve terminaller yüksek, heliks/yaprak düşük çıkar.
Beklenmedik bir yerde yüksek RMSF = ilginç bir bulgu ya da bir kurulum hatası.

> 🔍 RMSF'i kristal yapının **B-faktörleriyle** karşılaştırın. Uyuşuyorlar mı?

### 4 · Rg — protein kompakt kaldı mı?

```bash
gmx gyrate -s md.tpr -f md_fit.xtc -o gyrate.xvg
```

Ani artış = açılma (unfolding) veya kurulum sorunu.

### 5 · Hidrojen bağları

```bash
gmx hbond -s md.tpr -f md_fit.xtc -num hbond.xvg
```

> 🎓 **Bunu aklınızda tutun** — 5b'de Martini'ye geçtiğimizde bu analizi
> *yapamayacağız*. Nedenini orada konuşacağız.

### 6 · Yoğunluk profili (membranlı sistemler)

```bash
gmx density -s md.tpr -f md_fit.xtc -o density.xvg -d Z -sl 100
```

Membran normali boyunca su, lipid başları, kuyruklar ve proteinin nerede
olduğunu gösterir. Membran kalınlığını buradan okursunuz.

---

## Sonuçları görselleştirme

`.xvg` dosyaları düz metin — Python'la çizilir. Notebook'ta hazır:

```python
import numpy as np, matplotlib.pyplot as plt
d = np.loadtxt("rmsd.xvg", comments=["#", "@"])
plt.plot(d[:, 0], d[:, 1])
plt.xlabel("Zaman (ps)"); plt.ylabel("RMSD (nm)")
```

---

## Kontrol listesi — bir trajektoriyi ilk gördüğünüzde

- [ ] PBC düzeltildi mi?
- [ ] Enerji ve sıcaklık kararlı mı?
- [ ] RMSD platoya oturdu mu? Analizi hangi andan sonra yapmalıyım?
- [ ] Sistem çökmüş/patlamış mı? (görsel kontrol şart)
- [ ] Membran varsa: alan/lipid ve kalınlık makul mü?

---

## 📚 Kaynaklar

- 🔗 [GROMACS analiz araçları](https://manual.gromacs.org/current/user-guide/cmdline.html#commands-by-topic)
- 🔗 [GROMACS tutorials](https://tutorials.gromacs.org/)
- 🔗 [MDAnalysis](https://www.mdanalysis.org/) — Python'la özel analiz yazmak için
