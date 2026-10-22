# Clima de Anta — beta referencial

Aplicación Shiny para explorar estimaciones anuales de precipitación, temperatura e indicadores derivados en la provincia de Anta, Cusco, durante 2001–2025. El código y los resúmenes agregados pueden publicarse; los registros originales de estaciones, insumos de procesamiento, rásteres grandes y productos intermedios permanecen locales.

**Alcance científico.** Son resultados de modelos matemáticos ajustados con productos PISCO, no mediciones en cada píxel. El tamaño de celda de 30 m no expresa precisión instrumental. Solo se dispone de Ancachuro y Soraypampa dentro del territorio para contraste puntual; esas estaciones pudieron alimentar PISCO. El contraste detectó sesgos locales, especialmente de temperatura en Soraypampa. Los mapas sirven para explorar patrones generales; las decisiones sobre parcelas, obras o disponibilidad de agua requieren datos y estudios locales. Véanse [auditoría técnica](AUDITORIA_VALIDEZ_TECNICA_2026-10-21.md) y [contraste de estaciones](VALIDACION_RED_ESTACIONES_2026-10-21.md).

## Estructura de publicación

| Ruta | Contenido | Destino |
|---|---|---|
| `app.R`, `R/`, `scripts/`, código GEE y scripts principales | Código fuente y pruebas | GitHub |
| `public_data/` | Copias públicas de series, resumen con nombres de campos corregidos, métricas agregadas de estaciones y límites distritales | GitHub y Netlify |
| `www/custom.css`, `www/logo_anta.jpg`, informes de auditoría vigentes | Presentación y límites de uso | GitHub |
| `estaciones/`, `data_vectorial/`, `auditoria_*`, documentos metodológicos antiguos, archivos de sesión | Insumos originales, trabajo y resultados auxiliares | Solo local |
| `Clima_Anta/`, `app_data/` | Rásteres finales, caché RDS, tablas internas y mapas que necesita Shiny | Local; solo los archivos necesarios se incluyen en el paquete del servidor Shiny |

`.gitignore` aplica una lista permitida: cualquier archivo nuevo permanece fuera del repositorio hasta revisarlo. Antes de cada publicación, comprobar la lista real de archivos con `git status --short --untracked-files=all` y `git ls-files`.

Tras actualizar los datos de la app, regenerar las copias públicas con `Rscript scripts/preparar_datos_publicos.R`. Este script solo lee las tablas finales y crea `public_data/`; nunca copia las series originales de estaciones.

## Ejecución local

Con R y las dependencias de `DESCRIPTION` instaladas, y con los productos finales locales presentes en `Clima_Anta/` y `app_data/`:

```r
shiny::runApp(".")
```

La prueba de consistencia se ejecuta con `Rscript scripts/test_app.R` desde la raíz, usando una biblioteca R con los paquetes requeridos.

## Publicación web: Netlify + Shiny

La aplicación interactiva se mantiene en un servidor R Shiny. Netlify sirve el portal estático de `portal/`, que enlaza a la URL pública de Shiny y ofrece únicamente las copias de `public_data/`. La configuración de `netlify.toml` genera `dist/` y solo publica ese directorio; ningún archivo de `estaciones/`, `Clima_Anta/` o `app_data/` se sirve directamente desde Netlify.

1. Publicar y probar la instancia Shiny con el paquete explícito de `desplegar_shinyapps.R` u otro servidor R compatible. No incluir los registros originales de estaciones.
2. Configurar en Netlify la variable de entorno `SHINY_APP_URL` con la URL pública HTTPS de esa instancia, sin parámetros ni fragmentos.
3. Vincular el repositorio GitHub a Netlify. La configuración del repositorio ejecuta `node scripts/build_portal.mjs` y publica `dist/`. Si falta `SHINY_APP_URL`, la compilación falla para evitar un portal con enlace roto.

Para probar el portal localmente en PowerShell: `$env:SHINY_APP_URL='https://ejemplo.shinyapps.io/clima_anta_30m/'; node scripts/build_portal.mjs`. El directorio `dist/` generado queda fuera de Git. La URL de ejemplo solo sirve para la prueba local; no representa una aplicación desplegada.

`desplegar_shinyapps.R` es un despliegue a un servidor Shiny, no a Netlify. El código en GitHub por sí solo no ejecuta la aplicación porque los rásteres finales y el caché espacial grande permanecen locales.
