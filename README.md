# erescalona-personal

Un plugin de Claude con una forma de construir proyectos paso a paso, con pruebas y una arquitectura
clara. Se instala una vez en el computador y queda disponible en todos los proyectos, en Claude Desktop y en
Claude Code.

## Qué trae

| Pieza | Qué hace |
| --- | --- |
| `ub-mode` | La forma de trabajar: primero que funcione, después que quede bien, con pruebas antes del código. **Está cargada siempre**: entra al abrir cada sesión y vuelve después de `/clear` o cuando Claude resume la conversación. |
| `api-layer` | Cómo se construye el servidor: Fastify, Zod y Drizzle sobre PostgreSQL, en features y plugins. |
| `ui-layer` | Cómo se construyen las pantallas: Astro, Tailwind y los componentes de la marca. |
| `ai-layer` | Cómo se construyen los casos de IA con Mastra y OpenRouter, sin que el proveedor guarde los datos. |
| `poc` | Cómo comprobar con una prueba pequeña algo que nadie ha medido antes de construir sobre ello. |
| `mastra` | La guía oficial de Mastra (licencia Apache-2.0, de sus autores). |
| `ub-agent` | El ayudante que Claude lanza para tareas aparte; arranca con `ub-mode` cargada. |
| Formateo | Cada archivo que Claude escribe queda formateado con el Prettier del proyecto. |
| Documentación | Búsqueda en la documentación de Astro y en la web con Exa. |

Las skills hablan de la estructura de la plantilla de proyectos: `apps/api`, `apps/web`, `packages/ui` y
`packages/ai`.

## Qué necesita el computador

- Node.js 22, el estándar de Coninsa. Los hooks del plugin corren con Node, igual en Windows y en Mac.
- Claude Desktop o Claude Code.
- `ui-layer` usa además el plugin oficial `frontend-design`.
- `ub-mode` mide con `pnpm crap`, `pnpm dry` y `pnpm mutate` (crap-typescript, jscpd y StrykerJS). Los
  proyectos los traen en sus dependencias, así que funcionan en Windows sin instalar nada más.

## Instalar

En una terminal (PowerShell en Windows):

```sh
claude plugin marketplace add erescalona/taller-claude
claude plugin install erescalona-personal@taller-claude
claude plugin install frontend-design@claude-plugins-official
```

Después reinicia Claude Desktop. En una sesión nueva, el plugin aparece en el botón **+**, en **Plugins**.

## Actualizar

```sh
claude plugin marketplace update taller-claude
claude plugin update erescalona-personal@taller-claude
```

## Para quien lo mantiene

- Las skills viven en `plugins/erescalona-personal/skills/`, el ayudante en `plugins/erescalona-personal/agents/` y los hooks en
  `plugins/erescalona-personal/hooks/`.
- Sube `version` en `plugins/erescalona-personal/.claude-plugin/plugin.json` con cada cambio: quien ya lo tiene instalado
  solo recibe la actualización cuando cambia ese número.
- Antes de subir, comprueba con `claude plugin validate plugins/erescalona-personal --strict`.
