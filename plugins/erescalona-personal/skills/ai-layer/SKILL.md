---
name: ai-layer
description: 'Diseña, revisa y modifica el paquete de casos de IA en `packages/ai`, con Mastra y OpenRouter con retención cero, y el plugin `agent` con el que la API los carga. Cárgala antes de tocar un caso, el runtime compartido, un agente, una herramienta, un workflow o cualquier llamada de la API a un modelo de lenguaje.'
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Skill
---

# Casos de IA con Mastra

**Asume `@mastra/core` 1.74.0 con su gateway de OpenRouter, Zod 4 y TypeScript con `NodeNext`.** Un caso es
una finalidad de uso de IA, como el asistente del Tablero. Cada caso decide qué datos envía al modelo: manda
lo mínimo que la finalidad necesita y nunca un identificador interno que el modelo no use.

Antes de tocar un agente, una herramienta o un flujo, carga también la skill `mastra`: la API de Mastra cambia
entre versiones y hay que verificarla contra la instalada.

## Organización

```text
packages/ai/src/
  runtime/                 lo compartido; no importa ningún caso
    model.ts               ModelChoice, openRouterModel, telemetría apagada
    agent.ts               zeroRetentionAgent, el único new Agent
    turn.ts                turnSlot<T> sobre RequestContext
    usage.ts               ModelUsage, usageOf
    language.ts            ReplyLanguage, withReplyLanguage, instructionsInReplyLanguage
  cases/<caso>/
    index.ts               create<Caso>(opciones), la única entrada de ejecución
    contract.ts            tipos públicos e interfaces que implementa quien usa el caso
    agents/                agentes, instrucciones y procesadores
    tools/                 herramientas createTool con su schema Zod
    workflows/             flujos con etapas fijas y su sesión
    rules/                 lógica pura del caso
    adapters/              SDK o HTTP propios del caso, detrás de un puerto del contrato
  shared/<capacidad>/      solo cuando un segundo caso necesita una regla o un adapter
```

Un caso tiene `index.ts`, `contract.ts` y al menos `agents/` o `workflows/`. Las demás carpetas aparecen cuando
hacen falta. No hay `src/index.ts`: el paquete publica `./<caso>` y `./<caso>/contract`, y nada más.

## Qué puede importar cada pieza

- `contract.ts` no carga nada en ejecución. Puede hacer `import type` de `runtime/`.
- `rules/` importa su contrato y otras reglas. Nada de npm, Mastra, E/S ni el resto del caso.
- `adapters/` importa su contrato, sus reglas y su SDK. No conoce Mastra, el runtime ni la orquestación.
- `agents/`, `tools/` y `workflows/` usan el runtime, `@mastra/core`, `zod`, el contrato y las reglas. Un workflow
  puede usar además los tipos de los `adapters/` de su caso. Entre ellos no hay un orden fijo: una herramienta
  puede llamar otro agente y un workflow puede servir de herramienta.
- Un caso nunca importa otro caso, tampoco sus tipos. Lo que dos casos comparten pasa a `src/shared/<capacidad>/`.
- `runtime/` solo importa `@mastra/core`.

## Retención cero por construcción

Crea cada agente con `zeroRetentionAgent`. Fusiona `provider: { zdr: true, data_collection: 'deny' }` al final
de `providerOptions.openrouter`, pone el logger mudo y recibe el modelo de `openRouterModel`, que apaga la
telemetría. Un caso puede añadir opciones de OpenRouter, como un plugin de búsqueda, pero no puede quitar esas
dos.

No escribas `new Agent`, `__setLogger` ni `providerOptions` dentro de un caso. `tests/runtime/agent.test.ts`
comprueba que un caso no puede quitar la retención cero, y la suite de cada caso comprueba que la petición al
modelo guionizado la lleva.

## Estado del turno

Las herramientas reciben las implementaciones de la API y la sesión del turno por `RequestContext`. Declara una
ranura con `turnSlot<Turno>(mensaje)`, donde el mensaje explica el fallo si la ranura llega vacía. `index.ts` la
llena con `slot.context(turno)` y las herramientas la leen con `slot.of(context)`. La ranura guarda el turno en un
`WeakMap` indexado por el propio contexto, así que leerlo no necesita casts. El caso es dueño de su sesión; el
runtime solo la transporta.

## Idioma

Las instrucciones de un agente, las descripciones de sus herramientas y los mensajes que solo lee el agente se
escriben en inglés. El idioma de lo que lee la persona viaja en el `RequestContext` y es el español por
defecto. Los textos que ve una persona, como los errores de la API, siguen en su idioma.

```ts
instructions: instructionsInReplyLanguage(ASSISTANT_INSTRUCTIONS),
requestContext: withReplyLanguage(assistantTurn.context(turn), request.language),
```

`instructionsInReplyLanguage` añade al final «Write every text the person reads (answers, labels, titles) in
Spanish.», o `English`. La petición del caso lleva `language?: ReplyLanguage`, y `index.ts` lo pone en el
contexto que construye. No escribas «responde en el idioma de la pregunta» ni el nombre de un idioma en las
instrucciones.

## El paquete

- `package.json` publica cada caso con tres condiciones: `types` y `source` apuntan a `src/cases/<caso>/`, y
  `default` a `dist/`. El typecheck de la API y `pnpm dev` (que corre con `--conditions=source`) leen el
  código fuente sin compilar; producción carga `dist/` después de `pnpm build`.
- No añadas una entrada `"."`: cargaría las dependencias de todos los casos.

## Cómo lo usa la API

El concern es `apps/api/src/plugins/agent/` y sigue la skill `api-layer`.

- **`contract.ts`** reexporta con `export type` los tipos del contrato del caso que la API implementa o
  consume, y declara la interfaz que publica `app.agent`, más estrecha cuando la API expone menos que el caso.
- **La implementación del paquete** carga el caso con `await import('@<proyecto>/ai/<caso>')` la primera vez que
  se usa y tipa sus opciones con `import type`. Así importar la app no carga Mastra.
- **`index.ts` elige por configuración**: con `OPENROUTER_API_KEY`, la implementación del paquete; sin ella,
  una que responde 503 con un código propio. La app arranca sin credenciales de IA.
- **La feature implementa las interfaces del contrato** (las herramientas) con sus plugins, como `app.crm`, y
  se las entrega en cada llamada. El paquete no conoce tablas, permisos ni HTTP.
- **Ninguna otra capa de la API importa valores del paquete.** Solo `plugins/agent/` lo carga, con `import()`;
  el resto importa tipos. `tools/cruiser/cruiser` lo comprueba.
- Las suites de la API usan dobles de `app.agent`, no el paquete.

## Añadir un caso

1. Decide la finalidad y qué datos salen hacia el modelo.
2. Crea `cases/<caso>/contract.ts` con la petición, el resultado y las interfaces que implementa la API.
3. Escribe la lógica pura en `rules/`, con sus pruebas en `tests/<caso>/`.
4. Crea el agente con `zeroRetentionAgent` en `agents/` y las herramientas en `tools/`, que leen las
   implementaciones con `turnSlot`.
5. Añade `workflows/` solo si el caso tiene etapas fijas, y `adapters/` solo si llama un SDK o un servicio
   HTTP.
6. Escribe `index.ts` con `create<Caso>(opciones)`, cuyas opciones extienden `ModelChoice`.
7. Añade `./<caso>` y `./<caso>/contract` a `exports` con sus tres condiciones.
8. En la API, amplía `plugins/agent/` (contrato, implementación y selección) y crea la feature que lo usa.
   Carga `api-layer` antes.

## Pruebas

- Las pruebas del paquete pasan un modelo guionizado en `languageModel` y nunca llaman a la red. El modelo
  guionizado responde con `content` de texto o de `tool-call` y registra lo que recibe.
- Prueba el comportamiento que ve quien usa el caso: lo que devuelve `create<Caso>` con implementaciones falsas
  de las interfaces del contrato. No pruebes la forma interna de los pasos.
- Cada caso tiene una prueba que lee `providerOptions` de las llamadas al modelo guionizado y espera
  `zdr: true` y `data_collection: 'deny'`.

## Verifica el límite que cambiaste

| Cambio                                  | Evidencia                                                        |
| --------------------------------------- | ---------------------------------------------------------------- |
| Instrucciones, herramientas o workflows | Las pruebas del caso en `tests/<caso>/` con el modelo guionizado |
| Runtime                                 | `tests/runtime/` y las pruebas de todos los casos                |
| Contrato de un caso                     | `pnpm typecheck` y las suites de la API que lo consumen          |
| Imports entre la API y el paquete       | `tools/cruiser/cruiser`, solo si ella lo pide                    |
| Un modelo distinto                      | Una PoC con la skill `poc` antes de cambiar la configuración     |

Cierra con las comprobaciones mínimas de `ub-mode` (`tools/verificar`), corridas desde la raíz.

## Lo que no se hace

- No guardes conversaciones con Mastra Memory ni con un almacén vectorial: la API las guarda en sus tablas.
- No registres los casos en una instancia `Mastra` para Studio mientras no haya un consumidor.
- No exportes piezas internas de un caso para reutilizarlas desde otro. Muévelas a `src/shared/<capacidad>/`.
