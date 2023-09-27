---
title: 'Teoria dos Jogos no R: Jogos Sequenciais e Repetidos'
author: André Melo
date: '2023-09-26'
description: Este tutorial tem como objetivo ensinar como aplicar a teoria dos jogos no ambiente R, utilizando o pacote Rgamer.
slug: jogos-sequenciais-e-repetidos
categories: 
 - Tutorial
 - R
tags: 
 - teoriadosjogos
 - economia
image: jogos-sequenciais-repetidos.jpg
math: yes
license: no
hidden: no
comments: yes
---

<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />

<!--more-->

## Introdução

### Pacotes

Para realização dos passos seguintes, será necessário a instalação e ativação do pacote:


```r
# install.packages("devtools")
# devtools::install_github("yukiyanai/rgamer")
library(rgamer)
library(utf8)
```

## Jogos Sequenciais

Jogos sequenciais são modelos que representam a tomada de decisão em sequência, levando em conta as escolhas dos jogadores e as informações disponíveis. A análise desses jogos envolve a busca por estratégias ótimas e a previsão dos desdobramentos com base nessas estratégias. Na aplicação de jogos sequenciais no R, há funções que auxiliam na construção gráfica da forma extensiva e sequencial do jogo.

<div id="botoesSequencial">
  <button id="botao-sequencial1" class="botao-interativo-sequencial" onclick="showConteudoSequencial('sequencial1')">Forma Extensiva</button>
  <button id="botao-sequencial2" class="botao-interativo-sequencial" onclick="showConteudoSequencial('sequencial2')">Forma Sequencial</button>
</div>  

<script>
window.onload = function() {
    showConteudoSequencial('sequencial1');
    showConteudoPath('path1'); // Exibir conteúdo do método1 por padrão
    showConteudoENPS('enps1'); // Exibir conteúdo do exemplo1 por padrão
    showConteudoRepetido('repetido1');
  };
</script>

<script>
function showConteudoSequencial(conteudoId) {
  var conteudos = document.getElementsByClassName('conteudoSequencial');
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

  // Remover a classe 'selecionadoSequencial' de todos os botões
  var botoes = document.getElementsByClassName('botao-interativo-sequencial');
  for (var i = 0; i < botoes.length; i++) {
    botoes[i].classList.remove('selecionadoSequencial');
  }

  // Adicionar a classe 'selecionadoExemplo' apenas ao botão clicado
  var botaoSelecionado = document.getElementById('botao-' + conteudoId);
  botaoSelecionado.classList.add('selecionadoSequencial');
}
</script>

<style type="text/css">
/* JOGOS SEQUENCIAIS- PARTE 1 -- COMEÇO */
 #botoesSequencial {
    display: flex;
    justify-content: center;
  }
  .botao-interativo-sequencial {
    background-color: transparent;
    border-color: transparent;
    margin-left: 10px;
    padding: 5px 10px;
    color: #016dea;
    border-radius: 0.5rem;
    font-size: 15px;
    transition: background-color 0.3s;
    width: auto; /* Largura automática para ajustar ao tamanho do texto */
    white-space: nowrap; /* Evita que o texto quebre em várias linhas */
  }

  .botao-interativo-sequencial:hover {
    background-color: #E5E5E5;
    color: #002e63;
  }

  .botao-interativo-sequencial.selecionadoSequencial {
    background-color: #0766a6;
    color: white;
  }

  .conteudoSequencial {
    opacity: 0;
    transition: opacity 0.5s;
  }

/* JOGOS SEQUENCIAIS -- FIM */

/* JOGOS SEQUENCIAIS- PARTE2 -- COMEÇO */
 #botoesPath {
    display: flex;
    justify-content: center;
  }
  .botao-interativo-path {
    background-color: transparent;
    border-color: transparent;
    margin-left: 10px;
    padding: 5px 10px;
    color: #016dea;
    border-radius: 0.5rem;
    font-size: 15px;
    transition: background-color 0.3s;
    width: auto; /* Largura automática para ajustar ao tamanho do texto */
    white-space: nowrap; /* Evita que o texto quebre em várias linhas */
  }

  .botao-interativo-path:hover {
    background-color: #E5E5E5;
    color: #002e63;
  }

  .botao-interativo-path.selecionadoPath {
    background-color: #0766a6;
    color: white;
  }

  .conteudoPath {
    opacity: 0;
    transition: opacity 0.5s;
  }

/* JOGOS SEQUENCIAIS-PARTE 2 -- FIM */

/* JOGOS SEQUENCIAIS-EQ NASH -- COMEÇO */
   #botoesENPS {
    display: flex;
    justify-content: center;
  }
  .botao-interativo-enps {
    background-color: transparent;
    border-color: transparent;
    margin-left: 10px;
    padding: 5px 10px;
    color: #016dea;
    border-radius: 0.5rem;
    font-size: 15px;
    transition: background-color 0.3s;
    width: auto; /* Largura automática para ajustar ao tamanho do texto */
    white-space: nowrap; /* Evita que o texto quebre em várias linhas */
  }

  .botao-interativo-enps:hover {
    background-color: #E5E5E5;
    color: #002e63;
  }

  .botao-interativo-enps.selecionadoENPS {
    background-color: #0766a6;
    color: white;
  }

  .conteudoENPS {
    opacity: 0;
    transition: opacity 0.5s;
  }

/* ----------------- JOGOS SEQUENCIAIS FIM ------------------ */

/* ----------------- JOGOS REPETIDOS COMEÇO ------------------ */
 #botoesRepetido {
    display: flex;
    justify-content: center;
  }
  .botao-interativo-repetido {
    background-color: transparent;
    border-color: transparent;
    margin-left: 10px;
    padding: 5px 10px;
    color: #016dea;
    border-radius: 0.5rem;
    font-size: 15px;
    transition: background-color 0.3s;
    width: auto; /* Largura automática para ajustar ao tamanho do texto */
    white-space: nowrap; /* Evita que o texto quebre em várias linhas */
  }

  .botao-interativo-repetido:hover {
    background-color: #E5E5E5;
    color: #002e63;
  }

  .botao-interativo-repetido.selecionadoRepetido {
    background-color: #0766a6;
    color: white;
  }

  .conteudoRepetido {
    opacity: 0;
    transition: opacity 0.5s;
  }
</style>

<style type="text/css">

/* ---------- JOGOS REPETIDOS ERROS ------------ */

.callout {
  border: 1px solid #ccc;
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
}

.callout-title {
  font-weight: bold;
  margin-bottom: -10px;
  margin-left: 0.5rem;
  margin-top: -10px;
}

.callout-content {
  padding: 10px; /* Adicione padding para espaçamento */
  margin-bottom: -50px;
}

.callout-container {
  background: #e63946;
  color: white;
  padding: 10px;
  display: flex;
  align-items: center;
}

/* ERRO 1 */
.output-exemplo {
  font-family: 'Lucida Console';
  font-size: 15px;
  line-height: 1.4;
  white-space: nowrap;
  padding: 20px;
  position: relative;
  top: -20px;
  border: none;
  background: none;
  width: 100%; /* Defina a largura como 100% */
}

/* ERRO 2 - COMEÇO */
.output-matrix {
  font-family: 'Lucida Console';
  font-size: 15px;
  line-height: 1.4;
  white-space: nowrap;
  padding: 20px;
  position: relative;
  top: -20px;
  border: none;
  background: none;
  width: 100%; /* Defina a largura como 100% */
}

</style>

<div id="sequencial1" class="conteudoSequencial">

Na representação extensiva, podemos utilizar o exemplo mencionado anteriormente da guerra de preços entre dois postos de gasolina. Nessa estrutura de jogo, ao contrário da forma normal, os jogadores tomam decisões em uma ordem específica. Começando com o posto "OilFlex", que é o jogador inicial e tem um nó na árvore de decisão, e "EconoGas", que é repetido duas vezes porque possui dois nós, um para cada situação em que pode reagir às ações tomadas pelo outro posto de gasolina. Essa diferenciação ocorre porque o jogador inicial, neste caso, começa a árvore de decisão, enquanto o segundo jogador reage a essa ação inicial. O mesmo princípio se aplica às estratégias no argumento <span class="highlighted-text">`actions`</span>, que consiste nas estratégias <span class="highlighted-text">`"Manter"`</span>" e <span class="highlighted-text">`"Reduzir"`</span> para o jogador 1 e 2.

Ao definir <span class="highlighted-text">`rep(NA, 4)`</span> dentro do argumento <span class="highlighted-text">`players`</span>, estamos indicando que os nós terminais se repetirão quatro vezes, refletindo as possíveis combinações de ações ao longo da árvore de decisão. A estrutura de <span class="highlighted-text">`payoffs`</span> é feita em uma lista com o nome dos jogadores, seguida pela especificação de seus ganhos para cada combinação de ações. Essa estrutura, diferentemente da forma normal, é necessária porque a representação extensiva é mais detalhada e explícita, mostrando a árvore de decisão completa do jogo, passo a passo, com informações sobre as ações tomadas em cada nó da árvore. Dessa forma, os payoffs são especificados separadamente para cada jogador em cada nó, permitindo uma representação detalhada das recompensas em cada cenário do jogo.



```r
jogo7 <- extensive_form(
          players = list("OilFlex",
                         c("EconoGas", "EconoGas"),
                         rep(NA, 4)),
          actions = list(c("Manter", "Reduzir"),
                         c("Manter", "Reduzir"), c("Manter", "Reduzir")),
          payoffs = list(OilFlex = c(50, 30, 60, 40),
                         EconoGas = c(50, 60, 30, 40)),
          show_node_id = FALSE)
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game7b-1.png" width="672" style="display: block; margin: auto;" />

Quando <span class="highlighted-text">`show_node_id`</span> é definido como <span class="highlighted-text">`FALSE`</span> (sendo <span class="highlighted-text">`TRUE`</span> o valor padrão), a árvore de decisões é exibida de maneira simplificada, sem a numeração de cada nó na árvore.

</div>

<div id="sequencial2" class="conteudoSequencial">


Nesse outro método, iniciamos a estruturação do exemplo utilizando a função <span class="highlighted-text">`seq_form()`</span>, o que nos permite especificar as estratégias dos jogadores e os payoffs associados a cada combinação de estratégias.


```r
sq_jogo8 <- seq_form(
              players = c("OilFlex", "EconoGas"),
              s1 = c("Manter", "Reduzir"), 
              s2 = c("Manter", "Reduzir"), 
              payoffs1 = c(50, 60, 30, 40),
              payoffs2 = c(50, 30, 60, 40))
```

A partir disso, usamos a função <span class="highlighted-text">`seq_extensive()`</span> para transformar um jogo na forma sequencial, definido com <span class="highlighted-text">`seq_form()`</span>, em um jogo na forma extensiva.


```r
jogo8 <- seq_extensive(sq_jogo8, 
                       direction = "right", 
                       color_palette = "Dark2")
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game8b-1.png" width="672" style="display: block; margin: auto;" />

Ao especificarmos o parâmetro <span class="highlighted-text">`direction`</span> como <span class="highlighted-text">`"right"`</span>, a árvore extensiva é direcionada para a direita, e as cores são aplicadas de acordo com a paleta de cores especificada em <span class="highlighted-text">`color_palette`</span>.

</div>

Além disso, é possível utilizar funções que permitem não somente a indução manual dos caminhos, a restrição das opções dos jogadores, mas também outras funcionalidades que incluem a possibilidade da contagem de subjogos em cada ramo da forma extensiva e a transferência dos dados para matrizes. O que contribui para uma análise mais completa e coerente das possibilidades do jogo.

<div id="botoesPath">
  <button id="botao-path1" class="botao-interativo-path" onclick="showConteudoPath('path1')">Função draw_path</button>
  <button id="botao-path2" class="botao-interativo-path" onclick="showConteudoPath('path2')">Subjogos</button>
  <button id="botao-path3" class="botao-interativo-path" onclick="showConteudoPath('path3')">Matriz</button>
</div>

<script>
function showConteudoPath(conteudoId) {
  var conteudos = document.getElementsByClassName('conteudoPath');
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

  // Remover a classe 'selecionadoPath' de todos os botões
  var botoes = document.getElementsByClassName('botao-interativo-path');
  for (var i = 0; i < botoes.length; i++) {
    botoes[i].classList.remove('selecionadoPath');
  }

  var botaoSelecionado = document.getElementById('botao-' + conteudoId);
  botaoSelecionado.classList.add('selecionadoPath');
}
</script>

<div id="path1" class="conteudoPath">

Com a construção da estrutura da forma extensiva, podemos utilizar a função <span class="highlighted-text">`draw_path`</span> para induzir os caminhos específicos em um jogo representado em forma de árvore, definido pela função <span class="highlighted-text">`extensive_form()`</span>. 


```r
draw_path(jogo7, actions = list("Manter", "Manter"))
```

```
The game reaches at n4. 
Payoffs:
```

```
 OilFlex EconoGas 
      50       50 
```


```
The game reaches at n4. 
Payoffs:
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game8cc-1.png" width="672" style="display: block; margin: auto;" />

No R, é possível restringir as ações dos jogadores através da eliminação de certas sequências de jogadas. Essa restrição pode ser feita utilizando o parâmetro <span class="highlighted-text">`actions`</span> da função <span class="highlighted-text">`restrict_action()`</span>, que recebe uma lista de vetores. Ao utilizar essa função, é possível controlar quais jogadas são permitidas em cada estágio do jogo sequencial. 


```r
restrict_action(jogo7, action = list("n1" = "Reduzir", 
                                     "n2" = "Reduzir"))
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game8e-1.png" width="672" style="display: block; margin: auto;" />

Ao observar o parâmetro <span class="highlighted-text">`action`</span>, percebemos que ele contém a identificação dos nós do jogo, neste caso, <span class="highlighted-text">`"n1"`</span> e <span class="highlighted-text">`"n2"`</span>, juntamente com as ações correspondentes, que são <span class="highlighted-text">`"Reduzir"`</span> e <span class="highlighted-text">`"Reduzir"`</span>.

</div>

<div id="path2" class="conteudoPath">

A função <span class="highlighted-text">`subgames()`</span> é usada para encontrar e identificar os subjogos dentro de um jogo em forma extensiva. Um subjogo é uma parte do jogo que pode ser analisada e tratada separadamente.


```r
subgames(jogo7, quietly = FALSE)
```

```
The game has 3 subgames.
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game8g-1.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/game8g-2.png" width="672" style="display: block; margin: auto;" /><img src="{{< blogdown/postref >}}index_files/figure-html/game8g-3.png" width="672" style="display: block; margin: auto;" />

Ao utilizar o parâmetro <span class="highlighted-text">`quietly = FALSE`</span>, a mensagem de contagem de subjogos será exibida juntamente com os gráficos.

</div>

<div id="path3" class="conteudoPath">

A função <span class="highlighted-text">`to_matrix`</span> é usada para transformar um jogo em forma extensiva, com dois jogadores, em um jogo em forma normal. Isso permite representar o jogo em uma matriz de ganhos, onde as estratégias ou perfis de ações são especificados.


```r
jogo7mx <- to_matrix(jogo7)
```

Para visualizar o data frame que contém as matrizes dos jogadores 1 e 2, basta utilizar o objeto criado anteriormente, nomeado como <span class="highlighted-text">`jogo7mx`</span>, e acrescentar <span class="highlighted-text">`$df`</span>. Nesse data frame, as colunas <span class="highlighted-text">`payoff1`</span> e <span class="highlighted-text">`s1`</span> representam, respectivamente, os ganhos e as estratégias do posto OilFlex, enquanto as colunas <span class="highlighted-text">`payoff2`</span> e <span class="highlighted-text">`s2`</span> representam os ganhos e estratégias da EconoGas.


```r
jogo7mx$df
```

```
  row column        s1                 s2 payoff1 payoff2
1   1      1  (Manter)   (Manter, Manter)      50      50
2   1      2  (Manter)  (Manter, Reduzir)      50      50
3   1      3  (Manter)  (Reduzir, Manter)      30      60
4   1      4  (Manter) (Reduzir, Reduzir)      30      60
5   2      1 (Reduzir)   (Manter, Manter)      60      30
6   2      2 (Reduzir)  (Manter, Reduzir)      40      40
7   2      3 (Reduzir)  (Reduzir, Manter)      60      30
8   2      4 (Reduzir) (Reduzir, Reduzir)      40      40
```

Na visualização dos payoffs de cada jogador, é necessário utilizar a função <span class="highlighted-text">`matrix()`</span> em <span class="highlighted-text">`jogo7mx$mat$matrix1`</span>. Desse modo, é possível identificar as jogadas e os ganhos do jogador 1.


```r
# Payoff do posto "OilFlex"
matrix(jogo7mx$mat$matrix1, 
       nrow = 2, 
       dimnames = list(c('M', 'R'), 
                       c('MM', 'MR', 'RM', 'RR')))
```

```
  MM MR RM RR
M 50 50 30 30
R 60 40 60 40
```

Ao utilizar o argumento <span class="highlighted-text">`dimnames`</span> para especificar os nomes das colunas e linhas de uma matriz. Dessa forma, é implementada por meio de uma lista, permitindo uma representação mais intuítiva das ações dos jogadores (Manter e Reduzir) e dos payoffs correspondentes ao jogador 1 e 2.


```r
# Payoff do posto "EconoGas"
matrix(jogo7mx$mat$matrix2, 
       nrow = 2, 
       dimnames = list(c('M', 'R'), 
                       c('MM', 'MR', 'RM', 'RR')))
```

```
  MM MR RM RR
M 50 50 60 60
R 30 40 30 40
```

Quando utilizamos o argumento <span class="highlighted-text">`nrow = 2`</span>, estamos essencialmente informando que a matriz terá duas linhas, cada uma representando as ações "Reduzir" (<span class="highlighted-text">`'R'`</span>) e "Manter" (<span class="highlighted-text">`'M'`</span>). Vale notar que, ao especificar o número de linhas, o ambiente R define automaticamente o número de colunas com base nessa especificação. 

</div>

### Eq. de Nash Perfeito em Subjogos 

O Equilíbrio de Nash Perfeito em Subjogos (ENPS) é um conceito utilizado na teoria dos jogos para analisar estratégias em jogos sequenciais. Ele consiste em um conjunto de estratégias, uma para cada jogador, que representa um equilíbrio de Nash em cada subjogo do jogo original.

<div id="botoesENPS">
  <button id="botao-enps1" class="botao-interativo-enps" onclick="showConteudoENPS('enps1')">Função solve_efg</button>
  <button id="botao-enps2" class="botao-interativo-enps" onclick="showConteudoENPS('enps2')">Função solve_seq</button>
</div>

<script>
function showConteudoENPS(conteudoId) {
  var conteudos = document.getElementsByClassName('conteudoENPS');
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
  
  var botoes = document.getElementsByClassName('botao-interativo-enps');
  for (var i = 0; i < botoes.length; i++) {
    botoes[i].classList.remove('selecionadoENPS');
  }
  
  var botaoSelecionado = document.getElementById('botao-' + conteudoId);
  botaoSelecionado.classList.add('selecionadoENPS');
}
</script>

<div id="enps1" class="conteudoENPS">

O <span class="highlighted-text">`solve_efg`</span> permite encontrar soluções para jogos em forma extensiva. Ele recebe como entrada um jogo em forma extensiva definido previamente e retorna uma lista de soluções encontradas, baseadas no conceito de solução escolhido pelo usuário.

Existem duas opções para o conceito de solução: <span class="highlighted-text">`"backward"`</span> (Indução Retroativa) e <span class="highlighted-text">`"spe"`</span> (Equilíbrio Perfeito em Subjogos), ambos obtêm o mesmo resultado.


```r
solve_efg(jogo7, concept = "backward", quietly = FALSE)
```

```
backward induction: [(Reduzir), (Reduzir, Reduzir)]
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game10d-1.png" width="672" style="display: block; margin: auto;" />

Ou pode-se chegar ao gráfico de melhores respostas pelo comando `show_path()`.


```r
show_path(jogo7)
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game7d-1.png" width="672" style="display: block; margin: auto;" />

Também é possível obter a tabela a partir da matriz usando a função <span class="highlighted-text">`solve_nfg()`</span> e determinar os equilíbrios de Nash e Equilíbrio de Nash Perfeito em Subjogos a partir das informações mencionadas no tópico anterior.


```r
# Matriz do jogo 7
jogo7mxtab <- solve_nfg(jogo7mx)
```

```
Pure-strategy NE: [(Reduzir), (Reduzir, Reduzir)]
```

<br>

 <table class=" lightable-classic table" style="font-family: Arial; margin-left: auto; margin-right: auto; width: auto !important; margin-left: auto; margin-right: auto;">
  <thead>
 <tr>
 <th style="empty-cells: hide;" colspan="2"></th>
 <th style="padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; font-weight: bold; " colspan="4"><div style="border-bottom: 1px solid #111111; margin-bottom: -1px; ">EconoGas</div></th>
 </tr>
   <tr>
    <th style="text-align:left;">   </th>
    <th style="text-align:center;"> strategy </th>
    <th style="text-align:center;"> (Manter, Manter) </th>
    <th style="text-align:center;"> (Manter, Reduzir) </th>
    <th style="text-align:center;"> (Reduzir, Manter) </th>
    <th style="text-align:center;"> (Reduzir, Reduzir) </th>
   </tr>
  </thead>
 <tbody>
   <tr>
    <td style="text-align:left;font-weight: bold;"> OilFlex </td>
    <td style="text-align:center;"> (Manter) </td>
    <td style="text-align:center;"> 50, 50 </td>
    <td style="text-align:center;"> 50^, 50 </td>
    <td style="text-align:center;"> 30, 60^ </td>
    <td style="text-align:center;"> 30, 60^ </td>
   </tr>
   <tr>
    <td style="text-align:left;font-weight: bold;">  </td>
    <td style="text-align:center;"> (Reduzir) </td>
    <td style="text-align:center;"> 60^, 30 </td>
    <td style="text-align:center;"> 40, 40^ </td>
    <td style="text-align:center;"> 60^, 30 </td>
    <td style="text-align:center;"> 40^, 40^ </td>
   </tr>
 </tbody>
 </table>
 
Assim, o ENPS ocorre quando o posto EconoGas adota as estratégias de "Reduzir, Reduzir", em resposta à redução de preços realizada pelo posto OilFlex.

</div>

<div id="enps2" class="conteudoENPS">

O <span class="highlighted-text">`solve_seq`</span> aceita um jogo em forma sequencial como entrada e retorna os equilíbrios de Nash encontrados, se houver. Além disso, ele também pode exibir uma tabela com as jogadas e estratégias ótimas para cada jogador, facilitando a análise e compreensão dos resultados.

No exemplo anterior, utilizamos a função <span class="highlighted-text">`seq_form()`</span> para estruturar um jogo na forma sequencial, a partir de uma forma normal. Em seguida, aplicamos o <span class="highlighted-text">`solve_seq()`</span> para transformar o jogo da forma extensiva novamente para a forma normal.


```r
solve_seq(
  sq_jogo8,
  show_table = TRUE,
  mark_br = FALSE,
  precision = 1L,
  quietly = FALSE
  )
```

```
SPE outcome: (Reduzir, Reduzir)
```

<br>

 <table class=" lightable-classic table" style="font-family: Arial; margin-left: auto; margin-right: auto; width: auto !important; margin-left: auto; margin-right: auto;">
  <thead>
 <tr>
 <th style="empty-cells: hide;" colspan="2"></th>
 <th style="padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; font-weight: bold; " colspan="2"><div style="border-bottom: 1px solid #111111; margin-bottom: -1px; ">EconoGas</div></th>
 </tr>
   <tr>
    <th style="text-align:left;">   </th>
    <th style="text-align:center;"> strategy </th>
    <th style="text-align:center;"> Manter </th>
    <th style="text-align:center;"> Reduzir </th>
   </tr>
  </thead>
 <tbody>
   <tr>
    <td style="text-align:left;font-weight: bold;"> OilFlex </td>
    <td style="text-align:center;"> Manter </td>
    <td style="text-align:center;"> 50, 50 </td>
    <td style="text-align:center;"> 60, 30 </td>
   </tr>
   <tr>
    <td style="text-align:left;font-weight: bold;">  </td>
    <td style="text-align:center;"> Reduzir </td>
    <td style="text-align:center;"> 30, 60 </td>
    <td style="text-align:center;"> 40, 40 </td>
   </tr>
 </tbody>
 </table>

Já o argumento <span class="highlighted-text">`precision`</span> afeta a formatação dos valores exibidos na tabela de solução, determinando o número de casas decimais a serem apresentadas. Por exemplo, ao definir <span class="highlighted-text">`precision = 1L`</span>, os valores serão arredondados para uma casa decimal, já que o uso de <span class="highlighted-text">`1L`</span> assegura que a precisão seja interpretada como um número inteiro.

</div>

Encontrar o ENPS envolve analisar cada subjogo, identificar os equilíbrios de Nash em cada um e verificar se esses equilíbrios são compatíveis entre si ao longo de todo o jogo. Caso exista um conjunto de estratégias que satisfaça essas condições, temos um Equilíbrio de Nash Perfeito em Subjogos.

## Jogos Repetidos

<div class="reta">
  <div class="reta-hover"></div>
</div>

Em jogos repetidos é possível definir os jogadores envolvidos e as ações disponíveis para cada um em cada rodada, de forma que os payoffs podem ser atribuídos a diferentes combinações de ações ao longo do tempo. Esse enfoque permite uma exploração mais profunda das complexas dinâmicas estratégicas que emergem quando os jogadores interagem repetidamente. À medida que eles se envolvem em múltiplas rodadas é ajustado suas estratégias com base nas escolhas anteriores dos adversários, construindo gradualmente um aprendizado estratégico.

### Jogos Repetidos Finitos

Considerando um exemplo de jogo repetido finito entre dois países, <span class="highlighted-text">`"P1"`</span> e <span class="highlighted-text">`"P2"`</span>, que estão em um cenário de possíveis conflitos e cooperação, representados pelas ações de "Guerra" (<span class="highlighted-text">`"G"`</span>) e "Paz" (<span class="highlighted-text">`"P"`</span>). Nesse contexto, os jogadores estão envolvidos em quatro períodos de decisão. Eles estão avaliando se devem optar por "Guerra" ou "Paz" em cada período.

Comparando com a estrutura de Jogos Sequenciais, onde o argumento <span class="highlighted-text">`players`</span> continha <span class="highlighted-text">`rep()`</span> apenas no final e era definido por <span class="highlighted-text">`NA`</span> juntamente com o número de nós terminais. Em Jogos Repetidos, podemos utilizar a função <span class="highlighted-text">`rep()`</span> de forma mais detalhada.

Nesse caso, começamos com as jogadas de P2, pois as ações de P2 se repetirão sequencialmente após a ação do jogador inicial. Portanto, usamos <span class="highlighted-text">`"P2", 2`</span> e assim por diante. Em sequência, teremos <span class="highlighted-text">`"P1", 4`</span>, o que significa que cada nó da jogada anterior de P2 se ramificará em dois nós, representando os 4 nós de P1. Na configuração <span class="highlighted-text">`rep(NA, 16)`</span>, o valor <span class="highlighted-text">`NA`</span> indica que não há mais jogadas de nenhum jogador, apenas os nós terminais, que serão 16.

Nessa situação, especificamos duas estratégias para ambos os jogadores. Consequentemente, o número de repetições dos nós será sempre o dobro do anterior, como ilustrado abaixo.


```r
jogo9 <- extensive_form(
            players = list("P1",         # n1
                           rep("P2", 2), # n2 e n3
                           rep("P1", 4), # n4 - n7
                           rep("P2", 8), # n8 - n15
                           rep(NA, 16)), # Nós terminais
            actions = list(
              c("G", "P"), c("G", "P"), c("G", "P"), # n1 - n3
              c("G", "P"), c("G", "P"), c("G", "P"), # n4 - n6
              c("G", "P"), c("G", "P"), c("G", "P"), # n7 - n9
              c("G", "P"), c("G", "P"), c("G", "P"), # n10 - n12
              c("G", "P"), c("G", "P"), c("G", "P")  # n13 - n15
            ),
            payoffs = list(
              P1 = c(6, 5, 6, 4, 5, 3, 6, 2, 8, 4, 7, 6, 7, 3, 6, 4),
              P2 = c(8, 5, 6, 4, 7, 5, 6, 8, 6, 2, 3, 3, 6, 3, 4, 7)
            ),
            direction = "down",
            show_node_id = FALSE
          )
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game19b-1.png" width="672" style="display: block; margin: auto;" />

O exemplo acima possui uma estrutura de árvore com 15 nós, numerados de <span class="highlighted-text">`n1`</span> a <span class="highlighted-text">`n15`</span>. Em cada nó, os jogadores têm a opção de escolher entre duas ações. Por exemplo, os três primeiros nós (<span class="highlighted-text">`n1`</span> a <span class="highlighted-text">`n3`</span>) representam as escolhas de ação dos jogadores no primeiro período. 

Ao resolver o jogo acima por indução retroativa é possível visualizar as estratégias escolhidas pelos dois jogadores.


```r
s_jogo9 <- solve_efg(jogo9, concept = "backward", quietly = FALSE)
```

```
backward induction: [(P, G, G, G, G), (G, G, G, G, G, P, G, G, G, P)], [(P, G, G, G, G), (G, P, G, G, G, P, G, G, G, P)], [(P, P, G, G, G), (P, G, G, G, G, P, G, G, G, P)], [(P, P, G, G, G), (P, P, G, G, G, P, G, G, G, P)], [(P, G, G, G, G), (G, G, G, G, G, P, G, P, G, P)], [(P, G, G, G, G), (G, P, G, G, G, P, G, P, G, P)], [(P, P, G, G, G), (P, G, G, G, G, P, G, P, G, P)], [(P, P, G, G, G), (P, P, G, G, G, P, G, P, G, P)]
```



Em jogos repetidos, as árvores de decisão geralmente se tornam mais complexas, devido à repetição das jogadas pelos jogadores. Como observado anteriormente, foram identificadas oito soluções por meio da análise de indução retroativa.


```r
s_jogo9$sols
```

```
[[1]]
[1] "[(P, G, G, G, G), (G, G, G, G, G, P, G, G, G, P)]"

[[2]]
[1] "[(P, G, G, G, G), (G, P, G, G, G, P, G, G, G, P)]"

[[3]]
[1] "[(P, P, G, G, G), (P, G, G, G, G, P, G, G, G, P)]"

[[4]]
[1] "[(P, P, G, G, G), (P, P, G, G, G, P, G, G, G, P)]"

[[5]]
[1] "[(P, G, G, G, G), (G, G, G, G, G, P, G, P, G, P)]"

[[6]]
[1] "[(P, G, G, G, G), (G, P, G, G, G, P, G, P, G, P)]"

[[7]]
[1] "[(P, P, G, G, G), (P, G, G, G, G, P, G, P, G, P)]"

[[8]]
[1] "[(P, P, G, G, G), (P, P, G, G, G, P, G, P, G, P)]"
```


Utilizando o nome do objeto criado, <span class="highlighted-text">`s_jogo9`</span>, em conjunto com o atributo <span class="highlighted-text">`$n_sols`</span>, é possível obter o número total de soluções, que neste contexto específico é representado como <span class="highlighted-text">`[1] 8`</span>. Em uma análise mais aprofundada de uma das soluções, podemos escolher a primeira solução por meio da combinação entre <span class="highlighted-text">`s_jogo9`</span> e <span class="highlighted-text">`$trees[[1]]`</span>, que corresponde à representação visual da solução <span class="highlighted-text">`$sols[[1]]`</span>, ou seja, a primeira solução em formato de árvore.


```r
s_jogo9$trees[[1]]
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game21e-1.png" width="672" style="display: block; margin: auto;" />

Para cada solução em formato de combinação (<span class="highlighted-text">`$sols`</span>) é possível se chegar a uma representação gráfica em árvore de decisão (<span class="highlighted-text">`$trees`</span>).

 
<div id="botoesRepetido">
  <button id="botao-repetido1" class="botao-interativo-repetido" onclick="showConteudoRepetido('repetido1')">Parâmetro info_sets</button>
  <button id="botao-repetido2" class="botao-interativo-repetido" onclick="showConteudoRepetido('repetido2')">3 Jogadores</button>
</div>  

<script>
function showConteudoRepetido(conteudoId) {
  var conteudos = document.getElementsByClassName('conteudoRepetido');
  for (var i = 0; i < conteudos.length; i++) {
    conteudos[i].style.opacity = 0; // Definir a opacidade do conteúdo como 0 (invisível)
    conteudos[i].style.display = 'none'; // Esconder o conteúdo (display: none)
  }
  
  var conteudoDesejado = document.getElementById(conteudoId);
  conteudoDesejado.style.display = 'block'; // Exibir o conteúdo (display: block)
  setTimeout(function() {
    conteudoDesejado.style.opacity = 1; // Definir a opacidade do conteúdo como 1 (visível)
  }, 50); // Aguardar 50 milissegundos para aplicar a opacidade (ajuste conforme desejado)

  var botoes = document.getElementsByClassName('botao-interativo-repetido');
  for (var i = 0; i < botoes.length; i++) {
    botoes[i].classList.remove('selecionadoRepetido');
  }

  var botaoSelecionado = document.getElementById('botao-' + conteudoId);
  botaoSelecionado.classList.add('selecionadoRepetido');
}
</script>

<div id="repetido1" class="conteudoRepetido">

Os conjuntos de informações podem ser especificados no argumento <span class="highlighted-text">`info_sets`</span>, agrupando, dessa forma, os nós nos quais um jogador não consegue distinguir as ações tomadas por seu oponente. Por exemplo, os nós <span class="highlighted-text">`n2`</span> e <span class="highlighted-text">`n3`</span> formam um conjunto de informações para o jogador P1, indicando que ele não sabe qual ação o jogador P2 escolheu nos nós <span class="highlighted-text">`n2`</span> e <span class="highlighted-text">`n3`</span>.


```r
jogo9info <- extensive_form(
            players = list("P1",         # n1
                           rep("P2", 2), # n2 e n3
                           rep("P1", 4), # n4 - n7
                           rep("P2", 8), # n8 - n15
                           rep(NA, 16)), # Nós terminais
            actions = list(
              c("G", "P"), c("G", "P"), c("G", "P"), # n1 - n3
              c("G", "P"), c("G", "P"), c("G", "P"), # n4 - n6
              c("G", "P"), c("G", "P"), c("G", "P"), # n7 - n9
              c("G", "P"), c("G", "P"), c("G", "P"), # n10 - n12
              c("G", "P"), c("G", "P"), c("G", "P")  # n13 - n15
            ),
            payoffs = list(
              P1 = c(6, 5, 6, 4, 5, 3, 6, 2, 8, 4, 7, 6, 7, 3, 6, 4),
              P2 = c(8, 5, 6, 4, 7, 5, 6, 8, 6, 2, 3, 3, 6, 3, 4, 7)
            ),
            direction = "down",
            info_sets = list(c(2,3), c(8, 9), c(10, 11),
                             c(12, 13), c(14, 15)),
            show_node_id = FALSE
          )
```

<br>

<img src="{{< blogdown/postref >}}index_files/figure-html/game20b-1.png" width="672" style="display: block; margin: auto;" />

Devido à falta de conhecimento por parte do jogador P1 em relação às estratégias escolhidas pelo jogador P2, encontrar uma solução para esse jogo torna-se um desafio. Especialmente em cenários onde os jogadores estão alheios às estratégias dos demais participantes, como é o caso apresentado abaixo ao tentar aplicar o conceito de indução retroativa para elucidar as escolhas estratégicas de P1 e P2.



```r
solve_efg(jogo9info, concept = "backward", quietly = FALSE)
```

<br>

<div class="callout-container">
  <div>
    <svg viewBox="0 0 512 512" style="position:relative;display:inline-block;top:.1em;fill:#f1faee;height:1.2em;" xmlns="http://www.w3.org/2000/svg">  <path d="M440.5 88.5l-52 52L415 167c9.4 9.4 9.4 24.6 0 33.9l-17.4 17.4c11.8 26.1 18.4 55.1 18.4 85.6 0 114.9-93.1 208-208 208S0 418.9 0 304 93.1 96 208 96c30.5 0 59.5 6.6 85.6 18.4L311 97c9.4-9.4 24.6-9.4 33.9 0l26.5 26.5 52-52 17.1 17zM500 60h-24c-6.6 0-12 5.4-12 12s5.4 12 12 12h24c6.6 0 12-5.4 12-12s-5.4-12-12-12zM440 0c-6.6 0-12 5.4-12 12v24c0 6.6 5.4 12 12 12s12-5.4 12-12V12c0-6.6-5.4-12-12-12zm33.9 55l17-17c4.7-4.7 4.7-12.3 0-17-4.7-4.7-12.3-4.7-17 0l-17 17c-4.7 4.7-4.7 12.3 0 17 4.8 4.7 12.4 4.7 17 0zm-67.8 0c4.7 4.7 12.3 4.7 17 0 4.7-4.7 4.7-12.3 0-17l-17-17c-4.7-4.7-12.3-4.7-17 0-4.7 4.7-4.7 12.3 0 17l17 17zm67.8 34c-4.7-4.7-12.3-4.7-17 0-4.7 4.7-4.7 12.3 0 17l17 17c4.7 4.7 12.3 4.7 17 0 4.7-4.7 4.7-12.3 0-17l-17-17zM112 272c0-35.3 28.7-64 64-64 8.8 0 16-7.2 16-16s-7.2-16-16-16c-52.9 0-96 43.1-96 96 0 8.8 7.2 16 16 16s16-7.2 16-16z"></path></svg>
  </div>
  <div class="callout-title">
    Error in backward_induction()
  </div>
</div>
<div class="callout-content">
  <div class="output-matrix">
<pre>
  <span>Error in backward_induction(game, restriction = tree_overlay): This is not a perfect-information game.</span>
</pre>
</div>
</div>

  Nesse caso, há um erro ao empregar a função <span class="highlighted-text">`backward_induction()`</span> ou <span class="highlighted-text">`solve_efg()`</span>, pois o jogo em questão não se encaixa na categoria de informação perfeita (*Perfect-Information*). Em <span class="highlighted-text">`restriction = tree_overlay`</span> ocorre a restrição de sobreposição na estrutura da árvore, especificamente pelo uso do parâmetro <span class="highlighted-text">`info_sets`</span>.

Em jogos de informação perfeita, os jogadores têm conhecimento completo sobre as ações e movimentos realizados por outros jogadores em cada ponto da árvore de decisão, como exemplo o jogo 7, 8 e 9. Se o jogo contém informações imperfeitas ou incertezas sobre as ações de outros jogadores, a indução reversa ou indução retroativa não pode ser aplicada diretamente, já que ela pressupõe informação perfeita.

</div>

<div id="repetido2" class="conteudoRepetido">

Ao expandir o exemplo, agora com a introdução de um terceiro país <span class="highlighted-text">`"P3"`</span>, novas dimensões estratégicas emergem. Nessa situação ele possui as opções de "Ajudar" (<span class="highlighted-text">`"A"`</span>) e "Desestabilizar" (<span class="highlighted-text">`"D"`</span>). Se P3 escolher "Ajudar", seu objetivo é promover uma abordagem cooperativa entre P1 e P2, encorajando tratados de paz e parcerias, podendo ser alcançado através de diplomacia, oferecendo incentivos econômicos ou compartilhando informações sensíveis.

Por outro lado, se P3 optar por "Desestabilizar", suas ações terão como alvo a erosão da confiança entre P1 e P2, ou seja, ele poderia propagar rumores, incentivar disputas territoriais ou minar acordos já existentes. Ao fazer isso, será criado um ambiente de incerteza e rivalidade, aumentando assim as chances de conflito entre os outros dois países.


```r
jogo10 <- extensive_form(
            players = list("P1",          # n1
                           rep("P2", 2),  # n2 e n3
                           rep("P1", 4),  # n4 - n7
                           rep("P2", 8),  # n8 - n15
                           rep("P3", 16), # n16 - n31
                           rep(NA, 32)),  # Nós terminais
            actions = list(
              c("G", "P"), c("G", "P"), c("G", "P"), # n1 - n3
              c("G", "P"), c("G", "P"), c("G", "P"), # n4 - n6
              c("G", "P"), c("G", "P"), c("G", "P"), # n7 - n9
              c("G", "P"), c("G", "P"), c("G", "P"), # n10 - n12
              c("G", "P"), c("G", "P"), c("G", "P"), # n13 - n15
              # Ações do terceiro país (P3)
              c("A", "D"), c("A", "D"), c("A", "D"), # n16 - n18
              c("A", "D"), c("A", "D"), c("A", "D"), # n19 - n21
              c("A", "D"), c("A", "D"), c("A", "D"), # n22 - n24
              c("A", "D"), c("A", "D"), c("A", "D"), # n25 - n27
              c("A", "D"), c("A", "D"), c("A", "D"), # n28 - n30
              c("A", "D")                            # n31
            ),
            payoffs = list(
              P1 = c(6, 5, 6, 4, 5, 3, 6, 2, 
                     8, 4, 7, 6, 7, 3, 6, 4, 
                     8, 9, 1, 2, 3, 4, 5, 6, 
                     7, 8, 9, 1, 2, 3, 4, 5),
              P2 = c(8, 5, 6, 4, 7, 5, 6, 8, 
                     6, 2, 3, 3, 6, 3, 4, 7,
                     8, 9, 1, 2, 3, 4, 5, 6, 
                     7, 8, 9, 1, 2, 3, 4, 5),
              P3 = sample(1:9, 32, 
                          replace = TRUE)
            ),
            direction = "right",
            show_node_id = FALSE
          )
```


<br>

<div style="text-align:center;">
  <img src="3jogadores.png" alt="Jogo 10">
</div>

Nesta situação, ocorre a expansão do exemplo ao adicionar mais 15 nodos, a fim de incluir o terceiro país no jogo. Além disso, a amostragem dos payoffs é estendida para 32 elementos. Uma abordagem alternativa é a definição dos payoffs de forma aleatória para P3, como realizado através da função <span class="highlighted-text">`sample()`</span>, a qual gera uma seleção aleatória de valores a partir de um vetor.

Ao empregar <span class="highlighted-text">`1:9, 32`</span> como argumento dessa função, é criado um vetor com valores variando de 1 a 9, ou seja, os possíveis ganhos do jogador P3 estão dentro desse intervalo. Esses valores são então repetidos 32 vezes, correspondendo ao número de elementos amostrados. A utilização de <span class="highlighted-text">`replace = TRUE`</span> permite que elementos sejam selecionados mais de uma vez na amostra, possibilitando a repetição de valores nos payoffs do país P3. Caso fosse definido <span class="highlighted-text">`replace = FALSE`</span>, cada valor apareceria apenas uma vez.

Em resumo, essa abordagem amplia a complexidade do exemplo ao adicionar um terceiro país e introduzir aleatoriedade nos payoffs desse jogador por meio da função <span class="highlighted-text">`sample()`</span>.


```r
s_jogo10 <- solve_efg(jogo9, concept = "backward", quietly = FALSE)
```


```
backward induction: [(P, G , G , G , G ), (G, G, G  , G  , G  ,   P, G  , G  , G  ,   P)], [(P, G , G , G , G ), (G, P, G  , G  , G  ,   P, G  , G  , G  ,   P)], [(P,  P, G , G , G ), (P, G, G  , G  , G  ,   P, G  , G  , G  ,   P)], [(P,  P, G , G , G ), (P, P, G  , G  , G  ,   P, G  , G  , G  ,   P)], [(P, G , G , G , G ), (G, G, G  , G  , G  ,   P, G  ,   P, G  ,   P)], [(P, G , G , G , G ), (G, P, G  , G  , G  ,   P, G  ,   P, G  ,   P)], [(P,  P, G , G , G ), (P, G, G  , G  , G  ,   P, G  ,   P, G  ,   P)], [(P,  P, G , G , G ), (P, P, G  , G  , G  ,   P, G  ,   P, G  ,   P)]
```

<br>

<div style="text-align:center;">
  <img src="3jogadoresolved.png" alt="Resolução do jogo 10">
</div>

A presença de P3 adiciona uma nova camada de complexidade. Sua escolha de "Ajudar" em vez de "Desestabilizar" parece ter desempenhado um papel crucial em incentivar a paz entre P1 e P2 nas primeiras rodadas. No entanto, à medida que P1 opta por "Guerra" e P2 responde da mesma forma, o equilíbrio entre os três países se torna mais delicado.

Em síntese, a introdução de P3 com suas estratégias de "Ajudar" e "Desestabilizar" transformou a dinâmica geopolítica. As decisões agora são influenciadas pelas ações de três jogadores, levando a resultados variados e demonstrando como diferentes abordagens podem levar a cenários diversos de cooperação e conflito

Quando se trata de um jogo com três jogadores, como no caso do jogo 9, a função <span class="highlighted-text">`to_matrix()`</span> não pode ser empregada, conforme demonstrado na tentativa a seguir ao utilizá-la.


```r
to_matrix(jogo10)
```

<br>

<div class="callout-container">
  <div>
    <svg viewBox="0 0 512 512" style="position:relative;display:inline-block;top:.1em;fill:#f1faee;height:1.2em;" xmlns="http://www.w3.org/2000/svg">  <path d="M440.5 88.5l-52 52L415 167c9.4 9.4 9.4 24.6 0 33.9l-17.4 17.4c11.8 26.1 18.4 55.1 18.4 85.6 0 114.9-93.1 208-208 208S0 418.9 0 304 93.1 96 208 96c30.5 0 59.5 6.6 85.6 18.4L311 97c9.4-9.4 24.6-9.4 33.9 0l26.5 26.5 52-52 17.1 17zM500 60h-24c-6.6 0-12 5.4-12 12s5.4 12 12 12h24c6.6 0 12-5.4 12-12s-5.4-12-12-12zM440 0c-6.6 0-12 5.4-12 12v24c0 6.6 5.4 12 12 12s12-5.4 12-12V12c0-6.6-5.4-12-12-12zm33.9 55l17-17c4.7-4.7 4.7-12.3 0-17-4.7-4.7-12.3-4.7-17 0l-17 17c-4.7 4.7-4.7 12.3 0 17 4.8 4.7 12.4 4.7 17 0zm-67.8 0c4.7 4.7 12.3 4.7 17 0 4.7-4.7 4.7-12.3 0-17l-17-17c-4.7-4.7-12.3-4.7-17 0-4.7 4.7-4.7 12.3 0 17l17 17zm67.8 34c-4.7-4.7-12.3-4.7-17 0-4.7 4.7-4.7 12.3 0 17l17 17c4.7 4.7 12.3 4.7 17 0 4.7-4.7 4.7-12.3 0-17l-17-17zM112 272c0-35.3 28.7-64 64-64 8.8 0 16-7.2 16-16s-7.2-16-16-16c-52.9 0-96 43.1-96 96 0 8.8 7.2 16 16 16s16-7.2 16-16z"></path></svg>
  </div>
  <div class="callout-title">
    Error in to_matrix()
  </div>
</div>
<div class="callout-content">
  <div class="output-matrix">
<pre>
  <span>Error in to_matrix(jogo10): This function only works with a two-person game.</span>
</pre>
</div>
</div>

Esse erro ocorre pois a função <span class="highlighted-text">`to_matrix()`</span> do pacote Rgamer é projetada para trabalhar com jogos de dois jogadores. A mensagem de erro que está sendo mostrada, "*This function only works with a two-person game*", significa que essa função não é capaz de lidar com jogos envolvendo três jogadores ou mais, pois limita-se a jogos de dois jogadores porque ela transforma a estrutura de um jogo em uma matriz, que é mais adequada para jogos de dois jogadores.

Quando há três jogadores, como no exemplo apresentado, a representação em forma extensiva da árvore de decisão se torna mais clara e menos complexa do que a representação em forma normal por matriz, porém a complexidade aumenta ao considerar as possíveis soluções de indução retroativa, em que cada jogador analisa as escolhas dos outros para determinar suas próprias ações.

Com três ou mais jogadores, a quantidade de combinações possíveis de soluções de indução retroativa cresce exponencialmente. Desse modo, surge mais cenários estratégicos a considerar, tornando impraticável a representação por matriz.

</div>
