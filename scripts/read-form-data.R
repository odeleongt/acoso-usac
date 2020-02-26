#------------------------------------------------------------------------------*
# Initial code to explore the USAC data
#------------------------------------------------------------------------------*

# Load used packages
library(package = "tidyverse")


# read in the data
acoso_usac <- "data/Mapeo Acoso.xls" %>%
  readxl::read_excel() %>%
  select(-matches("[.]{3}[0-9]")) %>%
  set_names(
    names(.) %>%
      iconv(to = "ASCII//TRANSLIT") %>%
      tolower() %>%
      sub("[0-9. ]+", "", .) %>%
      gsub("[^0-9a-z ]", "", .) %>%
      gsub(" +", "_", .)
  ) %>%
  mutate_all(
    list(
      ~ iconv(., from = "UTF-8", to = "ISO-8859-1")
    )
  ) %>%
  print()


each_question <- acoso_usac %>%
  select(
    -aquac_sentiste, -tipos_de_acoso,
    -aa_quien_fue_dirigida_la_denuncia,
    -si_la_persona_que_te_acosa3_fue_tu_profesora_escribe_su_nombre_te_recordamos_que_esta_encuesta_es_ana3nima,
    -si_fue_dentro_de_un_edificio_distinto_a_tu_unidad_acadacmica_indica_cual_si_respondiste_esta_pregunta_pasa_a_la_seccia3n_3
  ) %>%
  gather(variable, value, -marcatemporal, na.rm = TRUE) %>%
  count(variable, value)

each_question %>%
  count(variable, sort = TRUE)


acoso_locations <- acoso_usac %>%
  select(
    marcatemporal,
    unit = unidad_acadacmica_en_la_que_estudias,
    where = si_fue_dentro_de_tu_unidad_acadacmica_indica_en_quac_parte_si_respondiste_esta_pregunta_pasa_a_la_seccia3n_3,
    other = si_fue_dentro_de_un_edificio_distinto_a_tu_unidad_acadacmica_indica_cual_si_respondiste_esta_pregunta_pasa_a_la_seccia3n_3,
    location = si_no_fue_dentro_de_tu_unidad_acadacmica_u_otra_unidad_ada3nde_fue
  ) %>%
  arrange(is.na(location), is.na(other), is.na(where)) %>%
  print(n = Inf)
  
acoso_locations %>% {
    if(!file.exists("output/locations_ref.xlsx")) {
      list(
        specific = filter(., !is.na(other) | !is.na(location)),
        units = count(., unit)
      ) %>%
      writexl::write_xlsx(path = "output/locations_ref.xlsx")
    }
  }

# End of script
