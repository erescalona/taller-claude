---
name: guardar
description: 'Guarda el trabajo de erescalona en git y lo sube a su repositorio de GitHub, con un mensaje claro en español y a su nombre. Úsala cuando ella diga guardar, subir, confirmar, hacer commit o «que no se pierda», y al terminar una historia construida si ella está de acuerdo.'
---

# Guardar en GitHub

## Pasos

1. **Mira qué cambió** (`git status`, `git diff --stat`) y cuéntaselo en una o dos líneas, en palabras de lo que
   hace el proyecto ahora.
2. **Revisa que el trabajo esté sano**: las pruebas y los tipos pasan. Si algo falla, díselo y arréglalo antes
   de guardar; no guardes algo roto sin que ella lo sepa y lo acepte.
3. **Revisa que el autor sea ella**: `git config user.name` y `git config user.email` deben ser los suyos (su
   usuario de GitHub, erescalona). Si son de otra persona o están vacíos, no confirmes: pregúntale y configúralos
   en este repositorio.
4. **Cuida los secretos**: si un archivo con claves (`.env`, `*.key`, credenciales) va a quedar en el commit,
   comprueba con `gh repo view --json visibility` que el repositorio sea privado. Si es público, no lo subas:
   explícale el riesgo y quita ese archivo del commit.
5. **Confirma** con un mensaje en español: una primera línea corta con lo que cambia, una línea en blanco y un
   párrafo con el porqué y cómo se comprobó.
6. **Sube** a GitHub con `git push`. Si no hay rama remota todavía, usa `git push -u origin <rama>`.
7. **Cuéntale** que quedó guardado y dale el enlace al commit en GitHub.

## Reglas

- Nunca uses `git push --force`, `git reset --hard` ni borres ramas o historia: si algo parece pedirlo, detente
  y explícale qué pasa.
- Un commit por paso con sentido propio; varios commits pequeños son mejores que uno enorme.
- Si `git push` pide iniciar sesión, explícale que se abrirá el navegador para entrar a GitHub con su cuenta.
