---
name: publicar
description: 'Publica en internet el proyecto de erescalona con el CLI de Railway y la clave del proyecto que guarda su .env, comprueba que quedó funcionando y le da la dirección. Úsala solo cuando ella diga publicar, desplegar, subir a internet, poner en línea o «que otros lo vean», o cuando el CLAUDE.md del proyecto pida desplegar.'
---

# Publicar con Railway

Publicar sube el código de esta carpeta a Railway, que lo construye y lo pone en internet. Usa la clave del
proyecto de Railway que guarda el `.env`, así que no hace falta iniciar sesión en Railway. No toca GitHub.

## Antes de publicar

1. **Publica solo lo guardado.** Si `git status` muestra cambios sin confirmar, usa primero la skill `guardar`.
2. **La clave**: `RAILWAY_TOKEN` en el `.env` de la raíz del proyecto, una clave del proyecto de Railway. Si no
   está, explícale que la crea quien administra el proyecto en Railway (el proyecto, Settings, Tokens) y que va
   en ese `.env`; no sigas sin ella y nunca la escribas en otro archivo ni en un mensaje.
3. **El CLI**: `railway --version` debe responder. Si no, la skill `revisar-mi-compu` dice cómo instalarlo.
4. **Qué se publica**: la API, la web o las dos. Pregúntale si no es obvio, y avísale que lo que está en vivo
   cambia por esta versión.

## Publicar

En Git Bash, desde la raíz del proyecto:

- Si el proyecto trae `tools/railway/desplegar`, úsalo: `tools/railway/desplegar api` y `tools/railway/desplegar
  web`. Lee la clave y los nombres de los servicios del `.env`.
- Si no, con el CLI directo, cargando el `.env` antes:
  `set -a; . ./.env; set +a; railway up --service <servicio> --ci --message "<último commit>"`. El nombre de cada
  servicio sale de `RAILWAY_API_SERVICE` y `RAILWAY_WEB_SERVICE` en el `.env`, o de `railway status`.

`--ci` muestra el registro de la construcción y termina con error si la construcción falla. Si falla, lee el
error, arréglalo en su causa, guarda y vuelve a publicar.

## Comprobar que quedó vivo

1. `railway deployment list --service <servicio>`: la última debe estar en `SUCCESS`.
2. Abre la dirección pública: la ruta `/health` de la API debe responder `{"status":"ok"}`, y la web debe abrir.
   `railway logs --service <servicio>` muestra el registro si algo no responde.
3. Dale la dirección y dile qué puede probar ahí.

## Reglas

- Solo cuando ella lo pida o el `CLAUDE.md` del proyecto lo indique.
- Nunca borres servicios, variables, despliegues ni proyectos de Railway, ni cambies variables sin preguntarle.
- La clave de Railway no se muestra, no se copia a otros archivos y no se sube a GitHub: el `.env` está en
  `.gitignore`.
