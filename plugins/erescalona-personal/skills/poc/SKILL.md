---
name: poc
description: 'Construye una prueba de concepto — código real, ejecutable y desechable que contesta UNA pregunta con un veredicto — bajo docs/poc/{tema}/. Úsala siempre que un plan afirme algo que nadie ha medido: una cifra, un límite, una fórmula, el comportamiento de una librería, una semántica de ejecución. Úsala cuando: (1) /slice-plan encuentra una afirmación no verificable, (2) el usuario pide medir si algo funciona, (3) una decisión de diseño depende de un número.'
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch
---

# Construir una PoC

Código **real, ejecutable y desechable** que contesta **una** pregunta con un veredicto. Vive en
`docs/poc/{tema}/`, no en `src/`, y se borra sin que nada se rompa.

## La regla que la justifica

**Ninguna cifra sin fuente.** Cada número que una rebanada asume viene de una medición o está
etiquetado, en voz alta, como **supuesto sin medir**. Nunca implícito.

Lo que casi siempre hace falta medir: un umbral, un límite, una comisión, un timeout · «esto escala» ·
«la librería hace X» —el comportamiento de una dependencia en el borde: streaming, reintentos, relojes,
unicode— · cualquier fórmula con dinero, ranking, cuotas o reparto, que se comportan al revés de lo que
la intuición dice · y toda semántica de ejecución: zonas horarias, aislamiento de transacciones, orden,
fallo parcial.

**Esto incluye a las propias herramientas de prueba.** Un rango de versiones o un peer requirement es un
hecho que se comprueba corriéndolo, no uno que se recuerda.

## La forma

```
docs/poc/{tema}/
  README.md      ← la pregunta, el método, el VEREDICTO con su número
  run.mjs        ← ejecutable, semilla fija, sale ≠ 0 si FALLA
```

- **Una sola pregunta.** Dos preguntas son dos PoCs, y una PoC que contesta dos contesta mal las dos.
- **Semilla fija.** Un veredicto que cambia entre corridas no es un veredicto.
- **Barre regímenes, no midas un punto.** La respuesta suele cambiar de signo en algún sitio, y el
  sitio es lo interesante.
- **Incluye al adversario**: el participante que juega a romper la fórmula, simulado.
- **El veredicto es `PASA` o `FALLA`, con su número**, y el proceso sale ≠ 0 cuando falla. Un README
  que dice «parece razonable» no ha medido nada.

## Una PoC que FALLA es el mejor resultado disponible

Acaba de salvar una rebanada entera antes de que existiera, que es la única vez que sale barato.
Repórtala **primero**, y más alto que un veredicto que pasa. Un plan que sobrevive a una PoC fallida es
un plan mejor; uno que la esconde es el plan anterior con más confianza.

## Cítala con su número

Desde la rebanada, la cita **carga su contenido**: no «medido en la PoC», sino _«midió 2 ms con 10.000
filas, 25× por debajo del umbral — por eso no hay total materializado»_. Un enlace pelado obliga a
abrir cinco documentos para averiguar si alguno importa.
