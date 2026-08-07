-- Avab kõik välised lingid uues aknas.
--
-- Quarto valik `link-external-newwindow` ei toimi kõikides versioonides
-- usaldusväärselt, seega teeme seda ise. Filter käib läbi kõik lingid ja lisab
-- neile, mis viitavad välja (algavad http:// või https://), atribuudid
-- target="_blank" ja rel="noopener noreferrer".
--
-- rel="noopener noreferrer" on turvasoovitus: ilma selleta saab avatud leht
-- ligipääsu sellele aknale, kust ta avati.

function Link(el)
  local sihtkoht = el.target

  if sihtkoht:match("^https?://") then
    el.attributes["target"] = "_blank"
    el.attributes["rel"] = "noopener noreferrer"
  end

  return el
end
