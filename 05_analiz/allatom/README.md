# Oturum 5a — Atomistik Trajektori Analizi

**Doç. Dr. Mustafa Tekpınar**

Colab not defteri: [`notebooks/05a_allatom_analiz.ipynb`](../../notebooks/05a_allatom_analiz.ipynb)

---

## Oturumun amacı

Önceki oturumlarda simülasyon girdilerinin hazırlanması ele alınmıştır. Bu
oturumda, elde edilmiş bir trajektorinin hangi ölçütlerle değerlendirileceği
incelenmektedir.

Kursta üretim simülasyonu koşulmadığından, önceden hesaplanmış bir trajektori
kullanılacaktır. Dosyalar: [`../trajektori/`](../trajektori/)

---

## Analiz adımları

### 1. Periyodik sınır koşullarının düzeltilmesi

Analiz öncesinde yapılması gereken ve sıklıkla atlanan adımdır. Periyodik sınır
koşulları nedeniyle molekül kutunun bir yüzeyinden çıkıp karşı yüzeyden
girmektedir. Düzeltme yapılmadığında hesaplanan RMSD değerleri yanıltıcı
olmaktadır.

```bash
gmx trjconv -s md.tpr -f md.xtc -o md_nojump.xtc -pbc nojump
gmx trjconv -s md.tpr -f md_nojump.xtc -o md_fit.xtc -fit rot+trans
```

### 2. RMSD — sistemin dengelenmesinin değerlendirilmesi

```bash
gmx rms -s md.tpr -f md_fit.xtc -o rmsd.xvg
```

**Yorumlama.** Eğrinin bir plato değerine ulaşması sistemin dengelendiğine işaret
etmektedir. Sürekli artış gösteren bir eğri, simülasyon süresinin yetersiz
olduğunu veya yapısal bozulma bulunduğunu göstermektedir.

**Tartışma sorusu.** Referans yapı olarak ilk kare mi yoksa kristal yapı mı
alınmalıdır? Bu seçim sonucu nasıl etkilemektedir?

### 3. RMSF — rezidü bazında dalgalanma

```bash
gmx rmsf -s md.tpr -f md_fit.xtc -o rmsf.xvg -res
```

**Yorumlama.** İlmikler ve terminal bölgeler yüksek, düzenli ikincil yapı
öğeleri düşük değerler vermektedir. Beklenmeyen bir bölgede yüksek dalgalanma,
ya biyolojik açıdan anlamlı bir bulguya ya da kurulum hatasına işaret etmektedir.

**Tartışma sorusu.** Hesaplanan RMSF profili kristal yapının B-faktörleriyle
uyum göstermekte midir?

### 4. Jirasyon yarıçapı — yapısal kompaktlığın izlenmesi

```bash
gmx gyrate -s md.tpr -f md_fit.xtc -o gyrate.xvg
```

Ani artış, yapının açılmasına veya kurulum hatasına işaret etmektedir.

### 5. Hidrojen bağı analizi

```bash
gmx hbond -s md.tpr -f md_fit.xtc -num hbond.xvg
```

**Not.** Bu analiz Oturum 5b'de kaba-taneli modeller için karşılaştırma noktası
oluşturacaktır; Martini modelinde uygulanabilir değildir.

### 6. Yoğunluk profili (membran içeren sistemler)

```bash
gmx density -s md.tpr -f md_fit.xtc -o density.xvg -d Z -sl 100
```

Membran normali boyunca su, lipit baş grupları, açil zincirler ve proteinin
dağılımını vermektedir. Membran kalınlığı bu profilden belirlenmektedir.

---

## Sonuçların görselleştirilmesi

GROMACS analiz araçları düz metin biçiminde `.xvg` dosyaları üretmektedir. Not
defterinde hazır çizim fonksiyonları bulunmaktadır:

```python
import numpy as np, matplotlib.pyplot as plt
d = np.loadtxt("rmsd.xvg", comments=["#", "@"])
plt.plot(d[:, 0], d[:, 1])
plt.xlabel("Zaman (ps)"); plt.ylabel("RMSD (nm)")
```

---

## Trajektori değerlendirme ölçütleri

Yeni bir trajektori incelenirken denetlenmesi önerilen hususlar:

1. Periyodik sınır koşulları düzeltilmiş midir?
2. Enerji ve sıcaklık zaman içinde kararlı seyretmekte midir?
3. RMSD plato değerine ulaşmış mıdır; analiz hangi zaman aralığından itibaren
   yapılmalıdır?
4. Sistemde yapısal bozulma bulunmakta mıdır (görsel denetim gereklidir)?
5. Membran içeren sistemlerde lipit başına alan ve membran kalınlığı deneysel
   değerlerle uyumlu mudur?

---

## Kaynaklar

- [GROMACS analiz araçları](https://manual.gromacs.org/current/user-guide/cmdline.html#commands-by-topic)
- [GROMACS öğretim materyalleri](https://tutorials.gromacs.org/)
- [MDAnalysis](https://www.mdanalysis.org/) — Python tabanlı özelleştirilmiş analiz
