#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Kontrollib, et iga funktsioon oleks seletatud enne, kui teda kasutatakse.

Kasutus:
    python3 R/kontrolli-esmakasutus.py 03-andmete-ettevalmistus-1.qmd
    python3 R/kontrolli-esmakasutus.py R/ettevalmistus.R --praktikum 3

Skript loeb registri failist R/funktsioonide-register.md ja teab seeläbi, mis on
eelmistes praktikumides juba seletatud. Praktikumi number võetakse failinimest
(nt "03-..." -> 3) või argumendist --praktikum.

Seletuseks loeb skript kommentaari kujul "nimi() -- ..." või rida, kus funktsiooni
nimi esineb kommentaaris enne esimest kasutuskohta.
"""

import re
import sys
import os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REGISTER = os.path.join(BASE, "R", "funktsioonide-register.md")

# R-i baasasjad, mida me kunagi eraldi ei seleta
IGNORE = {
    "function", "if", "else", "for", "while", "return", "in",
    "c", "T", "F", "TRUE", "FALSE", "NA", "NULL", "Inf",
    # Argumendid, mis on nii tavalised või nii ise-enesest mõistetavad,
    # et neid eraldi ei seleta
    "arg:data", "arg:x", "arg:y", "arg:file", "arg:levels", "arg:labels",
    "arg:title", "arg:fill", "arg:color", "arg:colour", "arg:size",
    "arg:width", "arg:height", "arg:alpha", "arg:linewidth",
    "arg:na.rm", "arg:.default", "arg:mean",
}


def loe_register(kuni_praktikum):
    """Tagastab nimede hulga, mis on registris kuni antud praktikumini (kaasa arvatud
    varasemad, aga MITTE käesolev)."""
    if not os.path.exists(REGISTER):
        print("HOIATUS: registrit ei leitud:", REGISTER)
        return set()

    teada = set()
    praegune = None
    with open(REGISTER, encoding="utf-8") as f:
        for rida in f:
            p = re.match(r"^##\s*Praktikum\s+(\d+)", rida)
            if p:
                praegune = int(p.group(1))
                continue
            if praegune is None or praegune >= kuni_praktikum:
                continue
            # kõik `nimi()` ja `operaator` tagurpidi ülakomade vahel
            for m in re.finditer(r"`([^`]+)`", rida):
                t = m.group(1).strip()
                t = re.sub(r"\(\)$", "", t)
                t = re.sub(r"\s*<-$", "", t)
                if re.match(r"^[a-zA-Z_.][a-zA-Z0-9._]*$", t):
                    teada.add(t)
                    # Registris ei ole eraldi märgitud, kas tegemist on
                    # funktsiooni või argumendiga -- lisame mõlemal kujul.
                    teada.add("arg:" + t)
    return teada


def eralda_kood(tekst, on_qmd):
    """Tagastab nimekirja (reanumber, rida, on_kood)."""
    read = tekst.split("\n")
    if not on_qmd:
        return [(i, r, not r.strip().startswith("#")) for i, r in enumerate(read, 1)]

    tulem = []
    tykis = False
    peidetud = False
    for i, r in enumerate(read, 1):
        if re.match(r"^```+\s*\{r", r):
            tykis = True
            peidetud = False
            tulem.append((i, r, False))
            continue
        if tykis and re.match(r"^```+\s*$", r):
            tykis = False
            peidetud = False
            tulem.append((i, r, False))
            continue
        if tykis:
            # Ploki valikud: kui echo või include on false, siis tudeng seda
            # koodi ei näe ning esmakasutuse reegel tema kohta ei kehti.
            if re.match(r"^\s*#\|\s*(echo|include):\s*false", r):
                peidetud = True
            on_kood = (not r.strip().startswith("#")) and not peidetud
            tulem.append((i, r, on_kood))
        else:
            # tavaline tekst loeb seletuseks
            tulem.append((i, r, False))
    return tulem


# Funktsioonid, mille sees paneb nimed kasutaja ise (mitte argumendid)
OMANIMED = {
    "c", "data.frame", "mutate", "summarise", "summarize", "aes", "list",
    "tibble", "transmute", "rename", "cbind", "rbind", "sobivus",
}


def omanimede_funktsioon(kood, asukoht):
    """Kas selles kohas olev `nimi =` asub funktsiooni sees, kus nimed valib
    kasutaja ise? Otsime tagasi lähima avatud sulu ja selle ees oleva nime."""
    sygavus = 0
    i = asukoht
    while i >= 0:
        if kood[i] == ")":
            sygavus += 1
        elif kood[i] == "(":
            if sygavus == 0:
                eelnev = re.search(r"([a-zA-Z._][a-zA-Z0-9._]*)\s*$", kood[:i])
                return bool(eelnev) and eelnev.group(1) in OMANIMED
            sygavus -= 1
        i -= 1
    return False


def kontrolli(tee, praktikum):
    tekst = open(tee, encoding="utf-8").read()
    on_qmd = tee.endswith(".qmd")
    read = eralda_kood(tekst, on_qmd)

    teada = loe_register(praktikum)
    esmakasutus, seletus = {}, {}

    for nr, rida, on_kood in read:
        if on_kood:
            kood = rida.split("#")[0]
            # Eemalda jutumärkides olev tekst -- seal võib olla sõnu, mis
            # näevad välja nagu funktsioonikutsed ("usalduse vastu (0-10)").
            kood = re.sub(r'"[^"]*"', '""', kood)
            kood = re.sub(r"'[^']*'", "''", kood)

            # Funktsioonid
            for m in re.finditer(r"\b([a-zA-Z_.][a-zA-Z0-9._]*)\s*\(", kood):
                esmakasutus.setdefault(m.group(1), nr)

            # ARGUMENDID. Nimega argument on `nimi = väärtus` funktsiooni
            # sulgudes. Jätame välja objektide loomise (`x <- ...`) ja
            # võrdlused (`==`, `<=`, `>=`, `!=`).
            #
            # NB! Osade funktsioonide puhul valib nimed KASUTAJA ISE -- need ei
            # ole argumendid, mida oleks vaja seletada.
            for m in re.finditer(r"[(,]\s*([a-zA-Z._][a-zA-Z0-9._]*)\s*=(?!=)", kood):
                if not omanimede_funktsioon(kood, m.start()):
                    esmakasutus.setdefault("arg:" + m.group(1), nr)
        else:
            for m in re.finditer(r"([a-zA-Z_.][a-zA-Z0-9._]*)\(\)", rida):
                seletus.setdefault(m.group(1), nr)
            # Argumendi seletus tekstis: `nimi` või `nimi = väärtus`
            for m in re.finditer(r"`([a-zA-Z._][a-zA-Z0-9._]*)\s*=", rida):
                seletus.setdefault("arg:" + m.group(1), nr)
            for m in re.finditer(r"argumen\w*\s+`([a-zA-Z._][a-zA-Z0-9._]*)`", rida, re.I):
                seletus.setdefault("arg:" + m.group(1), nr)
            for m in re.finditer(r"`([a-zA-Z._][a-zA-Z0-9._]*)`\s*(?:--|—|ütleb|määrab|näitab|palub|lisab|puudutab|võtab|teeb|joondab|paneb|muudab)", rida, re.I):
                seletus.setdefault("arg:" + m.group(1), nr)

    probleemid = []
    for nimi, nr in sorted(esmakasutus.items(), key=lambda x: x[1]):
        if nimi in IGNORE or nimi in teada:
            continue
        s = seletus.get(nimi)
        if s is None:
            probleemid.append((nr, nimi, "seletamata"))
        elif s > nr:
            probleemid.append((nr, nimi, "seletus alles real %d" % s))

    print("Fail      :", os.path.basename(tee))
    print("Praktikum :", praktikum)
    print("Registrist teada varasemast: %d nime" % len(teada))
    print()

    if not probleemid:
        print("KORRAS. Iga funktsioon on seletatud enne kasutamist.")
        return 0

    print("PROBLEEMID (%d):" % len(probleemid))
    for nr, nimi, miks in probleemid:
        print("  rida %4d  %-22s %s" % (nr, nimi + "()", miks))
    print()
    print("Kui mõni neist on tegelikult varasemas praktikumis seletatud,")
    print("lisa ta faili R/funktsioonide-register.md vastavasse ossa.")
    return 1


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)

    tee = sys.argv[1]
    praktikum = None
    if "--praktikum" in sys.argv:
        praktikum = int(sys.argv[sys.argv.index("--praktikum") + 1])
    else:
        m = re.match(r"^(\d+)", os.path.basename(tee))
        praktikum = int(m.group(1)) if m else 99

    sys.exit(kontrolli(tee, praktikum))
