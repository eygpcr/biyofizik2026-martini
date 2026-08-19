# Kurulum ve Hesap Kontrol Listesi

> ⚠️ **Bu listeyi kurs gününden ÖNCE tamamlayın.** Özellikle CHARMM-GUI hesabı
> onayı bir iş günü sürebiliyor. **21 Ağustos Cuma ön toplantısında** hep birlikte
> canlı olarak kontrol edeceğiz — o güne kadar hazır olmanız yeterli.

Kurs boyunca bilgisayarınıza **hiçbir yazılım kurmanıza gerek yok**. Tüm uygulamalar
tarayıcı üzerinden (CHARMM-GUI ve Google Colab) yapılacak.

---

## ✅ Zorunlu

### 1. CHARMM-GUI hesabı

Oturum 2 ve 3'ün tamamı bu sitede geçiyor.

- 🔗 https://charmm-gui.org
- Sağ üstten **Register** → akademik e-posta adresinizle kaydolun (**ücretsiz**)
- ⏳ **Hesap onayı bir iş günü sürebilir.** Bu yüzden en geç **18 Ağustos**'a kadar
  kaydolun ki 21 Ağustos toplantısında giriş yapabildiğinizi doğrulayabilelim.
- ✔️ **Kontrol:** siteye giriş yapabiliyor musunuz? *Input Generator → Solution Builder*
  sayfası açılıyor mu?

### 2. Google hesabı (Colab için)

Oturum 4, 5 ve 6'nın uygulamaları Google Colab'da.

- 🔗 https://colab.research.google.com
- ⚠️ **Kurumsal/üniversite Google hesaplarında Colab kapalı olabiliyor.**
  Bu yüzden **kişisel bir Gmail hesabı** kullanmanızı öneriyoruz.
- ✔️ **Kontrol:** Colab'ı açıp yeni bir notebook oluşturun, tek bir hücreye
  `print("merhaba")` yazıp çalıştırın. Çıktı geliyorsa hazırsınız.

### 3. Donanım

- Modern bir tarayıcı (Chrome, Firefox, Edge, Safari) çalıştıran **herhangi bir laptop**
- Kararlı internet bağlantısı
- **GPU gerekmiyor** — kursta uzun simülasyon koşmuyoruz

---

## 🔶 Önerilen (zorunlu değil)

### 4. VMD — moleküler görselleştirme

Oturum 5b'de kaba-taneli yapıları nasıl doğru göstereceğimizi anlatacağız.
Kendi ekranınızda denemek isterseniz:

- 🔗 https://www.ks.uiuc.edu/Research/vmd/
- İndirmek için siteye **ücretsiz kayıt** olmanız gerekiyor
- Alternatif: [PyMOL](https://pymol.org/) veya [ChimeraX](https://www.cgl.ucsf.edu/chimerax/)

---

## ❌ Gerekmeyenler

| | |
|---|---|
| **GitHub hesabı** | Bu depo herkese açık; hesapsız da indirebilir/okuyabilirsiniz |
| **Yerel GROMACS kurulumu** | Colab'da hazır gelecek |
| **Linux / terminal deneyimi** | Komutları birlikte, adım adım yazacağız |

---

## 📝 Kurs öncesi ödev (~20 dakika)

[`01_teori/README.md`](01_teori/) içindeki okuma listesinden **1–2 kısa kaynağa**
göz atın. Hepsini okumanız beklenmiyor; amaç kurs sabahı terimlerin tanıdık gelmesi.

---

## 🖥️ Ek: kurstan sonra kendi makinenize kurmak isterseniz

Kurs sırasında buna **ihtiyacınız yok**. Kendi araştırmanızda devam etmek isterseniz
en kolay yol `conda`/`mamba`:

```bash
# Miniforge kurulu değilse: https://github.com/conda-forge/miniforge
mamba create -n martini python=3.11
mamba activate martini
mamba install -c conda-forge gromacs
pip install vermouth insane
```

Kurulumu doğrulayın:

```bash
gmx --version
martinize2 -h
insane -h
```

**Windows kullanıcıları:** GROMACS'i doğrudan Windows'a kurmak yerine
[WSL2](https://learn.microsoft.com/tr-tr/windows/wsl/install) (Ubuntu) üzerine
kurmanız çok daha sorunsuz olur.

---

## 🆘 Takıldığınız yer olursa

21 Ağustos ön toplantısına takıldığınız noktayla gelin — birlikte çözelim.
Acil durumlar için bu deponun **Issues** sekmesini de kullanabilirsiniz.
