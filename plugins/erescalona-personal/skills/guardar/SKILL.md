---
name: guardar
description: 'Guarda el trabajo de erescalona en git, en su computador, con un mensaje claro en español y a su nombre; lo sube a GitHub solo si ella pidió conectar el proyecto a un repositorio remoto. Úsala cuando ella diga guardar, confirmar, hacer commit o «que no se pierda», y cuando pida subir el proyecto o conectarlo a GitHub.'
---

# Guardar

El trabajo de ella vive en su computador. Guardar es confirmarlo en git ahí. Subirlo a GitHub pasa solo cuando
ella pidió conectar el proyecto a un repositorio remoto.

## Guardar en el computador

1. **Mira qué cambió** (`git status`, `git diff --stat`) y cuéntaselo en una o dos líneas, en palabras de lo que
   hace el proyecto ahora.
2. **Revisa que el trabajo esté sano**: las pruebas y los tipos pasan. Si algo falla, díselo y arréglalo antes
   de guardar; no guardes algo roto sin que ella lo sepa y lo acepte.
3. **Revisa que el autor sea ella**: `git config user.name` y `git config user.email` deben ser los suyos (su
   usuario de GitHub, erescalona). Si son de otra persona o están vacíos, no confirmes: pregúntale y configúralos
   en este repositorio.
4. **Confirma** con un mensaje en español: una primera línea corta con lo que cambia, una línea en blanco y un
   párrafo con el porqué y cómo se comprobó.
5. **Cuéntale** que quedó guardado en su computador.

## Subir a GitHub, solo si está conectado

- Si `git remote get-url origin` responde, el proyecto está conectado porque ella lo pidió: sube con `git push`
  (la primera vez, `git push -u origin <rama>`) y dale el enlace al commit en GitHub.
- Si no responde, no subas nada ni crees un repositorio. Quedó guardado en su computador y eso basta.

## Conectar a GitHub, solo cuando ella lo pide

Cuando ella pida subir el proyecto a GitHub o conectarlo a un repositorio:

1. Pregúntale si ya tiene un repositorio (pídele el enlace) o si quiere que lo crees.
2. Si ya lo tiene: `git remote add origin <enlace>` y `git push -u origin main`.
3. Si quiere uno nuevo: `gh repo create erescalona/<nombre> --private --source . --remote origin --push`. Es
   privado salvo que ella pida otra cosa.
4. **Cuida los secretos**: antes de subir, comprueba que ningún archivo con claves (`.env`, `*.key`,
   credenciales) esté en git. Los `.env` ya están en `.gitignore`.

## Reglas

- Nunca uses `git push --force`, `git reset --hard` ni borres ramas o historia: si algo parece pedirlo, detente
  y explícale qué pasa.
- Un commit por paso con sentido propio; varios commits pequeños son mejores que uno enorme.
- Si GitHub pide iniciar sesión, explícale que se abrirá el navegador para entrar con su cuenta.
