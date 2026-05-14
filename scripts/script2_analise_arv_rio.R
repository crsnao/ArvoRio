# Arv.Rio

# Carregar pacotes
library(terra)
library(sf)
library(exactextractr)
library(ggplot2)
library(dplyr)
library(mapview)

# Caminhos dos arquivos (EDITAR CONFORME NECESSÁRIO)
raster_path <- "ArvoRio/dados_teste/ivu_teste.tif"          # <--- CAMINHO PARA O MAPA RASTER DE ARBORIZAÇÃO
vetor_path  <- "ArvoRio/dados_teste/logradouros_teste_ilha.gpkg"  # <--- CAMINHO PARA MAPA DE LOGRADOUROS
buffer_m    <- 5  # Buffer em metros (NULL se não quiser buffer)

# EXECUTAR 
resultado <- run_arvorio(raster_path, vetor_path, buffer_m)

# Ver top 10
resultado %>%
  st_drop_geometry() %>%
  arrange(desc(cobertura)) %>%
  head(10)

mapview(resultado, zcol = "cobertura")

st_write(resultado, "ArvoRio/dados_teste/logradouros_resultado.gpkg")
