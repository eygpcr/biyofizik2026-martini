# Oturum 1 — MD'nin Temelleri ve Ölçek Problemi

**🕘 09:00–09:45 · 45 dk · Prof. Dr. Nazmi Yaraş + Doç. Dr. Mustafa Tekpınar**

---

## Bu oturumda cevaplayacağımız sorular

1. Bir moleküler dinamik simülasyonu aslında **ne hesaplıyor**?
2. Neden atomistik simülasyonlarla hücresel ölçeğe **çıkamıyoruz**?
3. Kaba-taneli (coarse-grained) yaklaşım bu duvarı nasıl aşıyor — ve **karşılığında neyi feda ediyor**?

---

## İçerik

### 1. MD ne yapar? · ~15 dk

- **Kuvvet alanı (force field):** Bir molekülün enerjisini atom koordinatlarının
  fonksiyonu olarak yazmak. Bağ, açı, dihedral, van der Waals, elektrostatik.
- **Newton + integrasyon:** F = ma'yı adım adım çözmek. `leap-frog`, `velocity Verlet`.
- **Zaman adımı (timestep):** Neden 2 fs? En hızlı hareket (C–H titreşimi) belirler.
  `LINCS`/`SETTLE` ile bağları dondurup adımı büyütmek.
- **Periyodik sınır koşulları (PBC):** Sonlu kutuyla sonsuz sistemi taklit etmek.
- **Termostat ve barostat:** NVT, NPT. Sıcaklık ve basıncı sabit tutmak ne demek.

### 2. Ölçek problemi · ~15 dk

Atomistik simülasyonun iki duvarı var:

| Duvar | Neden |
|---|---|
| **Zaman** | 2 fs'lik adımlarla 1 μs'ye ulaşmak = 500 milyon adım |
| **Boyut** | 40 nm'lik bir membran yaması ≈ milyonlarca atom (çoğu su) |

Biyolojide ilgilendiğimiz olayların çoğu (protein oligomerizasyonu, lipid
alan oluşumu, vezikül füzyonu) **μs–ms** ve **10–100 nm** aralığında. Yani
tam da atomistik simülasyonun ulaşamadığı yerde.

**Çözüm fikri:** her atomu tek tek takip etmeyi bırakmak.

### 3. Martini 3 · ~15 dk

- **Bead haritalama:** Tipik olarak 4 ağır atom → 1 "bead". Su bile bead oluyor.
- **Kazanç:** Daha az parçacık (~10×) + daha yumuşak potansiyeller sayesinde daha
  büyük zaman adımı (20–30 fs) + hızlanmış dinamik. Toplamda **3–4 mertebe** hız.
- **Parametrizasyon felsefesi:** Martini, kuantum hesaplarından türetilmez —
  **deneysel bölünme katsayılarına (partitioning) göre** ayarlanır. Bu, onun
  hem gücü hem sınırı.
- **Ne kaybediyoruz?**
  - Atomik detay (yan zincir konformasyonu, hidrojen bağı yönelimi)
  - **Protein ikincil yapısı korunmaz** → elastic network ile dışarıdan dayatılır
  - Serbest enerji manzarası pürüzsüzleşir → zaman ölçeği "gerçek" değil, etkin

> 💡 **Günün geri kalanına bağlantı:** Sabah bu iki dünyanın *girdilerini*
> hazırlamayı öğreneceğiz. Öğleden sonra aynı proteini (AT2R) önce atomistik,
> sonra Martini olarak kuracağız — farkı elimizle göreceğiz.

---

## 📖 Kurs öncesi okuma listesi

Hepsini okumanız beklenmiyor. **1–2 tanesine göz atmanız yeterli** — amaç
kurs sabahı terimlerin tanıdık gelmesi.

### Kısa ve giriş seviyesi (önerilen)

- 🔗 [Martini 3'e giriş — cgmartini.nl](https://cgmartini.nl/docs/tutorials/Martini3/ProteinsI/)
  *(sadece giriş bölümü, ~10 dk)*
- 🔗 [GROMACS: What is molecular dynamics?](https://manual.gromacs.org/current/reference-manual/introduction.html)
  *(~10 dk)*

### Daha derin (isteyene)

- 📄 **Souza et al. (2021)** — *Martini 3: a general purpose force field for
  coarse-grained molecular dynamics.* Nature Methods.
  [doi:10.1038/s41592-021-01098-3](https://doi.org/10.1038/s41592-021-01098-3)
- 📄 **Marrink & Tieleman (2013)** — *Perspective on the Martini model.*
  Chem. Soc. Rev. [doi:10.1039/C3CS60093A](https://doi.org/10.1039/C3CS60093A)

---

## Slaytlar

Oturumun slaytları kurs günü buraya eklenecek: `01_teori/slaytlar.pdf`
