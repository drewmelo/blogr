library(tidyverse)
library(beautyxtrar)
library(ggtext)
library(scales)

library(showtext)

font_add_google("Merriweather", "merri")

showtext_auto()

dados <- read_csv("content/post/2025-04-14-teoria-dos-jogos-na-guerra-comercial-de-2025/TradeData_4_17_2025_15_10_56.csv") |> 
  select(
    ano = refYear,
    sigla_pais = reporterISO, 
    sigla_tipo = flowCode, 
    tipo = flowDesc, 
    valor = primaryValue) |> 
  mutate(valor = valor/1e9,
         ano = ymd(paste0(ano, "-01-01")),
         tipo = str_replace_all(tipo, c("Import" = "Importação", "Export" = "Exportação")),
         pais_nome = str_replace_all(sigla_pais, c("BRA" = "Brasil", "CHN" = "China", "USA" = "EUA"))
)

exp_liquida <- dados |> 
  group_by(sigla_pais, pais_nome, ano, tipo) |> 
  summarise(valor_total = sum(valor, na.rm = T), .groups = "drop") |>
  pivot_wider(
    names_from = tipo,
    values_from = valor_total
  ) |> 
  mutate(
    exp_liquida = `Exportação` - `Importação`
  ) |>
    arrange(sigla_pais, ano) |>  # Garante a ordem correta antes do lag
    group_by(sigla_pais) |> 
    mutate(
      tx_var_exp_liquida = (exp_liquida - lag(exp_liquida)) / lag(exp_liquida) * 100
    ) |> 
    ungroup()

obs <- exp_liquida |>
  filter(sigla_pais %in% c("CHN", "USA", "BRA"))

library(stringr)

texto_exp_01 <- str_wrap(
  "O crescimento foi abruptamente interrompido: <br> o setor externo chinês registrou <br> sua primeira contração desde <br> a crise financeira global de 2008.",
  width = 55  # <-- aumente esse número para deixar a caixa mais larga
)

texto_exp_02 <- str_wrap(
  "A China, por outro lado, seguiu uma trajetória oposta. <br> Suas exportações líquidas cresceram 23,72% em 2020, <br> atingindo US$ 519,5 bilhões.",
  width = 35  # <-- aumente esse número para deixar a caixa mais larga
)

texto_exp_03 <- str_wrap(
  "Mesmo após dois anos de <br> tarifas punitivas, as exportações líquidas <br> dos EUA caíram ainda mais, <br> com um déficit que cresceu 5,62% <br> em relação ao ano anterior — passando de <br> -923,2 para -975,1 bilhões de dólares.",
  width = 35  # <-- aumente esse número para deixar a caixa mais larga
)


# Pega o último ponto de cada país
label_final <- exp_liquida |> 
  filter(sigla_pais %in% c("CHN", "USA")) |> 
  group_by(pais_nome) |> 
  filter(ano == max(ano, na.rm = TRUE)) |> 
  ungroup()


# Base do gráfico com dados filtrados e média calculada
p <- exp_liquida |>
  mutate(media_m = mean(exp_liquida, na.rm = TRUE)) |>
  filter(sigla_pais %in% c("CHN", "USA")) |>
  ggplot(aes(x = ano, y = exp_liquida, col = pais_nome))

# Adiciona as linhas de série temporal
p <- p +
  geom_line(linewidth = 1.7, show.legend = FALSE)  # Linhas por país

# Destaque de ponto em 2018 para EUA e China
p <- p +
  geom_point(
    data = \(df) df |> filter(ano == ymd("2018-01-01"), sigla_pais %in% c("CHN", "USA")),
    size = 3.5, shape = 21, fill = "white", stroke = 1.2, show.legend = FALSE
  )

# Destaque de ponto em 2015 para China
p <- p +
  geom_point(
    data = \(df) df |> filter(ano == ymd("2015-01-01"), sigla_pais == "CHN"),
    size = 3.5, shape = 21, fill = "white", stroke = 1.2, show.legend = FALSE
  )

p <- p +
  geom_point(
      data = \(df) df |> filter(ano == ymd("2020-01-01"), sigla_pais == "USA"),
      size = 3.5, shape = 21, fill = "white", stroke = 1.2, show.legend = FALSE
  )

p <- p +
  geom_point(
      data = \(df) df |> filter(ano == ymd("2020-01-01"), sigla_pais == "CHN"),
      size = 3.5, shape = 21, fill = "white", stroke = 1.2, show.legend = FALSE
  )

# Eixo X formatado por ano
p <- p +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y")

p <- p +
  scale_y_continuous(
    labels = scales::dollar_format(suffix = " B", prefix = "US$ ", big.mark = ".", decimal.mark = ","),
    breaks = seq(-1400, 900, 200),
  )

p <- p + scale_color_manual(values = c("#155C7C", "#828282"))

# Linha horizontal com valor médio (exp_liquida média)
p <- p +
  geom_hline(aes(yintercept = media_m), linetype = "dashed")

# Linha vertical destacando o ano de 2018 (início da guerra comercial)
p <- p +
  geom_vline(xintercept = ymd("2018-01-01"), linetype = "dashed")

# Nome dos países ao lado direito das linhas
p <- p +
  geom_text(
    data = label_final,
    aes(x = ano + 100, y = exp_liquida, label = pais_nome, color = pais_nome),
    hjust = 0, size = 4.5, show.legend = FALSE, inherit.aes = FALSE
  )

# Bloco de texto explicativo sobre a guerra comercial
p <- p +
  ggtext::geom_richtext(
    data = data.frame(
      ano = ymd("2014-08-01"),
      exp_liquida = 50,
      label = "<b style='color:#444444;'>Média das Exportações Líquidas</span>"
    ),
    aes(x = ano, y = exp_liquida, label = label),
    fill = "white", label.color = NA,
    label.padding = unit(c(0.5, 0.6, 0.5, 0.6), "lines"),
    hjust = 0.5, vjust = 1, size = 4.5,
    inherit.aes = FALSE,
    show.legend = FALSE
  )

p <- p +
  ggtext::geom_richtext(
    data = data.frame(
      ano = ymd("2018-01-01"),
      exp_liquida = -100,
      label = "<b style='color:#444444;'>Início da<br>Guerra Comercial</span>"
    ),
    aes(x = ano, y = exp_liquida, label = label),
    fill = "white", label.color = NA,
    label.padding = unit(c(0.5, 0.6, 0.5, 0.6), "lines"),
    hjust = 0.5, vjust = 1, size = 4.5,
    inherit.aes = FALSE,
    show.legend = FALSE
  )

# Texto explicativo adicional sobre 2015 (primeira contração da China)
p <- p +
  ggtext::geom_richtext(
    data = data.frame(
      ano = ymd("2015-01-01"),
      exp_liquida = 650,
      label = paste0("<b style='color:#444444;'>", texto_exp_01, "</b>")
    ),
    aes(x = ano, y = exp_liquida, label = label),
    fill = "white", label.color = NA,
    label.padding = unit(c(0.7, 0.6, 0.5, 0.6), "lines"),
    hjust = 0, vjust = 0.1,
    size = 3.5,
    inherit.aes = FALSE,
    show.legend = FALSE
  )

p <- p +
    ggtext::geom_richtext(
      data = data.frame(
        ano = ymd("2020-01-01"),
        exp_liquida = 600,
        label = paste0("<b style='color:#444444;'>", texto_exp_02, "</b>")
      ),
      aes(x = ano, y = exp_liquida, label = label),
      fill = NA, label.color = NA,
      label.padding = unit(c(0.7, 0.6, 0.5, 0.6), "lines"),
      hjust = 0, vjust = 1.2,
      size = 3.5,
      inherit.aes = FALSE,
      show.legend = FALSE
    )  

p <- p +
    ggtext::geom_richtext(
      data = data.frame(
        ano = ymd("2020-01-01"),
        exp_liquida = 600,
        label = paste0("<b style='color:#444444;'>", texto_exp_03, "</b>")
      ),
      aes(x = ano, y = exp_liquida, label = label),
      fill = NA, label.color = NA,
      label.padding = unit(c(0.7, 0.6, 0.5, 0.6), "lines"),
      hjust = 0, vjust = 3.7,
      size = 3.5,
      inherit.aes = FALSE,
      show.legend = FALSE
    )  

# Tema estético e ajustes finais
p <- p +
  theme_academic(base_family = "merri") +
  theme(
    strip.background = element_blank(),
    strip.text = element_text(colour = "gray40"),
    plot.title = element_markdown(size = 16, face = "bold")
  )

p <- p +
  labs(
    title = "Guerra Comercial de 2025",
    subtitle = "Distribuição das Exportações Líquidas por Países",
    caption = "Fonte: Banco Mundial",
    y = "Exportações Líquidas (US$ bilhões)",
    x = NULL)

# Visualização
p 

ggsave(plot = p,
  filename = "content/post/2025-04-14-teoria-dos-jogos-na-guerra-comercial-de-2025/figura_01.pdf",
  width = 10.81, height = 7.75, units = "in",
  device = cairo_pdf)