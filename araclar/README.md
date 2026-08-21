# Yardımcı Betikler

Not defterlerinin dışında, doğrudan komut satırından kullanılabilecek
betikler.

## `index_olustur.py`

GROMACS için `index.ndx` dosyası üretir: `Protein`, `Lipid` ve `Solvent`
grupları.

```bash
python3 index_olustur.py sistem.gro index.ndx
```

**Ne zaman gerekir?** Martini `.mdp` dosyalarındaki
`tc-grps = Protein Lipid Solvent` satırı bu adlarda üç grup bulunmasını
gerektirir. GROMACS'in öntanımlı grupları arasında `Lipid` ve `Solvent`
bulunmadığından bunlar ayrıca oluşturulmalıdır. Aksi hâlde `gmx grompp`
şu hatayı verir:

```
Fatal error:
Group Protein referenced in the .mdp file was not found in the list of
index groups.
```

**Neden `gmx make_ndx` yerine bu betik?** `make_ndx` etkileşimli bir
araçtır ve komutları grup **numaralarına** göre yorumlar; `name 0 Protein`
gibi bir komut yeni oluşturulan grubu değil, 0 numaralı grubu (`System`)
yeniden adlandırır. Grup numaraları sisteme göre değiştiğinden bu yaklaşım
sessizce yanlış gruplar üretebilmektedir. Bu betik grupları rezidü
adlarından doğrudan belirler ve üç grubun sistemi tam ve örtüşmeden
kapsadığını doğrular.

**GROMACS gerektirmez**; yalnızca Python 3 yeterlidir.

### Sınıflandırma

| Grup | İçeriği |
|---|---|
| `Lipid` | POPC, POPE, POPS, POPG, CHOL, DOPC, DPPC, DOPE |
| `Solvent` | W, WF, PW ve iyonlar (NA, CL, K ...) |
| `Protein` | Yukarıdakilerin dışında kalan her şey |

Farklı lipit kullanıyorsanız betiğin başındaki `LIPIT` kümesine
eklemeniz gerekir.
