# Oturum 3 — CHARMM-GUI Membrane Builder

**11:00–12:15 (75 dakika) · Dr. Öğr. Üyesi Ekrem Yaşar**
**Model sistem: PDB [6JOD](https://www.rcsb.org/structure/6JOD), anjiyotensin II tip-2 reseptörü (AT2R)**

---

## Oturumun amacı

Oturum 2'de kullanılan sistem, karar gerektirmeyecek biçimde seçilmişti. Bu
oturumda deneysel olarak elde edilmiş, yardımcı bileşenler içeren ve kısmen
çözülmemiş bir yapı ile çalışılmaktadır. Oturumun asıl kazanımı işlem sırasının
ezberlenmesi değil, her adımda verilmesi gereken kararların gerekçelendirilmesidir.

---

## Yapının zincir bileşimi

6JOD yapısı beş zincir içermekte olup bunların ikisi incelenen sisteme aittir:

| Zincir | Uzunluk | Tanım | İşlem |
|---|---|---|---|
| A | 312 aa | Anjiyotensin II tip-2 reseptörü (AT2R) | Korunur |
| B | 8 aa | Anjiyotensin II — agonist peptit | Korunur |
| C | 86 aa | BRIL (çözünür sitokrom b562), kristalizasyon füzyonu | Çıkarılır |
| H | 220 aa | 4A03 Fab ağır zincir, kristalizasyon yardımcısı | Çıkarılır |
| L | 212 aa | 4A03 Fab hafif zincir, kristalizasyon yardımcısı | Çıkarılır |

**Kavramsal not.** PDB dosyasında yer alan her zincir, incelenen biyolojik
yapının bileşeni değildir.

GPCR ailesine ait proteinler kristalizasyona dirençlidir. Bu güçlüğün aşılması
için yaygın olarak iki strateji uygulanmaktadır: proteine BRIL veya T4 lizozim
gibi bir füzyon bölgesinin eklenmesi ve yapının bir Fab fragmanı ile kompleks
hâlinde kristalize edilmesi. Her iki bileşen de deneysel araçtır; fizyolojik
ortamda bulunmamaktadır. Simülasyona dâhil edilmeleri, incelenmesi amaçlanmayan
bir sistemin modellenmesi anlamına gelmektedir.

Bu yapıda BRIL ayrı bir zincir (C) olarak deposit edilmiş olduğundan çıkarılması
doğrudan zincir silme işlemiyle gerçekleştirilebilmektedir. Bazı GPCR
yapılarında BRIL, üçüncü hücre içi ilmiğin (ICL3) içine yerleştirilmiş
olduğundan zincirin bütünü silinemez; dizi içinden kesilerek çıkarılması
gerekmektedir. Bu ayrımın yapının kaynak makalesine başvurulmadan tespit
edilmesi mümkün değildir.

**Dosyalar:**
- Ham yapı: [`girdi/6jod.pdb`](girdi/6jod.pdb)
- Zincirleri ayıklanmış yapı: [`girdi/6jod_chainAB.pdb`](girdi/6jod_chainAB.pdb)

---

## Yapının nitel özellikleri

| Özellik | Değer |
|---|---|
| Yöntem ve çözünürlük | X-ışını kırınımı, 3.2 Å |
| A zincirinde çözülmüş rezidüler | 35–340 aralığı, toplam 306 rezidü |
| Çözülmemiş rezidüler | 341–346 (C-terminal uzantı, 6 rezidü) |
| Zincir içi kopukluk | Bulunmamaktadır |
| A zinciri disülfit köprüleri | Cys35–Cys290 ve Cys117–Cys195 |
| Kofaktör veya küçük molekül ligant | Bulunmamaktadır (ligant peptit yapıdadır) |

**Tartışma sorusu.** Çözülmemiş altı rezidü C-terminal uzantıda yer almaktadır.
Bu rezidülerin modellenmesi zorunlu mudur? Zincir içinde bir ilmiğin çözülmemiş
olması hâlinde nasıl bir yol izlenmesi gerekirdi?

*(Zincir içi kopukluk topolojik bütünlüğü bozduğundan modellenmesi zorunludur;
MODELLER, AlphaFold veya CHARMM-GUI'nin ilmik modelleme modülü kullanılabilir.)*

---

## Uygulama adımları

### 1. Yapının yüklenmesi ve zincirlerin ayıklanması

1. *Input Generator → Membrane Builder → Bilayer Builder* seçilir
2. *PDB ID* alanına `6JOD` yazılır veya [`girdi/6jod.pdb`](girdi/6jod.pdb)
   yüklenir
3. Zincir listesinde A ve B seçili bırakılır; C, H ve L seçimden çıkarılır
4. Kristalografik su molekülleri çıkarılır

**Dikkat.** Bu adımdaki bir hata, sonraki tüm işlemleri geçersiz kılmaktadır.
Zincir seçiminin doğrulanması gerekmektedir.

### 2. Yapı düzenlemeleri

**Terminal gruplar.** A zinciri 35. rezidüden başlayıp 340. rezidüde sona
ermektedir; her iki uç da dizi bütününden kesilmiş durumdadır. Öntanımlı yüklü
uçlar (NTER/CTER) ile nötr uç grupları (ACE/CT3) arasında seçim yapılması
gerekmektedir.

**Kavramsal not.** Kesilmiş bir dizinin ucuna yüklü grup atanması, gerçekte
bulunmayan bir yükün sisteme eklenmesi anlamına gelmektedir. Membran içine yakın
konumlanan bir uç için bu durum belirgin bir yapaylık oluşturmaktadır.

**Disülfit köprüleri.** Cys35–Cys290 ve Cys117–Cys195 bağlarının listede yer
alması doğrulanmalıdır. Cys35–Cys290 bağı, GPCR ailesinde N-terminal bölgeyi
üçüncü hücre dışı ilmiğe bağlayan korunmuş bir yapısal öğedir.

**Ligant.** B zincirinde yer alan anjiyotensin II sekiz rezidülük bir peptit
olduğundan CHARMM-GUI tarafından standart bir protein zinciri olarak
işlenebilmektedir. Ligandın küçük organik molekül olması durumunda kuvvet alanı
parametrelerinin ayrıca üretilmesi gerekecekti (CGenFF veya Ligand Reader &
Modeler modülü).

**Nokta mutasyonu.** Arayüz üzerinden mutasyon tanımlanması uygulamalı olarak
gösterilecektir. Belirli bir varyant üzerinde çalışacak katılımcılar için
başlangıç noktası bu adımdır.

### 3. Protonasyon durumları

Oturum 2'de öntanımlı değerlerle geçilen bu adım, membran sistemlerinde
belirleyici hâle gelmektedir.

- **Histidin rezidüleri.** HSD (Nδ protonlu), HSE (Nε protonlu) ve HSP (çift
  protonlu, +1 yüklü) seçenekleri arasında karar verilmesi gerekmektedir.
  Öntanımlı seçim genellikle HSE'dir.
- **Membran içinde konumlanan Asp ve Glu rezidüleri.** Düşük dielektrik sabitli
  hidrofobik ortamda karboksil gruplarının protonlu (nötr) durumda bulunması
  olağandır; öntanımlı atama ise deprotone (yüklü) durumdur.

**Kavramsal not.** Kuvvet alanları pH değişkenini içermez. Yanlış protonasyon
ataması hata mesajı üretmeden simülasyon boyunca geçerli kalmakta ve sonuçları
sistematik biçimde etkilemektedir. Yayımlanacak çalışmalarda bu kararın PROPKA
veya H++ gibi araçlarla desteklenmesi önerilmektedir.

### 4. Membrana yerleştirme

- PPM veya OPM sunucuları kullanılarak protein membran normaline göre
  hizalanır.
- Yerleştirme sonucu görsel olarak denetlenmelidir: transmembran heliksleri
  çift tabakanın içinde konumlanmış mıdır, hidrofobik kuşak lipit açil
  zincirleriyle örtüşmekte midir?

**Dikkat.** Otomatik yerleştirme sonucu doğrulanmadan sonraki adıma geçilmemelidir.

### 5. Lipit bileşiminin belirlenmesi

| Seçenek | Uygunluk |
|---|---|
| Saf POPC | Basit ve karşılaştırılabilir; standart referans membran |
| POPC/POPE/kolesterol | Plazma membranının bileşimine daha yakın |
| Asimetrik çift tabaka | Fizyolojik olarak gerçekçi; kurulumu daha karmaşık |

Oturumda saf POPC ile devam edilecek, kolesterol eklenmesinin sonuçlar üzerindeki
beklenen etkisi tartışılacaktır.

- Protein çevresinde asgari 20 Å lipit bulunmalıdır
- Membranın her iki yüzeyinde asgari 22.5 Å su tabakası tanımlanmalıdır
- İyon derişimi: 0.15 M KCl

### 6. Kuvvet alanı ve çıktı seçenekleri

- **Kuvvet alanı:** CHARMM36m
- **Çıktı formatı:** GROMACS
- İşlem tamamlandığında `charmm-gui.tgz` arşivi indirilir

---

## Çıktının incelenmesi

Dosya yapısı Oturum 2 ile aynıdır; `topol.top` dosyasına lipit bileşenleri
eklenmiştir:

```
[ molecules ]
PROA     1        AT2R
PROB     1        anjiyotensin II
POPC   256        lipit molekülleri
TIP3  12000+      su molekülleri
POT/CLA  ...      iyonlar
```

**Tartışma sorusu.** Sistemin toplam atom sayısı ne kadardır? Oturum 2'deki
lizozim sistemiyle karşılaştırıldığında oran nedir? Bu boyuttaki bir sistemin
1 µs süreyle simüle edilmesi hangi hesaplama kaynağını gerektirmektedir?

---

## Değerlendirme: büyük sistemlere ölçeklenme

Bu oturumda tek bir reseptör molekülü ile çalışılmıştır. Araştırma sorusunun
aşağıdaki koşulları gerektirmesi hâlinde yaklaşımın değiştirilmesi zorunlu hâle
gelmektedir:

- Oligomerizasyonun incelenmesi için çok sayıda reseptör kopyası
- 40–50 nm genişliğinde membran yaması
- Çok bileşenli, fizyolojik lipit bileşimi
- Sitozolik kalabalık koşullarının temsili

CHARMM-GUI bu ölçekte pratik değildir; işlem süreleri ve arayüz kısıtları
belirleyici olmaktadır. Öğleden sonraki oturumda komut satırı araçlarına
geçilecek ve model çözünürlüğü düşürülecektir.

---

## Sorun giderme

Önceden üretilmiş CHARMM-GUI çıktıları [`cikti/`](cikti/) klasöründe
bulunmaktadır. Zincir ayıklama adımında sorun yaşanması hâlinde
[`girdi/6jod_chainAB.pdb`](girdi/6jod_chainAB.pdb) dosyası doğrudan
yüklenebilir; bu dosyada C, H ve L zincirleri çıkarılmış durumdadır.
