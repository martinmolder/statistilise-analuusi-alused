# Projekti .Rprofile
#
# Seda faili käivitab R automaatselt iga kord, kui projekt avatakse -- ka siis,
# kui Quarto peatükke renderdab.
#
# MIKS SEE OLEMAS ON. Kui R töötab nn C-lokaadis, siis ei tea ta, mis kodeeringus
# tekstiväärtused on. Sellel on kaks tagajärge:
#
#   1. täpitähed kuvatakse väljundis baidikoodidena (näiteks "\303\244" ä asemel);
#   2. tekstide VÕRDLEMINE katkeb -- `elukoht == "suurlinna äärelinn"` ei leia
#      ühtegi vastet, kuigi need read on andmetes olemas.
#
# Teine neist on ohtlik, sest ta ei anna veateadet. Tulemus on lihtsalt vale.
#
# Allolev seab lokaadi nii, et täpitähed toimiksid. Proovime järjest mitut
# varianti, sest saadaolevad lokaadid erinevad operatsioonisüsteemiti.

local({
  praegune <- Sys.getlocale("LC_CTYPE")

  if (!grepl("UTF-8", praegune, fixed = TRUE)) {
    variandid <- c("et_EE.UTF-8", "en_US.UTF-8", "C.UTF-8", "English_Estonia.utf8")

    for (lok in variandid) {
      tulemus <- suppressWarnings(Sys.setlocale("LC_CTYPE", lok))
      if (nzchar(tulemus)) {
        break
      }
    }
  }
})
