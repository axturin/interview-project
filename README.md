# Dial

## Setup

Este proyecto usa [Vite](https://vitejs.dev/), que provee un modo desarrollo
que se encarga de recargar el navegador con cada cambio en los ficheros del
proyecto.

### Requerimientos

- Node, 14 o superior

### Instalación de dependencias

`npm install`

### Desarrollo

`npm start`

En modo desarrollo, cualquier cambio en los ficheros html, css, o elm hacen que
se recalcule el diseño sin necesidad de recargar la página (también se encarga
de sincronizar tailwind con los cambios en Elm).

## Opciones

### Desactivar Tailwind

Tailwind se puede descactivar:

- Quitando tailwind del fichero `postcss.config.js`
- Quitando las referencias a tailwind del fichero `src/styles.css`

