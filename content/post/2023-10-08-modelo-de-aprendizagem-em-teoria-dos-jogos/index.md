---
title: Modelo de Aprendizagem em Teoria dos Jogos
author: André Melo
date: '2023-10-08'
slug: []
categories: 
 - Tutorial
 - Data Science
 - R
tags: []
description: O modelo EWA descreve como jogadores tomam decisões estratégicas com base em experiências passadas, ajustando preferências por diferentes estratégias ao longo do tempo, podendo ser configurado como aprendizado por reforço ou crenças.
image: modelo-de-aprendizagem-em-teoria-dos-jogos.jpg
math: ~
license: ~
hidden: no
comments: yes
---

<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />

<!--more-->

## Introdução

Se você ainda não conferiu nosso tutorial sobre Teoria dos Jogos no R, abordando Jogos Sequenciais e Reptidos, clique <a href="https://drewmelo.github.io/blogr/p/jogos-simultaneos/" id="rgamer-link">aqui</a> para acessar diretamente o post.

<style type="text/css">
/* ---------------------------------------------------------- */

a#rgamer-link {
    color: #016dea; /* Cor do texto no modo light */
    text-decoration: none;
}

a#rgamer-link:hover {
    color: #014ba0; /* Cor do texto quando o mouse passar por cima no modo light */
}

/* ---------------------------------------------------------- */  

/* Estilos para o link no modo dark */
[data-scheme="dark"] a#rgamer-link {
    color: #5bc0be; /* Cor do texto no modo dark */
}

[data-scheme="dark"] a#rgamer-link:hover {
    color: #7eecea; /* Cor do texto quando o mouse passar por cima no modo dark */
}

/* ----------------- MODELO DE APRENDIZAGEM COMEÇO ------------------ */
  #botoesEWA {
    display: flex;
    justify-content: center;
}
  .botao-interativo-ewa {
    background-color: transparent;
    border-color: transparent;
    margin-left: 10px;  /* Adicionando margem para separar os botões */
    padding: 5px 10px; /* Adicionando espaçamento interno para melhor aparência */
    color: #016dea;
    border-radius: 0.5rem;
    font-size: 15px;
    transition: background-color 0.3s;
    width: auto; /* Largura automática para ajustar ao tamanho do texto */
    white-space: nowrap; /* Evita que o texto quebre em várias linhas */
  }

  .botao-interativo-ewa:hover {
    background-color: #E5E5E5;
    color: #002e63;
  }

  .botao-interativo-ewa.selecionadoEWA {
    background-color: #0766a6;
    color: white;
  }

  .conteudoEWA {
    opacity: 0;
    transition: opacity 0.5s;
  }

/* ---------------------------------------------------------- */  

  [data-scheme="dark"] .botao-interativo-ewa {
    background-color: transparent;
    color: #dedbd2; /* Use a variável de cor do texto para o modo dark */
}

  [data-scheme="dark"] .botao-interativo-ewa:hover {
    background-color: #cfdbd5; 
    color: #2f3e46;
}

  [data-scheme="dark"] .botao-interativo-ewa.selecionadoEWA {
    background-color: #0f4c5c;
    color: #dedbd2; /* Cor do texto do botão selecionado */
}

/* ---------------------------------------------------------- */  
  
/* Estilos para o layout responsivo dos botões */
@media screen and (max-width: 768px) {
  #botoesEWA {
    gap: 10px; /* Espaço entre os botões */
  }
  
  .botao-interativo-ewa {
    width: 100%; /* Largura total para preencher a coluna */
    margin: 0 auto;
  }
}

/* ------------ PROBABILIDADE E ATRAÇÃO ------------ */
/* probabilidade - COMEÇO */
.output-learningexemplop1,
.output-learningexemplop2 {
  font-family: 'Lucida Console' !important;
  font-size: 14px;
  line-height: 1.4;
  color: #333; /* Cor do texto */
  white-space: nowrap;
  padding: 10px;
  margin: 0;
  border: none;
  background: none;
  display: inline-block; /* Defina para inline-block para alinhar horizontalmente */
  max-width: 45%; /* Defina a largura máxima para cada tabela */
  vertical-align: top; /* Alinhe as tabelas ao topo uma da outra */
}

.output-learningexemplop1 {
  margin-top: -25px; /* Ajuste o valor conforme necessário */
  margin-bottom: -1rem;
}

.output-learningexemplop2 {
  margin-top: -25px; /* Ajuste o valor conforme necessário */
  margin-bottom: -1rem;
}
/* probabilidade - FIM */

/* atração - COMEÇO */
.output-learningatracaop1,
.output-learningatracaop2 {
  font-family: 'Lucida Console' !important;
  font-size: 12px;
  line-height: 1.4;
  color: #333; /* Cor do texto */
  white-space: nowrap;
  padding: 10px;
  margin: 0;
  border: none;
  background: none;
  display: inline-block; /* Defina para inline-block para alinhar horizontalmente */
  max-width: 100%; /* Defina a largura máxima para cada tabela */
  vertical-align: top; /* Alinhe as tabelas ao topo uma da outra */
}

.output-learningatracaop1 {
  margin-top: -25px; /* Ajuste o valor conforme necessário */
  margin-bottom: -1rem;
}

.output-learningatracaop2 {
  margin-top: -25px; /* Ajuste o valor conforme necessário */
  margin-bottom: -1rem;

/* atração - FIM */

</style>

## Pacotes

Para realização dos passos seguintes, será necessário a instalação e ativação do pacote:


```r
# install.packages("devtools")
# devtools::install_github("yukiyanai/rgamer")
library(rgamer)
library(utf8)
```

## Modelo de Aprendizagem

O modelo de aprendizagem aplicado à teoria dos jogos refere-se a um conjunto de regras e estratégias que os jogadores usam para aprender e adaptar seu comportamento ao longo do tempo em um jogo. Esses modelos podem ajudar a explicar como os jogadores tomam decisões e como essas decisões evoluem à medida que eles ganham experiência e aprendem com as interações passadas.

### Experienced-Weighted Attraction (EWA)

O modelo de aprendizagem EWA (*Experienced-Weighted Attraction*) ou Atração Ponderada Experiente é uma abordagem em modelagem de aprendizado que busca demonstrar como os jogadores realizam escolhas estratégicas com base em suas experiências passadas e nas atrações associadas a diferentes estratégias. Neste modelo, os jogadores atribuem valores de atração a cada uma das estratégias disponíveis com base nas recompensas (payoffs) que receberam no passado ao escolher essas estratégias. Esses valores de atração refletem a percepção  sobre a utilidade de cada estratégia e são atualizados ao longo do tempo com base nas recompensas obtidas.

Em um dos recursos presentes no pacote Rgamer está a função <span class="highlighted-text">`sim_learning()`</span> que realiza a simulação usando o modelo EWA e fornece resultados como estratégias escolhidas pelos jogadores, valores de atração, probabilidades de escolha de estratégias e gráficos de resultados.


```r
jogo2 <- normal_form(
          players = c("OilFlex", "EconoGas"),
          s1 = c("Manter Preço", "Reduzir Preço"), 
          s2 = c("Manter Preço", "Reduzir Preço"), 
          payoffs1 = c(50, 60, 30, 40), 
          payoffs2 = c(50, 30, 60, 40))
```

Utilizando o mesmo exemplo dos dois postos de gasolina, o qual é estruturado por <span class="highlighted-text">`normal_form()`</span> para criar o jogo que será utilizado na simulação executada pela função <span class="highlighted-text">`sim_learning()`</span>.


```r
jogo12 <- sim_learning(
            game = jogo2,
            n_samples = 10,
            n_periods = 20,
            type = "EWA",
            lambda = 1,
            delta = 0.5,
            rho = 0.5,
            phi = 0.5
            )
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/simlearning.png" width="672" style="display: block; margin: auto;" />

Em 10 amostras (repetições) definido por <span class="highlighted-text">`n_samples`</span>, em que cada amostra contém 20 períodos (rodadas) configurado por <span class="highlighted-text">`n_periods`</span>, é necessário observar que quanto maior o número de amostras e períodos, maior será a precisão da simulação do modelo de aprendizagem. No entanto, isso também exigirá mais tempo e recursos de desempenho da máquina.

Abaixo estão as definições e configuração dos parâmetros `lambda`, `delta`, `rho` e `phi`:

- `lambda` <span style="font-size: 100%;">$\(\lambda\)$</span>: Esse parâmetro controla a rapidez com que os jogadores ajustam suas probabilidades de escolha com base nas experiências passadas. Quando o valor é igual a 1, significa que o jogadores aumentam ao máximo suas taxas de aprendizado.

- `delta` <span style="font-size: 100%;">$\(\Delta\)$</span>: Possui influência na sensibilidade dos jogadores às mudanças nas recompensas. Ao configurar esse parâmetro com o valor 0.5, irá gerar um equilíbrio entre reagir a mudanças e manter estabilidade nas escolhas.

- `rho` <span style="font-size: 100%;">$\(\rho\)$</span>: Ao adicionar esse parâmetro, é possível modificar a sensibilidade dos jogadores às diferenças nas atrações entre estratégias. Um valor de 0.5 indica que as preferências serão moderadamente relativas entre estratégias.

- `phi` <span style="font-size: 100%;">$\(\phi\)$</span>: Esse parâmetro representa a sensibilidade dos jogadores às mudanças nas atrações entre estratégias ao longo das amostras. Um valor de 0.5 significa que as mudanças nas preferências serão graduais.

Em muitos casos, é necessário ajustar esses valores, que variam de 0 a 1, durante a modelagem e testar diferentes combinações para ver como afetam o comportamento do modelo e se ajustam aos dados reais do problema em estudo. É importante notar que cada combinação diferente pode ativar um caso específico do modelo EWA, abordado mais a frente.

#### Probabilidade de Escolha

Este modelo não se limita apenas em fornecer representações gráficas, mas também oferece informações sobre as escolhas probabilísticas das estratégias feitas pelos jogadores ao longo dos períodos. Essas informações podem ser acessadas por meio dos comandos <span class="highlighted-text">`$choice_prob$P1`</span> para o jogador 1 e <span class="highlighted-text">`$choice_prob$P2`</span> para o jogador 2, ou também <span class="highlighted-text">`$choice_prob`</span> na visualização geral das probabilidades de escolha dos dois jogadores.

Para acessar as escolhas em probabilidade feitas pelo jogador 1 e 2, neste caso, basta utilizar o objeto criado, <span class="highlighted-text">`jogo12`</span>, em conjunto com esses comandos, como demonstrado abaixo.

```r
# Probabilidade das escolhas do posto "OilFlex"
round(jogo12$choice_prob$P1[[10]], digits = 2)
```
```
   Manter Preço Reduzir Preço period
1           0.5           0.5      1
2           1.0           0.0      2
3           1.0           0.0      3
4           1.0           0.0      4
5           1.0           0.0      5
6           1.0           0.0      6
7           1.0           0.0      7
8           1.0           0.0      8
9           1.0           0.0      9
10          1.0           0.0     10
11          1.0           0.0     11
12          1.0           0.0     12
13          1.0           0.0     13
14          1.0           0.0     14
15          1.0           0.0     15
16          1.0           0.0     16
17          1.0           0.0     17
18          1.0           0.0     18
19          1.0           0.0     19
20          1.0           0.0     20
```

```r
# Probabilidade das escolhas do posto "EconoGas"
round(jogo12$choice_prob$P2[[10]], digits = 2)
```
```
   Manter Preço Reduzir Preço period
1           0.5           0.5      1
2           0.0           1.0      2
3           0.0           1.0      3
4           0.0           1.0      4
5           0.0           1.0      5
6           0.0           1.0      6
7           0.0           1.0      7
8           0.0           1.0      8
9           0.0           1.0      9
10          0.0           1.0     10
11          0.0           1.0     11
12          0.0           1.0     12
13          0.0           1.0     13
14          0.0           1.0     14
15          0.0           1.0     15
16          0.0           1.0     16
17          0.0           1.0     17
18          0.0           1.0     18
19          0.0           1.0     19
20          0.0           1.0     20
```

Para garantir a clareza dos resultados, neste cenário, realizamos a formatação dos números por meio do arredondamento utilizando a função <span class="highlighted-text">`round()`</span>, com precisão de duas casas decimais (<span class="highlighted-text">`digits = 2`</span>). A análise foi focada nos períodos (<span class="highlighted-text">`n_periods`</span>) da décima amostra (<span class="highlighted-text">`n_samples`</span>), que pode ser acessada através da posição <span class="highlighted-text">`[[10]]`</span>. 

Ao analisar o resultado, podemos inferir o seguinte:


- No primeiro período, tanto "OilFlex" quanto "EconoGas" começam com uma probabilidade equilibrada de 50% para escolher qualquer uma das estratégias disponíveis, ou seja, "Manter Preço" ou "Reduzir Preço". Esse cenário é comum em jogos onde os jogadores têm informações limitadas sobre as estratégias de seus oponentes. Nesse contexto, eles adotam uma abordagem inicial de "esperar para ver" e fazem suas escolhas de maneira aleatória, com base em suas percepções iniciais, sem conhecimento das escolhas do oponente. Essa abordagem equilibrada reflete a incerteza inicial sobre qual estratégia é a mais vantajosa.

A partir do segundo período, se observa uma mudança significativa no comportamento dos jogadores:


- O jogador 1 ("OilFlex") começa a escolher "Manter Preço" com uma probabilidade de 100%, indicando que ele adotou essa estratégia determinística a partir do segundo período. Essa escolha sugere uma tomada de decisão baseada em um padrão de aprendizado em atração ponderada experiente ou em uma estratégia que ele percebe como mais vantajosa a longo prazo.

- O jogador 2 ("EconoGas"), por outro lado, começa a escolher "Reduzir Preço" com probabilidade de 100% a partir do segundo período. Da mesma forma que o jogador 1, o jogador 2 tomou uma decisão consistente de reduzir o preço, independentemente da escolha do oponente.

As escolhas dos jogadores são totalmente aleatórias? A resposta é não. Nesse exemplo, as probabilidades de escolha, representadas pelo termo "<span class="highlighted-text">`$choice_prob`</span>", determinam as chances de um jogador selecionar uma estratégia específica em um determinado período. Essas probabilidades não são totalmente aleatórias, elas são diretamente influenciadas pelos valores de atração associados a cada estratégia. É importante notar que o modo de configuração dos parâmetros <span style="font-size: 100%;">$\lambda$</span>, <span style="font-size: 100%;">$\Delta$</span>, <span style="font-size: 100%;">$\rho$</span> e <span style="font-size: 100%;">$\phi$</span> também podem desempenhar um papel significativo na forma como o modelo lida com os valores de atrações em cenários específicos.

#### Valor de Atração (Attraction)

O valor de atração é uma medida que representa o grau de preferência ou atratividade de uma estratégia para um jogador em uma determinada amostra do jogo. Essencialmente, ele indica o quão valiosa uma estratégia é para o jogador em comparação com outras alternativas disponíveis.

Quando o valor de atração é elevado para uma determinada estratégia, isso implica que o jogador percebe essa estratégia como altamente vantajosa ou preferível naquela amostra em particular. Como resultado, a probabilidade dos jogadores escolherem essa estratégia será significativamente alta, aproximando-se de 1, enquanto a probabilidade de optar por outras estratégias será baixa, refletindo um valor de atração menor que influencia a diminuição das escolhas probabilísticas para valores próximos de 0.

É possível personalizar o quão atrativas (ou favoráveis) as estratégias são consideradas pelos jogadores no início da simulação. Essa modificação pode ser feito usando os parâmetros <span class="highlighted-text">`A1_init`</span> para o jogador 1 e <span class="highlighted-text">`A2_init`</span> para o jogador 2, fornecendo os valores correspondentes para cada parâmetro. Essa personalização afetará a forma como cada jogador começa a jogar no início de cada simulação. Também é relevante mencionar que a influência das experiências passadas na aprendizagem dos jogadores pode ser ajustada por meio do parâmetro <span class="highlighted-text">`N_init`</span>, que define o peso atribuído às escolhas passadas dos jogadores.

Na prática, ao utilizar o objeto de jogo da simulação, <span class="highlighted-text">`$jogo12`</span>, em conjunto com os comandos de valor de atração <span class="highlighted-text">`$attraction$A1`</span> para o jogador 1 ou <span class="highlighted-text">`$attraction$A2`</span> para o jogador 2 (ou simplesmente <span class="highlighted-text">`$attraction`</span> para uma visão geral), torna-se possível identificar preferências em relação às vantagens.

```r
# Valor de atração para o posto "OilFlex" 
jogo12$attraction$A1[[10]]
```
```
   Manter Preço Reduzir Preço period
1            30            20      1
2            30            20      2
3            30            20      3
4            30            20      4
5            30            20      5
6            30            20      6
7            30            20      7
8            30            20      8
9            30            20      9
10           30            20     10
11           30            20     11
12           30            20     12
13           30            20     13
14           30            20     14
15           30            20     15
16           30            20     16
17           30            20     17
18           30            20     18
19           30            20     19
20           30            20     20
```

```r
# Valor de atração para o posto "EconoGas"
jogo12$attraction$A2[[10]]
```
```
   Manter Preço Reduzir Preço period
1            25            60      1
2            25            60      2
3            25            60      3
4            25            60      4
5            25            60      5
6            25            60      6
7            25            60      7
8            25            60      8
9            25            60      9
10           25            60     10
11           25            60     11
12           25            60     12
13           25            60     13
14           25            60     14
15           25            60     15
16           25            60     16
17           25            60     17
18           25            60     18
19           25            60     19
20           25            60     20
```

Ao analisar o primeiro período, podemos inferir que:

- O jogador "OilFlex" demonstra uma atratividade quase igual tanto pela estratégia "Manter Preço" (30) quanto pela "Reduzir Preço" (20). Essa paridade resulta em probabilidades de escolha equilibradas (0.5 para cada estratégia). Portanto, o jogador parece estar indeciso e faz suas escolhas de forma aleatória.

- O jogador "EconoGas" encontra-se em uma situação semelhante ao "OilFlex". Suas atrações pela estratégia "Manter Preço" (25) e "Reduzir Preço" (60) também levam a probabilidades equilibradas (0.5 para cada estratégia), indicando que o jogador também está indeciso e faz escolhas aleatórias.

Nesse período, uma situação interessante e curiosa destaca-se, pois as probabilidades de escolha para ambos os jogadores foram de 0.5, o que equivale a 50%. Essas probabilidades ocorreram independentemente dos valores de atração atribuídos a cada estratégia. Por exemplo, o posto EconoGas pode ter uma preferência maior (valor de atração de 60) por reduzir o preço, mas ainda assim, no primeiro período, há uma probabilidade de 50% de escolher entre manter ou reduzir o preço. Para visualização das escolhas que cada jogador realizou na décima amostra é necessário combinar o objeto de jogo com <span class="highlighted-text">`$data_list[[10]]`</span>.

#### Estocasticidade e Valor de Atração Médio

A aparente contradição na análise do primeiro período pode ser atribuída a dois fatores. O primeiro é a Aleatoriedade ou Estocasticidade, um componente inerente à teoria probabilística. Mesmo quando o valor de atração indica uma preferência mais forte por "Reduzir Preço", pode haver um elemento estocástico nas decisões do jogador 2. Esse fator demonstra que as escolhas do jogador 2 não são feitas puramente com base em preferências, mas também envolvem um elemento aleatório, principalmente no primeiro período, quando ambos os jogadores estão jogando pela primeira vez em uma amostra.

O segundo fator é o Valor de Atração Médio. Com o tempo, é possível observar que o valor médio de atração seja igual para ambas as estratégias, apesar das flutuações de curto prazo. Por exemplo, pode ser que o jogador 2 tenha escolhido "Reduzir Preço" com mais frequência em amostras passadas, mas em média, as escolhas se equilibram ao longo do tempo, como demonstrado nos períodos subsequentes. Esse valor médio de atração tem um impacto significativo nas probabilidades de escolha, especialmente quando se utiliza uma função de escolha estocástica que leva em consideração as diferenças nas atrações médias das estratégias.

Assim, o valor médio de atração desempenha um papel na influência das probabilidades de escolha ao longo das amostras. No entanto, a estocasticidade introduz uma variabilidade nas decisões, mesmo quando existe uma preferência clara por uma estratégia naquele intervalo de tempo. Por exemplo, em uma simulação com 10 amostras, os jogadores podem alternar entre as estratégias de "Manter Preço" e "Reduzir Preço", sendo essa alternância influenciada pelo valor médio de atratividade e pela aleatoriedade na exploração de novas estratégias.

A combinação desses fatores pode resultar em probabilidades de escolha que não correspondem diretamente aos valores de atração em um período específico. Essa complexidade reflete a natureza realista das decisões humanas em situações de jogo, onde as preferências individuais, juntamente com elementos estocásticos, contribuem para as escolhas finais dos jogadores.

### Tipos de Modelo

Além dos parâmetros mencionados anteriormente, o tipo de modelo de aprendizagem também é um elemento importante a ser considerado. Dependendo dos valores dos argumentos fornecidos, o modelo pode ser configurado como um modelo de aprendizagem por reforço ou um modelo de aprendizagem por crenças. Essas configurações especiais são casos específicos do modelo EWA.

Na representação gráfica, a opção de ajustar a escala do eixo Y nos gráficos de probabilidade de escolha ao longo do tempo é feita por meio do argumento <span class="highlighted-text">`plot_range_y`</span>. Existem três valores disponíveis para este argumento: <span class="highlighted-text">`"fixed"`</span>, <span class="highlighted-text">`"full"`</span>, e <span class="highlighted-text">`"free"`</span>.

No caso do primeiro valor, <span class="highlighted-text">`"fixed"`</span>, a faixa do eixo Y permanece constante e igual para todos os gráficos gerados. A escala vertical dos gráficos permanece inalterada, independentemente das variações nas probabilidades de escolha observadas. Essa abordagem pode ser útil para identificar tendências, diferenças ou padrões entre os gráficos de forma mais consistente.

No segundo cenário, <span class="highlighted-text">`"full"`</span>, a faixa do eixo Y é definida com base nas probabilidades de escolha reais observadas durante a simulação. A escala vertical dos gráficos é automaticamente ajustada para incluir todas as probabilidades observadas, garantindo que os gráficos mostrem todas as variações nas escolhas ao longo do tempo.

Já no terceiro caso, <span class="highlighted-text">`"free"`</span>, a faixa do eixo Y é flexível e depende dos resultados específicos de cada simulação. A escala vertical dos gráficos pode variar de uma execução para outra, dependendo das probabilidades de escolha observadas em cada simulação. Essa opção é útil quando se deseja realizar uma análise detalhada das mudanças nas probabilidades ao longo das amostras e quando é importante obter uma visão precisa das flutuações nas escolhas dos jogadores.

A escolha entre esses valores depende dos objetivos da análise. Por exemplo, se precisa fazer comparações consistentes entre gráficos de diferentes simulações, optar por <span class="highlighted-text">`"fixed"`</span> pode ser mais apropriado. Por outro lado, <span class="highlighted-text">`"full"`</span> ou <span class="highlighted-text">`"free"`</span> são escolhas preferíveis quando se tem a escala ajustada automaticamente com base nos resultados da simulação.

<div id="botoesEWA">
  <button id="botao-ewa1" class="botao-interativo-ewa" onclick="showConteudoEWA('ewa1')">Modelo por Reforço</button>
  <button id="botao-ewa2" class="botao-interativo-ewa" onclick="showConteudoEWA('ewa2')">Modelo por Crenças</button>
</div>

<script>
window.onload = function() {
    showConteudoEWA('ewa1');
}
</script>

<script>
function showConteudoEWA(conteudoId) {
  var conteudos = document.getElementsByClassName('conteudoEWA');
  for (var i = 0; i < conteudos.length; i++) {
    conteudos[i].style.opacity = 0; // Definir a opacidade do conteúdo como 0 (invisível)
    conteudos[i].style.display = 'none'; // Esconder o conteúdo (display: none)
  }
  
  // Exibir o conteúdo desejado com animação suave
  var conteudoDesejado = document.getElementById(conteudoId);
  conteudoDesejado.style.display = 'block'; // Exibir o conteúdo (display: block)
  setTimeout(function() {
    conteudoDesejado.style.opacity = 1; // Definir a opacidade do conteúdo como 1 (visível)
  }, 50); // Aguardar 50 milissegundos para aplicar a opacidade (ajuste conforme desejado)
  
  var botoes = document.getElementsByClassName('botao-interativo-ewa');
  for (var i = 0; i < botoes.length; i++) {
    botoes[i].classList.remove('selecionadoEWA');
  }
  
  var botaoSelecionado = document.getElementById('botao-' + conteudoId);
  botaoSelecionado.classList.add('selecionadoEWA');
}
</script>

<div id="ewa1" class="conteudoEWA">

O modelo por reforço, popularmente conhecido como *Reinforcement Learning*, é uma abordagem amplamente utilizada em *Machine Learning* e teoria dos jogos. Ele é empregado em cenários nos quais um agente ou jogador precisa tomar decisões sequenciais com o objetivo de maximizar recompensas ao longo do tempo.

Neste modelo, os jogadores aprendem quais estratégias são mais vantajosas com base nas recompensas que recebem. É importante notar que no exemplo abaixo, o parâmetro <span class="highlighted-text">`rho`</span> está definido como 0, o que implica que o modelo não leva em consideração a atração ponderada experiente (EWA) nas escolhas dos jogadores. Portanto, no contexto desse caso específica, as escolhas dos jogadores são influenciadas principalmente pelas recompensas passadas. Dessa forma, quando uma estratégia leva a recompensas positivas, a probabilidade do jogador escolher essa estratégia aumenta ao longo do tempo, refletindo o seu aprendizado e adaptação. 

Quando <span class="highlighted-text">`type = "reinforcement"`</span>, utilizamos o modelo de aprendizado por reforço. Os jogadores escolhem a melhor resposta às ações do oponente na rodada anterior, buscando maximizar suas recompensas. Ao considerar o <span class="highlighted-text">`plot_range_y`</span> como <span class="highlighted-text">`"free"`</span>, é possível ter uma visão mais detalhada das mudanças nas probabilidades.


```r
sim_learning(
  game = jogo2,
  n_samples = 10,
  n_periods = 20,
  type = "reinforcement",
  lambda = 1,
  delta = 0.5,
  rho = 0,
  plot_range_y = "free"
  )
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game15-1.png" width="672" style="display: block; margin: auto;" />

Ao utilizar o valor <span class="highlighted-text">`"free"`</span>, é importante notar que os gráficos podem apresentar escalas diferentes em diversas simulações, o que pode dificultar a comparação visual entre diferentes conjuntos de dados. Contudo, essa configuração é ideal para uma análise minuciosa das variações nas probabilidades ao longo do tempo em um modelo de reforço.

</div>

<div id="ewa2" class="conteudoEWA">

O modelo por crenças é uma abordagem que se concentra na consideração das crenças dos jogadores sobre as estratégias e informações de seus oponentes ao tomar decisões em um jogo. Essa abordagem leva em conta não apenas as próprias informações do jogador, mas também o que o jogador acredita que seus oponentes sabem ou podem fazer.

Nesse modelo, os jogadores formam e atualizam suas crenças sobre as estratégias de seus oponentes com base nas informações disponíveis, podendo ser usado como parte dessas crenças o valor de atração médio. Por exemplo, se um jogador observar que, ao longo de várias rodadas, seu oponente tem consistentemente escolhido uma determinada estratégia, isso afetará suas crenças sobre a probabilidade de o oponente escolher essa estratégia no futuro. 

No exemplo abaixo, quando temos <span class="highlighted-text">`phi`</span> igual a 1, os jogadores são racionais, pois realizam uma avaliação precisa e completa das ações passadas de seus oponentes. Eles atualizam suas crenças de forma ótima, pois levam em consideração todas as informações disponíveis, similar a Inferência Bayesiana.

Ao definir o <span class="highlighted-text">`type`</span> como <span class="highlighted-text">`"belief"`</span> e ajustar os valores de <span class="highlighted-text">`delta`</span>, <span class="highlighted-text">`rho`</span>, para 0.5 e <span class="highlighted-text">`phi`</span> para 1 é possível simular o comportamento de aprendizado baseado em crenças no <span class="highlighted-text">`sim_learning()`</span>. Também podemos definir o argumento <span class="highlighted-text">`plot_range_y`</span> como <span class="highlighted-text">`"fixed"`</span> para ter uma escala vertical fixa nos gráficos.


```r
sim_learning(
  game = jogo2,
  n_samples = 10,
  n_periods = 20,
  type = "belief",
  lambda = 1,
  delta = 0.5,
  rho = 0.5,
  phi = 1,
  plot_range_y = "fixed"
  )
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game16-1.png" width="672" style="display: block; margin: auto;" />

É importante mencionar que ao utilizar o valor <span class="highlighted-text">`"fixed"`</span>, pode haver a possibilidade de corte das informações visuais se as probabilidades ou crenças observadas ultrapassarem os limites da faixa fixa. O mesmo ocorre com o <span class="highlighted-text">`"full"`</span>, pois as probabilidades observadas podem variar amplamente em uma simulação específica, tornando difícil a visualização dos detalhes das mudanças nas probabilidades.

</div>

### Simulação de Jogadas

A função <span class="highlighted-text">`sim_game()`</span> é usada para simular jogadas em um jogo na forma normal, permitindo a simulação de diferentes estratégias e comportamentos esperados com base em regras específicas.

Na opção <span class="highlighted-text">`"br"`</span> do argumento <span class="highlighted-text">`type`</span>, cada jogador escolhe a melhor resposta à escolha do oponente no período anterior. O valor do argumento <span class="highlighted-text">`eta`</span> <span style="font-size: 100%;">$\(\eta\)$</span> é definido como 0.5 para equilibrar a decisão atual em relação à decisão tomada na partida anterior.


```r
sim_game(
  game = jogo2,
  n_samples = 10,
  n_periods = 20,
  type = "br",
  eta = 0.5,
  lambda = 1 
  )
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game17-1.png" width="672" style="display: block; margin: auto;" />

Em outra opção como <span class="highlighted-text">`"imitation"`</span> em que os jogadores imitam a escolha do outro no período anterior, copiando a estratégia escolhida pelo oponente no período anterior.


```r
sim_game(
  game = jogo2,
  n_samples = 1,
  n_periods = 10,
  type = "imitation",
  eta = 0.7,
  lambda = 0.8
  )
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game18-1.png" width="672" style="display: block; margin: auto;" />

Nesse caso, o parâmetro <span class="highlighted-text">`eta`</span> é definido como 0.7 para controlar a aleatoriedade no comportamento dos jogadores, enquanto o <span class="highlighted-text">`lambda`</span> é definido como 0.8.

Adicionalmente, o parâmetro <span class="highlighted-text">`type`</span> presente na função <span class="highlighted-text">`sim_game()`</span> disponibiliza outras opções para simulação, incluindo:

- <span class="highlighted-text">`"sbr"`</span> (*Soft Best Response*): Nessa abordagem, os jogadores optam por uma resposta suavizada às jogadas do oponente em períodos anteriores. Isso implica que eles não mudam suas estratégias abruptamente, mas, ao invés disso, ajustam-nas gradualmente com base nas escolhas prévias do oponente.

- <span class="highlighted-text">`"abr"`</span> (*Alternating Best Response*): Os jogadores tomam decisões alternadas, escolhendo a melhor resposta possível para a ação do oponente. Isso significa que em cada turno, um jogador seleciona a sua melhor opção de acordo com a jogada feita pelo oponente no turno anterior, e no próximo turno, o outro jogador faz o mesmo, baseando-se na escolha do primeiro jogador no turno anterior.

Essas diferentes estratégias de simulação permitem o estudo de como as escolhas dos jogadores evoluem ao longo do tempo e como essas estratégias afetam o resultado do jogo. Cada opção de <span class="highlighted-text">`type`</span> fornece uma abordagem diferente para modelar o comportamento dos jogadores e pode levar a resultados distintos na simulação do jogo.

### Referências 

HAZRA, Tanmoy; ANJARIA, Kushal. Applications of game theory in deep learning: a survey. **Multimedia Tools and Applications**, v. 81, n. 6, p. 8963-8994, 2022. DOI: <a href="https://doi.org/10.1007/s11042-022-12153-2" target="_blank" style="color:#016dea; text-decoration: none;" onmouseover="this.style.color='#014ba0';" onmouseout="this.style.color='#016dea';">https://doi.org/10.1007/s11042-022-12153-2</a>.

MANKIW, N. Gregory et al. **Introdução à economia**. 2005.

YANAI, Yusei; KAMIJO, Yoshio. **Game Theory With R**. Shin-Ogawacho, Shinjuku-ku, Tóquio, JP: Asakura Publishing Co,. Ltd., 2023. 244 p. ISBN 978-4-254-27024-2 C3050.
