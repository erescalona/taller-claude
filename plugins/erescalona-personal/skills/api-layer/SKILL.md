---
name: api-layer
description: 'Diseña, revisa y modifica la API con Fastify 5, Zod y Drizzle directo, organizada en features y plugins. Cárgala antes de tocar endpoints, handlers, schemas, plugins, integraciones externas, persistencia o composición, y antes de añadir un caso, una feature, un plugin o una implementación nueva.'
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# API con features y plugins

**Asume Fastify 5, Zod y Drizzle con PostgreSQL.** El servidor atiende al cliente, persiste en
PostgreSQL y habla con servicios externos. Las features implementan el producto; los plugins
encapsulan lo que las features consumen y no es suyo.

## Organización

```text
apps/api/
  migrations/                 SQL generado por drizzle-kit
  src/
    index.ts                  entorno, buildApp, listen
    app.ts                    buildApp: compiladores, errores, config → db → plugins → features
    config.ts                 variables de entorno validadas con Zod
    db/
      client.ts               conexión, tipos Database y Transaction, plugin que publica app.db
      schema/<dominio>.ts     tablas
    plugins/<concern>/        una carpeta por concern; index.ts es su única entrada
    features/<dominio>/
      index.ts                registra las rutas del dominio
      <caso>/                 schema.ts, handler.ts, endpoint.ts
      shared/                 lo que comparten casos del mismo dominio
    lib/                      funciones puras sin dominio: AppError, paginación, fechas
```

No hay `core/`, `adapters/` ni `shared/` de primer nivel. La dirección es
`features → plugins → db, lib`.

## Plugins

Un plugin es un concern cohesivo que las features consumen mediante `app.<concern>`. Puede ser
una **integración** con un servicio externo o un **módulo abstraído**: una capacidad propia que
varias features usan, como la autenticación. Todo lo del concern vive en su carpeta: contrato,
implementaciones, helpers y tipos.

Un plugin existe porque tiene recursos, estado o proveedor, o porque varias features comparten el
concern. Un parser, una plantilla o un cálculo con un solo consumidor siguen siendo funciones: en
`lib/` si no tienen dominio, en la feature si lo tienen. No crear plugins por uniformidad.

### Directo o con interfaz

```text
plugins/<concern>/            directo: un proveedor y nada que sustituir
  index.ts                    registro, decoración y tipos públicos
  client.ts                   cliente del proveedor, si no cabe en index.ts

plugins/<concern>/            con interfaz
  index.ts                    registro, selección y tipos públicos
  contract.ts                 contrato en el lenguaje del producto
  <implementación>.ts         una por proveedor o variante, incluida la local sobre app.db
```

El plugin **directo** exporta el tipo inferido de su implementación:
`export type Concern = ReturnType<typeof createConcern>`.

El plugin **con interfaz** existe cuando hay dos o más implementaciones en el alcance, o cuando el
proveedor no sirve en pruebas por costo, red o no determinismo. Su `contract.ts` habla el lenguaje
del producto (contacto, póliza, cita, mensaje), nunca el del proveedor: los campos, payloads y
tipos de un SDK no salen del archivo de su implementación.

No crear interfaces por anticipado ni una por helper o tabla.

### Selección

La selección vive en `index.ts`. Ninguna feature sabe qué implementación está activa.

| Modo            | Cuándo                                                  | Qué publica                                       |
| --------------- | ------------------------------------------------------- | ------------------------------------------------- |
| Por config      | Una implementación activa entre varias                  | El contrato, elegido por `app.config.<concern>`   |
| Registro por id | Varias implementaciones activas a la vez                | `get(id)` y `list()`; un id desconocido lanza 404 |
| Única           | Una implementación que hay que poder sustituir en tests | El contrato, con una sola implementación detrás   |

### Forma de index.ts

```ts
import fp from 'fastify-plugin';
import type { Concern } from './contract.js';
import { createLocal } from './local.js';
import { createRemote } from './remote.js';

export type { Concern } from './contract.js';

declare module 'fastify' {
  interface FastifyInstance {
    concern: Concern;
  }
}

export default fp<{ concern?: Concern }>(
  async (app, options) => {
    const settings = app.config.concern;
    app.decorate(
      'concern',
      options.concern ??
        (settings.provider === 'remote' ? createRemote(settings.remote) : createLocal(app.db))
    );
  },
  { name: 'concern', dependencies: ['config', 'db'] }
);
```

- Usa `fastify-plugin`, con `name`, `dependencies` y la declaración de `FastifyInstance`.
- Acepta un sustituto en sus opciones para pruebas.
- Registra `onClose` para los recursos que abre: pools, clientes con conexión, timers.
- Una implementación que usa nuestra base recibe `app.db` y el plugin declara `db`.
- Las credenciales salen de `app.config`. Solo `config.ts` lee `process.env`.
- Exporta sus tipos públicos con `export type`, para no arrastrar el registro Fastify al importarlos.

### Límites

- **`index.ts` es la única entrada.** Desde fuera de `plugins/<x>/` solo se importa
  `plugins/<x>/index.ts`; las features solo importan de ahí tipos, con `import type`. Ninguna
  feature importa el archivo de una implementación.
- **Un plugin no importa features**, y una feature no importa otra feature.
- **Un plugin usa otro mediante `app.<x>`**, declarado en `dependencies`, nunca importando sus
  archivos internos.
- **Lo que depende del producto se inyecta.** Si un plugin necesita una política, una plantilla o
  ejecutar operaciones del producto (herramientas, callbacks), `app.ts` se las pasa por opciones o
  la feature las entrega en la llamada.
- **Los plugins no registran rutas de producto.** Un webhook entrante es un caso de feature; el
  plugin le ofrece la verificación de firma y el parseo del payload.
- **Los errores del proveedor no cruzan el plugin.** La implementación traduce el fallo del SDK a
  `AppError` con un código propio (`<concern>_unavailable`, 502) o a un valor del contrato.

`tools/cruiser/cruiser` comprueba las dependencias de estos límites con `.dependency-cruiser.cjs`;
una regla cambia junto con esta sección. No distingue `import { type X }` de `import type`: esa
forma la vigila la revisión.

## Features

Cada dominio es una carpeta en `features/`; cada caso, una subcarpeta con nombre de verbo
(`create-<recurso>`, `list-<recursos>`).

**`schema.ts`** define petición, parámetros y respuesta con Zod. Es dueño del filtrado HTTP: no
publicar una fila completa con datos internos por comodidad.

**`handler.ts`** es el caso. Recibe sus dependencias en un objeto limitado al caso y los datos ya
validados; devuelve el resultado o lanza `AppError`. Hace sus consultas Drizzle directamente. Nunca
recibe `FastifyInstance`, `request` ni un contexto universal.

```ts
export async function createItem(deps: { db: Database; concern: Concern; now: () => Date }, input: Body) {
  const reference = await deps.concern.register(input);
  const [item] = await deps.db
    .insert(items)
    .values({ ...input, reference, createdAt: deps.now() })
    .returning();
  return item;
}
```

**`endpoint.ts`** es un plugin de ruta con `FastifyPluginAsyncZod`. Declara método, URL, guards y
schemas, pasa al handler lo que usa y decide código, cabeceras y cookies. Es el único archivo que
toca HTTP.

```ts
export const registerCreateItem: FastifyPluginAsyncZod = async (app) => {
  app.route({
    method: 'POST',
    url: '/items',
    preValidation: [app.requireAuth],
    schema: { body: schema.body, response: { 201: schema.response } },
    handler: async (request, reply) => {
      const item = await createItem({ db: app.db, concern: app.concern, now: app.now }, request.body);
      return reply.status(201).send(item);
    },
  });
};
```

`features/<dominio>/index.ts` registra los endpoints del dominio y **no** se envuelve en `fp()`,
para conservar la encapsulación de Fastify.

## Datos

- **Drizzle directo.** `app.db` es el cliente Drizzle real. Sin repositorios, stores ni puertos de
  persistencia.
- `Database` y `Transaction` se infieren en `db/client.ts`. Las filas usan `$inferSelect` y
  `$inferInsert`; no redeclarar entidades. La forma de un JSON persistido se declara junto a su
  columna con `.$type<...>()`.
- Las lecturas y escrituras que deben ser atómicas comparten `db.transaction`; el handler pasa el
  `tx` a quien escriba.
- **Las llamadas a servicios externos van fuera de la transacción.** No mantener una transacción
  abierta mientras se espera a un proveedor.
- Las migraciones se generan con `drizzle-kit generate`. No editar ni regenerar las ya aplicadas.

## Autenticación

`plugins/auth/` prepara `request.auth` en `onRequest` y publica los hooks de admisión, como
`app.requireAuth`. Cada ruta protegida los declara en `preValidation`. Las rutas públicas no los
llevan; un webhook verifica la firma de su proveedor. El handler no lee cookies ni cabeceras de
sesión: el endpoint le pasa lo que necesita de la identidad, como el `userId`.

## Errores

- `AppError(statusCode, code, message)` en `lib/errors.ts` para los fallos esperados.
- Un único `setErrorHandler` en `app.ts` traduce `AppError`, la validación de Zod (422) y los
  errores 4xx del framework, y registra los inesperados.
- No volver a parsear con Zod dentro del handler ni usar `attachValidation`.
- Las respuestas exitosas son datos, sin sobre `{ success, data }`.

## Composición y pruebas

`buildApp(options)` registra compiladores Zod, el manejador de errores, `app.config`, `app.now`,
la base, los plugins y las features, en ese orden. Acepta un sustituto por plugin y un reloj
`now`. Ningún módulo abre conexiones al importarse.

- **Las pruebas unitarias no tocan Postgres.** Prueban las features con `app.inject` y un sustituto
  de `buildApp` por plugin, como el CRM en memoria de `tests/support/`. Su `DATABASE_URL` apunta a un
  puerto cerrado, así que un acceso accidental a la base falla en vez de pasar. Corren con
  `pnpm --filter api test`.
- **Las pruebas de integración usan PostgreSQL real**: viven en `tests/integration/` y corren con
  `pnpm --filter api test:integration` después de `pnpm db:up`. Cubren las implementaciones sobre
  `app.db`, las migraciones y la composición completa, cada prueba en su propia base desechable.
- **Las implementaciones de un mismo contrato pasan la misma suite del contrato**, incluido el doble en
  memoria de las pruebas unitarias: así el doble no se aleja de la implementación real. Las que llaman a
  un proveedor remoto quedan fuera de la suite por defecto.
- Un handler que consulta `app.db` directamente se prueba en integración. No simular Drizzle con
  cadenas de mocks y `as any`.

## Extender

**Un caso nuevo.** Crea `features/<dominio>/<caso>/` con `schema.ts`, `handler.ts` y
`endpoint.ts`, y regístralo en `features/<dominio>/index.ts`.

**Una feature nueva.** Crea `features/<dominio>/index.ts` sin `fp()` y regístrala en `app.ts`,
después de los plugins.

**Una implementación más de un concern existente.** Añade `plugins/<concern>/<implementación>.ts`
que cumpla `contract.ts`, su configuración en `config.ts` y su rama en la selección o su entrada en
el registro. Las features no cambian.

**Un concern nuevo.** Crea `plugins/<concern>/index.ts` como plugin directo. Añade las
credenciales a `config.ts`, el sustituto a `BuildOptions` y el registro a `app.ts`. Las features
lo consumen por `app.<concern>`.

**Un plugin directo que gana una segunda implementación.** Extrae `contract.ts` con lo que las
features ya usan, mueve el cliente a `<implementación>.ts` y añade la selección en `index.ts`. Las
features no cambian, porque ya dependían de `app.<concern>`.

**Una operación que comparten dos features.** Si es lógica de producto, se extrae a un plugin
módulo que la publica en `app.<concern>`; si es una función pura sin dominio, a `lib/`. Nunca se
importa una feature desde otra.

Al terminar, corre las comprobaciones mínimas de `ub-mode` (`tools/verificar`). `tools/cruiser/cruiser`
corre solo si ella lo pide.
