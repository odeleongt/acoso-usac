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

# End of script
