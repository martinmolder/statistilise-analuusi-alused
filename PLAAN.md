# Statistilise analüüsi alused — 2026 sügis
## Revision plan (rev. 2, incorporating Martin's comments)

---

## 1. Data: resolved

Three files are now in the working folder. **The one to build the course on is:**

**`ESS11e04_2-subset/ESS11e04_2-subset.sav`** — ESS11 edition 4.2, proddate 02.07.2026,
50 116 rows, 665 variables, **30 countries including EE**.

- **Estonia n = 1 293**
- Party choice variable: **`prtvtiee`**
- Weights present: `dweight`, `pspwght`, `pweight`, `anweight`, plus `prob`, `stratum`, `psu`

Filtered to Estonia and saved, the file is **1.81 MB as `.sav` / 0.48 MB as `.rdata`** with all
665 variables retained. Small enough to host anywhere — see §7.

**Decided:** the course base is ESS11 e04.2 filtered to Estonia — one round, one country, 665
variables. The filtering step is itself a session-3 exercise.

Also present, not used as the base:

- `ESS11/ESS11.sav` — edition 3.0, **no Estonia**. Superseded; archive so it cannot be loaded
  by mistake.
- `ESS country data - EE/ESS country data - EE.sav` — Estonia, **rounds 2–11 cumulative**,
  18 149 rows × 2 542 variables. Kept in reserve. If an over-time example is ever wanted
  ("has trust in politicians changed since 2004?"), this is where it comes from — but it stays
  out of the main line to keep every cleaning step free of a round dimension.

---

## 2. Session structure — 14 slots, 12 teaching sessions

Sessions **6 and 14** are reserved for other activities. Data preparation is absorbed into the
existing count by the two merges Martin proposed: correlation + bivariate regression into one
session, and logistic regression down from two sessions to one. That frees exactly the two slots
data preparation needs.

| # | Session | Status |
|---|---|---|
| 1 | R and RStudio; objects, vectors, data frames, lists | Refresh |
| 2 | Getting data in: formats, `haven`, the ESS file, reading a codebook | Rewritten |
| 3 | **Data preparation I: from raw file to analysable data** | **New** |
| 4 | **Data preparation II: recoding and building variables** | **New** |
| 5 | Descriptive statistics | Rewritten on ESS11 EE |
| 6 | *(reserved — other activities)* | — |
| 7 | Visualisation (ggplot2) | Own heading at last |
| 8 | **Sample, uncertainty, SD → SE → CI** — two-track | **Restructured** (§3) |
| 9 | **Hypothesis testing and t-tests** — two-track | **Restructured** (§3) |
| 10 | Correlation **and** bivariate regression | **Merged** |
| 11 | Multiple regression | Own heading |
| 12 | Presenting results: tables and figures | Unfinished sections completed |
| 13 | Logistic regression | **Compressed from 2 sessions to 1** |
| 14 | *(reserved — other activities)* | — |

Net: 12 teaching sessions in, 12 out. Same topic range. Data preparation goes from half a
session to two full sessions plus a running thread.

**Note on the session 13 compression.** Cutting logistic regression from two sessions to one
means the logit → odds → probability derivation (old l. 1831–1907) has to become more compact.
Recommendation: keep the conceptual chain but move the manual `log()`/`exp()` arithmetic drills
into the "deeper" track described in §3, so the core session stays within one slot while the
detail remains available to students who want it.

---

## 3. Two-track treatment of the hard material (sessions 8, 9, 13)

Martin's point: Praktikum 5 is the strongest section but the hardest for students.

**Mechanism: Quarto tabsets.** Genuinely side by side, one click apart, no duplicate navigation:

```markdown
::: {.panel-tabset}
## Lihtsam seletus
(intuition, simulation, pictures — no algebra)

## Täpsem seletus
(the existing derivation with formulas)
:::
```

Applied consistently, with the same two tab labels every time, so students learn the convention
once and can pick a lane and stay in it.

**What goes in each track.** The easy track should not be a watered-down version of the algebra
— it should be a genuinely different route to the same idea:

- **Easy track = simulation** (decided). Draw 1 000 random samples of n = 100 from the Estonian
  data, compute the mean each time, plot the distribution of those means. Students *see* the
  sampling distribution appear, see it narrow as n grows, and see that about 95% of it falls
  within a certain range. No formula required.

  Students **run** the simulation rather than write it — roughly 15 lines, supplied in the
  materials, with the sample size as the one thing they change so they can watch the
  distribution tighten. This is the only genuinely new technique added to the course, and it
  earns its place: it is the modern standard way to teach sampling distributions, and it makes
  the hardest idea in the course visible instead of asserted.
- **Hard track = the existing derivation.** Variance → SD → the $n-1$ correction → SE → t-
  distribution → CI, exactly as currently written. The formula is then revealed as *predicting*
  what the simulation just produced.

This is a stronger version of the current material rather than a reduction of it: the simulation
gives the concept, the algebra explains why it works, and the two tracks visibly agree.

Same treatment for session 13: easy track = "positive coefficient means the probability goes up,
read the predicted-probability plot"; hard track = the logit/odds/exponentiation chain.

---

## 4. Where the example variables come from — factor analysis, minimally

Martin's constraint: surveys have no truly continuous variables, so the analysis variables have
to be built from several items. A simple mean is not a defensible way to aggregate — it assumes
every item measures the thing equally well. So **factor analysis, with minimal explanation of
the method but with its output shown.**

What students are told, and no more:

- if several questions are correlated, there is probably one common thing behind them;
- **loadings** show how well each question measures it;
- **factor scores** are each respondent's value on that common thing — this is the new variable;
- the method itself belongs to a different course.

`factanal(x, factors = 1, scores = "regression")`. The output shown is the loadings table and
`Proportion Var`.

Two practical points that must not be skipped, because both bite silently:

- `factanal()` uses complete cases only, so scores cannot simply be assigned as a column —
  `complete.cases()` plus filling an empty variable is required, or the scores land on the wrong
  respondents;
- the **direction of a factor is mathematically arbitrary**, so it has to be checked against a
  known item and flipped if necessary.

The unavoidable sequencing cost: session 4 uses correlation (as the direction diagnostic) before
correlation is formally taught in session 10. Handled with an explicit forward reference — at
this point students need only "positive = same direction, negative = opposite".

Two cases, both verified in the Estonian data:

**(a) Immigration attitudes — 3 items, straightforward.** `imbgeco`, `imueclt`, `imwbcnt`, each
0–10. Inter-item correlations in Estonia are 0.55, 0.61, 0.68 — all positive, all same
direction. Loadings 0.71 / 0.78 / 0.87, `Proportion Var` 0.62. A clean first case. Built in
session 4, carries through sessions 10–11.

**(b) CES-D 8-item wellbeing scale — contains reverse-coded items.** `fltdpr`, `flteeff`,
`slprl`, `wrhpp`, `fltlnl`, `enjlf`, `fltsd`, `cldgng`.

This is the best teaching case in the dataset. Correlations with `fltdpr` in the Estonian data:

```
fltdpr flteeff  slprl   wrhpp fltlnl   enjlf  fltsd cldgng
 1.000   0.360  0.365  -0.354  0.343  -0.381  0.519  0.447
```

`wrhpp` ("were happy") and `enjlf` ("enjoyed life") come out **negative** — the reversal is
visible in the correlation matrix before anything is explained. So the session runs:
**detect → fix → verify.** Students find the problem themselves, reverse the two items (5 − x),
re-run the matrix, and watch all correlations turn positive. Only then does the factor analysis
run, and its loadings come out all positive (0.47–0.71, `Proportion Var` 0.34) — a second
confirmation that the fix worked.

The factor analysis reinforces rather than replaces this lesson: run on the *raw* items it
produces loadings of −0.56 and −0.60 on the two reversed questions, so the problem is visible in
both diagnostics.

---

## 5. Missing values — a real example, not a manufactured one

The old materials *invented* a 999 code in order to have something to recode (l. 776–789). Not
needed any more. Three genuinely real cases, all verified in the Estonian data:

**(a) A code that looks valid and is not missing-declared.** `vote` has
`3 = "Not eligible to vote"`, **n = 111 in Estonia**. Across the entire Estonian dataset this is
the *only* such code — I checked every labelled variable. It arrives in R as a real number 3.
Folding it into "did not vote" would be wrong. It must become `NA`, and the 1/2 coding must be
flipped to 0/1 for session 13. One recode, two lessons, and it sets up the logistic regression
outcome.

**(b) Missingness that is clearly not random.** Income (`hinctnta`) is missing for 114 Estonian
respondents (8.8%). Those respondents are **on average 9 years younger** (41.9 vs 50.8) and
**less educated** (eisced 4.16 vs 4.94) than those who answered:

| | n | mean age | mean eisced |
|---|---|---|---|
| answered income | 1 179 | 50.8 | 4.94 |
| did not answer | 114 | 41.9 | 4.16 |

Two lines of R, and the point lands: dropping incomplete cases is not neutral, it changes who is
in your analysis. This replaces the fabricated 999 example entirely and is far more valuable.

**(c) Missingness rates worth knowing before modelling.** `prtvtiee` 37.1%, `lrscale` 14.3%,
`hinctnta` 8.8%, `stfdem` 5.1%. Worth tabulating early so students see that "n = 1 293" is not
the n any given model will actually use — which connects directly to the existing (good) warning
at old l. 1996 about model n differing from data n.

**Honest framing to state plainly.** ESS declares 7/8/9 and 77/88/99 as user-missing, so both
`haven::read_sav()` and `foreign::read.spss()` convert them to `NA` automatically — verified.
Students should be told this is ESS being unusually well prepared, that many datasets they meet
will not be, and shown `read_sav(user_na = TRUE)` once so they can see the underlying codes and
understand what was done on their behalf. The `haven_labelled` class — which silently breaks
`mean()` and misbehaves in ggplot until `as_factor()` / `zap_labels()` — is the friction that
replaces the old artificial example.

---

## 6. Weights — verified example

Martin asked for an example showing what weights are, when to use them, and when they matter
less. The Estonian data gives a clean two-part answer. Computed with `pspwght`:

**Weights change population descriptive estimates:**

| | unweighted | weighted | shift |
|---|---|---|---|
| mean age | 50.07 | 48.47 | −1.60 |
| mean education (eisced) | 4.87 | 4.60 | −0.27 |
| % women | 55.4 | 53.0 | −2.4 pp |
| **% who voted** | **74.1** | **71.8** | **−2.3 pp** |

**Weights barely touch attitude means or associations:**

| | unweighted | weighted | shift |
|---|---|---|---|
| mean `lrscale` | 5.672 | 5.648 | −0.024 |
| mean `trstplt` | 3.443 | 3.431 | −0.012 |
| mean `stfdem` | 5.108 | 5.083 | −0.025 |

And in a regression, `lrscale ~ agea + eisced`:

| coefficient | unweighted | weighted |
|---|---|---|
| `agea` | 0.0099 | 0.0107 |
| `eisced` | 0.0575 | 0.0500 |

**The lesson, stated in one line:** weights matter when you want to describe the population —
turnout is overstated by 2.3 points without them, the classic survey problem — and matter much
less when you want to describe a relationship between variables. Which is why this course
reports weighted descriptives once, then analyses unweighted, and says so openly.

Section placement: session 3 (what weights are, why ESS has them, the table above), referenced
again in session 5 (descriptives) and once in session 11 (coefficients barely move).
`weighted.mean()` is sufficient — no `survey`/`srvyr` dependency.

---

## 7. Hosting and versioning

Martin asked for a recommendation. The Estonia file is **1.81 MB** — small enough that hosting
is no longer constrained by size.

**Decided: a GitHub repository, with three things in it.**

1. The Quarto book source, rendered to **GitHub Pages** — students get a stable URL, and every
   edit is versioned with a visible history. This replaces the current situation where the HTML
   is a loose 8 MB file and nobody can tell which version they have.
2. `data/ess11_ee_raw.sav` (1.81 MB) — Estonia extracted, otherwise untouched.
3. `data/ess11_ee_clean.rdata` (well under 1 MB) — the output of sessions 3–4.

Why this beats owncloud share links: links do not rot, students can see when a file changed, you
can tag a release at the start of term so mid-semester edits never break a student's setup, and
the data sits next to the materials that use it rather than in a separate system.

**Two things still to settle when the repo is created:**

- **ESS terms.** ESS data are free after registration and require citation. Redistributing a
  derived single-country teaching subset is normal practice, but worth a look at the current
  conditions of use before the raw file goes in a public repo. A clean alternative that
  sidesteps the question entirely: have students register with ESS and download the file
  themselves in session 2 — which is *also* a better lesson about how one actually obtains
  research data — and commit only the small cleaned `.rdata` plus the scripts. This can be
  decided late; it changes one paragraph of session 2, nothing else.
- **Public or private.** Public is simpler and lets Pages work on the free tier. Needed before
  the first render is published, not before the writing starts.

Neither blocks any work below.

---

## 7a. Code style convention

Applies to `R/ettevalmistus.R` and to every code chunk in all 12 sessions.

**Multi-argument calls: one argument per line, closing paren flush.**

```r
ee_koodidega <- read_sav(
  "ESS11e04_2-subset/ESS11e04_2-subset.sav",
  col_select = c(cntry, lrscale),
  user_na = TRUE
) |>
  filter(cntry == "EE")
```

Not the align-under-the-opening-paren style. Reasons: the indent does not depend on the
function name's length, nothing shifts when a function is renamed, long names do not push
arguments off to the right, and — the reason that matters most here — each argument gets its
own line on which to carry an explanatory comment. Closing paren flush with the start of the
statement, because that is what RStudio's Cmd+I and `styler` produce; an indented `)` gets
silently reformatted the first time a student tidies the file.

**When to break a call across lines:** three or more arguments, or the line exceeds ~76
characters, or an argument needs its own comment. Short calls stay on one line — `dim(ess)`,
`table(ee$valis, useNA = "ifany")`.

**Character vectors of names** use the same block form but pack several per line rather than
exploding one-per-line, which would turn a 15-name list into 15 lines:

```r
huvipakkuvad <- c(
  "agea", "gndr", "eisced", "hinctnta", "domicil", "lrscale",
  "polintr", "vote", "trstplt", "stfdem", "health",
  "imbgeco", "imueclt", "imwbcnt", "prtvtiee"
)
```

**No padding spaces to align `=` signs** — `n = n()`, never `n          = n()`. Alignment
padding has to be re-done by hand every time any name changes, and it makes diffs noisy.

**Long pipes get a numbered comment per step** (`# 1. samm. mutate() -- ...`), so each stage is
explained where it happens rather than in a paragraph above the block.

**Every function, operator or concept gets a short note on first use** — what it does and how
its arguments are specified — placed immediately above the line that first uses it. Applies to
operators too: `|>`, `%in%`, `~`, `if () { }` all need introducing, not just named functions.

Two tools enforce this across twelve chapters:

- **`R/funktsioonide-register.md`** — which function, operator and concept is introduced in
  which session. Consult before writing a chapter, update after. Also records the deliberate
  **forward references**, where something is used before it is taught.
- **`R/kontrolli-esmakasutus.py`** — reads the register, then flags anything in a `.qmd` or `.R`
  file used before it is explained. Run before finishing a chapter:

  ```bash
  python3 R/kontrolli-esmakasutus.py 03-andmete-ettevalmistus-1.qmd
  ```

---

## 8. Confirmed technical fixes

| Fix | Detail |
|---|---|
| `warn = FALSE` → `warning = FALSE` | 107 chunks. Never actually suppressed anything |
| Hard-coded CSS path | `/Users/martinmolder/Documents/css_styles/…` → relative `styles.css` |
| Hard-coded `setwd()` | → Quarto project-relative paths |
| SPSS reader | `foreign::read.spss()` → `haven::read_sav()` |
| `geom_hist()` | → `geom_histogram()` (l. 911) |
| `stargazer` | → `modelsummary` (writes `.docx` directly, retiring the "retype it in Word" warning at l. 1710) |
| Subtitle | "2025 sügis" → "2026 sügis" |
| `options(stringsAsFactors = F)` | Obsolete since R 4.0 — remove |
| Unfinished note l. 1712 | Stargazer section — write properly, now against `modelsummary` |
| Unfinished note l. 1968 | Logistic regression table — write properly |
| `figures/logreg.png` screenshot | → reproducible `modelsummary` code producing the real table |
| AI section (l. 382–384) | Rewritten — see below |

**Reproducible logistic regression table (session 13).** Replaces the screenshot. Must include:
log-odds coefficients, odds ratios (`exponentiate = TRUE`), n, McFadden pseudo-R², and the
sensitivity/specificity pair the old material computes by hand at l. 2051–2052. `modelsummary`
handles all of it in one call with a custom `gof_map`.

**Rewritten AI section.** Three parts:
1. What AI coding assistance is genuinely good at here — explaining an error message, suggesting
   a ggplot argument, translating base R to dplyr, commenting your code.
2. **Why it is a bad first contact with statistical coding.** It will produce plausible code for
   an analysis that is wrong for your data — the wrong test for your measurement level, a mean
   of a `haven_labelled` column, a model that silently dropped a third of your cases. You cannot
   catch any of that until you can read the code yourself. The failure mode is not "it doesn't
   work" but "it works and the answer is wrong", which is much worse. This course is where you
   build the judgement that makes the tool safe to use.
3. Link to the University of Tartu guidance on AI use in teaching and studies:
   <https://ut.ee/en/content/guidelines-using-ai-applications-teaching-and-studies>
   (Estonian: <https://sisu.ut.ee/ti/materjalid/>) — plus the standing rule that submitting
   AI-generated text as your own is academic dishonesty.

---

## 9. Reporting boxes for every method

Currently exist for t-test (l. 1418), correlation (l. 1537) and regression (l. 1716). To be
written to the same pattern — the model sentence with real numbers from the Estonian data, bolded
— for:

- descriptive statistics (session 5)
- one-sample t-test (session 9)
- **correlation and bivariate regression (session 10)** — update the existing two
- multiple regression (session 11) — update the existing one
- **logistic regression (session 13)** — currently absent, most needed, must cover odds ratios
  *and* pseudo-R² *and* classification

Suggestion: give them a consistent Quarto callout style (`::: {.callout-tip}` titled
"Kuidas seda kirja panna") so they are visually identical and findable when writing a thesis.

---

## 10. Order of work

1. Archive `ESS11/ESS11.sav` (e03, no Estonia) so it cannot be loaded by mistake.
2. Scaffold the Quarto book — `_quarto.yml` (book profile), 12 chapter stubs, relative
   `styles.css`.
3. **Write `R/ettevalmistus.R` first** — the cleaning script exactly as students build it across
   sessions 3–4: EE filter, `zap_labels`/`as_factor`, `vote` recode, immigration index, CES-D
   reverse-code and index, party collapse, variable selection and renaming. Everything
   downstream depends on which cleaned variables exist. Produce `ess11_ee_clean.rdata` from it.
4. Write sessions 3–4 around that script.
5. Port sessions 1–2, 5, 7 (R basics, import, descriptives, visualisation).
6. Build sessions 8–9 with the two-track structure; write the simulation code for the easy track.
7. Port sessions 10–13, applying the merges and the session 13 compression.
8. Technical pass (§8) and reporting boxes (§9) throughout.
9. `quarto render` from a clean session on another machine to catch remaining absolute paths.

## 11. Packages

R 4.6.0 and Quarto 1.8.26 confirmed present. Already installed: `tidyverse`, `haven`,
`labelled`, `sjPlot`, `ggeffects`, `broom`, `pscl`.

```r
install.packages(c("modelsummary", "gt", "flextable", "officer", "janitor", "quarto"))
```
