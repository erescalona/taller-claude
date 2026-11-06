---
name: traer-base-whatsapp
description: 'Trae el proyecto base de la hackatón, el bot de WhatsApp «Agenda Asesores» (erescalona/repo-base-hackaton), a la raíz de la carpeta donde erescalona está trabajando y lo deja listo para la fase 01: dependencias, base de datos local y todas las comprobaciones pasando. Úsala cuando ella pida traer, descargar, clonar o empezar el proyecto base, el proyecto de WhatsApp, Agenda Asesores o el proyecto de la hackatón.'
---

# Traer el proyecto base de WhatsApp

`erescalona/repo-base-hackaton` es el proyecto de la hackatón: la arquitectura vacía de «Agenda Asesores» y sus 13
fases en `fases/`, cada una con su planeación, su especificación técnica y sus pruebas. Trae también sus `.env` con
las claves del proyecto (Google, Meta, OpenRouter, El Libertador y la clave de Railway del servidor de la
hackatón), porque el repositorio es privado.

## Reglas que no se negocian

- **Dónde:** el proyecto queda en la raíz de la carpeta actual de la sesión, no en otra carpeta ni en una
  subcarpeta.
- **Local:** su trabajo queda en su computador. No subas nada a GitHub salvo que ella lo pida.
- **Los `.env` no se muestran:** nunca imprimas ni copies sus valores en un mensaje.

## 1. Antes de traerlo

1. **La carpeta:** lista lo que hay. Puede estar vacía o tener solo `README.md`, `LICENSE`, `.gitignore` o
   `.git`. Si tiene otro contenido (código, otro proyecto), no lo toques: explícale qué hay y pregúntale qué hacer.
   Si la carpeta está dentro de OneDrive, avísale que puede volver lento o romper el proyecto; ella decide.
2. **GitHub:** `gh auth status` debe mostrar la cuenta erescalona, porque el repositorio es privado. Si no, pídele
   que corra `gh auth login --web` y entre con su cuenta en el navegador; no inicies sesión por ella.
3. **El computador:** comprueba Git, Node (22.13 o más nuevo; el estándar de Coninsa es el 22), pnpm y Docker con lo
   que dice la skill `revisar-mi-compu`. Docker Desktop debe estar abierto («Engine running»). Si algo falta,
   arréglalo primero.

## 2. Traerlo a la raíz

En Git Bash, desde la carpeta:

```sh
tmp=$(mktemp -d)
gh repo clone erescalona/repo-base-hackaton "$tmp/base"
cp -R "$tmp/base/." .
rm -rf "$tmp"
git remote rename origin base
```

- La copia trae la historia de git del repositorio. El remoto queda con el nombre `base`, no `origin`: así
  `guardar` confirma en su computador y no sube nada a GitHub mientras ella no pida conectar el proyecto a un
  repositorio.
- Si la carpeta ya era un repositorio de git (por ejemplo, con solo un `README.md`), no copies encima: explícale que
  el proyecto base trae su propia historia y pregúntale si se puede vaciar la carpeta primero.

## 3. Dejarlo listo

1. **Su identidad en git**, solo para este repositorio: `git config user.name erescalona` y como correo el que da
   `gh api user --jq '"\(.id)+\(.login)@users.noreply.github.com"'`.
2. `pnpm install --frozen-lockfile`.
3. `tools/fase/verificar`, en Git Bash: tipos, pruebas, base de datos local, integración, dependencias, formato y
   build sobre la arquitectura vacía. Todo debe pasar; si algo falla, arréglalo en su causa antes de seguir. Es la
   prueba de que su computador está listo para la hackatón.

## 4. Contarle

En pocas líneas:

- que el proyecto quedó en esta carpeta, listo para la fase 01, y que no subió nada a GitHub;
- que el plan de las 13 fases está en `fases/README.md`;
- que cada fase se trabaja así: `/erescalona-personal:idea fase 01`, después `/erescalona-personal:construir`, y
  al terminar `/erescalona-personal:guardar` y `/erescalona-personal:publicar`;
- que el número de WhatsApp sigue respondiendo desde el servidor original hasta que, desde la fase 03, se cambie con
  `tools/whatsapp/servidor hackaton` (y se devuelve con `tools/whatsapp/servidor original`).
