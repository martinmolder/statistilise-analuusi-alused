#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Eesti andmete eraldamine ESS11 originaalfailist.

ÕPPEJÕU TÖÖRIIST, MITTE KURSUSE MATERJAL. Seda skripti jooksutatakse ÜKS KORD,
et toota fail data/ess11_ee_raw.sav, mille tudengid alla laevad. Kursuse enda
kood on kõik R-is.

Miks Python ja mitte R?
    haven::write_sav() EI SÄILITA kasutaja määratud puuduvate väärtuste
    definitsioone (user-defined missing values). Kui eraldada Eesti andmed
    R-iga, kaovad failist koodid 7/8/9 ja 77/88/99 ning nende märgistus
    puuduvate väärtustena. Praktikumis 3 me aga just neid näitame -- tudeng
    peab nägema, MIDA ESS on tema eest ära teinud.

    pyreadstat oskab need definitsioonid alles hoida, seega teeme eraldamise
    temaga. Tulemuseks on fail, mis käitub täpselt nagu ESS-i originaal,
    ainult ühe riigi andmetega.

Kasutus:
    python3 R/00-eesti-eraldamine.py
"""

import os
import pyreadstat

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SISEND = os.path.join(BASE, "ESS11e04_2-subset", "ESS11e04_2-subset.sav")
VALJUND = os.path.join(BASE, "data", "ess11_ee_raw.sav")


def main():
    if not os.path.exists(SISEND):
        raise SystemExit("Sisendfaili ei leitud: %s" % SISEND)

    # user_missing=True hoiab koodid 7/8/9 ja 77/88/99 alles ning annab
    # meta.missing_ranges kaudu kätte nende definitsioonid.
    df, meta = pyreadstat.read_sav(SISEND, user_missing=True)

    ee = df[df["cntry"] == "EE"].copy()
    print("Eesti vastajaid : %d" % len(ee))
    print("Muutujaid       : %d" % len(ee.columns))

    # Ainult need muutujad, millel Eesti andmetes üldse mingi väärtus on.
    # Ristriiklikus failis on hulk muutujaid, mis puudutavad ainult teisi
    # riike (nt teiste riikide erakonnad) -- need on Eesti puhul tühjad.
    tuhjad = [c for c in ee.columns if ee[c].notna().sum() == 0]
    ee = ee.drop(columns=tuhjad)
    print("Tühje muutujaid eemaldatud: %d" % len(tuhjad))
    print("Alles jääb      : %d muutujat" % len(ee.columns))

    alles = list(ee.columns)
    veerusildid = [meta.column_names_to_labels.get(c, "") or "" for c in alles]
    vaartussildid = {
        k: v for k, v in meta.variable_value_labels.items() if k in alles
    }
    puuduvad = {
        k: v for k, v in meta.missing_ranges.items() if k in alles
    }

    pyreadstat.write_sav(
        ee,
        VALJUND,
        column_labels=veerusildid,
        variable_value_labels=vaartussildid,
        missing_ranges=puuduvad,
        file_label="ESS11 edition 4.2, Eesti",
    )

    suurus = os.path.getsize(VALJUND) / 1024 ** 2
    print("\nSalvestatud: %s (%.2f MB)" % (VALJUND, suurus))
    print("Puuduvate väärtuste definitsioone säilitatud: %d muutujal" % len(puuduvad))

    # Kontroll: kas fail käitub nii, nagu vaja?
    k, kmeta = pyreadstat.read_sav(VALJUND, usecols=["lrscale"], user_missing=True)
    print("\nKontroll, lrscale koodidega:")
    print(k["lrscale"].value_counts().sort_index().to_dict())
    print("missing_ranges:", kmeta.missing_ranges.get("lrscale"))


if __name__ == "__main__":
    main()
