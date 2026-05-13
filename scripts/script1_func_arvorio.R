# Função principal

run_arvorio <- function(raster_path, vetor_path, buffer_m = NULL) {
  
  cat("\n🚀 Iniciando ArvoRio...\n")
  
  # Carregar dados
  cat("📂 Carregando dados...\n")
  r <- rast(raster_path)
  v <- st_read(vetor_path, quiet = TRUE)
  
  # Reprojetar
  cat("🔄 Reprojetando para mesmo CRS...\n")
  v <- st_transform(v, crs(r))
  
  # Buffer (opcional)
  if(!is.null(buffer_m)) {
    cat("📏 Criando buffer de", buffer_m, "metros...\n")
    v <- st_buffer(v, dist = buffer_m)
  }
  
  # Calcular cobertura
  cat("🌳 Calculando cobertura arbórea...\n")
  cobertura <- exact_extract(
    x = r,
    y = v,
    fun = function(df) {
      arv <- sum(df[df$value == 1, "coverage_fraction"], na.rm = TRUE)
      tot <- sum(df$coverage_fraction, na.rm = TRUE)
      if(tot == 0) return(NA)
      return((arv / tot) * 100)
    },
    summarize_df = TRUE
  )
  
  # Adicionar resultados
  v$cobertura <- cobertura
  v$nivel <- cut(cobertura, 
                 breaks = c(-Inf, 5, 15, 30, 60, Inf),
                 labels = c("Crítico", "Baixo", "Regular", "Bom", "Excelente"))
  
  # Estatísticas
  cat("\n📊 RESULTADOS:\n")
  cat("Média:", round(mean(cobertura, na.rm = TRUE), 2), "%\n")
  cat("Mediana:", round(median(cobertura, na.rm = TRUE), 2), "%\n")
  cat("Mínimo:", round(min(cobertura, na.rm = TRUE), 2), "%\n")
  cat("Máximo:", round(max(cobertura, na.rm = TRUE), 2), "%\n")
  cat("\nDistribuição:\n")
  print(table(v$nivel))
  
  # Visualização
  p <- ggplot(v) +
    geom_sf(aes(color = cobertura), size = 1) +
    scale_color_gradient(low = "red", high = "darkgreen", 
                         name = "Cobertura (%)") +
    theme_minimal() +
    ggtitle("ArvoRio - Cobertura Arbórea por Logradouro")
  
  print(p)
  
  # Salvar resultado
  #output_path <- "arvorio_resultado.gpkg" TENHO QUE TROCAR PARA DAR UM NOME BASEADO NOS DADOS DE ENTRADA
  #st_write(v, output_path, delete_layer = TRUE)
  #cat("\n💾 Resultado salvo em:", output_path)
  
  return(v)
}
