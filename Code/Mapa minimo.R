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


leaflet() |> 
  addTiles() |>  
  addMarkers(data = datos_sf, label = datos$`NOMBRE DEL SITIO`) #|> 
  # addHeatmap(data = datos_sf,
  #            intensity = 100,
  #            blur = 20,
  #            radius = 15)






