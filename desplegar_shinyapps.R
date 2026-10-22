# ==============================================================================
# DESPLEGAR_SHINYAPPS.R: Publicación Optimizada en shinyapps.io
# Municipalidad Provincial de Anta - Gerencia de Desarrollo Urbano y Rural (GDUR)
# ==============================================================================

if (dir.exists(".r-library")) {
  .libPaths(c(file.path(getwd(), ".r-library"), .libPaths()))
}

options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))

suppressPackageStartupMessages({
  library(rsconnect)
})

cat("==============================================================================\n")
cat("🚀 PUBLICACIÓN EN SHINYAPPS.IO - SISTEMA HIDROCLIMÁTICO ANTA\n")
cat("==============================================================================\n\n")

# Archivos estrictamente necesarios (excluye archivos redundantes o pesados no usados)
archivos_clima_necesarios <- c(
  "Clima_Anta/P_anual_30m_PISCOv3_Anta_2001_2025.tif",
  "Clima_Anta/T_anual_30m_PISCOt_Anta_2001_2025.tif",
  "Clima_Anta/Estres_y_Balance_Hidrico_30m_PISCO_Anta.tif",
  "Clima_Anta/Variabilidad_y_Tendencias_PISCO_Anta_2001_2025.tif",
  "Clima_Anta/Estres_Hidrico_Anta_2001_2025.tif"
)

# Evita publicar cifras de comparación instrumental calculadas con capas o
# registros anteriores. La estación sigue siendo un control puntual, no una
# calibración provincial.
archivo_validacion <- "app_data/validacion_red_estaciones.csv"
insumos_validacion <- c(
  archivos_clima_necesarios[1:2],
  list.files("estaciones", pattern = "\\.csv$", full.names = TRUE)
)
if (!file.exists(archivo_validacion) || length(insumos_validacion) < 6L ||
    file.info(archivo_validacion)$mtime < max(file.info(insumos_validacion)$mtime)) {
  stop("El contraste de estaciones falta o está desactualizado. Ejecute scripts/validar_red_estaciones.R antes del despliegue.")
}

archivos_despliegue <- c(
  "app.R",
  "DESCRIPTION",
  list.files("R", pattern = "\\.R$", full.names = TRUE),
  c("www/custom.css", "www/logo_anta.jpg"),
  setdiff(list.files("app_data", pattern = "\\.(rds|geojson|tif|csv)$", full.names = TRUE),
          "app_data/validacion_ancachuro.csv"),
  archivos_clima_necesarios
)

archivos_despliegue <- gsub("^\\./", "", archivos_despliegue)
archivos_despliegue <- archivos_despliegue[file.exists(archivos_despliegue)]

tamanio_mb <- sum(file.info(archivos_despliegue)$size) / 1024^2
cat(sprintf("📦 Archivos a empaquetar: %d archivos\n", length(archivos_despliegue)))
cat(sprintf("📊 Tamaño estimado del paquete: %.2f MiB\n\n", tamanio_mb))

cuentas <- rsconnect::accounts()
if (nrow(cuentas) == 0) {
  cat("⚠️ No se encontró ninguna cuenta de shinyapps.io configurada.\n")
  cat("Para configurar su cuenta, ejecute:\n")
  cat("rsconnect::setAccountInfo(name='<cuenta>', token='<token>', secret='<secret>')\n")
} else {
  cuenta_destino <- cuentas$name[1]
  cat("🛰️ Desplegando en la cuenta:", cuenta_destino, "...\n")
  cat("Aplicación: clima_anta_30m\n\n")
  
  rsconnect::deployApp(
    appDir = getwd(),
    appFiles = archivos_despliegue,
    appName = "clima_anta_30m",
    appTitle = "Sistema Hidroclimático de Anta 30m (GDUR)",
    account = cuenta_destino,
    forceUpdate = TRUE,
    lint = FALSE
  )
  
  cat("\n✅ ¡Despliegue completado exitosamente!\n")
}
