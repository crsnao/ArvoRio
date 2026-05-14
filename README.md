# Análise da Cobertura Arbórea a nível de logradouro

O **ArV.log** é uma ferramenta de análise geoespacial que calcula e visualiza o **grau de cobertura arbórea** em cada rua da cidade do Rio de Janeiro. O ArV.log esta sendo produzida no âmbito do Grupo "Mapeia Meu Bairro" do [Coletivo ArborizaJá](https://www.instagram.com/arborizaja.co/)

### Objetivos

- Calcular a porcentagem exata de cobertura arbórea por trecho de rua
- Classificar logradouros por nível de arborização
- Gerar mapas interativos para visualização dos resultados
- Identificar áreas prioritárias para plantio de árvores
- Fornecer base para políticas públicas de arborização

## Instruções para Execução

Para análise foram usados o mapeamento da cobertura arbórea urbana para Brasil produzidos por [Guo et al. 2023](https://www.sciencedirect.com/science/article/pii/S0924271623000461?via%3Dihub) e o mapa dos logradouros disponibilizados pelo [DATARIO](https://www.data.rio/datasets/PCRJ::logradouros/explore).

Os scripts devem ser executados na seguinte ordem:

1. Primeiro, execute o `script1_func_arvorio.R`
2. Em seguida, execute o `script2_analise_arvorio.R`

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
