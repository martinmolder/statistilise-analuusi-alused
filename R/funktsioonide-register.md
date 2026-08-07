# Funktsioonide ja operaatorite register

Töövahend materjalide kirjutamiseks, mitte tudengitele mõeldud materjal.

**Reegel:** iga funktsioon, operaator või mõiste seletatakse lahti seal, kus teda
ESIMEST KORDA kasutatakse — lühidalt, vahetult enne kasutamist. Hiljem võib talle
viidata ilma uuesti seletamata.

See register ütleb, kus miski esimest korda esineb. Enne uue peatüki kirjutamist vaata
siit, mis on juba seletatud; pärast kirjutamist lisa siia see, mis uut sisse tuli.

Legend: **[U]** = uus selles praktikumis, seletus vajalik · **[V]** = varem seletatud ·
**[E]** = ettepoole viitav, kasutatakse enne kui õpetatakse

---

## Praktikum 1 — R-i alused

Aritmeetika `+ - * / ^` · `<-` · `#` · `c()` · `log()` · `sum()` · `mean()` ·
`round()` · `length()` · `class()` · `factor()` · `levels()` · `data.frame()` ·
`names()` · `list()` · `$` · `[ ]` · `[i, j]` · `[[ ]]` · `NA` · `TRUE` / `FALSE` ·
`na.omit()` · argument `na.rm` · argument `base` · `install.packages()` · `library()` · `help()` / `?`

> Jutumärkide reegel: tekst on jutumärkides, objektide ja funktsioonide nimed ilma.

## Praktikum 2 — Andmete laadimine

`read_sav()` · `write_sav()` · `read.csv()` · `write.csv()` · `load()` · `save()` ·
`head()` · `dim()` · `nrow()` · `ncol()` · `rm()` · `str()` · `summary()` · `table()`

> `foreign::read.spss()` mainitakse ainult möödaminnes kui vanem alternatiiv.

## Praktikum 3 — Andmete ettevalmistus I

**[U]** `|>` (toru) · `filter()` · `select()` · `mutate()` · `group_by()` ·
`summarise()` · `n()` · `%in%` · `is.na()` · `sapply()` · `function(x)` (anonüümne
funktsioon) · `as_factor()` · `zap_labels()` · `attr()` · `as.numeric()` ·
`as.character()` · `weighted.mean()` · `cbind()` · `coef()` · `round()`

Võrdlusoperaatorid `== != < > <= >=` · `&` · `|` · `which()`

Argumendid: `col_select`, `user_na`, `useNA`, `use`

**[E]** `lm()` · `~` · `coef()` — kasutame kaaluosas näitena, õpetame praktikumis 10–11.
Öelda tudengile otse: praegu ei ole vaja aru saada, kuidas mudel töötab, vaata ainult,
kui vähe arvud muutuvad.

**Mõisted:** `haven_labelled` · puuduv väärtus · kasutaja määratud puuduv kood
(7/8/9, 77/88/99) · disainikaal · poststratifitseerimiskaal · straatum

## Praktikum 4 — Andmete ettevalmistus II

**[U]** `case_when()` · `if_else()` · `NA_real_` · `NA_character_` · `cor()` · `!` ·
`complete.cases()` · `factanal()` · `lapply()` · `as.data.frame()` · `cbind()` ·
`droplevels()` · `levels() <-` · `sort()` · `if () { }` · unaarne miinus

Argumendid: `decreasing = TRUE`, `factors`, `scores = "regression"`, `levels`

**[E]** `cor()` — kasutame suuna kontrollimiseks, õpetame praktikumis 10.
Tudengile piisab: positiivne = sama suund, negatiivne = vastupidine suund.

**Mõisted:** indeks · pööratud küsimus · faktor (faktoranalüüsis) · faktorlaadung ·
faktorskoor · referentskategooria

## Praktikum 5 — Kirjeldav statistika

**[U]** `prop.table()` · `median()` · `sd()` · `var()` · `quantile()` · argument `margin`

## Praktikum 5b — Visualiseerimine (sama peatükk kui 5)

**[U]** `ggplot()` · `aes()` · `geom_bar()` · `geom_histogram()` · `geom_density()` ·
`geom_boxplot()` · `geom_violin()` · `geom_point()` · `labs()` · `theme_bw()` ·
`theme()` · `element_text()` · `scale_fill_manual()` · `scale_x_discrete()` ·
`ggsave()` · `geom_jitter()` · `+` ggplot-i mõttes

Argumendid: `bins`, `position`, `values`, `angle`, `hjust`, `axis.text.x`

## Praktikum 6 — Valim ja ebakindlus

**[U]** `set.seed()` · `sample()` · `replicate()` · `geom_vline()` · `rep()` ·
`pnorm()` · `qnorm()` · `qt()` · `as.vector()` · `range()` · `max()`

Argumendid: `lower.tail`, `df`, `each`, `xintercept`

**Mõisted:** valim · populatsioon · valimijaotus · standardviga · usaldusvahemik ·
vabadusastmed · normaaljaotus · t-jaotus · z-skoor

> Simulatsioon toob sisse juhuarvud. `set.seed()` on hädavajalik — ilma selleta saab
> igaüks erineva tulemuse ja materjalis olevad arvud ei klapi.

## Praktikum 7 — Hüpoteeside testimine

**[U]** `t.test()` · `pt()` · `rnorm()` · argumendid `mu`, `var.equal`

**Mõisted:** nullhüpotees · alternatiivne hüpotees · p-väärtus · statistiline olulisus ·
sisuline olulisus

## Praktikum 8 — Korrelatsioon ja lihtne regressioon

**[U]** `cor.test()` · `lm()` (nüüd päriselt) · `~` (nüüd päriselt) · `summary()` mudeli
peal · `stat_smooth()` · `geom_jitter()`

**Mõisted:** kovariatsioon · korrelatsioonikordaja · determinatsioonikordaja (R-ruut) ·
vabaliige · regressioonikordaja · jääk

## Praktikum 9 — Mitmene regressioon

**[U]** `predict()` · `nobs()` · `confint()` · `if_else()` mudelites

**Mõisted:** kontrollimine teiste muutujate suhtes · kohandatud R-ruut ·
multikollineaarsus (mainida)

## Praktikum 10 — Tulemuste esitamine

**[U]** `modelsummary()` · `predict_response()` · `as.data.frame()` mudeliväljundil ·
`geom_ribbon()` · `geom_errorbar()`

Argumendid: `output`, `stars`, `coef_map`, `gof_map`, `terms`, `ymin`, `ymax`

## Praktikum 11 — Logistiline regressioon

**[U]** `glm()` · `exp()` · `fitted()` · `pR2()` · `seq()` · argument `family`, `exponentiate`

**Mõisted:** šansid · šansside suhe · logit · pseudo R-ruut · sensitiivsus ·
spetsiifilisus · klassifikatsioonitabel

---

## Kontroll

Enne peatüki lõpetamist jooksuta:

```bash
python3 R/kontrolli-esmakasutus.py <fail.qmd>
```

See leiab funktsioonid, mida kasutatakse enne, kui neid on seletatud. Skript ei tea,
mis on eelmistes praktikumides juba seletatud — selleks on käesolev register.
