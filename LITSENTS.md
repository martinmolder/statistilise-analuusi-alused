# Litsentsid

Selles hoidlas on kahte eri laadi materjali ja neil on **erinevad litsentsid**.

---

## 1. Andmed — CC BY-NC-SA 4.0

Kaustas `data/` olevad failid põhinevad Euroopa Sotsiaaluuringu (ESS) andmetel.

| Fail | Mis see on |
|------|------------|
| `ess11_ee_raw.sav` | ESS11 (väljaanne 4.2) Eesti osa, muidu muutmata |
| `ess11_ee_clean.rdata` | eelmisest tuletatud analüüsivalmis andmestik |

**ESS-i andmed on avaldatud litsentsi [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) all**
([ESS-i teade](https://www.europeansocialsurvey.org/contact/disclaimer)). Mõlemad
ülalolevad failid on ESS-i andmetest tuletatud ja jäävad seetõttu **sama litsentsi
alla**.

See tähendab kolme asja.

* **BY (viitamine).** Andmete kasutamisel tuleb viidata algallikale — vt viide allpool.
* **NC (mittetulunduslik).** Kasutus ainult mittetulunduslikul eesmärgil. Õppetöö ja
  teadustöö vastavad sellele tingimusele.
* **SA (jagamine samadel tingimustel).** Kui sa neid andmeid muudad või nende põhjal uue
  andmestiku teed, siis peab ka see olema sama litsentsi all.

### Viitamine

> European Social Survey European Research Infrastructure (ESS ERIC) (2026).
> *ESS11 — integrated file, edition 4.2.* Sikt — Norwegian Agency for Shared Services in
> Education and Research. doi:[10.21338/ess11e04_2](https://doi.org/10.21338/ess11e04_2)

### Muudatused originaalandmetes

CC-litsents nõuab, et tehtud muudatused oleksid ära märgitud. Need on:

1. **`ess11_ee_raw.sav`** — ristriiklikust failist on välja võetud ainult Eesti
   vastajad (`cntry == "EE"`, n = 1293) ning eemaldatud need muutujad, mis on Eesti
   andmetes läbivalt tühjad (peamiselt teiste riikide erakondade muutujad). Muutujate
   sildid, väärtuste sildid ja puuduvate väärtuste definitsioonid on säilitatud
   muutmata kujul. Eraldamise skript: `R/00-eesti-eraldamine.py`.

2. **`ess11_ee_clean.rdata`** — eelmisest tuletatud õppeotstarbeline andmestik. Tehtud
   on muutujate valik, ümberkodeerimine, kategooriate ühendamine, siltide tõlkimine
   eesti keelde ning kahe faktorskoori arvutamine. Kõik sammud on kirjas ja
   kommenteeritud failis `R/ettevalmistus.R`.

> **Kui sa kasutad neid andmeid oma töös**, siis on soovitatav laadida originaalfail ise
> alla [ESS-i andmeportaalist](https://www.europeansocialsurvey.org). Nii saad kõik
> muutujad, kõik riigid ja kõige värskema väljaande — ning ESS saab arvestust selle üle,
> kui palju tema andmeid kasutatakse, mis on tema rahastuse seisukohalt oluline.

---

## 2. Õppematerjalid — CC BY 4.0

Kaustas olevad `.qmd` failid, R-skriptid kaustas `R/`, `styles.css` ja muud
õppematerjalid on **Martin Mölderi** autoriõigusega teosed.

Need ei ole ESS-i andmetest tuletatud teosed selle litsentsi tähenduses — tegemist on
iseseisva tekstiga, mis andmeid kasutab. Seetõttu ei laiene neile ESS-i litsentsi
"jagamine samadel tingimustel" nõue ja litsentsi valib autor.

**Materjalid on avaldatud litsentsi
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) all.**

See tähendab, et neid tohib:

* **kasutada** ükskõik millisel eesmärgil, sealhulgas õppetöös;
* **kopeerida ja edasi jagada** ükskõik millises vormis;
* **kohandada** — muuta, täiendada, oma kursuse jaoks ümber teha.

Ainus tingimus on **viitamine autorile**:

> Mölder, M. (2026). *Statistilise analüüsi alused: praktikumimaterjalid.*
> Tartu Ülikool.

### Mida see praktikas tähendab

| Kes | Mida tohib |
|---|---|
| tudeng | kasutada, kopeerida, oma märkmetesse võtta |
| teine õppejõud | võtta materjalid oma kursuse aluseks, muuta ja täiendada |
| ükskõik kes | avaldada oma kohandatud versioon, kui autorile on viidatud |

CC BY on kõige lubavam Creative Commonsi litsents peale avaliku omandi. Ta **ei nõua**,
et tuletatud teosed oleks sama litsentsi all, ega piira kasutust mittetulunduslikuga.

> **Üks nüanss, mida tasub teada.** Materjalide litsents (CC BY) on lubavam kui andmete
> oma (CC BY-NC-SA). Kui keegi võtab need materjalid ja jagab neid **koos andmetega**,
> siis kehtivad andmete kohta endiselt NC- ja SA-tingimused. Materjalide vabam litsents
> ei muuda andmete oma. Praktikas tähendab see, et kohandatud materjalid võib avaldada
> vabalt, aga andmefailid peavad kaasa minnes säilitama oma märgise.

## 3. Failid, mida hoidlasse ei panda

ESS-i **ristriiklik originaalfail** (`ESS11e04_2-subset/`) ja Eesti kumulatiivne fail
(`ESS country data - EE/`) on `.gitignore` failis välja jäetud. Põhjus ei ole
litsentsist tulenev keeld — CC BY-NC-SA lubab ka neid jagada — vaid praktiline: nad on
kokku üle 100 MB ja igaüks saab nad ESS-ist ise alla laadida.
