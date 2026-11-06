---
name: idea
description: 'Convierte lo que erescalona quiere en una historia de usuario clara, con ejemplos de cómo se sabe que funciona, y la guarda en docs/historias antes de construir nada. Úsala cada vez que ella describa algo que quiere en su proyecto (una pantalla, una función, un cambio, un arreglo), aunque no diga «historia» ni «idea», y antes de usar construir sobre algo que no tiene historia.'
---

# Idea: de lo que ella quiere a una historia

Una historia dice quién usa algo, qué quiere y para qué, y trae ejemplos concretos de cómo se sabe que funciona.
Esos ejemplos son el acuerdo con ella: cada uno se convierte después en una prueba. En esta skill no se escribe
código.

## Pasos

1. **Repite en una frase lo que entendiste**, con sus palabras. Si ella corrige, vuelve a empezar.
2. **Pregunta solo lo que falte** para saber qué debe pasar: como mucho tres preguntas, sobre lo que ella o sus
   usuarios verán. Usa la herramienta de preguntas con opciones cuando haya alternativas claras, y marca la que
   recomiendas. Nunca preguntes cosas técnicas (base de datos, librerías, arquitectura): esas las decides tú.
3. **Escribe la historia** en `docs/historias/NNN-nombre-corto.md`, con el siguiente número libre (`001`, `002`…)
   y un nombre corto en minúsculas con guiones. Usa esta forma:

   ```markdown
   # NNN · Título corto

   **Estado:** borrador

   **Quién:** quién lo usa.
   **Quiere:** qué quiere hacer.
   **Para:** qué gana con eso.

   ## Así sé que funciona

   - Cuando <situación concreta>, veo <resultado concreto>.
   - …

   ## Fuera de esta historia

   - Lo que se habló pero queda para después.

   ## Preguntas abiertas

   - Lo que todavía no está decidido (o «Ninguna»).
   ```

   Los ejemplos de «Así sé que funciona» son de tres a seis, cada uno con datos de verdad («Ana escribe
   300 123 4567»), incluido al menos uno de qué pasa cuando algo sale mal (un dato vacío, uno equivocado).
4. **Muéstrale la historia** en un resumen corto y pregúntale si está bien así. Si dice que sí, cambia el estado a
   `aprobada`. Si pide cambios, ajústala y vuelve a preguntar.
5. **Cierra** diciéndole que cuando quiera, la construyes (skill `construir`).

## Reglas

- Una historia es algo que ella puede probar sola en una tarde. Si es más grande, propón partirla en varias
  historias y escribe cada una por separado.
- Si ya existe una historia parecida en `docs/historias/`, propón cambiar esa en vez de crear otra.
- No inventes reglas de negocio: si un ejemplo depende de algo que ella no dijo, va a «Preguntas abiertas».
