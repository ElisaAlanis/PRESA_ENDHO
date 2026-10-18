datos = "Inputs/Calidad_del_Agua_Superficial_p_2012-2025.xlsx" |> readxl::read_excel()

datos$ESTADO |> unique() |>  sort()

datos = datos |> 
  dplyr::filter(ESTADO == "HIDALGO")




datos$MUNICIPIO |> unique() |>  sort()


datos = datos |> 
  dplyr::filter(MUNICIPIO %in% c("TEZONTEPEC DE ALDAMA", "TULA DE ALLENDE", "TEPETITLÁN"))



datos$CUENCA |> unique() |> sort()

datos = datos |> 
  dplyr::filter(CUENCA == "PRESA ENDHÓ")


datos |> names() |> sort()

datos = datos |> 
  dplyr::select(
    `CLAVE SITIO`:AÑO,
    `DBO_mg/L`,
    `CALIDAD_DBO`,
    `E_COLI_NMP_100mL`,
    `CALIDAD_E_COLI`,
    `TOX_D_48_SUP_UT`,
    `CALIDAD TOX_D_48_SUP`,
    SEMAFORO,
    CONTAMINANTES
  )



datos_sf = datos |> 
  sf::st_as_sf(
    coords = c("LONGITUD", "LATITUD"),
    crs = 4326,
    remove = F,
    na.fail = F
  )




library(leaflet)
library(leaflet.extras)


mapa = leaflet() |> 
  addTiles() |>  
  addMarkers(
    data = datos_sf, 
    label = datos$`NOMBRE DEL SITIO`, 
    popup = vapply(seq_len(nrow(datos_sf)), function(i) {
      fila = sf::st_drop_geometry(datos_sf[i, , drop = FALSE])
      valores = vapply(fila, function(columna) {
        valor = columna[[1]]
        if (is.na(valor)) "NA" else as.character(valor)
      }, character(1))
      paste0(
        "<strong>", htmltools::htmlEscape(names(valores)), "</strong>: ",
        htmltools::htmlEscape(unname(valores)),
        collapse = "<br>"
      )
    }, character(1), USE.NAMES = FALSE),
    group = "Marcadores"
  ) |> 
  addHeatmap(
    data = datos_sf,
    intensity = datos$`DBO_mg/L` |>  as.numeric(),
    group = "Mapa de calor"
  ) |> 
  addLayersControl(
    overlayGroups = c("Marcadores", "Mapa de calor"),
    options = layersControlOptions(collapsed = FALSE)
  )





htmlwidgets::saveWidget(widget = mapa, file = "Outputs/Mapa/Presa_ENDHO.html", selfcontained = F, title = "Presa ENDHO")



