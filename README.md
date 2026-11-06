# erescalona-personal

Un plugin de Claude con una forma de construir proyectos paso a paso, con pruebas y una arquitectura
clara. Se instala una vez en el computador y queda disponible en todos los proyectos, en Claude Desktop y en
Claude Code.

## Qué trae

**Su forma de trabajar, en español.** Claude le habla siempre en español sencillo y sigue tres pasos, cada uno
con su skill. Sus proyectos corren en su computador y se publican en internet solo cuando ella lo pide.

| Skill | Qué hace |
| --- | --- |
| `idea` | Convierte lo que ella quiere en una historia con ejemplos de «así sé que funciona» y la guarda en `docs/historias/`. |
| `construir` | Construye una historia aprobada: muestra el plan, una prueba por ejemplo, las comprobaciones mínimas (tipos, pruebas, integración y formato) y la pantalla en Chrome. |
| `guardar` | Guarda el trabajo en git en su computador, a su nombre; lo sube a GitHub solo si ella conectó el proyecto a un repositorio. |
| `publicar` | Lo pone en internet con el CLI de Railway y la clave del proyecto que guarda el `.env`, y comprueba que quedó funcionando. Solo cuando ella lo pide. |
| `nuevo-proyecto` | Arma un proyecto desde su plantilla `erescalona/plantilla-proyectos` en la carpeta donde está trabajando: `.env`, base de datos, git y todas las comprobaciones pasando, sin crear repositorios. |
| `traer-base-whatsapp` | Trae el proyecto base de la hackatón, el bot de WhatsApp «Agenda Asesores», a la carpeta donde está trabajando, y lo deja listo para la fase 01. |
| `revisar-mi-compu` | Comprueba que el computador tenga Git, el CLI de GitHub, Node 22, pnpm, Docker, el CLI de Railway y Claude, y dice cómo arreglar lo que falte. |

La forma de hablarle está en `plugins/erescalona-personal/hooks/forma-de-hablar.md` y entra en cada sesión.

**Las skills base de desarrollo**, que Claude usa por dentro (en inglés las que vienen de afuera):

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
- `ub-mode` corre por defecto solo las comprobaciones mínimas, `tools/verificar`: tipos, pruebas, integración y
  formato. `pnpm crap`, `pnpm dry` y `pnpm mutate` (crap-typescript, jscpd y StrykerJS) corren solo cuando ella
  los pide. Los proyectos los traen en sus dependencias, así que funcionan en Windows sin instalar nada más.

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
