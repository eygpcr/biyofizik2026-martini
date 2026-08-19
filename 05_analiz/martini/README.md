# Oturum 5b — Kaba-Taneli Modellerde Analiz Farklılıkları

**Dr. Öğr. Üyesi Ekrem Yaşar**

---

## Oturumun amacı

Oturum 5a'da atomistik trajektoriler üzerinde uygulanan analizlerin, kaba-taneli
modellere aktarılması hâlinde hangilerinin geçerliliğini koruduğu, hangilerinin
yorumunun değiştiği ve hangilerinin uygulanamaz hâle geldiği değerlendirilmektedir.

---

## Analiz yöntemlerinin karşılaştırılması

| Analiz | Martini modelinde durumu | Açıklama |
|---|---|---|
| RMSD | Hesaplanabilir, yorumu farklıdır | Elastik ağ yapıyı kısıtladığından düşük RMSD değeri proteinin kararlılığını değil, kısıtlamanın etkinliğini yansıtmaktadır |
| RMSF | Anlamlıdır | Bölgesel esneklik bilgisi korunmakta, ancak elastik ağın etkisi altında değerlendirilmelidir |
| Jirasyon yarıçapı | Hesaplanabilir | Elastik ağ nedeniyle yaklaşık sabit kalmaktadır |
| Hidrojen bağı | Uygulanamaz | Modelde hidrojen atomu bulunmamaktadır |
| Yoğunluk profili | Uygulanabilir ve bilgilendiricidir | Membran analizi Martini modelinin en güçlü uygulama alanıdır |
| Lipit–protein teması | Yöntemin ayırt edici üstünlüğüdür | Erişilebilen zaman ölçeği istatistiksel anlamlılık sağlamaktadır |
| Difüzyon ve MSD | Ölçek düzeltmesi gerektirmektedir | Martini dinamiği yaklaşık dört kat hızlıdır |

**Değerlendirme.** Kaba-taneli modellerde aynı analiz komutları
çalıştırılabilmekte, ancak bazı soruların yanıtları fiziksel anlamını
yitirmektedir. Model seçimi, araştırma sorusunun seçimini de belirlemektedir.

---

## 1. Kaba-taneli yapıların görselleştirilmesi

Kaba-taneli yapı dosyaları doğrudan VMD ortamında açıldığında bağlar
görüntülenmemektedir. Bunun nedeni `.gro` biçiminin bağ bilgisi taşımaması ve
etkileşim merkezleri arası mesafelerin bağ tahmini için uygun olmamasıdır. Yapı
bağlantısız bir nokta kümesi olarak görüntülenmektedir.

Çözüm olarak [MartiniGlass](https://martiniglass.readthedocs.io/) aracı
kullanılmaktadır; topoloji dosyasından bağ bilgisini okuyarak VMD ile uyumlu
dosyalar üretmektedir.

```bash
pip install martiniglass
martiniglass -p sistem.top
```

Görsel denetim yapılamayan bir sistemde kurulum hatalarının fark edilmesi de
mümkün olmamaktadır.

---

## 2. Lipit–protein etkileşim analizi

Kaba-taneli modellerin en belirgin üstünlüğü bu alanda ortaya çıkmaktadır.
Atomistik simülasyonlarda 100 ns süresince gözlenen lipit değişim sayısı
istatistiksel değerlendirme için yetersiz kalmaktadır. Martini modelinde
mikrosaniye mertebesindeki simülasyonlar, belirli bir lipidin protein üzerindeki
hangi bölgede ne kadar süre kaldığının nicel olarak belirlenmesine olanak
vermektedir.

Temel yaklaşım:

```bash
gmx select -s md.tpr -f md.xtc \
  -select 'resname POPC and within 0.6 of group "Protein"' -os temas.xvg
```

Özelleşmiş araçlar (oturumda yalnızca tanıtılacaktır):

- [ProLint2](https://cgmartini.nl/docs/tutorials/Martini3/ProLint/) — temas
  süreleri ve bağlanma bölgelerinin etkileşimli analizi
- [PyLipID](https://pylipid.readthedocs.io/) — rezidans süresi hesabı ve
  bağlanma bölgesi kümelemesi

---

## 3. Zaman ölçeği düzeltmesi

Martini kuvvet alanının yumuşatılmış potansiyel yüzeyi difüzyonu
hızlandırmaktadır. Su difüzyon katsayısına göre kalibre edilmiş yaklaşık dört
katlık bir ölçekleme faktörü yaygın olarak kullanılmaktadır.

| Büyüklük | Değer |
|---|---|
| Simülasyon süresi | 10 µs |
| Etkin süre | yaklaşık 40 µs |

**Dikkat.** Bu faktör evrensel değildir; incelenen sisteme ve sürece bağlı olarak
değişmektedir. Yayımlanan çalışmalarda hangi zaman ölçeğinin raporlandığı açıkça
belirtilmelidir.

---

## Yöntem seçimi

| Araştırma sorusu | Uygun yaklaşım |
|---|---|
| Yan zincir konformasyonunun ayrıntısı | Atomistik |
| Belirli bir hidrojen bağı ağı | Atomistik |
| Ligant bağlanma geometrisinin ayrıntısı | Atomistik |
| Protein oligomerizasyonu | Kaba-taneli |
| Lipit–protein tercihli etkileşimleri | Kaba-taneli |
| Geniş membran yamalarındaki organizasyon | Kaba-taneli |
| Hücresel kalabalık koşullarında difüzyon | Kaba-taneli |

En verimli yaklaşım iki yöntemin birlikte kullanılmasıdır: kaba-taneli
simülasyonlarla geniş konformasyon uzayı taranarak ilgi çekici durumlar
belirlenmekte, bu durumlar atomistik çözünürlüğe geri haritalanarak
(backmapping) ayrıntılı olarak incelenmektedir.
