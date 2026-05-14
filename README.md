# Análise espacial da Cobertura Arbórea Viária a nível de logradouro

## Sobre o Projeto

O **ArV.log** é uma ferramenta de análise geoespacial que calcula e visualiza o **grau de cobertura arbórea** em cada rua da cidade do Rio de Janeiro.

### Objetivos

- Calcular a porcentagem exata de cobertura arbórea por trecho de rua
- Classificar logradouros por nível de arborização
- Gerar mapas interativos para visualização dos resultados
- Identificar áreas prioritárias para plantio de árvores
- Fornecer base para políticas públicas de arborização

# README - Análise da Arborização no Subúrbio do Rio de Janeiro

## Instruções para Execução

Os scripts devem ser executados na seguinte ordem:

1. Primeiro, execute o script `func_arvorio.R`
2. Em seguida, execute o script `analise_arvorio.R`

## Dependências

Carregue os seguintes pacotes antes de executar as análises:

```r
library(terra)
library(sf)
library(exactextractr)
library(ggplot2)
library(dplyr)
library(mapview)
```

## Instalação dos pacotes

Caso não os tenha instalados, execute:

```r
install.packages(c("terra", "sf", "exactextractr", "ggplot2", "dplyr", "mapview"))
```
