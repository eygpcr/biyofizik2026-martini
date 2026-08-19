# Hesap ve Yazılım Kurulum Yönergesi

Bu belgede yer alan hazırlıkların **kurs gününden önce** tamamlanması
gerekmektedir.

Kurs boyunca katılımcıların kendi bilgisayarlarına yazılım kurmaları
gerekmemektedir. Tüm uygulamalar tarayıcı üzerinden yürütülecektir (CHARMM-GUI
ve Google Colab).

---

## 1. Zorunlu hazırlıklar

### 1.1. CHARMM-GUI hesabı

Oturum 2 ve Oturum 3'ün tamamı bu platform üzerinde yürütülecektir.

- Adres: https://charmm-gui.org
- Sayfanın sağ üst köşesindeki *Register* bağlantısı kullanılarak akademik
  e-posta adresi ile ücretsiz kayıt oluşturulmalıdır.
- **Hesap onayı bir iş günü sürebilmektedir.** Bu nedenle kaydın kurs
  gününden en az bir hafta önce tamamlanması önerilmektedir.
- **Doğrulama:** Platforma giriş yapılabildiği ve *Input Generator → Solution
  Builder* sayfasının açıldığı kontrol edilmelidir.

### 1.2. Google hesabı (Colab erişimi)

Oturum 4, 5 ve 6'nın uygulamaları Google Colab üzerinde yürütülecektir.

- Adres: https://colab.research.google.com
- Kurumsal Google hesaplarında Colab erişimi kurum politikası gereği kapalı
  olabilmektedir. Bu nedenle kişisel bir Google hesabı kullanılması
  önerilmektedir.
- **Doğrulama:** Colab üzerinde yeni bir not defteri oluşturularak tek satırlık
  bir hücrenin (`print("test")`) çalıştırılması yeterlidir.

### 1.3. Donanım

- Güncel bir tarayıcı (Chrome, Firefox, Edge veya Safari) çalıştırabilen
  herhangi bir dizüstü bilgisayar
- Kararlı internet bağlantısı
- GPU gereksinimi bulunmamaktadır; kursta üretim simülasyonu koşulmamaktadır.

---

## 2. Önerilen hazırlıklar

### 2.1. Moleküler görselleştirme yazılımı

Oturum 5b'de kaba-taneli yapıların görselleştirilmesi ele alınacaktır.
Uygulamayı kendi bilgisayarında tekrar etmek isteyen katılımcılar için:

- [VMD](https://www.ks.uiuc.edu/Research/vmd/) — indirme için ücretsiz kayıt
  gerekmektedir
- Alternatifler: [PyMOL](https://pymol.org/),
  [ChimeraX](https://www.cgl.ucsf.edu/chimerax/)

---

## 3. Gerekmeyen hazırlıklar

| Bileşen | Açıklama |
|---|---|
| GitHub hesabı | Depo herkese açıktır; hesap gerekmeksizin erişilebilir |
| Yerel GROMACS kurulumu | Colab ortamında hazır olarak sunulacaktır |
| Linux veya komut satırı deneyimi | Komutlar oturum sırasında adım adım açıklanacaktır |

---

## 4. Kurs öncesi okuma

[01_teori](01_teori/) klasöründeki okuma listesinden bir veya iki kısa kaynağın
incelenmesi önerilmektedir. Listenin tamamının okunması
beklenmemektedir; amaç, kullanılacak terminolojinin kurs sabahı tanıdık
gelmesidir.

---

## 5. Ek: Yerel kurulum

Bu bölüm kurs için gerekli değildir. Katılımcıların kurs sonrasında kendi
araştırmalarında çalışmaya devam edebilmeleri amacıyla verilmiştir.

Önerilen yol `conda`/`mamba` paket yöneticisidir:

```bash
# Miniforge kurulu değilse: https://github.com/conda-forge/miniforge
mamba create -n martini python=3.11
mamba activate martini
mamba install -c conda-forge gromacs
pip install vermouth insane
```

Kurulum doğrulaması:

```bash
gmx --version
martinize2 -h
insane -h
```

**Windows kullanıcıları için not.** GROMACS'in doğrudan Windows üzerine
kurulması yerine [WSL2](https://learn.microsoft.com/tr-tr/windows/wsl/install)
(Ubuntu) ortamı üzerine kurulması önerilmektedir.

---

## 6. Destek

Kurulum aşamasında sorun yaşayan katılımcılar deponun *Issues* bölümünü
kullanarak veya eğitmenlere doğrudan yazarak destek talep edebilirler.
