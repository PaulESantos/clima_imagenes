# Guía pública: describe únicamente los indicadores realmente calculados.
# Se presenta dentro de la portada; no contiene cifras territoriales fijas.

mod_guia_indicadores_ui <- function(id) {
  ns <- NS(id)

  div(
    id = ns("seccion-guia-indicadores"),
    class = "content-card mt-4",
    div(
      class = "content-card-header",
      tags$h5(class = "content-card-title", icon("book-open-reader"),
              " Guía para interpretar los indicadores"),
      tags$span(class = "content-card-subtitle",
                "Qué representa cada cifra, de dónde procede y qué no permite concluir")
    ),
    navset_pill(
      id = ns("nav_indicadores"),
      nav_panel(
        title = "Series y tendencias",
        div(
          class = "p-3",
          tags$h6("Lluvia y temperatura anuales"),
          tags$p("La precipitación se expresa en mm/año y procede de un modelo espacial ajustado con PISCOp para 2001–2025. La temperatura se expresa en °C: se ajustó con PISCOt para 2001–2020 y se prolongó con ERA5-Land y un sesgo medio para 2021–2025. Cada valor es una estimación de una celda, no una lectura de estación."),
          tags$h6("Anomalía respecto de la media del periodo"),
          tags$p("La anomalía de un año es su valor menos la media de 2001–2025 del mismo lugar. Para lluvia también puede expresarse como porcentaje de esa media. Esta media de 25 años no se presenta como normal climatológica estándar de 30 años."),
          tags$h6("Tendencia por década"),
          tags$p("La pendiente se obtiene mediante regresión lineal de las 25 estimaciones anuales finales y se multiplica por diez. Su signo describe la dirección de la serie modelada; por sí solo no demuestra significancia estadística, causa ni evolución futura. La pendiente provincial de lluvia requiere especial cautela por su incertidumbre.")
        )
      ),
      nav_panel(
        title = "Aridez y ETo",
        div(
          class = "p-3",
          tags$h6("Evapotranspiración de referencia (ETo)"),
          tags$p("La base es una climatología PISCOeo_pm de 1981–2010. En este proyecto se ajustó empíricamente por temperatura anual: ETo_base + 35 mm/°C × (T_anual − T_referencia), con un piso de 200 mm/año. No se calculó Penman–Monteith de nuevo para cada año con radiación, humedad y viento anuales."),
          tags$h6("Diferencia P − ETo e índice de aridez"),
          tags$p("P − ETo se expresa en mm/año; P/ETo no tiene unidades. Sirven para comparar condiciones climáticas entre lugares. La diferencia negativa no mide por sí sola déficit de agua disponible: faltan escorrentía, infiltración, almacenamiento, aguas subterráneas, riego y demanda humana."),
          tags$p("Las capas multianuales resumen el periodo completo; no cambian cuando se selecciona un año en el mapa anual.")
        )
      ),
      nav_panel(
        title = "WSI y alcance",
        div(
          class = "p-3",
          tags$h6("Índice relativo de susceptibilidad hídrica (WSI)"),
          tags$p("Es una combinación normalizada de aridez (35 %), NDMI de vegetación (30 %), variabilidad de precipitación (20 %) y pendiente (15 %). Su escala va de 0 a 100. Un valor de 70 no significa 70 % de probabilidad de sequía o pérdida de agua."),
          tags$p("Las clases del modelo son: 1, valor menor que 35; 2, de 35 a menos de 55; 3, de 55 a menos de 70; y 4, desde 70. Pesos y umbrales son decisiones de modelado pendientes de validación de campo."),
          tags$h6("NDMI y resolución"),
          tags$p("El NDMI procede de un compuesto Sentinel-2 de 2019–2025 y se usa como predictor espacial estático. No es una medición de humedad del suelo para cada año desde 2001. Las series y consultas puntuales usan celdas modeladas de 30 m; los mapas web se generalizan a aproximadamente 150 m. Tamaño de celda y exactitud no son equivalentes."),
          tags$h6("Comprobación con estaciones"),
          tags$p("Ancachuro y Soraypampa están dentro del territorio modelado y muestran sesgos térmicos distintos. No hay otras estaciones disponibles dentro de Anta. Curahuasi y Urubamba están fuera del ráster y solo aportan contexto regional para PISCO. Estas estaciones pudieron alimentar PISCO; el contraste detecta sesgos locales, pero no constituye validación independiente. Los resultados y límites figuran en Datos y Metodología.")
        )
      )
    )
  )
}

mod_guia_indicadores_server <- function(id) {
  moduleServer(id, function(input, output, session) invisible(NULL))
}
