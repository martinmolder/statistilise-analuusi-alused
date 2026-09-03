# Funktsioonide ja operaatorite register

Töövahend materjalide kirjutamiseks, mitte tudengitele mõeldud materjal.

**Reegel:** iga funktsioon, operaator või mõiste seletatakse lahti seal, kus teda
ESIMEST KORDA kasutatakse — lühidalt, vahetult enne kasutamist. Hiljem võib talle
viidata ilma uuesti seletamata.

See register ütleb, kus miski esimest korda esineb. Enne uue peatüki kirjutamist vaata
siit, mis on juba seletatud; pärast kirjutamist lisa siia see, mis uut sisse tuli.

Legend: **[U]** = uus selles praktikumis, seletus vajalik · **[E]** = ettepoole viitav

---

## Praktikum 1 — R ja RStudio

Aritmeetika `+ - * / ^` · `<-` · `#` · `c()` · `log()` · `sum()` · `mean()` ·
`round()` · `length()` · `class()` · `factor()` · `levels()` · `data.frame()` ·
`names()` · `list()` · `$` · `[ ]` · `[i, j]` · `[[ ]]` · `NA` · `TRUE` / `FALSE` ·
`na.omit()` · argument `na.rm` · argument `base` · `install.packages()` · `library()` ·
`help()` / `?`

> Jutumärkide reegel: tekst on jutumärkides, objektide ja funktsioonide nimed ilma.

## Praktikum 2 — Andmete laadimine

`read_sav()` · `write_sav()` · `read_dta()` · `read.csv()` · `write.csv()` · `load()` ·
`save()` · `head()` · `dim()` · `nrow()` · `ncol()` · `rm()` · `str()` · `summary()` ·
`table()` · `list.files()`

Argumendid: `sep`, `header`, `row.names`

Süntaks: `andmed[, c("a","b")]` veergude valimine nimede järgi

> `foreign::read.spss()` mainitakse ainult möödaminnes kui vanem alternatiiv.

## Praktikum 3 — Kirjeldamine ja visualiseerimine

**[U]** `|>` (toru) · `prop.table()` · `median()` · `sd()` · `var()` · `quantile()` ·
`group_by()` · `summarise()` · `n()` · `is.na()` · `!` · `weighted.mean()` ·
`datasummary_skim()`

**[U] ggplot:** `ggplot()` · `aes()` · `geom_bar()` · `geom_histogram()` ·
`geom_density()` · `geom_boxplot()` · `geom_violin()` · `geom_point()` ·
`geom_jitter()` · `labs()` · `theme_bw()` · `theme()` · `element_text()` ·
`scale_fill_manual()` · `scale_x_discrete()` · `ggsave()` · `+` ggplot-i mõttes

Argumendid: `margin`, `bins`, `position`, `values`, `angle`, `hjust`, `axis.text.x`,
`type`, `output`

**Mõisted:** kirjeldav ja järeldav statistika · mood · mediaan · standardhälve ·
dispersioon · kvartiil · disainikaal · poststratifitseerimiskaal

> Faktorskoorid `ranne` ja `usaldus` on siin juba olemas, kuid neid EI ehitata —
> ainult seletatakse, mida nad tähendavad, ja viidatakse praktikumile 5.

## Praktikum 4 — Andmete ettevalmistus I

**[U]** `filter()` · `select()` · `mutate()` · `%in%` · `sapply()` ·
`function(x)` (anonüümne funktsioon) · `as_factor()` · `zap_labels()` · `attr()` ·
`as.numeric()` · `as.character()`

Võrdlusoperaatorid `== != < > <= >=` · `&` · `|` · `which()`

Argumendid: `col_select`, `user_na`, `useNA`

**Mõisted:** `haven_labelled` · puuduv väärtus · kasutaja määratud puuduv kood
(7/8/9, 77/88/99)

## Praktikum 5 — Andmete ettevalmistus II

**[U]** `case_when()` · `if_else()` · `cor()` · `complete.cases()` · `factanal()` ·
`lapply()` · `as.data.frame()` · `droplevels()` · `levels() <-` · `sort()` ·
`if () { }` · unaarne miinus · `enc2utf8()`

Argumendid: `decreasing`, `factors`, `scores`, `levels`, `use`, `.default`

**[E]** `cor()` — kasutame faktori suuna kontrollimiseks, õpetame praktikumis 8.
Tudengile piisab: positiivne = sama suund, negatiivne = vastupidine suund.

**Mõisted:** indeks · faktor (faktoranalüüsis) · faktorlaadung · faktorskoor ·
referentskategooria

## Praktikum 6 — Valim, ebakindlus ja hüpoteeside testimine

**[U]** `set.seed()` · `sample()` · `replicate()` · `geom_vline()` · `rep()` ·
`pnorm()` · `qnorm()` · `qt()` · `as.vector()` · `range()` · `max()` ·
`geom_area()` · `annotate()` · `scale_x_continuous()` · `element_blank()` ·
`rbind()` · `dnorm()` · `dt()` · `scale_color_manual()` · `scale_linetype_manual()`

Argumendid: `replace`, `lower.tail`, `each`, `xintercept`

**Mõisted:** valim · populatsioon · valimijaotus · standardviga · usaldusvahemik ·
vabadusastmed · normaaljaotus · t-jaotus · z-skoor · nullhüpotees ·
alternatiivne hüpotees · p-väärtus · statistiline olulisus

> Simulatsioon toob sisse juhuarvud. `set.seed()` on hädavajalik — ilma selleta saab
> igaüks erineva tulemuse ja materjalis olevad arvud ei klapi.

## Praktikum 7 — Keskmiste võrdlemine

**[U]** `t.test()` · `pt()` · `~` (mudeli valem, esimest korda) · `rnorm()` ·
`signif()`

Argumendid: `mu`, `df`, `var.equal`

**Mõisted:** ühe grupi t-test · kahe grupi t-test · sisuline olulisus

## Praktikum 8 — Korrelatsioon

**[U]** `cor.test()` · `stat_smooth()` (hiljem regressioonis)

**Mõisted:** kovariatsioon · korrelatsioonikordaja · determinatsioonikordaja (R-ruut)

## Praktikum 9 — Regressioon: baasmudel

**[U]** `lm()` · `summary()` mudeli peal · `stat_smooth()` · `coef()` · `cbind()`

**Mõisted:** vabaliige · regressioonikordaja · jääk · kohandatud R-ruut ·
mõõtmise kvaliteet

## Praktikum 10 — Mitmene regressioon

**[U]** `predict()` · `nobs()` · `confint()`

Argument: `newdata`, `weights`

**Mõisted:** kontrollimine teiste muutujate suhtes · multikollineaarsus (mainida)

## Praktikum 11 — Tulemuste esitamine

**[U]** `modelsummary()` · `predict_response()` · `geom_ribbon()` · `geom_errorbar()`

Argumendid: `stars`, `coef_map`, `gof_map`, `terms`, `ymin`, `ymax`

## Praktikum 12 — Logistiline regressioon

**[U]** `glm()` · `exp()` · `fitted()` · `pR2()` · `seq()` · `geom_line()` ·
`ylim()` · `sprintf()` · `registerS3method()` · `suppressMessages()`

Argumendid: `family`, `exponentiate`, `length.out`

**Mõisted:** šansid · šansside suhe · logit · pseudo R-ruut · sensitiivsus ·
spetsiifilisus · klassifikatsioonitabel

---

## Kontroll

Enne peatüki lõpetamist jooksuta:

```bash
python3 R/kontrolli-esmakasutus.py <fail.qmd>
```

See leiab funktsioonid ja argumendid, mida kasutatakse enne, kui neid on seletatud.
Skript loeb varasemate praktikumide sisu käesolevast registrist, seega **register peab
olema ajakohane**. Peidetud plokid (`echo: false`, `include: false`) jäetakse vahele.
