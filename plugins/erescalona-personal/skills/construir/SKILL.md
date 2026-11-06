---
name: construir
description: 'Construye una historia aprobada de docs/historias, paso a paso, con una prueba por cada ejemplo de «Así sé que funciona», todas las comprobaciones del proyecto y la pantalla revisada en Chrome. Úsala cuando erescalona pida construir, hacer, programar o implementar una historia o algo ya acordado; si lo que pide no tiene historia aprobada, usa primero idea.'
---

# Construir una historia

## Antes de empezar

1. **Busca la historia** en `docs/historias/`. Si no hay una aprobada para lo que pide, usa la skill `idea`
   primero y vuelve aquí cuando ella la apruebe.
2. **Lee el `CLAUDE.md` del proyecto** y carga las skills que pida para lo que vas a tocar: `api-layer` para el
   servidor, `ui-layer` para pantallas, `ai-layer` para inteligencia artificial. `ub-mode` ya está cargada y
   manda en el orden de trabajo.
3. **Muéstrale el plan** en pasos cortos, cada uno con lo que ella podrá ver al terminarlo, y espera su sí. Un
   mensaje basta; no le expliques cómo vas a programarlo.

## Mientras construyes

- **Un ejemplo a la vez.** Por cada línea de «Así sé que funciona»: escribe la prueba, mírala fallar por la
  razón esperada, escribe lo mínimo para que pase. Así cada ejemplo queda fijado por una prueba.
- **Cuéntale el avance** en una línea al cerrar cada paso del plan, en palabras de lo que ya funciona.
- Si descubres algo que la historia no decide, no lo inventes: pregúntale con opciones y anota la respuesta en
  la historia.

## Antes de darlo por terminado

1. Corre las comprobaciones que pide `CLAUDE.md` del proyecto, sobre lo que tocaste: tipos, pruebas, pruebas de
   integración si hay base de datos, `pnpm crap`, `pnpm dry`, `pnpm mutate`, las reglas de dependencias y el
   formato. Arregla cada falla en su causa, sin apagar la comprobación.
2. Si la historia tiene pantallas, levanta la web, ábrela en Chrome, recorre cada ejemplo como lo haría ella y
   revisa que la consola no tenga errores.
3. Cambia el estado de la historia a `construida` y agrega la fecha.

## Cierre para ella

En pocas líneas, sin jerga:

- **Qué hice:** lo que ya funciona, en sus palabras.
- **Cómo lo comprobé:** cuántos ejemplos quedaron con prueba y qué revisaste en la pantalla.
- **Pruébalo tú:** la dirección para abrir (por ejemplo `http://localhost:4321`) y qué hacer ahí.
- **Algo para aprender:** una sola idea de lo que pasó hoy, explicada en dos frases.
- Lo que no pudiste comprobar, dilo. Y ofrécele guardar el trabajo en su computador con la skill `guardar`; no
  subas nada a GitHub.
