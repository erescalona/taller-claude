---
name: revisar-mi-compu
description: 'Comprueba que el computador de erescalona (Windows o Mac) tenga todo lo que necesitan sus proyectos (Git, el CLI de GitHub, Node 22, pnpm, Docker, el CLI de Railway y Claude) y le dice en palabras sencillas qué falta y cómo arreglarlo. Úsala cuando ella pregunte si su compu está lista, cuando un comando falle porque algo no está instalado, o antes de empezar un proyecto nuevo.'
---

# Revisar el computador

## Qué comprobar

Corre cada comprobación y anota el resultado. En Windows, Claude usa Git Bash; los comandos son los mismos.

| Qué | Comando | Está bien si… |
| --- | --- | --- |
| Git | `git --version` | responde una versión |
| GitHub | `gh auth status` | muestra la sesión de la cuenta erescalona |
| Node.js | `node -v` | es v22.13 o más nuevo (el estándar es Node 22) |
| pnpm | `pnpm -v` | es 10 o más nuevo |
| Docker | `docker info` | responde sin error: Docker Desktop está abierto y dice «Engine running» |
| Railway | `railway --version` | responde una versión |
| Claude Code | `claude --version` | responde una versión |
| Autor de los commits | `git config user.name` y `git config user.email` en el proyecto | son los de ella |
| Rutas largas (Windows) | `git config --global core.longpaths` | dice `true` |
| Carpeta del proyecto | la ruta actual | no está dentro de OneDrive: su sincronización vuelve lentos o rompe los proyectos |

## Cómo contárselo

Una tabla corta con «Listo» o «Falta» por cada cosa y, para lo que falte, el arreglo exacto:

| Falta | Arreglo (PowerShell en Windows) |
| --- | --- |
| Git | `winget install --id Git.Git -e` |
| CLI de GitHub | `winget install --id GitHub.cli -e`, y después ella corre `gh auth login --web` y entra con su cuenta |
| Node 22 | Descargar Node 22 LTS de nodejs.org e instalar con las opciones por defecto |
| pnpm | `npm install -g pnpm@10` |
| Docker | Abrir Docker Desktop y esperar «Engine running»; si no está instalado, seguir la guía de instalación de Coninsa |
| Railway | `npm install -g @railway/cli` |
| Claude Code | `irm https://claude.ai/install.ps1 \| iex` |
| Rutas largas | `git config --global core.longpaths true` |
| Carpeta en OneDrive | Avisarle y proponerle una carpeta fuera de OneDrive; ella decide dónde |

## Reglas

- Pregúntale antes de instalar algo: algunas instalaciones piden permiso de administrador y una ventana de «Sí».
- Después de instalar, dile que cierre y vuelva a abrir la terminal y Claude Desktop, porque no ven los programas
  nuevos hasta reiniciarse, y vuelve a comprobar.
- No cambies configuraciones del sistema (registro de Windows, antivirus, BIOS): si algo lo necesita, explícale
  qué y que pida apoyo.
