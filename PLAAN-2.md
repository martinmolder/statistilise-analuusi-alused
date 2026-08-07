# Revision plan 2 — implementing Martin's review

Companion: `JUHISED-materjalide-koostamiseks.md` holds the generalised principles.
This file holds the concrete work items.

---

## 1. Assessment: the errors are real, and two are worse than flagged

I verified every technical claim before planning. All confirmed. Three deserve
particular attention.

### 1.1. The p-value error produced an impossible number

You said "ei korruta kahega, lahutame ühest". Verified — and the consequence is worse
than a stylistic slip:

```
t-skoor                : 3.8319
pt(t, df)              : 0.999933
minu kood, pt(t) * 2   : 1.999867   <- p-väärtus üle ühe, võimatu
õige 2 * (1 - pt(|t|)) : 0.000133
t.test() annab         : 0.000133
```

The chapter printed a p-value of 2.0 next to a `t.test()` output showing 0.000133 and
claimed they were the same number. Both the formula and the surrounding sentence are
wrong.

The general rule: two-sided p is `2 * (1 - pt(abs(t), df))`, equivalently
`2 * pt(-abs(t), df)`. Multiplying by two is correct only in the lower tail. I will
check every hand-computed probability in the materials against the corresponding
built-in function.

### 1.2. The two t-test examples are exactly backwards

The prose numbers were invented, not read from output. Actual values:

| Näide | tegelikud keskmised | tegelik p | mida tekst väitis |
|---|---|---|---|
| `vasak_parem ~ sugu` | 5,857 vs 5,508 | **0,0022 — oluline** | "ei ole oluline, p = 0,57" |
| `ranne ~ sugu` | 0,005 vs −0,004 | **0,86 — ei ole oluline** | "on oluline" |

So the chapter used a significant result to illustrate non-significance and vice versa,
with fabricated confidence intervals attached to both.

This is the single most important thing to fix in how the materials are written, not
just what they say. Principle 6.1 in the guidelines: **numbers in prose must come from
output, ideally via inline code so they cannot drift.** I will convert every reported
number in the materials to inline R.

### 1.3. The encoding problem is not cosmetic — it silently breaks results

You saw `\303\244\303\244` in the HTML and NA coefficients in `mudel6`. These are the
same bug.

Root cause: `data/ess11_ee_clean.rdata` was written in a `C` locale, so the Estonian
strings were stored with encoding marked as US-ASCII rather than UTF-8. Loading it in a
UTF-8 session produces:

```
input string 'suurlinna äärelinn' cannot be translated from 'US-ASCII' to UTF-8
```

The consequence in `mudel6`: `data$elukoht == "suurlinna äärelinn"` fails to match, the
dummy becomes all zeros, and `lm()` returns `NA` for it. Note which one worked —
`el_maa`, built from `"maa-asula"`, the only label with **no Estonian characters**.

**A wrong result with no error message.** Exactly the failure mode worth warning
students about, which makes it doubly embarrassing to have shipped it.

Fix: set the encoding explicitly when building the clean file, and pin the locale in the
project so renders are reproducible.

### 1.4. Other confirmed errors

* **Linear model does not predict above 1** with `lm(valis ~ vanus)` — range is
  0,623–0,881. Claim is false as written. Replacement found: `lm(valis ~ huvi_pol)`
  predicts **1,004** at the top category, and adding vanus + haridus gives a range of
  0,302–1,139 with **55 cases above 1**. The argument works, with a different example.
* **`predict()` interpretation in session 11** — the "2 punkti väärt" phrasing is not
  Estonian and the interpretation is muddled. Rewrite.
* **"Korrelatsioon 0,5 ei tähenda poole tugevam kui 1,0"** — wording error, should be
  about *r* not being linearly interpretable; rewrite the whole note.
* **CES-D battery is 4-category** and violates the stated five-category rule. See §3.2.

---

## 2. What I verified as feasible

| Question | Answer |
|---|---|
| Search needs a web server? | **Yes — and hosting fixes it.** Quarto's search fetches `search.json`, which `file://` blocks for security. `_book/search.json` exists and is correct. It will work on GitHub Pages, or locally via `quarto preview`. |
| Can pseudo R², sensitivity, specificity go into the `modelsummary` table automatically? | **Yes.** A `glance_custom.glm` method adds them as ordinary GOF rows. Tested and working — see §5.5. |
| Can duplicated model statistics be suppressed in the two-column logistic table? | Yes, but the cleaner fix is not to put the same model in twice — see §5.5. |
| Can table row spacing be tightened? | Yes, via CSS on `.tinytable` in `styles.css`. |

---

## 3. Structural decisions

### 3.1. Eleven practicals, numbered consecutively

Merging descriptive statistics and visualisation gives eleven. Proposed mapping:

| Uus | Sisu | Vana |
|-----|------|------|
| 1 | R ja RStudio, objektid | 1 |
| 2 | Andmete laadimine, mõõteskaalad | 2 |
| 3 | Andmete ettevalmistus I | 3 |
| 4 | Andmete ettevalmistus II | 4 |
| 5 | **Andmete kirjeldamine ja visualiseerimine** | 5 + 7 |
| 6 | Valim, populatsioon ja ebakindlus | 8 |
| 7 | Hüpoteeside testimine ja t-test | 9 |
| 8 | Korrelatsioon ja lihtne regressioon | 10 |
| 9 | Mitmene regressioon | 11 |
| 10 | Tulemuste esitamine | 12 |
| 11 | Logistiline regressioon | 13 |

Files renamed to `01`–`11`, all cross-references updated, `_quarto.yml` rewritten.

**Length balancing.** Session 5 becomes the longest by some margin if simply
concatenated. Current chunk counts: descriptives 15, visualisation 15. The merge needs
active trimming, not just joining — likely dropping the violin plot (redundant with
boxplot), shortening the density section, and moving the figure-formatting advice into
the reporting box.

Conversely sessions 8 (correlation + regression) and 9 are thin and get the additions
in §5.

### 3.2. The five-category rule and the wellbeing battery

You are right that the CES-D items break the rule. Each is 1–4.

There is a defensible counter-argument — the rule governs treating a *single* item as
continuous, whereas a factor score from eight items is continuous by construction — but
consistency in an introductory course matters more than that nuance, and mixed messages
are worse than a slightly conservative rule.

**Proposed replacement: the institutional trust battery.** Seven items, all 0–10:

```
trstprl  trstlgl  trstplc  trstplt  trstprt  trstep  trstun
```

Verified in the data: all 11 categories, loadings 0,59–0,87, `Proportion Var` 0,61,
missingness 12–125. Substantively it is a better fit for a political science course than
a depression scale.

**Decided: the reverse-coding lesson is dropped.** The trust items all run the same
direction and the detect → fix → verify sequence goes with the CES-D battery.

One thing I will keep, because dropping it entirely would make the code look arbitrary:
where a variable actually is reversed — `polintr` runs 1 = very interested to 4 = not at
all — the script still flips it, with **one sentence** saying why. That is a code comment
and a passing note, not a teaching sequence. Without it a student reading
`5 - as.numeric(polintr)` has no way to know what it is for.

**Other variables checked against the rule:**

| Muutuja | Kategooriaid | Otsus |
|---|---|---|
| `vasak_parem`, `usaldus_pol`, `rahulolu_dem` | 11 | pidev, korras |
| `sissetulek` | 10 | pidev, korras |
| `haridus` | 7 | pidev, korras |
| `tervis` | 5 | **võib olla pidev** — praegu faktor, muuta |
| `huvi_pol` | 4 | **ei tohi olla pidev** — praegu kasutatakse mudelites pidevana |

**Decided: `huvi_pol` collapses to binary** — huvitatud / ei ole huvitatud. ESS
categories 1–2 ("very" and "quite" interested) become 1, categories 3–4 become 0.

This keeps the logistic regression's strongest and most interesting predictor, gives a
single interpretable coefficient, and reuses the binary-predictor machinery already
taught in session 9. It loses the gradient across four categories, which is the price of
consistency with the rule.

Done in `ettevalmistus.R`, so the collapse is visible where all the other recoding
happens rather than buried in a model formula.

### 3.3. Shorter category labels

Party names break table and figure layout. To be shortened in `ettevalmistus.R`:

| Praegu | Uus |
|---|---|
| Eesti Reformierakond | Reform |
| Eesti Konservatiivne Rahvaerakond | EKRE |
| Sotsiaaldemokraatlik Erakond | SDE |
| Eesti Keskerakond | Kesk |
| Isamaa Erakond | Isamaa |
| Eesti 200 | E200 |
| Muu erakond | Muu |

Same for `elukoht` (`suurlinna äärelinn` → `äärelinn`, `talu või maakodu` → `maakodu`).

---

## 4. Global changes across all files

| # | Muudatus | Ulatus |
|---|---|---|
| G1 | **Kodeering korda** — `Encoding()` selgesõnaliselt, lokaat projektis | `ettevalmistus.R`, `_quarto.yml` |
| G2 | **Kõik arvud tekstis inline-koodiks** | kõik peatükid |
| G3 | **Proosa ilma fikseeritud reamurdmiseta** | kõik `.qmd` |
| G4 | **Lingid uues aknas** | `_quarto.yml` (globaalne filter) |
| G5 | **Kastides must tekst** | `styles.css` |
| G6 | **Külgriba: "Praktikum" pealkirjadest välja** | kõik peatükid + `_quarto.yml` |
| G7 | **"Author"/"Published" eesti keelde** | `_quarto.yml` (`language:`) |
| G8 | **Esmakasutuse reegel ka argumentidele ja süntaksile** | kõik peatükid |
| G9 | **Pesastatud tegevused lahti** | kõik peatükid |
| G10 | **Muutuja skaala ja jaotus enne mudelisse panekut** | 6–11 |
| G11 | **Arutelu küsimused** | kõik peatükid |
| G12 | **Iseseisvad harjutused — ainult ülesanne, lahendusteta** | kõik peatükid |
| G13 | **Peatükid ümber nummerdatud 1–11** | failinimed, `_quarto.yml`, ristviited |

G8 needs the checker extended — it currently catches functions but not arguments or
indexing syntax. I will add argument detection to `kontrolli-esmakasutus.py`.

---

## 5. Per-chapter work

### index
* AI disclosure note — model, and what it did (drafting, restructuring, code, checking).
* Section listing freely available surveys for social scientists: ESS, ISSP, EVS/WVS,
  Eurobarometer, ESS-adjacent Estonian sources (Eesti Rahvusraamatukogu, Statistikaamet),
  CSES, Comparative Political Data Set. With links and one line each on what they cover.
* Updated textbook list — see question 4.

### 1 — R ja RStudio
* Expand the RStudio project explanation substantially: what it is, what problem it
  solves, what the `.Rproj` file does, why paths then work everywhere.

### 2 — Andmete laadimine
* Explain every first-use argument: `sep`, `header`, `row.names`, `col_select`.
* Explain `dim()` output order at first use.
* Explain `ee[, c("idno", "agea")]` column-selection syntax.

### 3 — Ettevalmistus I
* Rewrite the two unclear sentences about `filter()`/`select()` and quoting. The point is
  that dplyr uses *tidy evaluation* — bare variable names work because the function looks
  them up inside the data frame. Say that plainly.

### 4 — Ettevalmistus II
* Explain `mutate()` at first use here (it is used in session 3, so verify the register).
* Explain the `ee <- ee |>` pattern — overwriting an object with its own modified version.
* **Drop the correlation matrix computation.** Replace with one sentence that the items
  were checked and are in the same direction; return to it properly in session 8.
* **Shorten the factor analysis drastically** — show `factanal()` and the scores, mention
  everything else in words.
* **Replace the CES-D battery** with institutional trust (§3.2).
* Un-nest all compound calls.
* Consider whether the different missing-value types need distinguishing — see question 3.

### 5 — Kirjeldamine ja visualiseerimine (merged)
* Fix label encoding (follows from G1).
* Explain `tibble` at first appearance.
* **Add a descriptive statistics table** with a function that handles both continuous and
  categorical variables — `datasummary_skim()` from `modelsummary` is the natural choice
  since the package is already in use.
* Add `geom_jitter()` to the overplotting example.
* Reporting box: add figure-formatting failures — text too small, non-informative
  elements, duplicated information. Text on figures should be near body-text size. Mention
  Tufte's data-ink principle.
* Trim to fit 1.5 hours.

### 6 — Valim ja ebakindlus
* **Estonian-language versions of the normal-distribution and t-distribution figures**,
  generated in R, code hidden, figures only.
* Note on degrees of freedom as "how much free information is in the data" — depends on
  case count and on what has already been computed from the data.
* Verify the simulation/formula agreement still holds after the data rebuild.

### 7 — Hüpoteeside testimine
* **Explain the p-value before any test is run.** It is the number decisions are made on
  and it currently appears mid-derivation.
* **Fix the p-value formula** (§1.1).
* **Rewrite both t-test examples against actual output** (§1.2), swapping which one
  illustrates significance.

### 8 — Korrelatsioon ja regressioon
* Split covariance → correlation into simpler/harder; formulas only in the harder track.
* Fix the "poole tugevam" note.
* **Section is thin — additions proposed:** standardised coefficients (as you asked);
  Spearman correlation and when to prefer it; what a residual is and a residual plot;
  the effect of outliers on *r*, shown by example; non-linearity as a warning case.
  See question 5.

### 9 — Mitmene regressioon
* Fix `mudel6` (follows from G1) and remove the duplicated `el_vaikelinn` term.
* Fix the `predict()` interpretation and its phrasing.
* Shorter party labels (§3.3) fix the output-width problem.
* Check `summary()` output width after relabelling.

### 10 — Tulemuste esitamine
* Tighten table row spacing via CSS.
* **Replace `plot()` on ggeffects objects with a hand-built ggplot** from the predicted
  values, so the mechanics are visible.

### 11 — Logistiline regressioon
* **Fix the out-of-range claim** using `huvi_pol` (§1.4).
* Expand the simpler track: describe the move to the logit scale in words, no formulas
  (principle 4.3).
* Expand the odds-ratio explanation.
* Compute sensitivity and specificity for the improved model too.
* **Rebuild the results table**: do not put the same model in twice. Use `exponentiate`
  on a single column, or two genuinely different models. Add pseudo R², sensitivity and
  specificity via `glance_custom.glm` — tested and working:

```
| Num.Obs.       | 1164  |
| McFadden       | 0.146 |
| Sensitiivsus   | 0.949 |
| Spetsiifilisus | 0.312 |
```

---

## 5a. Exercises and discussion questions

**Exercises: task only, no solutions in the materials.** Solutions stay with you for the
seminar. Two or three per chapter, at the end, in a clearly marked block.

Each exercise must be doable using **only** what the chapter and its predecessors have
covered — I will check this against the function register, the same way first use is
checked.

**Discussion questions** are placed where an output is shown but deliberately not
explained, and where the answer should already be derivable. Visually distinct from
exercises so the two are not confused.

## 5b. Textbook additions

To propose alongside the existing three, all freely available online:

* **Wickham, Çetinkaya-Rundel & Grolemund, *R for Data Science* (2nd ed.)** — the
  standard reference for the dplyr/ggplot idiom this course now uses.
* **Ismay & Kim, *Statistical Inference via Data Science (ModernDive)*** — teaches
  inference through simulation first, exactly the approach in session 6.
* **Navarro, *Learning Statistics with R*** — closest in level and tone to Gravetter &
  Wallnau, but R-based and free.

You decide which stay. The existing three remain listed either way.

## 6. Order of work

1. **Data layer first** — encoding fix, short labels, trust battery, `tervis` continuous,
   `huvi_pol` handling. Rebuild `ess11_ee_clean.rdata`. Everything downstream depends on
   this.
2. **Global infrastructure** — `_quarto.yml` (language, link targets, numbering),
   `styles.css` (black text, table spacing), renumber files 1–11.
3. **Extend the checker** to catch arguments and syntax, not just functions.
4. **Fix the confirmed errors** — sessions 7, 9, 11.
5. **Merge 5 + 7** and trim to length.
6. **Content additions** chapter by chapter, in order.
7. **Add exercises and discussion questions** as a pass across all chapters.
8. **Convert reported numbers to inline code** as a pass across all chapters.
9. **Full verification** per the checklist in the guidelines file.

---

# TEHTUD (implementeerimise kokkuvõte)

## Parandatud vead

| Viga | Oli | Nüüd |
|---|---|---|
| P-väärtuse valem | `pt(t)*2` → **1,9999** (võimatu) | `2*(1-pt(|t|))` → 0,000133, klapib `t.test()`-ga |
| T-testi näited | kaks näidet vastupidi | `vasak_parem` p = 0,0022 (oluline), `ranne` p = 0,86 (ei ole) |
| Kodeering | `.rdata` C-lokaadis → katkised võrdlused | `.Rprofile` + `enc2utf8()`, lokaat `et_EE.UTF-8` |
| `mudel6` NA-koefitsiendid | 3 NA-d | kõik neli hinnatud |
| Lineaarse mudeli ennustus | väide vale (max 0,88) | `huvi_pol + vanus + haridus`, max 1,041, **35 juhtumit üle 1** |
| `predict()` tõlgendus | arusaamatu sõnastus | tabel + selgitus, arvud inline-koodiga |
| "poole tugevam" | vale sõnastus | ümber kirjutatud, R-ruudu kaudu |

## Struktuur

11 praktikumi, nummerdatud järjest. Vana 5+7 ühendatud (violin alles, midagi ei kärbitud).

## Andmekiht

* `.Rprofile` seab lokaadi — parandab nii kuva kui **stringide võrdlemise**
* Lühikesed sildid: Reform, Isamaa, E200, SDE, EKRE, Kesk, Muu; äärelinn, väikelinn, maakodu
* CES-D asendatud **institutsionaalse usalduse patareiga** (7 küsimust, kõik 0–10)
* `tervis` pidevaks (5 kategooriat), `huvi_pol` binaarseks (4 oli liiga vähe)
* Pööramise õppetund eemaldatud, alles üks lause seal, kus muutuja tegelikult pööratakse

## Läbivad muudatused

* Esmakasutuse kontroll laiendatud **argumentidele ja süntaksile**; `echo: false` plokid vahele
* Kõik pesastatud kutsed lahti kirjutatud
* Arvud tekstis inline-koodiks (7, 9, 11)
* Eestikeelne liides (Autor, Avaldatud, Otsi)
* Välised lingid uues aknas — Lua filter `_extensions/valised-lingid.lua`
  (Quarto `link-external-newwindow` **ei tööta** versioonis 1.8.26, kontrollitud)
* Tsitaadiplokkides must tekst (`!important`, sest cosmo teema kirjutab üle)
* Tabelite reavahe kokku surutud
* **15 harjutust ja 6 arutelukohta** kõikides peatükkides

## Uus sisu

* Peatükk 5: `datasummary_skim()` tabelid, `geom_jitter()`, Tufte ja teksti suurus
* Peatükk 6: **eestikeelsed normaaljaotuse ja t-jaotuse joonised** (R-is, kood peidetud), vabadusastmete selgitus
* Peatükk 7: p-väärtus seletatud **enne** teste, koos "mida ta EI ole"
* Peatükk 8: kovariatsioon kahel rajal, **standardiseeritud koefitsiendid**
* Peatükk 10: `ggeffects` → käsitsi ggplot (`geom_ribbon`, `geom_errorbar`)
* Peatükk 11: logit sõnadega ilma valemiteta, šansside suhe pikemalt, `sobivus()` funktsioon,
  **pseudo R-ruut + sensitiivsus + spetsiifilisus automaatselt tabelis** (`glance_custom.glm`)
* index: 12 tasuta küsitlusuuringu loetelu, 2 uut õpikut, **tehisintellekti kasutamise märkus**

## Lahtised otsad

1. **Otsing** vajab veebiserverit — töötab pärast hostimist või `quarto preview`.
2. **Maht.** Peatükk 5 on nüüd 32 koodiplokki (suurim). Vajab seminaris ajalist proovi.
3. **Vana `figures/` kaust** — `Empirical_Rule.png` ja t-jaotuse pilt ei ole enam kasutusel.
4. **GitHubi repo** loomata.

---

## ESS-i litsents — lahendatud

Kontrollisin ESS-i tingimused üle. **Probleemi ei ole** — varem sai see kolm korda
lahtise küsimusena üles märgitud, kuid alusetult.

**ESS-i andmed on CC BY-NC-SA 4.0**, dokumentatsioon CC BY-SA 4.0
([ESS-i teade](https://www.europeansocialsurvey.org/contact/disclaimer)). CC BY-NC-SA
annab otsesõnu õiguse materjali "kopeerida ja edasi jagada ükskõik millises vormis" ning
seda kohandada. Edasijagamine ei vaja eraldi luba.

Kolm tingimust, mis kehtivad:

| Tingimus | Olukord |
|---|---|
| **BY** viitamine | täidetud — viide `index.qmd`-s, `LITSENTS.md`-s ja `data/README.md`-s |
| **NC** mittetulunduslik | õppetöö vastab; GitHubis hoidmine ei riku (piirang käib kasutaja, mitte platvormi kohta) |
| **SA** samadel tingimustel | **mõjutab tuletatud andmefaile** — mõlemad `data/` failid on nüüd selgelt CC BY-NC-SA 4.0 all |

**Kas SA laieneb ka õppematerjalidele?** Õiguslikult vaieldav — tekst ja kood on
iseseisev teos, mitte andmestiku kohandus, kuigi andmetest arvutatud tabelite ja
jooniste puhul on piir hägusam. Praktiline lahendus, mida ka mujal kasutatakse:
**andmefailid saavad selge CC BY-NC-SA 4.0 märgise, materjalid oma litsentsi.** Nii ei
teki küsimust, millele oleks vaja vastata.

Lisatud:

* `LITSENTS.md` — mõlema poole litsentsid, tehtud muudatuste loetelu (CC nõuab), ja
  valikute tabel materjalide litsentsi jaoks
* `data/README.md` — lühiversioon andmekausta juures
* üks lõik `index.qmd`-s jaotise "Andmed" all

**Materjalide litsents on otsustatud: CC BY 4.0.** Kasutamine, jagamine ja kohandamine
on lubatud, ainus tingimus on viitamine autorile. `LITSENTS.md` §2 ja `index.qmd`
jaotis "Materjalide kasutamine" on vastavalt kirjutatud.

**Mitteõiguslik kaalutlus, mis jääb kehtima.** ESS palub kasutajatel registreeruda ja
tema rahastuse põhjendus tugineb muuhulgas kasutajate arvule. Kui fail on materjalidega
kaasas, siis ~40 tudengit aastas nendesse numbritesse ei jõua. `LITSENTS.md` soovitab
oma töö jaoks andmed ise alla laadida.
