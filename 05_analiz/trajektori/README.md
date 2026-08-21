# Analiz Trajektorileri

Oturum 5'te kullanılacak, önceden hesaplanmış simülasyon çıktıları.
Doç. Dr. Mustafa Tekpınar tarafından sağlanmıştır.

## Sistem: adenilat kinaz (PDB `1AKE`)

| | |
|---|---|
| Protein | *Escherichia coli* adenilat kinaz (ADK) |
| Uzunluk | 214 rezidü, 3.341 atom |
| Kuvvet alanı | CHARMM |
| Su modeli | TIP3P |
| Trajektori | 1001 kare, 200 ps aralık — toplam **200 ns** |

Trajektoride yalnızca protein bulunmaktadır; çözücü çıkarılmıştır. Bu sayede
dosya boyutu küçük kalmakta ve analizler doğrudan yapılabilmektedir.

## Dosyalar

| Dosya | İçeriği | Boyut |
|---|---|---|
| `1ake_charmm_tip3p_reference.pdb` | Referans yapı (ilk kare) | 260 KB |
| `1ake_charmm_tip3p_traj_1000frames.xtc` | Trajektori, 1001 kare | 12 MB |

`.xtc` dosyası GROMACS analiz araçlarında `-s` seçeneği ile birlikte referans
`.pdb` dosyasını gerektirir:

```bash
gmx rms -s 1ake_charmm_tip3p_reference.pdb \
        -f 1ake_charmm_tip3p_traj_1000frames.xtc -o rmsd.xvg
```

## Bu sistem neden seçildi?

Adenilat kinaz, büyük ölçekli konformasyonel değişimin ders kitabı örneğidir.
Enzim, substrat bağlanmasıyla **açık** konformasyondan **kapalı** konformasyona
geçer; LID ve NMP alanları merkezi CORE alanı üzerine kapanır.

Bu geçiş trajektoride açıkça gözlenmektedir:

| Ölçüt | Değer |
|---|---|
| Omurga RMSD | ortalama 0,64 nm, en yüksek 0,92 nm |
| Jirasyon yarıçapı | 1,63 – 2,05 nm arasında değişiyor |

Bu genlikteki bir RMSD, küçük dalgalanmalardan değil gerçek bir domain
hareketinden kaynaklanmaktadır. Dolayısıyla trajektori, Oturum 5'teki RMSD,
RMSF ve jirasyon yarıçapı analizlerinin **anlamlı sonuç verdiği** bir örnektir.

## Oturum 5 ile ilişkisi

- **5a — Atomistik analiz:** bu trajektori kullanılmaktadır
- **5b — Kaba-taneli analiz:** aynı analizlerin Martini modellerinde nasıl
  değiştiği tartışılmakta, karşılaştırma buradaki sonuçlar üzerinden
  yapılmaktadır

## Not

Bu trajektori atomistik (CHARMM/TIP3P) bir simülasyondan gelmektedir; Oturum 4
ve 6'daki Martini sistemleriyle doğrudan karşılaştırılamaz. Amaç, atomistik
analiz yöntemlerinin gösterilmesidir.
