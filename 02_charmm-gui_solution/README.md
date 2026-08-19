# Oturum 2 — CHARMM-GUI Solution Builder

**🕙 10:00–10:45 · 45 dk · Dr. Öğr. Üyesi Ekrem Yaşar**
**Sistem: PDB [`1AKI`](https://www.rcsb.org/structure/1AKI) — tavuk yumurta akı lizozimi**

---

## Hedef

Günün ilk uygulaması. Basit bir soruyla başlıyoruz:

> **Bir MD simülasyonu başlatmak için elimizde tam olarak ne olması gerekiyor?**

Cevabı bir protein üzerinden, baştan sona kendimiz üreteceğiz.

## Neden 1AKI?

| Özellik | Neden işimize yarıyor |
|---|---|
| **Tek zincir** (129 aa) | Zincir seçme kararı yok — dikkat dağılmıyor |
| **Kofaktör yok, ligand yok** | Hetero grup problemi yok |
| **X-ray 1.5 Å** | Yüksek çözünürlük, eksik atom neredeyse yok |
| **Küçük ve hızlı** | 45 dakikaya rahat sığıyor |

Lizozim, MD literatürünün "merhaba dünya" sistemidir. Kasıtlı olarak **kolay**
bir başlangıç seçtik; zor kısımlar Oturum 3'te geliyor.

📁 Yapı zaten depoda: [`girdi/1aki.pdb`](girdi/1aki.pdb)

---

## Adım adım

### 1 · Yapıyı yükle
1. https://charmm-gui.org → giriş yapın
2. **Input Generator → Solution Builder**
3. **PDB ID** kutusuna `1AKI` yazın *(veya `girdi/1aki.pdb`'yi yükleyin)*
4. **Next Step**

> 🔍 **Durun ve bakın:** Gelen sayfada kaç zincir var? Kaç su molekülü var?
> Kristal yapıdaki suları tutmalı mıyız?

### 2 · Model seçimi (Manipulate PDB)
- **Zincir seçimi:** Tek zincir var, işaretli bırakın
- **Su molekülleri:** Kristal sularını **atıyoruz** — kendi su kutumuzu kuracağız
- **Terminal grupları:** Varsayılan (NTER/CTER) uygun
- **Disülfit köprüleri:** Lizozimde **4 tane** var. CHARMM-GUI bunları otomatik
  buluyor — listeyi kontrol edin

> 🎓 **Kavram:** Disülfitler kovalent bağdır; kuvvet alanında ayrıca tanımlanmaları
> gerekir. Burada gözden kaçarsa protein simülasyonda açılır.

### 3 · Protonasyon durumları
- **pH 7.0** varsayılan değerlerle devam ediyoruz
- Histidinlere dikkat: HSD / HSE / HSP seçenekleri ne demek?

> 🎓 **Kavram:** Kuvvet alanı pH bilmez. pH'ı siz, **protonasyon durumlarını
> seçerek** sisteme söylersiniz. Oturum 3'te bu karar çok daha kritik olacak.

### 4 · Kutu ve solvasyon
- **Kutu tipi:** `Rectangular` veya `Octahedron`
  → *Neden oktahedron daha az su ile aynı işi görür?*
- **Kenar boşluğu (edge distance):** 10 Å
  → *Neden? Protein PBC'de kendi görüntüsüyle etkileşmemeli.*
- **İyonlar:** 0.15 M KCl (fizyolojik) — `Monte-Carlo` yerleştirme

### 5 · Kuvvet alanı ve çıktı
- **Force field:** CHARMM36m
- **Input generation options:** **GROMACS** işaretleyin
- **Next Step** → iş tamamlanınca `charmm-gui.tgz` indirin

---

## Ne indirdik? — Çıktı dosyalarının anatomisi

Bu, oturumun **en önemli 10 dakikası**. İndirdiğiniz arşivi açıp birlikte
gezeceğiz:

```
charmm-gui-XXXX/
├── gromacs/
│   ├── step5_input.gro     ← koordinatlar (tüm sistem: protein + su + iyon)
│   ├── topol.top            ← topoloji: hangi molekülden kaç tane, hangi kuvvet alanı
│   ├── index.ndx            ← atom grupları (Protein, SOL, ION...)
│   ├── toppar/              ← kuvvet alanı parametre dosyaları
│   ├── step6.0_minimization.mdp   ← enerji minimizasyonu ayarları
│   ├── step6.1_equilibration.mdp  ← dengeleme ayarları
│   └── step7_production.mdp       ← üretim simülasyonu ayarları
└── step3_input.pdb          ← solvasyonlu sistem, PDB formatında
```

### Bu üçlüyü tanıyın

| Dosya | Ne söyler | Analoji |
|---|---|---|
| **`.gro`** | Her atom **nerede** | Fotoğraf |
| **`.top`** | Atomlar **birbirine nasıl bağlı**, parametreleri ne | Tarif |
| **`.mdp`** | Simülasyon **nasıl koşacak** (süre, sıcaklık, adım) | Talimat |

GROMACS bu üçünü `gmx grompp` ile birleştirip tek bir `.tpr` dosyası üretir;
simülasyon o `.tpr` ile koşar.

> ✅ **Oturum 4'te aynı üçlüyü** — koordinat, topoloji, çalıştırma ayarları —
> bu kez **terminalden ve Martini için** kendimiz üreteceğiz. Bugünkü GUI, yarınki
> komut satırının aynasıdır.

---

## `topol.top` içinde ne var? (birlikte açacağız)

```
#include "toppar/forcefield.itp"     ← hangi kuvvet alanı
#include "toppar/PROA.itp"           ← proteinin topolojisi
#include "toppar/TIP3.itp"           ← su modeli

[ system ]
Title

[ molecules ]
PROA    1        ← 1 protein
TIP3    5842     ← 5842 su molekülü
POT     14       ← 14 potasyum
CLA     22       ← 22 klorür
```

> 🔍 **Soru:** Sistemin net yükü sıfır mı? İyon sayıları neden eşit değil?

---

## 🆘 Takılırsanız

CHARMM-GUI işi uzun sürerse veya hata verirse: hazır çıktı
[`cikti/`](cikti/) klasöründe duruyor. Oradan devam edin — akışı kaçırmayın.

---

## ⏭️ Sırada ne var?

Oturum 3'te işler ciddileşiyor: **5 zincirli, ligandlı, eksik loop'lu bir GPCR**
alıp membrana gömeceğiz. Bugün öğrendiğiniz her adım orada tekrar karşınıza
çıkacak — sadece her birinde verilecek bir **karar** olacak.
