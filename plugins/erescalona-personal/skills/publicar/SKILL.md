---
name: publicar
description: 'Publica en internet la versión guardada del proyecto de erescalona con el CLI de Railway, comprueba que quedó funcionando y le da la dirección. Úsala cuando ella diga publicar, desplegar, subir a internet, poner en línea o «que otros lo vean».'
---

# Publicar con Railway

## Antes de publicar

1. **Publica solo lo guardado.** Si `git status` muestra cambios sin confirmar, usa primero la skill `guardar`.
2. **Busca la clave de Railway**: la variable `RAILWAY_TOKEN` en el `.env` de la raíz del proyecto. Con ella el
   CLI publica sin iniciar sesión. Si no está, explícale que necesita una clave del proyecto de Railway (se crea
   en Railway, en la configuración del proyecto, «Tokens») y que su profesor puede dársela; no sigas sin ella.
3. **Busca cómo publica este proyecto**: si el `CLAUDE.md` o `tools/railway/` dicen cómo, sigue eso (por
   ejemplo `tools/railway/desplegar api`, en Git Bash). Si no, usa el CLI directo, cargando el `.env` antes:
   `set -a; . ./.env; set +a; railway up --service <servicio> --ci --message "<último commit>"`.

## Publicar y comprobar

1. Cuéntale qué vas a publicar (qué parte: la web, el servidor o las dos) y que tarda unos minutos.
2. Publica. Si la construcción falla, lee el error, arréglalo en su causa, guarda y vuelve a publicar.
3. Comprueba que quedó vivo: revisa el registro con `railway logs --service <servicio>` y abre la dirección
   pública (por ejemplo, la ruta `/health` del servidor o la página principal de la web).
4. Dale la dirección y dile qué puede probar ahí.

## Reglas

- Nunca borres servicios, variables ni proyectos de Railway, ni cambies variables de producción sin preguntarle.
- Si publicar cambia algo que ya usan otras personas, avísale antes de hacerlo.
