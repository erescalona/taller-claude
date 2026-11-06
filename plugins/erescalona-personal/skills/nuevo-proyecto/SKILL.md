---
name: nuevo-proyecto
description: 'Crea un proyecto nuevo de erescalona desde su plantilla (erescalona/plantilla-proyectos): un repositorio privado en su GitHub, la copia en su computador, los .env, la base de datos local y todas las comprobaciones pasando. Úsala cuando ella diga que quiere empezar, crear o arrancar un proyecto, una app o una página nueva, o cuando pida algo en una carpeta que todavía no es un proyecto.'
---

# Nuevo proyecto desde la plantilla

La plantilla `erescalona/plantilla-proyectos` trae el monorepo listo: la API, la web, los componentes, el paquete
de IA, las comprobaciones y su `CLAUDE.md`. Esta skill la copia a un repositorio nuevo y deja todo funcionando.

## 1. Lo que hace falta saber

- **El nombre**: en minúsculas, con guiones y sin tildes, por ejemplo `agenda-de-citas`. Si ella da un nombre
  con espacios o tildes, propón esa forma y confírmala.
- **Una frase de qué es**, en sus palabras. Va al README y al `CLAUDE.md` del proyecto.

Si ya los dijo, no vuelvas a preguntar.

## 2. Antes de crear

1. Comprueba que el CLI de GitHub tenga la sesión de ella: `gh auth status` debe mostrar la cuenta erescalona.
   Si no, pídele que corra `gh auth login --web` y que entre con su cuenta en el navegador; no inicies sesión por
   ella.
2. Comprueba que no exista ya: `gh repo view erescalona/<nombre>` debe fallar. Si existe, pídele otro nombre.
3. Comprueba Node, pnpm y Docker con lo que dice la skill `revisar-mi-compu`; si algo falta, arréglalo primero.
4. La carpeta de proyectos: `C:\dev` en Windows (`/c/dev` en Git Bash) o `~/dev` en Mac, fuera de OneDrive.
   Créala si no existe. Si ya hay una carpeta con ese nombre adentro, no la toques: pide otro nombre.

## 3. Crear el repositorio y la copia

Desde la carpeta de proyectos:

```sh
gh repo create erescalona/<nombre> --private --template erescalona/plantilla-proyectos --clone
```

GitHub tarda unos segundos en llenar un repositorio creado desde una plantilla: si la carpeta queda vacía,
espera cinco segundos y corre `git pull origin main` dentro de ella.

## 4. Hacerlo suyo

Dentro de la carpeta del proyecto:

1. **Su identidad en git**, solo para este repositorio: `git config user.name erescalona` y como correo el que
   da `gh api user --jq '"\(.id)+\(.login)@users.noreply.github.com"'`. Los commits de sus proyectos son suyos.
2. **El nombre**: `"name"` en el `package.json` de la raíz pasa a `<nombre>`; el título `# Proyecto` del
   README y del `CLAUDE.md`, y el texto «Proyecto» de `apps/web/src/layouts/AppLayout.astro`, pasan al nombre
   legible (por ejemplo «Agenda de citas»). Debajo del título del README y del `CLAUDE.md`, la frase de ella.
3. **Los `.env`**: copia `apps/api/.env.example` y `apps/web/.env.example` a `.env` en su misma carpeta. En
   `apps/api/.env`, la base de `DATABASE_URL` pasa de `proyecto` al nombre con guiones bajos (por ejemplo
   `agenda_de_citas`), para que cada proyecto tenga sus propios datos.
4. `pnpm install`.
5. Docker Desktop abierto (o `container` en Mac) y `pnpm db:up`: crea la base del proyecto.
6. `tools/verificar`, en Git Bash. Todo debe pasar; si algo falla, arréglalo en su causa antes de seguir.

## 5. Guardar y contarle

1. Guarda con la skill `guardar`, con el mensaje `chore: <nombre> desde la plantilla`.
2. Dile, en pocas líneas:
   - dónde quedó la carpeta y el enlace al repositorio en GitHub;
   - que abra esa carpeta en Claude Desktop (pestaña Code) para trabajar en el proyecto, porque ahí Claude lee
     su `CLAUDE.md`;
   - que para verlo corriendo use `pnpm --filter web dev` y abra `http://localhost:4321`;
   - y que el siguiente paso es contarle a Claude su primera idea (skill `idea`).

## Reglas

- El repositorio es privado salvo que ella pida otra cosa.
- No subas los `.env`: ya están en `.gitignore`.
- No cambies la plantilla desde un proyecto: si algo de la plantilla debería mejorar, díselo para que se haga en
  `erescalona/plantilla-proyectos`.
