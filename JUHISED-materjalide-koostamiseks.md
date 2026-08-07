# Juhised õppematerjalide koostamiseks

Üldistatud põhimõtted, mille järgi koostada R-i ja statistika õppematerjale.
Mõeldud kasutamiseks instruktsioonina ka teiste ainete materjalide juures.

---

## 1. Selgitamise reeglid

**1.1. Kui midagi tehakse koodis esimest korda, järgneb sellele kohe selgitus.**
See ei kehti ainult funktsioonide kohta. Seletada tuleb kõik:

| Mis | Näide |
|-----|-------|
| funktsioon | `dim()` — mida ta annab ja mis järjekorras |
| **argument** | `sep = ","` — mida ta teeb ja miks teda vaja on |
| operaator | `%in%`, `\|>`, `~`, `!` |
| süntaks | `ee[, c("a", "b")]` — miks koma, miks jutumärgid |
| objektitüüp | `tibble`, `haven_labelled`, faktor |
| väljundi osa | mida tähendab rida `Proportion Var` |

Kõige sagedasem viga on argumentide vahelejätmine. Funktsioon seletatakse ära,
aga argumendid, mis temaga koos esimest korda esinevad, jäävad seletamata.

**1.2. Selgitus tuleb enne kasutust või vahetult pärast seda, mitte hiljem.**
Kui funktsiooni kasutatakse real 40 ja seletatakse real 120, on see viga. Lugeja
loeb järjest.

**1.3. Selgitus on lühike ja käib asja kohta.** Üks-kaks lauset: mida teeb ja kuidas
teda määratakse. Mitte dokumentatsiooni ümberjutustus.

**1.4. Iga peatüki juurde käib register sellest, mis on varem juba seletatud.**
Ilma selleta ei ole reeglit võimalik järjekindlalt rakendada. Kontrolli
masinaga, mitte peast.

---

## 2. Koodi kirjutamise stiil

**2.1. Tegevused ei tohi olla üksteise sees.** Pesastatud kutsed tuleb lahti
kirjutada eraldi ridadele ja vaheobjektidesse.

```r
# HALB
round(cor(zap_labels(ee[, kysimused]), use = "complete.obs"), 3)

# HEA
kysimuste_andmed <- zap_labels(ee[, kysimused])
korrelatsioonid <- cor(kysimuste_andmed, use = "complete.obs")
round(korrelatsioonid, 3)
```

Pesastatud kood on lühem, aga õppematerjalis on loetavus tähtsam kui lühidus.
Lugeja peab nägema iga sammu eraldi.

**2.2. Mitme argumendiga funktsioonikutse:** üks argument reas, sulg lõpus
eraldi real, taane kaks tühikut.

```r
mudel <- lm(
  y ~ x1 + x2,
  data = andmed,
  weights = kaal
)
```

Mitte joondada argumente avaseleku alla — siis sõltub taane funktsiooni nime
pikkusest ja nihkub ümbernimetamisel.

**2.3. Ei mingit tühikutega joondamist.** `n = n()`, mitte `n     = n()`.

**2.4. Pikkade torude iga samm saab nummerdatud kommentaari.**

**2.5. Koodiread hoia 80 tähemärgi sees.** See kehtib **ainult koodi** kohta.

---

## 3. Teksti vormistus

**3.1. Proosat ei murta fikseeritud laiusega.** Lõik on üks pikk rida; murdmise
teeb tekstiredaktor ise (word wrap). Käsitsi murtud read teevad hilisema
toimetamise tülikaks — iga muudatus nõuab kogu lõigu ümbermurdmist.

**3.2. Lingid avanevad uues aknas.**

**3.3. Tekst kastides ja esiletõstetud plokkides peab olema must**, mitte hall.
Hall tekst värvilisel taustal ei ole loetav.

**3.4. Sildid ja nimetused hoia lühikesed.** Nad lähevad tabelitesse, joonistele
ja mudeliväljunditesse, kus pikad nimed lõhuvad vormistuse. Lühenda juba
andmete ettevalmistamisel, mitte hiljem iga joonise juures.

**3.5. Kodeering on UTF-8 kõikjal ja see tuleb tagada ka andmefailides.**
Vt punkt 6.3.

---

## 4. Raskusastmete eristamine

**4.1. Lihtsam rada peab olema iseseisvalt täielik.** Kõik, mida iga tudeng
peab teadma ja mõistma, öeldakse ära lihtsamas rajas. Lihtsam rada ei ole
kokkuvõte ega sissejuhatus keerulisemale — ta on täisväärtuslik seletus.

**4.2. Keerulisem rada on vabatahtlik** ja mõeldud edasijõudnumatele. Sinna
lähevad valemid, tuletuskäigud ja matemaatiline põhjendus.

**4.3. Valemid kuuluvad üldiselt ainult keerulisemasse rajasse.** Kui mõiste on
oluline kõigile, tuleb ta lihtsamas rajas seletada **sõnadega ja piltidega**.

> Näide: logit-skaalale liikumist tuleb lihtsamas rajas kirjeldada sõnaliselt —
> mis probleemi ta lahendab ja mis suunas ta asju muudab — ilma ühegi valemita.
> Valemid lähevad keerulisemasse rajasse.

**4.4. Lihtsam rada peab olema võimalikult põhjalik.** Lühidus ei ole siin
eesmärk. Eesmärk on, et lugeja saaks aru ilma teise raja juurde minemata.

---

## 5. Andmete ja muutujate tutvustamine

**5.1. Enne muutuja kasutamist mudelis näita tema skaalat ja jaotust.** Lühike
meeldetuletus: mis on skaala ulatus, mida tähendavad otsad, kuidas väärtused
jaotuvad. Nii on lugejal ettekujutus sellest, mille kohta arvud käivad.

**5.2. Mõõteskaala reegleid tuleb järgida järjekindlalt.** Kui materjalides on
kirjas reegel, siis peavad kõik näited sellele vastama. Kui reegel on "viis või
enam järjest nummerdatud kategooriat, et käsitleda pidevana", siis ei tohi
kusagil mujal kasutada neljakategoorialist muutujat pidevana.

Kontrolli see üle **kõikide** näidete puhul, mitte ainult seal, kus reegel
sõnastatakse.

**5.3. Kui reeglist tehakse erand, tuleb see välja öelda ja põhjendada.**

---

## 6. Korrektsus

**6.1. Ära kirjuta arve teksti käsitsi.** Iga arv, mis tekstis esineb, peab
tulema tegelikust väljundist. Kõige turvalisem on kasutada inline-koodi, nii et
arv arvutatakse dokumendi genereerimisel ja ei saa aegunuks jääda.

See on kõige tõsisem vigade allikas õppematerjalides. Käsitsi kirjutatud arv on
õige kirjutamise hetkel ja vale kohe, kui andmed või mudel muutuvad.

**6.2. Iga näite tekst peab klappima tegeliku väljundiga.** Kui tekst ütleb "seos
ei ole statistiliselt oluline", siis peab väljundis olema p > 0,05. Kontrolli
see üle iga näite puhul, kus tehakse sisuline järeldus.

**6.3. Andmefailid tuleb salvestada teadaoleva kodeeringuga.** Kui andmefail
salvestatakse vale lokaadiga keskkonnas, siis märgitakse stringide kodeering
valesti ning hiljem katkevad nii kuva kui **stringide võrdlemine**. Viimane on
ohtlik, sest ta ei anna veateadet — tulemus on lihtsalt vale.

Tagamiseks: määra lokaat projektis üheselt ja märgi tekstiväljade kodeering
salvestamisel selgesõnaliselt.

**6.4. Statistiliste tehete puhul kontrolli tulemuse võimalikku vahemikku.**
Kui tehe annab tõenäosuse, siis peab tulemus jääma nulli ja ühe vahele. Kui ta
seda ei tee, on valemis viga.

---

## 7. Aktiivõpe

**7.1. Osa väljundite seletusi jäta teadlikult puudu ja asenda küsimusega.**
Seda kasuta seal, kus vastus **peaks** varem käsitletu põhjal tudengil olemas
olema. See on seminaris arutelukoht.

Küsimus peab olema selgelt eristatav, mitte retooriline vahemärkus.

**7.2. Iga peatüki juurde käivad iseseisvad harjutused.** Ülesanne, mille tudeng
saab näiteandmete põhjal ise ära teha ja mis tugineb ainult sellele, mida on
juba käsitletud. See on seminaris iseseisva harjutamise koht.

**7.3. Harjutus peab olema tehtav** — kontrolli, et kõik vajalik on tõesti juba
seletatud.

---

## 8. Maht ja struktuur

**8.1. Üks peatükk = üks seminar.** Kui seminar on 1,5 tundi, siis peab peatükk
selle aja sisse mahtuma koos harjutuste ja aruteluga.

**8.2. Peatükid peaksid olema ühtlase pikkusega.** Kui üks on kaks korda pikem
kui teine, tuleb ta kas jagada või lühendada.

**8.3. Peatükid nummerdatakse järjest**, ilma lünkadeta.

**8.4. Näited hoia lühikesed.** Kui mingi meetodi tutvustamine ei ole
peatüki eesmärk, siis näita ainult seda koodi, mis on vajalik, ja maini
ülejäänut sõnades. Kõike, mida tehakse, ei pea koodina näitama.

> Näide: kui eesmärk on saada pidev muutuja, siis näita faktoranalüüsi käsku ja
> skooride kasutamist. Eeltingimuste kontrollimist maini lauses, ära näita
> koodina — selle juurde tullakse tagasi siis, kui see on omaette teema.

**8.5. Materjal ei pea kordama seda, mis tuleb hiljem.** Kui mingi meetod on
hilisema peatüki teema, siis ära tee teda varem ära — viita ette ja tule tagasi.

---

## 9. Tulemuste esitamise õpetamine

**9.1. Iga meetodi juures peab olema näidislause selle kohta, kuidas tulemust
kirja panna.** Konkreetsete arvudega, mitte üldsõnaliselt.

**9.2. Näidislause juurde käib loetelu sagedastest vigadest**, mida vältida.

**9.3. Jooniste puhul tuleb eraldi käsitleda vormistust:**

* teksti suurus joonisel peab olema ligilähedane töö teksti suurusele;
* iga element joonisel peab kandma olulist infot;
* dubleerivat infot ei tohi olla;
* teljed peavad olema sildistatud inimkeeles, mitte muutujate koodinimedega.

---

## 10. Tehniline kontroll enne valmis lugemist

Enne kui peatükk loetakse valmis olevaks:

1. **Esmakasutuse kontroll** — kas kõik uus on seletatud enne kasutamist?
2. **Arvude kontroll** — kas kõik tekstis olevad arvud tulevad väljundist?
3. **Järelduste kontroll** — kas iga sisuline järeldus klapib väljundiga?
4. **Skaalade kontroll** — kas mõõteskaala reeglid on järgitud?
5. **Kodeeringu kontroll** — kas täpitähed on nii koodis kui väljundis korras?
6. **Mahu kontroll** — kas peatükk mahub ette nähtud aja sisse?
7. **Renderdamise kontroll** — puhtast keskkonnast, teises arvutis.
