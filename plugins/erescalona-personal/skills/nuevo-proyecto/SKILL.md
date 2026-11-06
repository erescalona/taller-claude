---
name: nuevo-proyecto
description: 'Arma un proyecto nuevo de erescalona desde su plantilla (erescalona/plantilla-proyectos) en la raíz de la carpeta donde está trabajando: la API, la web, los componentes, la IA, los .env, la base de datos local, git y todas las comprobaciones pasando, todo en su computador. Úsala cuando ella diga que quiere empezar, crear o arrancar un proyecto, una app o una página nueva, o cuando pida algo en una carpeta que todavía no es un proyecto.'
---

# Nuevo proyecto desde la plantilla

La plantilla `erescalona/plantilla-proyectos` trae el monorepo listo: la API, la web, los componentes, el paquete
de IA, las comprobaciones y su `CLAUDE.md`. Esta skill la pone en la carpeta donde se está trabajando y deja todo
funcionando en su computador.

## Reglas que no se negocian

- **Dónde:** el proyecto queda en la raíz de la carpeta actual de la sesión. No lo pongas en otra carpeta ni en
  una subcarpeta.
- **Local:** todo queda en su computador, con git. No crees repositorios en GitHub ni subas nada, salvo que ella
  pida conectar el proyecto a un repositorio remoto; entonces sigue la skill `guardar`.

## 1. Mirar la carpeta

Lista lo que hay en la carpeta. Puede estar vacía o tener solo `README.md`, `LICENSE`, `.gitignore` o `.git`.
Si tiene otro contenido (código, otro proyecto), no lo toques: explícale qué hay y pregúntale qué hacer.

## 2. Lo que hace falta saber

- **El nombre**: en minúsculas, con guiones y sin tildes. Propón el nombre de la carpeta en esa forma (por
  ejemplo `Agenda de Citas` → `agenda-de-citas`) y confírmalo.
- **Una frase de qué es**, en sus palabras. Va al README y al `CLAUDE.md`.

Si ya los dijo, no vuelvas a preguntar.

## 3. Antes de copiar

1. `gh auth status` debe mostrar la cuenta erescalona, porque la plantilla es privada y se descarga de su GitHub.
   Si no, pídele que corra `gh auth login --web` y entre con su cuenta en el navegador; no inicies sesión por
   ella.
2. Comprueba Node, pnpm y Docker con lo que dice la skill `revisar-mi-compu`; si algo falta, arréglalo primero.

## 4. Copiar la plantilla en la raíz

En Git Bash, desde la carpeta del proyecto:

```sh
tmp=$(mktemp -d)
gh repo clone erescalona/plantilla-proyectos "$tmp/plantilla" -- --depth 1
rm -rf "$tmp/plantilla/.git"
cp -R "$tmp/plantilla/." .
rm -rf "$tmp"
```

La plantilla reemplaza un `README.md` o `.gitignore` que ya hubiera; un `LICENSE` se queda. Si la carpeta no es
un repositorio de git todavía, `git init -b main`.

## 5. Hacerlo suyo

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

## 6. Guardar y contarle

1. Guarda con la skill `guardar`, con el mensaje `chore: <nombre> desde la plantilla`. Queda en su computador.
2. Dile, en pocas líneas:
   - que el proyecto quedó en esta carpeta y guardado en git en su computador;
   - que para verlo corriendo use `pnpm --filter web dev` y abra `http://localhost:4321`;
   - que si algún día lo quiere en GitHub, lo pida y se conecta a un repositorio;
   - y que el siguiente paso es contarle a Claude su primera idea (skill `idea`).

## Más reglas

- No subas los `.env`: ya están en `.gitignore`.
- No cambies la plantilla desde un proyecto: si algo de la plantilla debería mejorar, díselo para que se haga en
  `erescalona/plantilla-proyectos`.
