---
title: Transformação e Manipulação de Dados em Teoria dos Jogos
author: André Melo
date: '2023-12-25'
slug: transformacao-e-manipulacao-de-dados-em-teoria-dos-jogos
categories: 
 - Tutorial
 - R
tags: 
 - economia
 - datascience
 - teoriadosjogos
description: Transferimos dados do jogo para simulações, permitindo análises detalhadas e adaptação a diferentes modelos de aprendizagem. O tutorial destaca a extração e organização dos dados para análises eficientes.
image: transformacao-manipulacao-teoria-dos-jogos.jpg
math: ~
license: ~
hidden: no
comments: yes
---

<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />

<!--more-->

## Introdução

Na teoria dos jogos, como discutido anteriormente neste blog, exploramos jogos simultâneos, sequenciais e repetidos, bem como a aplicação do modelo de aprendizagem. Esse modelo usa uma matriz de jogos simultâneos para gerar simulações entre os jogadores, com base em seus payoffs e estratégias.

A principal vantagem de utilizar modelo de aprendizagem na teoria dos jogos, especialmente no ambiente R, é a flexibilidade na manipulação das informações. Mas o que exatamente significa essa flexibilidade? Para uma compreensão mais clara, considere o mapa mental abaixo, que ilustra o processo e os objetivos deste tutorial.

<img src="{{< blogdown/postref >}}index_files/figure-html/mindmap.png" width="850" style="display: block; margin: auto;" />

Começamos com um jogo na forma normal e, a partir dessa matriz, transferimos as informações para as simulações, nos permitindo obter detalhes adicionais sobre a interação competitiva entre os jogadores. 

No entanto, as possibilidades não se limitam somente a esse processo, pois você pode optar por concluir sua análise após aplicar o jogo ao modelo EWA ou aprofundar-se ainda mais.

É aqui que entra a flexibilidade da programação, já que você pode direcionar seus dados de várias maneiras, seja com base em modelos específicos, como reforço ou crença, ou em qualquer outra direção que sua análise exija.

Neste cenário, realizaremos a extração dos dados gerados pelas simulações do modelo de aprendizagem. Esse processo envolve a preparação e separação dos dados dos jogadores, com a finalidade de simplificar a posterior manipulação, reorganização, limpeza e junção de data frames. A partir disso, teremos uma base de dados sólida e estruturada para fins analíticos categorizados.

### Pacotes

Para a realização dos passos a seguir será necessário o uso desses pacotes:

```r
# install.packages("devtools")
# devtools::install_github("yukiyanai/rgamer")
library(rgamer)
library(dplyr)
library(tidyr)
library(stringr)
library(purrr)
library(utf8)
```

## Coca-Cola e PepsiCo

Em um jogo, representamos duas empresas, Coca-Cola e PepsiCo, que estão tomando decisões estratégicas em relação a diferentes aspectos de seus negócios para ganhar uma parcela maior do mercado e aumentar seus lucros em milhões de dólares.

Podemos atribuir o exemplo a um objeto chamado `matriz`. Agora nesse exemplo a complexidade fica maior, já que é possível aumentar o número de estratégias dos jogadores, nesse caso aumentaremos para 5 estratégias para os dois jogadores. 


```r
matriz <- normal_form(
  players = c("Coca-Cola", "PepsiCo"),
  s1 = c("Marketing e Publicidade", 
         "Eventos e Parcerias", 
         "Produtos Alternativos", 
         "Distribuição Global", 
         "Aquisição de Marcas"), 
  s2 = c("Promoção da Marca", 
         "Patrocício de Eventos", 
         "Diversificação de Portfólio", 
         "Estratégias de Preços", 
         "Parcerias com Restaurantes"), 
  payoffs1 = c(98, 92, 70, 90, 70, 
               92, 98, 70, 90, 35, 
               70, 70, 70, 90, 70, 
               90, 90, 70, 90, 98, 
               75, 75, 70, 75, 75), 
  payoffs2 = c(92, 98, 70, 90, 35, 
               98, 92, 70, 90, 25, 
               70, 70, 70, 90, 35, 
               90, 98, 98, 90, 98, 
               75, 92, 70, 98, 92))
```

Consequentemente, nessa configuração, o número de payoffs também terá que satisfazer o número de estratégias, já que a matriz agora será uma 5x5, como é visto na tabela abaixo.


```r
s.matriz <- solve_nfg(matriz, mark_br = FALSE)
```

```
Pure-strategy NE: [Aquisição de Marcas, Estratégias de Preços], [Distribuição Global, Parcerias com Restaurantes]
```

<br>

<style type="text/css">
.container-da-tabela {
    overflow-x: auto;
}

@media (max-width: 768px) {
    .table td th{
        font-size: 12px;
    }
}
</style>

<div class="container-da-tabela">
<table class=" lightable-classic table" style="font-family: Arial; margin-left: auto; margin-right: auto; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
<tr>
<th style="empty-cells: hide;" colspan="2"></th>
<th style="padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; font-weight: bold; " colspan="5"><div style="border-bottom: 1px solid #111111; margin-bottom: -1px; ">PepsiCo</div></th>
</tr>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> strategy </th>
   <th style="text-align:center;"> Promoção da Marca </th>
   <th style="text-align:center;"> Patrocício de Eventos </th>
   <th style="text-align:center;"> Diversificação de Portfólio </th>
   <th style="text-align:center;"> Estratégias de Preços </th>
   <th style="text-align:center;"> Parcerias com Restaurantes </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;"> Coca-Cola </td>
   <td style="text-align:center;"> Marketing e Publicidade </td>
   <td style="text-align:center;"> 98, 92 </td>
   <td style="text-align:center;"> 92, 98 </td>
   <td style="text-align:center;"> 70, 70 </td>
   <td style="text-align:center;"> 90, 90 </td>
   <td style="text-align:center;"> 75, 75 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;">  </td>
   <td style="text-align:center;"> Eventos e Parcerias </td>
   <td style="text-align:center;"> 92, 98 </td>
   <td style="text-align:center;"> 98, 92 </td>
   <td style="text-align:center;"> 70, 70 </td>
   <td style="text-align:center;"> 90, 98 </td>
   <td style="text-align:center;"> 75, 92 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;">  </td>
   <td style="text-align:center;"> Produtos Alternativos </td>
   <td style="text-align:center;"> 70, 70 </td>
   <td style="text-align:center;"> 70, 70 </td>
   <td style="text-align:center;"> 70, 70 </td>
   <td style="text-align:center;"> 70, 98 </td>
   <td style="text-align:center;"> 70, 70 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;">  </td>
   <td style="text-align:center;"> Distribuição Global </td>
   <td style="text-align:center;"> 90, 90 </td>
   <td style="text-align:center;"> 90, 90 </td>
   <td style="text-align:center;"> 90, 90 </td>
   <td style="text-align:center;"> 90, 90 </td>
   <td style="text-align:center;"> 75, 98 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;">  </td>
   <td style="text-align:center;"> Aquisição de Marcas </td>
   <td style="text-align:center;"> 70, 35 </td>
   <td style="text-align:center;"> 35, 25 </td>
   <td style="text-align:center;"> 70, 35 </td>
   <td style="text-align:center;"> 98, 98 </td>
   <td style="text-align:center;"> 75, 92 </td>
  </tr>
</tbody>
</table>
</div>

Agora que temos o exemplo estruturado na forma normal, podemos prosseguir para a simulação do modelo de aprendizagem. Durante esse processo podemos configurar os parâmetros <span style="font-size: 100%;">$\lambda$</span>, <span style="font-size: 100%;">$\Delta$</span>, <span style="font-size: 100%;">$\rho$</span> e <span style="font-size: 100%;">$\phi$</span>.


```r
pepsicoca <- sim_learning(
                game = matriz,
                n_samples = 36,
                n_periods = 31,
                type = "EWA",
                lambda = 1,
                delta = 0.3,  
                rho = 0.7,    
                phi = 0.5,
              )
```

Nesse cenário, ajustar o valor de `delta` para 0.3 resulta em uma adaptação mais lenta, o que, por sua vez, permite uma maior incerteza nas escolhas estratégicas. Além disso, definir `rho` como 0.7 atribui mais peso às recompensas passadas, tornando as estratégias com recompensas mais elevadas mais atrativas.

Dessa forma, teremos uma competição um pouco mais incerta entre a Coca-Cola e a Pepsi. Nesse cenário, a empresa que for mais precisa e seguir o equilíbrio de Nash terá um lucro maior do que aquela que for indecisa em relação às suas estratégias em um intervalo específico de tempo.

## Estruturação dos Dados

A partir desse passo, ao transferir os dados de um jogo na forma-normal para uma simulação dentro do pacote Rgamer, esses dados ficarão armazenados em um objeto, que, ao ser examinado em sua estrutura, será identificado como uma lista. Dentro desse objeto será possível encontrar uma variedade de informações abrangendo os jogadores, partidas, probabilidades de escolha e a atratividade das estratégias.

<img src="{{< blogdown/postref >}}index_files/figure-html/img1.png" width="850" style="display: block; margin: auto; box-shadow: 0 5px 15px rgba(0,0,0,.25);" />

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/img2.png" width="850" style="display: block; margin: auto; box-shadow: 0 5px 15px rgba(0,0,0,.25);" />

O propósito deste tutorial é justamente extrair essas informações, que são representadas em forma de data frames, e, após a realização dos procedimentos a seguir, combiná-las em uma única base de dados. Essa base consolidada conterá todas as informações relevantes relativas aos jogadores e ao jogo em questão.

### Extração dos dados

Para a realização dos passos seguintes será preciso extrair os dados da simulação ao atribuir `$data` a um objeto que conterá as informações dos jogador 1 e 2.


```r
base <- pepsicoca$data
```

Nesse caso, `base` será nossa base de referência no momento da separação dos dataframes dos jogadores.

#### Coca-Cola

Após definir um data frame de referência (`base`), podemos realizar a extração dos dados da Coca-Cola.


```r
# Escolhas de probabilidade da Coca-Cola
coca.prob <- do.call(rbind, pepsicoca$choice_prob$P1) %>% 
              pivot_longer(cols = 1:5,
                           names_to = 'estrategia.prob', 
                           values_to = 'probabilidade')
```

Por se tratar de uma lista, podemos utilizar a função `do.call()` que permite chamar uma função com argumentos armazenados em uma lista, no caso, `rbind`, que combinará várias estruturas de dados em uma única estrutura de dados.

Esse será a probabilidade de escolha da Coca-Cola, demonstrado por `coca.prob`, abaixo faremos o mesmo com o valor de atração.


```r
# Valor de atração da Coca-Cola
coca.atr <- do.call(rbind, pepsicoca$attraction$A1) %>% 
              pivot_longer(cols = 1:5,
                           names_to = 'estrategia.atr', 
                           values_to = 'lucro.atr') %>%
              mutate(estrategia.atr = str_replace_all(estrategia.atr, "\\.1", ""))
```

Em ambas as operações realizamos a pivotagem dos dados, ou seja, transformará dados de um formato mais amplo para um formato mais longo, onde as estratégias se tornam valores de uma coluna chamada `estrategia.prob`, e as probabilidades associadas a essas estratégias se tornam valores de outra coluna chamada `probabilidade`.

#### PepsiCo

Podemos repetir o mesmo processo feito anteriormente agora para a Pespsi. Repare que em todo o processo da extração dos dados dos jogadores usamos a função `str_replace_all()` em que substituirá padrões em strings.



```r
# Escolhas de probabilidade da PepsiCo
pepsi.prob <- do.call(rbind, pepsicoca$choice_prob$P2) %>% 
                pivot_longer(cols = 1:5,
                             names_to = 'estrategia.prob', 
                             values_to = 'probabilidade')

# Valor de atração da PepsiCo
pepsi.atr <- do.call(rbind, pepsicoca$attraction$A2) %>% 
                pivot_longer(cols = 1:5,
                             names_to = 'estrategia.atr', values_to = 'lucro.atr') %>%
                mutate(estrategia.atr = str_replace_all(estrategia.atr, "\\.1", ""))
```

Nesse caso, `.1` será o padrão que será substituido na nova coluna gerada após o uso do `pivot_longer()`. Substiuiremos esse padrão por `""`, ou seja, será substituído por uma string vazia, removendo o `.1` da coluna.

## Manipulação dos Dados I

Neste segundo passo, após a extração dos dados provenientes da simulação do modelo de aprendizagem usando o pacote Rgamer, iniciaremos a preparação das bases de dados. O objetivo é permitir a combinação dos data frames referentes tanto à Coca-Cola quanto à Pepsi. Estamos considerando não apenas as escolhas de probabilidade, mas também os valores de atração registrados para ambos os jogadores.

Essa etapa é fundamental para consolidar os dados e facilitar a análise e a manipulação das informações específicas de cada jogador, tornando possível comparar e avaliar as estratégias adotadas pela Coca-Cola e pela Pepsi de forma mais eficiente.

### Filtragem e multiplicação de strings

Para tornar essa manipulação dos dados mais eficiente, realizamos um filtro na base principal. Nesse processo, extraímos as entradas que contêm "Coca-Cola" e "PepsiCo" na coluna 'player'.


```r
cocacola <- base[base$player == "Coca-Cola", ]

pepsico <- base[base$player == "PepsiCo", ]
```

Em seguida, é essencial multiplicar essas observações por um fator de 5. Isso se deve ao fato de haver 5 estratégias para cada jogador, como resultado da transformação realizada anteriormente, na qual as 5 colunas (representando estratégias) se tornaram linhas (observações), cada uma com seus respectivos valores associados.

Essa multiplicação é necessária para garantir que, ao realizar a junção dos data frames, as strings estejam perfeitamente alinhadas com as 5 estratégias correspondentes.


```r
cocacola <- do.call(rbind, replicate(5, cocacola, simplify = FALSE)) %>% 
  arrange(sample, period)

pepsico <- do.call(rbind, replicate(5, pepsico, simplify = FALSE)) %>% 
  arrange(sample, period)
```

Aqui utilizamos a função `replicate()` é usada para criar cópias de um objeto. Neste caso, estamos replicando os data frames da Coca-Cola e Pepsi. É importante notar que o argumento `simplify = FALSE` garante que cada replicação seja mantida como uma lista, em vez de ser simplificada em um vetor, para que possamos combinar essas cópias posteriormente.

#### Junção dos dados I

Após essa breve manipulação, agora é possível realizar a junção dos dados do jogador 1 e 2.


```r
# Junção dos dados do jogador 1
cocacola <- cbind(cocacola, coca.prob, coca.atr)

# Junção dos dados do jogador 2
pepsico <- cbind(pepsico, pepsi.prob, pepsi.atr)
```

Com o mesmo número de linhas cada data frame e após a filtragem e clonagem das strings, agora é perfeitamente possível juntar os data frames de Coca-Cola e Pepsi através da função `cbind()`, pois todos possuem o mesmo número de linhas.

## Limpeza dos Dados 

Após as manipulações realizadas, uma análise visual rápida dos dados revela diversas colunas referentes ao período (`'period'``) resultantes das junções com outros data frames. É crucial ressaltar que os valores dos dados podem apresentar variações, uma vez que se trata de simulações, resultando em diferentes conjuntos de resultados a cada simulação ou execução em máquinas distintas.

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> sample </th>
   <th style="text-align:right;"> period </th>
   <th style="text-align:left;"> player </th>
   <th style="text-align:left;"> strategy </th>
   <th style="text-align:right;"> period </th>
   <th style="text-align:left;"> estrategia.prob </th>
   <th style="text-align:right;"> probabilidade </th>
   <th style="text-align:right;"> period </th>
   <th style="text-align:left;"> estrategia.atr </th>
   <th style="text-align:right;"> lucro.atr </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Coca-Cola </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Marketing e Publicidade </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Marketing e Publicidade </td>
   <td style="text-align:right;"> 22.5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Coca-Cola </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Eventos e Parcerias </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Eventos e Parcerias </td>
   <td style="text-align:right;"> 22.5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Coca-Cola </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Produtos Alternativos </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Produtos Alternativos </td>
   <td style="text-align:right;"> 21.0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Coca-Cola </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Distribuição Global </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Distribuição Global </td>
   <td style="text-align:right;"> 22.5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Coca-Cola </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:right;"> 75.0 </td>
  </tr>
</tbody>
</table>

### Remoção de colunas

No contexto de abordar a questão das repetições das colunas 'period' nas bases de dados da Coca-Cola e Pepsi, se torna essencial desenvolver uma função capaz de resolver esse problema de forma automatizada. Nesse sentido, propõe-se a criação de uma função que aceitará dois argumentos: o primeiro, denominado `data`, refere-se ao dataframe em questão, enquanto o segundo, chamado `col_name`, representa o nome da coluna a ser removida.


```r
# Remoção da coluna 'period' para as bases dos dois jogadores
remove_col <- function(data, col_name) {
  period_col <- which(names(data) == col_name)
  
  if (length(period_col) > 1) {
    data <- data[, -period_col[-1]]
  }
  
  return(data)
}
```

É viável empregar funções base do R para a criação de uma solução destinada à remoção de colunas indesejadas. Especificamente, podemos fazer uso da função `which()`, a qual localiza as posições das colunas em data frames cujos nomes são iguais a col_name. As informações obtidas são então armazenadas no objeto denominado `period_col`.

Posteriormente, podemos introduzir uma condição na qual, se houver mais de uma coluna repetida no objeto `period_col`, a função realizará a remoção de todas essas colunas, mantendo apenas a primeira por posição em `data[, -period_col[-1]]`. Essa abordagem é justificada pela necessidade de identificação prévia com `which()`. Ao final do processo, o data frame é retornado, refletindo as modificações efetuadas pelos argumentos criados. 


```r
# Remoção da coluna 'period' para a base da Coca Cola
cocacola <- remove_col(cocacola, 'period') 

# Remoção da coluna 'period' para a base da Pepsi
pepsico <- remove_col(pepsico, 'period') 
```

Em seguida, procedemos à aplicação da função previamente desenvolvida (`remove_col`), na qual informamos o nome do data frame e a coluna que desejamos remover, no caso, a coluna denominada `'period'`. Esse passo finaliza o processo de utilização da função, garantindo a remoção eficiente da coluna especificada no conjunto de dados.

#### Junção dos dados II

Após a conclusão da limpeza nas colunas das bases de dados individuais, estamos prontos para realizar a junção, unindo-as em um único conjunto de dados. Vale ressaltar que os data frames dos dois jogadores foram previamente ajustados para conter colunas com nomes idênticos. Nessa etapa, é possível empregar a função `bind_rows()` do pacote dplyr, facilitando o processo de combinação dos dados de ambos os jogadores.


```r
base <- bind_rows(cocacola, pepsico)
```

Nesse caso, a escolha da função para unir os data frames torna-se opcional. Em fases anteriores, empregamos funções do pacote base, como `rbind()`, e também mencionamos a alternativa do `bind_rows()` do pacote dplyr. Ambas as abordagens resultarão no mesmo resultado final. Portanto, a flexibilidade na seleção da função de união permite ao usuário optar por aquela que melhor se adequa à sua preferência ou ao contexto específico do projeto.

### Nomeação de colunas

Nesse momento, a etapa de nomear colunas também é opcional, uma vez que se refere à atribuição de nomes específicos às colunas. No presente caso, optou-se por realizar essa nomeação, visando facilitar a posterior identificação das colunas no conjunto de dados.


```r
names(base)[1:4] <- c('amostra', 'periodo', 'jogador', 'estrategia')  
```

Para acessar os nomes das colunas, utilizamos a função `names()` do R. Em seguida, especificamos as posições dessas colunas, abrangendo do índice 1 ao 4 da base de dados. Posteriormente, procedemos à atribuição dos nomes correspondentes às colunas, considerando a ordem estabelecida pela sua posição no conjunto de dados. 

## Conclusão

Como último passo, é possível aprimorar a organização e representação da base principal ordenando-a pela amostra e período. Essa ordenação é particularmente significativa na teoria dos jogos, onde cada jogador tem a oportunidade de efetuar uma escolha com base em sua estratégia a cada período. Dessa maneira, a disposição sequencial da informação reflete de forma mais clara e coerente a dinâmica temporal das decisões tomadas pelos jogadores ao longo do processo analisado.


```r
dados <- base %>%
  arrange(amostra, periodo) %>% 
  select(-estrategia.atr)
```

Utilizando a função `arrange()`, podemos efetuar a organização da base de dados pelas colunas 'amostra' e 'periodo'. Além disso, optamos por remover a coluna 'estrategia.atr' para evitar redundâncias junto à coluna 'estrategia'. Ao conduzir essas etapas, os dados são apresentados da seguinte maneira:

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> amostra </th>
   <th style="text-align:right;"> periodo </th>
   <th style="text-align:left;"> jogador </th>
   <th style="text-align:left;"> estrategia </th>
   <th style="text-align:left;"> estrategia.prob </th>
   <th style="text-align:right;"> probabilidade </th>
   <th style="text-align:right;"> lucro.atr </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Coca-Cola </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:left;"> Marketing e Publicidade </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 22.5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Coca-Cola </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:left;"> Eventos e Parcerias </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 22.5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Coca-Cola </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:left;"> Produtos Alternativos </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 21.0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Coca-Cola </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:left;"> Distribuição Global </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 22.5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Coca-Cola </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:left;"> Aquisição de Marcas </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 75.0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> PepsiCo </td>
   <td style="text-align:left;"> Parcerias com Restaurantes </td>
   <td style="text-align:left;"> Promoção da Marca </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 10.5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> PepsiCo </td>
   <td style="text-align:left;"> Parcerias com Restaurantes </td>
   <td style="text-align:left;"> Patrocício de Eventos </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 7.5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> PepsiCo </td>
   <td style="text-align:left;"> Parcerias com Restaurantes </td>
   <td style="text-align:left;"> Diversificação de Portfólio </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 10.5 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> PepsiCo </td>
   <td style="text-align:left;"> Parcerias com Restaurantes </td>
   <td style="text-align:left;"> Estratégias de Preços </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 29.4 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> PepsiCo </td>
   <td style="text-align:left;"> Parcerias com Restaurantes </td>
   <td style="text-align:left;"> Parcerias com Restaurantes </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 92.0 </td>
  </tr>
</tbody>
</table>

É crucial observar que, neste tutorial, optou-se por não abordar a etapa "Manipulação II" conforme indicado no mind map apresentado na introdução. Essa escolha visa evitar uma extensão excessiva do tutorial, considerando que a extração e estruturação básica dos dados provenientes dos jogos, na forma-normal, são suficientes para análises futuras.

A segunda fase de manipulação é reservada para categorizar elementos específicos nas bases de dados, facilitando análises conforme o foco do estudo ou pesquisa. Em resumo, os dados originam-se das simulações realizadas nos jogos na forma-normal, utilizando o pacote Rgamer. Nos passos seguintes, efetuamos extração e filtragem para realizar ajustes nas bases de dados dos jogadores separadamente. Utilizando funções como `replicate()` para manipulações e `pivot_longer()` para pivotagem.

Posteriormente, desenvolvemos uma função dedicada à remoção das colunas repetidas, resultado das junções realizadas após as manipulações. Este processo visa otimizar a organização dos data frames dos jogadores. Neste ponto, alcançamos uma base de dados consolidada, contendo as ações de ambos os jogadores, acompanhadas de seus valores de atração e probabilidades de escolha. 

Em breve a segunda parte deste tutorial! na qual exploraremos de forma mais aprofundada a segunda fase de manipulação desta base de dados obtida ao longo do tutorial.
