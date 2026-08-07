# ---------------------------------------------------------------------------
# Statistilise analüüsi alused, 2026 sügis
# Andmete ettevalmistus: ESS11 (Eesti)
#
# See skript teeb läbi kõik need sammud, mille me praktikumides 3 ja 4 koos
# ette võtame. Ta võtab sisendiks ESS-i Eesti andmefaili ja annab väljundiks
# analüüsivalmis andmestiku, mida me kasutame alates praktikumist 5.
#
# Sisend : data/ess11_ee_raw.sav      -- ESS11 Eesti osa, muidu puutumata
# Väljund: data/ess11_ee_clean.rdata  -- analüüsivalmis andmestik
#
# Sisendfail on ESS11 (väljaanne 4.2) originaalfailist eraldatud Eesti osa.
# Eraldamine on tehtud skriptiga R/00-eesti-eraldamine.py ning failis on
# säilitatud kõik see, mis ESS-i originaalis oli -- muutujate ja väärtuste
# sildid ning puuduvate väärtuste definitsioonid.
#
# Andmete allikas:
#   European Social Survey European Research Infrastructure (ESS ERIC) (2026).
#   ESS11 - integrated file, edition 4.2. Sikt - Norwegian Agency for Shared
#   Services in Education and Research. doi:10.21338/ess11e04_2
# ---------------------------------------------------------------------------

# library() -- laeb juba paigaldatud lisapaketi, et selle funktsioone saaks
# kasutada. Paketi nimi käib siin ILMA jutumärkideta. Kui pakett on veel
# paigaldamata, tuleb esmalt kasutada install.packages("nimi") -- see aga
# jutumärkidega.

library(haven)   # SPSS ja Stata failide lugemine
library(dplyr)   # andmetöötlus

# Lokaadi kontroll. Kui R töötab C-lokaadis, siis lähevad täpitähed katki --
# nii kuvamisel kui ka tekstide võrdlemisel. Projekti .Rprofile seab selle
# üldjuhul juba paika; siin on kontroll igaks juhuks.
if (!grepl("UTF-8", Sys.getlocale("LC_CTYPE"), fixed = TRUE)) {
  Sys.setlocale("LC_CTYPE", "en_US.UTF-8")
}


# ===========================================================================
# 1. ANDMETE SISSE LUGEMINE
# ===========================================================================

# read_sav() -- loeb sisse SPSS faili (.sav). Ainus kohustuslik argument on
# faili nimi/asukoht jutumärkides. Vanem funktsioon foreign::read.spss()
# töötab samuti, kuid haven on tänapäeval standard: ta on kiirem ja säilitab
# muutujate ning väärtuste sildid.

ee_raw <- read_sav("data/ess11_ee_raw.sav")

# dim() -- näitab andmetabeli mõõtmeid: esmalt ridade, siis veergude arv.
dim(ee_raw)   # 1293 vastajat, 426 muutujat


# ===========================================================================
# 2. MIS ANDMETEGA MEIL ÜLDSE TEGEMIST ON?
# ===========================================================================

# class() -- ütleb, mis tüüpi objektiga on tegemist.
class(ee_raw$polintr)   # "haven_labelled" -- mitte lihtsalt "numeric"!

# Kui loeme SPSS faili sisse paketiga haven, siis ei ole muutujad tavalised
# arvulised muutujad, vaid nn "haven_labelled" tüüpi. See tähendab, et arvude
# küljes on ka sildid.
#
# See on ühest küljest kasulik (näeme, mida arvud tähendavad), teisest küljest
# tüütu: paljud funktsioonid ei tea, mida sellise muutujaga peale hakata.
# Seetõttu peame iga muutuja puhul otsustama, kas teeme temast
#   - arvulise muutuja        -> zap_labels()  (viskab sildid minema)
#   - kategoorilise muutuja   -> as_factor()   (teeb siltidest kategooriad)
#
# Lisaks on olemas üldised TEISENDUSFUNKTSIOONID, mis töötavad ükskõik millise
# muutujaga ja mida me allpool tihti kasutame:
#   as.numeric()   -- teeb muutujast arvulise muutuja
#   as.character() -- teeb muutujast tekstilise muutuja
#
# Neid on hea meeles pidada, sest R keeldub sageli millegi tegemisest lihtsalt
# sellepärast, et muutuja on "vale" tüüpi. Kontrolli siis alati esmalt
# funktsiooniga class(), mis tüüpi muutujaga tegelikult tegemist on.

# attr() -- küsib objekti juurde kuuluvat lisainfot ("atribuuti"). Siltide
# nägemiseks küsime atribuuti nimega "labels".
attr(ee_raw$polintr, "labels")


# --- Puuduvad väärtused ----------------------------------------------------

# ESS kodeerib "ei oska öelda" ja "keeldus vastamast" eraldi koodidega:
# väiksema skaalaga muutujatel 7/8/9, suurema skaalaga muutujatel 77/88/99.
#
# HEA UUDIS: ESS on need failis ära märkinud kui puuduvad väärtused, nii et
# haven muudab nad automaatselt NA-ks. Vaatame, mis toimub kapoti all.
#
# read_sav() argumendid, mida siin kasutame:
#   col_select -- loe sisse ainult loetletud muutujad (kiirem)
#   user_na    -- kui TRUE, siis ÄRA muuda neid koode NA-ks, vaid näita neid

ee_koodidega <- read_sav(
  "data/ess11_ee_raw.sav",
  col_select = c(lrscale),
  user_na = TRUE
)

# table() argument useNA = "ifany" lisab tabelisse ka puuduvate väärtuste arvu.
table(ee_koodidega$lrscale, useNA = "ifany")   # 77 ja 88 on näha
table(ee_raw$lrscale, useNA = "ifany")         # samad juhtumid on NA

# NB! Ära harju sellega ära. ESS on erakordselt hästi ette valmistatud
# andmestik. Väga paljud andmestikud, millega sa oma töös kokku puutud, ei
# ole. Seal on 999 lihtsalt üks arv teiste seas ja kui sa seda ei märka, siis
# arvutab R sinu eest keskmise, milles on sees hunnik 999-eid.

rm(ee_koodidega)


# --- Kui palju meil üldse andmeid on? --------------------------------------

# Enne modelleerimist tasub alati vaadata, kui palju on iga muutuja puhul
# puuduvaid väärtusi. "n = 1293" ei ole see n, millega mudel päriselt arvutab.

huvipakkuvad <- c(
  "agea", "gndr", "eisced", "hinctnta", "domicil", "lrscale",
  "polintr", "vote", "trstplt", "stfdem", "health",
  "imbgeco", "imueclt", "imwbcnt", "prtvtiee"
)

# sapply() -- rakendab funktsiooni kõikidele elementidele (siin: kõikidele
# muutujatele) ja paneb tulemused kokku. Teine argument on funktsioon, mida
# rakendada. Siin kirjutame selle ise: loe kokku puuduvad väärtused.
# is.na() -- annab iga väärtuse kohta TRUE, kui ta on puuduv.
huvipakkuvate_andmed <- ee_raw[huvipakkuvad]
sapply(huvipakkuvate_andmed, function(x) sum(is.na(x)))


# --- Kas puuduvad väärtused on juhuslikud? ---------------------------------

# Sissetuleku kohta jättis vastamata 114 inimest. Kas nad on "keskmised"
# vastajad, kes lihtsalt juhuslikult vastamata jätsid? Vaatame.
#
# Järgnev on nn TORU (pipe). Märk |> võtab vasakul oleva tulemuse ja annab
# selle järgmisele funktsioonile esimeseks argumendiks. Nii saab mitu sammu
# ritta panna, ilma et peaks iga vahetulemuse eraldi objekti panema.
# Loe teda nii: "võta ee_raw JA SIIS tee sellega järgmist ...".

ee_raw |>
  # 1. samm. mutate() -- lisab andmetabelisse uue muutuja (või muudab
  #    olemasolevat). Siin: uus tõeväärtusmuutuja, mis on TRUE nende ridade
  #    puhul, kus sissetulek on puudu.
  mutate(sissetulek_puudu = is.na(hinctnta)) |>
  # 2. samm. group_by() -- jagab andmed gruppideks. Kõik järgnevad arvutused
  #    tehakse iga grupi kohta eraldi. Siin: kaks gruppi, vastanud ja
  #    vastamata jätnud.
  group_by(sissetulek_puudu) |>
  # 3. samm. summarise() -- arvutab igast grupist kokkuvõtte. Iga rida
  #    väljundis on üks grupp. n() loendab juhtumeid grupis.
  #    NB! mean() argument na.rm = TRUE ütleb, et puuduvad väärtused tuleb
  #    arvutusest välja jätta. Ilma selleta annaks mean() vastuseks NA.
  summarise(
    n = n(),
    keskm_vanus = mean(agea, na.rm = TRUE),
    keskm_haridus = mean(eisced, na.rm = TRUE)
  )

# Vastus on EI. Need, kes sissetulekut ei avaldanud, on keskmiselt 9 aastat
# nooremad ja madalama haridusega. Kui me nad analüüsist välja jätame -- ja
# seda teeb R iga mudeli puhul automaatselt -- siis me ei jäta välja
# "juhuslikku" osa valimist, vaid ühe kindla grupi. Seda tuleb oma töös
# alati mainida.


# ===========================================================================
# 3. KAALUD
# ===========================================================================

# --- Mis on kaal ja miks teda vaja on? -------------------------------------
#
# ESS-i valim ei ole Eesti rahvastiku täpne väikemudel. Selleks on kaks
# põhjust.
#
# 1. VALIMI DISAIN. Inimesi ei valita alati ühesuguse tõenäosusega. Näiteks
#    kui valim moodustatakse leibkondade kaupa, siis suures leibkonnas elaval
#    inimesel on väiksem tõenäosus valituks osutuda kui üksi elaval inimesel.
#    Seda parandab DISAINIKAAL, muutuja "dweight".
#
# 2. VASTAMATA JÄTMINE. Osa valimisse sattunud inimestest ei vasta. Ja nad ei
#    jäta vastamata juhuslikult -- noored, mehed ja suurlinnaelanikud on
#    küsitlustes süstemaatiliselt alaesindatud, sest neid on raskem kätte
#    saada ja nad keelduvad sagedamini.
#
# Teise probleemi lahendamiseks kasutatakse POSTSTRATIFITSEERIMISKAALU
# (muutuja "pspwght"). Mõte on lihtne. Me teame rahvastikuregistrist ja
# statistikaametist üsna täpselt, milline on Eesti elanikkonna tegelik
# koosseis. Neid teadaolevaid jaotusi nimetatakse STRAATUMITEKS. Kui mingi
# grupp on valimis alaesindatud, saavad tema liikmed ühest suurema kaalu.
#
# summary() -- annab muutujast kiire kokkuvõtte: miinimumi, maksimumi,
# keskmise, mediaani ja kvartiilid.

summary(ee_raw$pspwght)

# ESS-i failis on kaale mitu:
#   dweight  -- disainikaal (valikutõenäosuste erinevused)
#   pspwght  -- poststratifitseerimiskaal (sisaldab ka disainikaalu) <- see
#   pweight  -- rahvaarvukaal, riikide võrdlemiseks
#   anweight -- pspwght ja pweight koos, analüüsikaal


# --- Millal kaalud loevad? -------------------------------------------------

# zap_labels() -- eemaldab haven-i sildid ja teeb muutujatest tavalised
# arvulised muutujad. Vajalik, et allpool olevad arvutused töötaksid.
d <- zap_labels(ee_raw)

# (a) KUI KIRJELDAME RAHVASTIKKU -- kaalud loevad.
#
# weighted.mean() -- kaalutud keskmine. Esimene argument on muutuja, teine
# (w) on kaalud. Iga väärtus loeb keskmise arvutamisel oma kaalu võrra.

c(
  kaalumata = mean(d$agea, na.rm = TRUE),
  kaalutud = weighted.mean(d$agea, d$pspwght, na.rm = TRUE)
)

# Valimisaktiivsus. Võtame ainult need, kes vastasid kas jah või ei.
#
# filter() -- valib andmetabelist READ, mis vastavad tingimusele. Esimene
# argument on andmetabel, sellele järgneb tingimus. (Veergude valimiseks on
# eraldi funktsioon select(), mida kasutame allpool.)
#
# %in% -- operaator, mis küsib "kas see väärtus leidub selles loetelus?".
# Vastus on TRUE või FALSE. Ta on lühem viis kirjutada mitut võrdlust:
# `vote %in% c(1, 2)` tähendab sama, mis `vote == 1 | vote == 2`.

valis <- filter(d, vote %in% c(1, 2))

c(
  kaalumata = mean(valis$vote == 1),
  kaalutud = weighted.mean(valis$vote == 1, valis$pspwght)
)
# 74.1% vs 71.8%. Kaalumata andmed ÜLEHINDAVAD valimisaktiivsust rohkem kui
# kahe protsendipunkti võrra.

# (b) KUI ARVUTAME HOIAKUTE KESKMISI -- kaalud loevad vähe.
c(
  kaalumata = mean(d$lrscale, na.rm = TRUE),
  kaalutud = weighted.mean(d$lrscale, d$pspwght, na.rm = TRUE)
)

# (c) KUI KIRJELDAME SEOST kahe muutuja vahel -- kaalud loevad samuti vähe.
#
# lm() -- lineaarne regressioonimudel.
#
# ~ -- "tilde". See operaator kirjeldab R-is MUDELI VALEMIT. Vasakule poole
# käib see muutuja, mida me seletada tahame, ja paremale poole need
# muutujad, millega me teda seletame.
#
# coef() -- võtab mudelist välja koefitsiendid.
# cbind() -- paneb veerud kõrvuti üheks tabeliks ("column bind").
# round() ümardab, teine argument ütleb, mitu kohta pärast koma jätta.

mudel_kaalumata <- lm(lrscale ~ agea + eisced, data = d)

mudel_kaalutud <- lm(
  lrscale ~ agea + eisced,
  data = d,
  weights = pspwght
)

koefitsiendid_korvuti <- cbind(
  kaalumata = coef(mudel_kaalumata),
  kaalutud = coef(mudel_kaalutud)
)

round(koefitsiendid_korvuti, 4)

# JÄRELDUS. Kaalud on olulised siis, kui sa tahad öelda midagi RAHVASTIKU
# KOHTA. Nad on palju vähem olulised siis, kui sa uurid, KUIDAS KAKS NÄHTUST
# ON OMAVAHEL SEOTUD.

rm(d, valis, mudel_kaalumata, mudel_kaalutud, koefitsiendid_korvuti)


# ===========================================================================
# 4. MUUTUJATE VALIK JA ÜMBER KODEERIMINE
# ===========================================================================

# select() -- valib andmetabelist VEERUD (muutujad). Vastandub funktsioonile
# filter(), mis valib ridu.

ee <- ee_raw |>
  select(
    idno, pspwght, anweight,
    # demograafia
    agea, gndr, eisced, hinctnta, domicil,
    # poliitika
    lrscale, polintr, vote, prtvtiee, stfdem, ppltrst,
    # institutsionaalne usaldus (indeksi koostisosad)
    trstprl, trstlgl, trstplc, trstplt, trstprt, trstep, trstun,
    # suhtumine sisserändesse (indeksi koostisosad)
    imbgeco, imueclt, imwbcnt,
    # tervis
    health
  )


# --- 4.1 Valimisosalus: kategooria, mis EI OLE puuduv väärtus --------------

# Muutuja "vote" on kodeeritud 1 = jah, 2 = ei, 3 = ei olnud hääleõiguslik.
# Kolmas kategooria ei ole ESS-i failis märgitud puuduvaks väärtuseks, seega
# tuleb ta R-i sisse päris arvuna 3.

table(zap_labels(ee$vote), useNA = "ifany")   # 111 inimest väärtusega 3

# Neid inimesi EI TOHI lugeda mittevalijateks -- nad ei saanudki valida.
# Nende õige koht on puuduv väärtus.
#
# Ühtlasi kodeerime ümber 1/2 -> 1/0, sest logistiline regressioon tahab
# sõltuvat tunnust kujul 0 ja 1.
#
# case_when() -- mitmene tingimuslause. Iga rida on kujul
# "tingimus ~ väärtus" ja loetakse ülevalt alla: esimene sobiv tingimus
# annab tulemuse. Argument .default määrab, mis saab kõigist ülejäänutest.
# NA_real_ on arvulise muutuja puuduv väärtus.

vote_arvuna <- as.numeric(ee$vote)

ee <- ee |>
  mutate(
    valis = case_when(
      vote_arvuna == 1 ~ 1,   # jah
      vote_arvuna == 2 ~ 0,   # ei
      .default = NA_real_     # 3 = ei olnud hääleõiguslik + NA
    )
  )

table(ee$valis, useNA = "ifany")   # 871 valis, 304 ei valinud, 118 NA


# --- 4.2 Kuidas mitmest küsimusest üks muutuja teha? -----------------------
#
# Küsitlusuuringus ei ole päris pidevaid muutujaid. Iga üksik küsimus on
# jäme ja mürane mõõdik: vastaja valib mõne astme ning tema tegelik hoiak
# jääb kuhugi vahepeale.
#
# Lahendus on küsida sama asja kohta MITU küsimust ja need kokku panna.
#
# Kõige lihtsam oleks võtta keskmine, aga see eeldab, et kõik küsimused
# mõõdavad seda asja ÜHTVIISI HÄSTI, mis üldiselt ei ole tõsi.
#
# Seetõttu kasutame FAKTORANALÜÜSI. Ta annab meile kaks asja:
#   1. FAKTORLAADUNGID -- kui tugevalt iga küsimus ühise nähtusega seotud on;
#   2. FAKTORSKOORID   -- iga vastaja väärtus sellel nähtusel. See ongi meie
#      uus muutuja.
#
# factanal() argumendid:
#   x       -- andmetabel ainult nende küsimustega, mida analüüsida
#   factors -- mitu ühist nähtust otsida (meil üks)
#   scores  -- "regression" palub arvutada iga vastaja faktorskoori
#
# NB! factanal() vajab tavalisi arvulisi muutujaid ja ei oska puuduvate
# väärtustega midagi peale hakata.
#   lapply()        -- rakendab funktsiooni igale veerule eraldi
#   as.data.frame() -- teeb nimekirjast tagasi andmetabeli
#   complete.cases()-- annab TRUE ridade kohta, kus puuduvaid väärtusi ei ole


# --- 4.3 Suhtumine sisserändesse ------------------------------------------

# Kolm küsimust, kõik skaalal 0-10:
#   imbgeco  0 = halb majandusele      10 = hea majandusele
#   imueclt  0 = kahjustab kultuuri    10 = rikastab kultuuri
#   imwbcnt  0 = halvem koht elamiseks 10 = parem koht elamiseks
#
# Küsimuste omavaheline seotus ja suund on eelnevalt üle kontrollitud: kõik
# kolm on samas suunas ja piisavalt tugevalt seotud. Korrelatsiooni juurde
# tuleme praktikumis 8, siis vaatame seda ka päriselt.

ranne_kysimused <- c("imbgeco", "imueclt", "imwbcnt")

ranne_veerud <- lapply(ee[ranne_kysimused], as.numeric)
ranne_andmed <- as.data.frame(ranne_veerud)
ranne_terved <- complete.cases(ranne_andmed)

ranne_fa <- factanal(
  ranne_andmed[ranne_terved, ],
  factors = 1,
  scores = "regression"
)

ranne_fa$loadings

# Faktorskoorid andmetabelisse. Kuna faktoranalüüs kasutas ainult osa
# ridadest, ei saa skoore lihtsalt veeruks panna -- nad ei satuks õigete
# inimeste kohale. Teeme tühja muutuja ja täidame ainult arvutatud read.

ee$ranne <- NA_real_
ee$ranne[ranne_terved] <- ranne_fa$scores[, 1]

# Faktori SUUND on matemaatiliselt suvaline. Kontrollime ja pöörame
# vajadusel ümber, et suurem väärtus tähendaks positiivsemat suhtumist.
#
# if () { } -- TINGIMUSLAUSE. Ümarsulgudes on tingimus ja looksulgudes see,
# mida teha, kui tingimus on tõene.

imwbcnt_arvuna <- as.numeric(ee$imwbcnt)
ranne_suund <- cor(ee$ranne, imwbcnt_arvuna, use = "complete.obs")

if (ranne_suund < 0) {
  ee$ranne <- -ee$ranne
}

summary(ee$ranne)


# --- 4.4 Institutsionaalne usaldus ----------------------------------------

# Seitse küsimust, kõik skaalal 0-10, kus 0 = ei usalda üldse ja
# 10 = usaldan täielikult:
#   trstprl  Riigikogu          trstlgl  õigussüsteem
#   trstplc  politsei           trstplt  poliitikud
#   trstprt  erakonnad          trstep   Euroopa Parlament
#   trstun   ÜRO
#
# Ka need on eelnevalt üle kontrollitud: kõik samas suunas ja omavahel
# tugevalt seotud.

usaldus_kysimused <- c(
  "trstprl", "trstlgl", "trstplc",
  "trstplt", "trstprt", "trstep", "trstun"
)

usaldus_veerud <- lapply(ee[usaldus_kysimused], as.numeric)
usaldus_andmed <- as.data.frame(usaldus_veerud)
usaldus_terved <- complete.cases(usaldus_andmed)

usaldus_fa <- factanal(
  usaldus_andmed[usaldus_terved, ],
  factors = 1,
  scores = "regression"
)

usaldus_fa$loadings

ee$usaldus <- NA_real_
ee$usaldus[usaldus_terved] <- usaldus_fa$scores[, 1]

trstplt_arvuna <- as.numeric(ee$trstplt)
usaldus_suund <- cor(ee$usaldus, trstplt_arvuna, use = "complete.obs")

if (usaldus_suund < 0) {
  ee$usaldus <- -ee$usaldus
}

summary(ee$usaldus)


# --- 4.5 Erakondlik eelistus: väikeste kategooriate kokku panemine ---------

# as_factor() -- teeb haven_labelled muutujast faktori, kasutades
# kategooriate nimedena silte.
# sort() argumendiga decreasing = TRUE järjestab tabeli suuruse järgi.

erakond_kogu <- as_factor(ee$prtvtiee)
erakond_tabel <- table(erakond_kogu)
sort(erakond_tabel, decreasing = TRUE)

# Kuus erakonda on korraliku suurusega (93-231 vastajat), ülejäänud on
# üksikud juhtumid. Viie vastajaga grupi kohta ei saa statistiliselt midagi
# öelda, seega paneme nad kokku kategooriasse "Muu".
#
# NB! Kasutame LÜHIKESI nimetusi. Pikad erakonnanimed ei mahu tabelitesse
# ega joonistele ära ning lõhuvad vormistuse. Lühendame kohe siin, mitte
# hiljem iga joonise juures eraldi.

erakond_tekstina <- as.character(as_factor(ee$prtvtiee))

erakond_lyhike <- case_when(
  erakond_tekstina == "Eesti Reformierakond" ~ "Reform",
  erakond_tekstina == "Isamaa Erakond" ~ "Isamaa",
  erakond_tekstina == "Eesti 200" ~ "E200",
  erakond_tekstina == "Sotsiaaldemokraatlik Erakond" ~ "SDE",
  erakond_tekstina == "Eesti Konservatiivne Rahvaerakond" ~ "EKRE",
  erakond_tekstina == "Eesti Keskerakond" ~ "Kesk",
  is.na(erakond_tekstina) ~ NA_character_,
  .default = "Muu"
)

# factor() -- teeb tekstist kategoorilise muutuja. Argument levels määrab
# kategooriate JÄRJEKORRA. Esimene kategooria jääb regressioonimudelis
# referentskategooriaks.

ee$erakond <- factor(
  erakond_lyhike,
  levels = c("Reform", "Isamaa", "E200", "SDE", "EKRE", "Kesk", "Muu")
)

table(ee$erakond, useNA = "ifany")


# --- 4.6 Kategoorilised muutujad ja nende sildid ---------------------------

# ESS-i sildid on inglise keeles. Kuna kogu meie töö on eesti keeles ja need
# sildid lähevad hiljem otse joonistele ja tabelitesse, tõlgime nad kohe siin.
#
# levels() -- näitab faktori kategooriaid nende järjekorras. Sama
# funktsiooniga saab neid ka ASENDADA. Kontrolli ALATI enne asendamist, mis
# järjekorras kategooriad on.
#
# droplevels() -- viskab välja kategooriad, mida andmetes ei esine.
#
# Sildid hoiame LÜHIKESED, et nad tabelitesse ja joonistele ära mahuksid.

levels(as_factor(ee_raw$gndr))      # Male, Female
levels(as_factor(ee_raw$domicil))   # A big city ... Farm or home in countryside

ee$sugu <- droplevels(as_factor(ee$gndr))
levels(ee$sugu) <- c("mees", "naine")

ee$elukoht <- droplevels(as_factor(ee$domicil))
levels(ee$elukoht) <- c(
  "suurlinn",
  "äärelinn",
  "väikelinn",
  "maa-asula",
  "maakodu"
)


# --- 4.7 Arvulised muutujad -----------------------------------------------

# eisced on skaalal 1-7. ESS-i failis on ka koodid 0 ("ei saa
# harmoniseerida") ja 55 ("muu"), mis EI OLE märgitud puuduvateks. Eesti
# andmetes neid ei esine, aga me kontrollime seda, mitte ei eelda.

table(zap_labels(ee$eisced), useNA = "ifany")

ee <- ee |>
  mutate(
    vanus = as.numeric(agea),
    haridus = as.numeric(eisced),
    sissetulek = as.numeric(hinctnta),
    vasak_parem = as.numeric(lrscale),
    usaldus_pol = as.numeric(trstplt),
    usaldus_rii = as.numeric(trstprl),
    usaldus_inim = as.numeric(ppltrst),
    rahulolu_dem = as.numeric(stfdem),
    # tervis: ESS-is 1 = väga hea ... 5 = väga halb. Pöörame ümber, et
    # suurem väärtus tähendaks paremat tervist. Viis kategooriat, seega
    # võime teda käsitleda pidevana.
    tervis = 6 - as.numeric(health),
    # huvi poliitika vastu: ESS-is 1 = väga huvitatud ... 4 = üldse mitte.
    # Neli kategooriat on pideva muutuja jaoks liiga vähe, seega teeme
    # temast binaarse muutuja: 1 = huvitatud, 0 = ei ole huvitatud.
    huvi_pol = case_when(
      as.numeric(polintr) %in% c(1, 2) ~ 1,
      as.numeric(polintr) %in% c(3, 4) ~ 0,
      .default = NA_real_
    )
  )


# ===========================================================================
# 5. LÕPLIK ANDMESTIK
# ===========================================================================

data <- ee |>
  select(
    idno, pspwght, anweight,
    vanus, sugu, haridus, sissetulek, elukoht,
    vasak_parem, huvi_pol, valis, erakond,
    usaldus_pol, usaldus_rii, usaldus_inim, rahulolu_dem,
    ranne, usaldus, tervis
  )

# Kodeeringu kindlustamine. Kui tekstiväärtuste kodeering ei ole selgelt
# märgitud, siis lähevad täpitähed teises arvutis katki -- nii kuvamisel kui
# ka võrdlemisel. Märgime kõikide faktorite sildid selgesõnaliselt UTF-8-ks.

for (veerg in names(data)) {
  if (is.factor(data[[veerg]])) {
    levels(data[[veerg]]) <- enc2utf8(levels(data[[veerg]]))
  }
}

# str() -- näitab objekti struktuuri: muutujad, nende tüübid ja esimesed
# väärtused.
str(data)

# summary() töötab ka terve andmetabeli peal korraga.
summary(data)

# Kui palju juhtumeid on iga muutuja puhul tegelikult olemas?
# Hüüumärk ! tähendab "mitte", seega !is.na(x) tähendab "on olemas".
sapply(data, function(x) sum(!is.na(x)))

# save() -- salvestab objekti R-i enda formaadis.
save(data, file = "data/ess11_ee_clean.rdata")

# ---------------------------------------------------------------------------
# Kõik. Objekt "data" on see, millega me alates praktikumist 5 töötame.
# ---------------------------------------------------------------------------
