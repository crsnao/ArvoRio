library(terra)
library(sf)
library(exactextractr)
library(ggplot2)
library(dplyr)
library(leaflet)
library(leaflet.extras)
library(htmltools)

# Função Leaflet ajustada para usar seu objeto
criar_leaflet_arvorio <- function(dados) {
  
  # Verificar inputs
  if(is.null(dados)) {
    stop("❌ O objeto 'dados' é NULL")
  }
  
  if(!inherits(dados, "sf")) {
    stop("❌ Objeto não é sf. Classe: ", class(dados)[1])
  }
  
  # Verificar coluna cobertura
  if(!"cobertura" %in% names(dados)) {
    stop("❌ Coluna 'cobertura' não encontrada")
  }
  
  cat("✅ Dados carregados com sucesso\n")
  cat("   📊 Total de trechos:", nrow(dados), "\n")
  cat("   🌳 Média de cobertura:", round(mean(dados$cobertura, na.rm = TRUE), 1), "%\n")
  cat("   📈 Variação:", round(min(dados$cobertura, na.rm = TRUE), 1), 
      "-", round(max(dados$cobertura, na.rm = TRUE), 1), "%\n")
  
  # Garantir CRS WGS84 para Leaflet
  crs_atual <- st_crs(dados)$epsg
  if(!is.null(crs_atual) && crs_atual != 4326) {
    cat("   🔄 Convertendo de EPSG:", crs_atual, "para EPSG:4326\n")
    dados <- st_transform(dados, 4326)
  }
  
  # Paleta de cores
  pal <- colorNumeric(
    palette = c("#d73027", "#fc8d59", "#fee08b", "#d9ef8b", "#1a9850"),
    domain = dados$cobertura,
    na.color = "#e0e0e0"
  )
  
  # Paleta para classificação (usando seu campo 'nivel')
  pal_class <- colorFactor(
    palette = c("Crítico" = "#d73027", 
                "Baixo" = "#fc8d59", 
                "Regular" = "#fee08b", 
                "Bom" = "#d9ef8b", 
                "Excelente" = "#1a9850"),
    domain = dados$nivel
  )
  
  # Criar mapa
  mapa <- leaflet(dados) %>%
    # Camadas base
    addProviderTiles(providers$CartoDB.Voyager, group = "Mapa Base") %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satélite") %>%
    addProviderTiles(providers$OpenStreetMap.HOT, group = "HOT") %>%
    
    # Polígonos principais
    addPolygons(
      fillColor = ~pal(cobertura),
      color = "#333333",
      weight = 1,
      opacity = 0.8,
      fillOpacity = 0.7,
      label = ~paste0(
        "📊 ", round(cobertura, 1), "% | ",
        nivel,
        " | ", bairro  # Usando o campo bairro do seu dado
      ),
      labelOptions = labelOptions(
        style = list(
          "font-weight" = "normal", 
          "padding" = "3px 8px",
          "background" = "rgba(255,255,255,0.9)",
          "border-radius" = "5px"
        ),
        textsize = "12px",
        direction = "auto"
      ),
      highlightOptions = highlightOptions(
        color = "white",
        weight = 3,
        fillOpacity = 0.9,
        bringToFront = TRUE
      ),
      popup = ~paste0(
        '<div style="min-width: 250px; font-family: Arial, sans-serif;">',
        '<h4 style="margin: 0 0 5px 0;">🌳 ArvoRio - Detalhes</h4>',
        '<hr style="margin: 5px 0;">',
        '<table style="width: 100%; font-size: 13px;">',
        '<tr><td><strong>📍 Logradouro:</strong></td><td>', completo, '</td></tr>',
        '<tr><td><strong>🏘️ Bairro:</strong></td><td>', bairro, '</td></tr>',
        '<tr><td><strong>🌿 Cobertura:</strong></td><td><strong>', round(cobertura, 1), '%</strong></td></tr>',
        '<tr><td><strong>📊 Classificação:</strong></td><td><span style="background-color: ', 
        pal_class(nivel), '; padding: 2px 8px; border-radius: 12px; color: white; font-weight: bold;">', 
        nivel, '</span></td></tr>',
        '<tr><td><strong>🆔 Código:</strong></td><td>', cod_trecho, '</td></tr>',
        '</table>',
        '<hr style="margin: 5px 0;">',
        '<div style="background-color: ', pal_class(nivel), '; height: 4px; width: 100%;"></div>',
        '<div style="font-size: 10px; color: #666; text-align: center; margin-top: 5px;">',
        '<small>📊 ArvoRio - Monitoramento Urbano</small>',
        '</div>',
        '</div>'
      )
    ) %>%
    
    # Legenda
    addLegend(
      pal = pal,
      values = ~cobertura,
      opacity = 0.8,
      title = "🌳 Cobertura Arbórea (%)",
      position = "bottomright",
      labFormat = labelFormat(suffix = "%", digits = 0)
    ) %>%
    
    # Barra de escala
    addScaleBar(position = "bottomleft") %>%
    
    # Mini mapa
    addMiniMap(
      toggleDisplay = TRUE,
      position = "bottomleft",
      width = 100,
      height = 100
    ) %>%
    
    # Botões de fácil acesso
    addEasyButton(easyButton(
      icon = "fa-globe",
      title = "Zoom para extensão total",
      onClick = JS("function(btn, map){ map.fitBounds(map.getBounds()); }")
    )) %>%
    addEasyButton(easyButton(
      icon = "fa-info-circle",
      title = "Sobre o ArvoRio",
      onClick = JS("function(btn, map){ alert('ArvoRio v1.0\\nAnálise de cobertura arbórea por logradouro\\nClique nos polígonos para detalhes.'); }")
    )) %>%
    
    # Controle de camadas
    addLayersControl(
      baseGroups = c("Mapa Base", "Satélite", "HOT"),
      options = layersControlOptions(collapsed = TRUE)
    ) %>%
    
    # Controle informativo
    addControl(
      html = paste0(
        '<div style="background: white; padding: 8px 12px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.2);">',
        '<strong>🌳 ArvoRio</strong><br>',
        '<small>📊 Média: ', round(mean(dados$cobertura, na.rm = TRUE), 1), '%</small><br>',
        '<small>📈 Máx: ', round(max(dados$cobertura, na.rm = TRUE), 1), '% | 📉 Mín: ', round(min(dados$cobertura, na.rm = TRUE), 1), '%</small><br>',
        '<small>🏘️ Bairro: ', unique(st_drop_geometry(dados)$bairro)[1], '</small>',
        '</div>'
      ),
      position = "topright"
    )
  
  cat("✅ Mapa criado com sucesso!\n")
  return(mapa)
}

# EXECUTAR - Use seu objeto resultado_lista diretamente
mapa_leaflet <- criar_leaflet_arvorio(resultado_lista)

# Exibir o mapa
mapa_leaflet
