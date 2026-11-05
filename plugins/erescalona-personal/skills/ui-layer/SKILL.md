---
name: ui-layer
description: 'Diseña, construye y revisa la interfaz web con Astro, Tailwind CSS v4 e islas React: layouts, páginas, componentes visuales reutilizables de packages/ui, tokens de marca y View Transitions. Cárgala antes de crear o cambiar cualquier pantalla, layout, página, componente, estilo, color, tipografía, animación o navegación del cliente, aunque el encargo no diga «UI» ni «diseño».'
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Skill, mcp__plugin_erescalona-personal_astro-docs__search_astro_docs
---

# UI con layouts, componentes y marca

**Asume Astro, Tailwind CSS v4 e islas React en el monorepo pnpm.** Cada app de `apps/` monta sus
páginas sobre layouts; `packages/ui` guarda los componentes visuales reutilizables y los tokens de
la marca.

## Antes de escribir UI

1. **Carga el MCP de Astro (`astro-docs`) y lee la documentación** del tema que vas a tocar:
   layouts, View Transitions, islas, imágenes, fuentes o estilos. Astro cambia entre versiones y lo
   que recuerdas puede estar desfasado; la documentación dice cuál es la práctica vigente. Para
   Tailwind y React, lee su documentación oficial (context7 cuando esté disponible). Si no puedes
   consultar la documentación, dilo antes de seguir.
2. **Carga la skill `frontend-design`** para toda decisión visual: pantallas nuevas, rediseños,
   jerarquía, tipografía, movimiento y textos de interfaz. Cómo se combina con la marca está en
   [su sección](#frontend-design-y-la-marca).
3. **Inventaria lo que existe**: los tokens de `packages/ui/src/theme.css`, los componentes de
   `packages/ui` y los layouts de la app. Lo que ya existe se reutiliza antes de crear algo nuevo.

## Organización

```text
packages/ui/
  package.json                exports de componentes, islas y theme.css
  src/
    theme.css                 tokens de marca en @theme: color, tipografía, espaciado, radios, movimiento
    components/<Nombre>.astro primitivas visuales sin JavaScript
    islands/<Nombre>.tsx      componentes React reutilizables con estado de cliente
apps/<app>/
  astro.config.mjs
  src/
    styles/global.css         importa Tailwind y el tema de packages/ui
    layouts/                  BaseLayout → AppLayout → layouts de sección
    pages/                    rutas: eligen layout, cargan datos y componen
    components/<dominio>/     composiciones propias de la app
    islands/<dominio>/        islas React propias de la app
```

## Arquitectura por layouts

La estructura de una pantalla la dan sus layouts; la página solo aporta su contenido.

- **Un solo `BaseLayout`** escribe `<html>`, `<head>`, `<ClientRouter />`, `global.css` y las
  fuentes. Ningún otro archivo abre `<html>`.
- **Los layouts se anidan.** `AppLayout` envuelve `BaseLayout` y añade la estructura persistente:
  navegación, barra lateral, cabecera. Un layout de sección envuelve `AppLayout` cuando varias
  páginas comparten la misma estructura interna.
- **Las páginas son finas**: eligen layout, cargan datos y componen componentes. No redibujan
  estructura que ya da un layout ni copian la de otra página.
- **Las regiones variables son slots con nombre** (`<slot name="actions" />`,
  `<slot name="aside" />`), no props que transportan HTML. Las props se tipan con `interface Props`.
- **Una pantalla nueva empieza por su layout.** Busca el que ya le da su estructura; si dos páginas
  repiten una estructura, esa estructura pasa a ser un layout.

## Componentes visuales reutilizables

- **Una primitiva vive en `packages/ui`**: es visual, no conoce el dominio, no carga datos ni llama
  a la API. Recibe datos por props y contenido por slots, y sus variantes son props (`variant`,
  `size`), no listas de clases copiadas en cada uso.
- **Una composición vive en la app**: conoce el dominio, combina primitivas y se guarda en
  `components/<dominio>/`.
- **Un patrón visual que aparece dos veces se extrae a `packages/ui`.** Antes de crear un
  componente, busca uno que ya lo resuelva o que pueda ganar una variante.
- **Astro primero.** Un componente `.astro` no envía JavaScript. Una isla React existe solo cuando
  hay estado de cliente real: validación en vivo, filtros que cambian sin navegar, chat. Elige la
  directiva `client:*` más perezosa que sirva (`client:visible` o `client:idle` antes que
  `client:load`).
- **Una isla no importa componentes `.astro`.** El contenido estático le llega como children o
  slots desde el `.astro` que la usa, y sus props tienen que ser serializables: nada de funciones.
- **HTML semántico y accesible**: el elemento correcto (`button`, `a`, `label`), foco visible,
  texto alternativo y contraste suficiente.

## Estilos, tokens y marca

**La marca existente manda.** Antes de introducir un color, una fuente o una medida, búscalo en el
tema. El orden de preferencia es:

1. Una utilidad que ya sale de un token del tema (`bg-primary`, `text-muted`).
2. Un componente de `packages/ui` que ya tiene ese estilo.
3. Un token nuevo en `packages/ui/src/theme.css`, con nombre semántico (`--color-surface-raised`,
   no `--color-azul-2`) y derivado de la paleta existente. El cambio explica por qué hacía falta.

Nunca un valor de color suelto (`bg-[#1e40af]`, `style="color: …"`) ni la paleta por defecto de
Tailwind: rompen la marca sin dejar rastro en el tema.

- **`theme.css` vacía la paleta por defecto** con `--color-*: initial;` antes de declarar los
  colores de marca. Así `bg-blue-500` deja de existir y el único color que se puede escribir es uno
  de la marca.
- **El tema registra `packages/ui` con `@source`** para que Tailwind genere las clases de sus
  componentes; la app importa el tema desde `global.css`.
- **Una lista de clases que se repite es un componente que falta.** Extrae el componente en vez de
  copiar clases o acumular `@apply`.
- **Los `<style>` de Astro** quedan para lo que las utilidades no expresan bien, como selectores de
  estado o animaciones de transición, y usan las variables del tema (`var(--color-primary)`).
- **Si todavía no hay marca**, el primer trabajo visual la define en `theme.css` con
  `frontend-design`, y desde entonces rige esta sección.

## View Transitions

- **`BaseLayout` incluye `<ClientRouter />` una sola vez** y todas las páginas lo heredan.
- **`transition:persist`** en lo que debe sobrevivir a la navegación: la navegación del
  `AppLayout`, la barra lateral y las islas con estado, como filtros o un chat.
- **`transition:name`** para el mismo objeto en dos páginas, como la fila de un listado y la
  cabecera de su detalle. Cada nombre es único dentro de una página.
- **Los scripts se inicializan en `astro:page-load`**, no en `DOMContentLoaded`: con el router, un
  script empaquetado se ejecuta una sola vez. Un script inline que crea estado global comprueba
  antes si ya existe.
- **`data-astro-reload`** en los enlaces que deben recargar la página completa: descargas, cierre de
  sesión, rutas fuera de la app.
- **El movimiento muestra continuidad, no decora.** Prefiere las animaciones integradas (`fade`,
  `slide`) y, si creas una propia, respeta `prefers-reduced-motion`.
- La documentación de Astro advierte que el router irá siendo innecesario a medida que los
  navegadores cubran sus funciones; revísala antes de depender de algo que solo da el router.

## frontend-design y la marca

`frontend-design` empuja hacia decisiones visuales propias y huye de los defaults genéricos. Aquí
la marca es el encargo: paleta, tipografía y logotipo vienen dados, y esa misma skill indica que
una dirección visual fijada por el encargo se sigue al pie de la letra. Usa su libertad en lo que
la marca no decide: composición, jerarquía, ritmo, el elemento memorable de la pantalla y los
textos. Su plan de tokens parte de `theme.css` en vez de inventar una paleta.

Su proceso aplica completo: plan breve, revisión contra el encargo, construcción y crítica con
capturas. Su piso de calidad también: responsive hasta móvil, foco visible, movimiento reducido
respetado y contraste accesible.

## Verificación

- **`pnpm typecheck`.** Todo paquete con archivos `.astro` declara `"typecheck": "astro check"`;
  `tsc` no los lee. `@astrojs/check` ya está instalado en la raíz del workspace.
- **Formato.** El hook de Prettier formatea cada archivo editado. Para que alcance los `.astro`, la
  configuración raíz necesita `prettier-plugin-astro`; añádelo al crear la primera app Astro.
- **En el navegador.** Revisa la pantalla en escritorio y a 390 px de ancho, navegando entre páginas
  para ver las transiciones y la persistencia. Toma capturas y critícalas antes de darla por
  terminada.
