#!/usr/bin/env python3
"""index.ndx olusturur: Protein / Lipid / Solvent gruplari.

Kullanim:
    python3 index_olustur.py sistem.gro index.ndx

GROMACS gerektirmez. Gruplar rezidu adlarindan belirlenir; uc grubun
sistemi tam ve ortusmeden kapsadigi dogrulanir.
"""
import sys

LIPIT  = {'POPC','POPE','POPS','POPG','CHOL','DOPC','DPPC','DOPE'}
COZUCU = {'W','WF','PW'}
IYON   = {'NA','CL','NA+','CL-','ION','K','K+'}


def main(gro, ndx):
    satirlar = open(gro).read().splitlines()
    n = int(satirlar[1])
    gruplar = {'Protein': [], 'Lipid': [], 'Solvent': []}
    for i, s in enumerate(satirlar[2:2+n], start=1):
        rn = s[5:10].strip()
        if rn in LIPIT:
            gruplar['Lipid'].append(i)
        elif rn in COZUCU or rn in IYON:
            gruplar['Solvent'].append(i)
        else:
            gruplar['Protein'].append(i)

    with open(ndx, 'w') as f:
        for ad, idx in gruplar.items():
            f.write('[ %s ]\n' % ad)
            for k in range(0, len(idx), 15):
                f.write(' '.join('%7d' % x for x in idx[k:k+15]) + '\n')

    toplam = 0
    for ad, idx in gruplar.items():
        print('  %-10s %10d parcacik' % (ad, len(idx)))
        toplam += len(idx)
    print()
    print('  Gruplarin toplami : %d' % toplam)
    print('  Sistemdeki toplam : %d' % n)
    print()
    if toplam == n and all(gruplar.values()):
        print('BASARILI: %s yazildi.' % ndx)
    elif not all(gruplar.values()):
        print('UYARI: bos grup(lar) var -> %s'
              % [a for a, v in gruplar.items() if not v])
    else:
        print('UYARI: gruplarin toplami sistemle uyusmuyor.')


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(__doc__); sys.exit(1)
    main(sys.argv[1], sys.argv[2])
