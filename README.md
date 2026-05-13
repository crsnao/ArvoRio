# 🌳 ArV.Rio - Análise espacial da Arborização Viária do Rio a nível de logradouro

[![R Version](https://img.shields.io/badge/R-4.3+-blue.svg)](https://www.r-project.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/status-active-brightgreen.svg)]()

## 📖 Sobre o Projeto

O **Arv.Rio** é uma ferramenta de análise geoespacial que calcula e visualiza o **grau de cobertura arbórea** em cada rua da cidade do Rio de Janeiro. O projeto utiliza dados de sensoriamento remoto e geoprocessamento para gerar relatórios e mapas interativos que auxiliam no planejamento urbano sustentável.

### 🎯 Objetivos

- Calcular a porcentagem exata de cobertura arbórea por trecho de rua
- Classificar logradouros por nível de arborização
- Gerar mapas interativos para visualização dos resultados
- Identificar áreas prioritárias para plantio de árvores
- Fornecer base para políticas públicas de arborização

## ✨ Estrutura de Diretórios

ArvoRio/
├── data/
│   ├── raster/          # Arquivos .tif de arborização
│   └── vetor/           # Shapefiles/GeoPackages de logradouros
├── scripts/
│   ├── arvorio_main.R   # Script principal
│   ├── arvorio_functions.R  # Funções modulares
│   └── arvorio_leaflet.R    # Visualização interativa
├── results/             # Resultados gerados
├── docs/                # Documentação
├── README.md
├── LICENSE
└── .gitignore

