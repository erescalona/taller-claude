---
name: construir
description: 'Construye una historia aprobada de docs/historias, paso a paso, con una prueba por cada ejemplo de «Así sé que funciona», las comprobaciones mínimas del proyecto y la pantalla revisada en Chrome. Úsala cuando erescalona pida construir, hacer, programar o implementar una historia o algo ya acordado; si lo que pide no tiene historia aprobada, usa primero idea.'
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
  razón esperada, escribe lo mínimo para que pase. Así cada ejemplo queda fijado por una prueba. Mientras
  construyes, corre solo ese archivo de pruebas; nada de `tools/verificar` ni de la suite completa entre paso
  y paso.
- **Cuéntale el avance** en una línea al cerrar cada paso del plan, en palabras de lo que ya funciona.
- Si descubres algo que la historia no decide, no lo inventes: pregúntale con opciones y anota la respuesta en
  la historia.

## Antes de darlo por terminado

1. Corre las comprobaciones mínimas una sola vez, desde la raíz del proyecto y en Git Bash:
   - `tools/verificar`: tipos, pruebas, pruebas de integración y formato. Debe terminar en «Todo pasa». Si
     arreglas algo, vuelve a correr solo la prueba que falló y, al final, `tools/verificar` otra vez.
   - Las mínimas son siempre lo que corre por defecto. CRAP, código repetido, dependencias, build y mutación
     corren solo si ella las pide, con `tools/verificar --completo` o con `pnpm crap`, `pnpm dry` o
     `pnpm mutate <archivos>` sobre lo que tocaste.
   - Lánzala con `run_in_background`, con la salida a un archivo de tu scratchpad, y espera el aviso de que
     terminó. No la cortes ni la saltes por tiempo.
   - Arregla cada falla en su causa, sin apagar la comprobación. Nunca uses `--inPlace` de Stryker: cambia los
     archivos de ella mientras corre.
   - Si el proyecto aún no tiene `tools/verificar --completo`, su `tools/verificar` es el viejo y corre todo:
     corre a mano solo `pnpm typecheck`, `pnpm -r test`, `pnpm --filter api test:integration` con la base
     arriba y `pnpm format:check`.
   - Si `pnpm mutate` falla con «Tsconfig not found» o `pnpm crap` con «spawn pnpm ENOENT», el proyecto trae
     el `tools/calidad/mutate.mjs` viejo: Stryker copia el paquete a `<paquete>/.stryker-tmp/sandbox-*`, dos
     carpetas más adentro, y desde ahí `../../tsconfig.base.json` no existe; la copia que queda tiene un
     `package.json` y crap-typescript la toma por un paquete sin cobertura. Arréglalo así: en `mutate.mjs`
     pásale a Stryker `--tempDirName <raíz>/.stryker-tmp-<nombre del paquete>`, que queda a la misma
     profundidad que el paquete; pon `.stryker-tmp*/` en `.gitignore` y `**/.stryker-tmp*/**` en el `ignore`
     de `.jscpd.json`; y borra las carpetas `.stryker-tmp/` que hayan quedado en `apps/` y `packages/`.
   - Si falla algo que no tocaste, mira `git status` antes de arreglarlo: puede ser trabajo a medio hacer de
     otra sesión en la misma carpeta. En ese caso trabaja en un worktree.
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
