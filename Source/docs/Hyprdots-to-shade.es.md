# ¡Hola! 👋 Aquí Khing

[![de](https://img.shields.io/badge/lang-de-black.svg)](./Hyprdots-to-shade.de.md)
[![en](https://img.shields.io/badge/lang-en-red.svg)](../../Hyprdots-to-shade.md)
[![中文](https://img.shields.io/badge/lang-中文-orange.svg)](./Hyprdots-to-shade.zh.md)

## Este fork mejorará y corregirá prasanthrangan/hyprdots con el tiempo

### ¿Por qué?

- Tittu (el creador original) está AFK por ahora, y soy el único colaborador restante. ⁉️
- Mis permisos son limitados, así que solo puedo fusionar PRs. Si algo se rompe, tengo que esperar ayuda. 😭
- No cambiaré todo en sus dotfiles por respeto.
- Este repositorio no **sobrescribirá** los dotfiles de $USER.

**Este fork es temporal y servirá como puente entre la estructura antigua y una nueva [próximamente...].**

### ¿Quiénes son los $USER?

> **NOTA**: Si estás confundido sobre por qué cada vez que ejecutas `install.sh -r` se sobrescriben tus configuraciones, deberías hacer un fork de [shade](https://github.com/shade-Project/shade), editar el archivo `*.lst` y ejecutar el script. Esa es la forma prevista.

¿Quiénes son los $USER?

✅ No quieren mantener un fork
✅ Quieren mantenerse actualizados con estos excelentes dotfiles
✅ No saben cómo funciona el repositorio
✅ No tienen tiempo para crear sus propios dotfiles, solo quieren inspiración
✅ Quieren un `~/.config` más limpio con todo estructurado como un paquete real de Linux
✅ Exigen una experiencia similar a un entorno de escritorio (DE)

### HOJA DE RUTA 🛣️📍

- [ ] **Portabilidad**

  - [ ] Los archivos específicos de shade deben importarse al $USER, no al revés
  - [x] Mantenerlo minimalista
  - [ ] Hacerlo empaquetable
  - [x] Seguir las especificaciones XDG
  - [ ] Agregar Makefile

- [ ] **Extensibilidad**

  - [ ] Agregar un sistema de extensiones para shade
  - [ ] Instalación predecible

- [ ] **Rendimiento**

  - [ ] Optimizar scripts para velocidad y eficiencia
  - [ ] Crear una CLI única para gestionar todos los scripts principales

- [ ] **Manejabilidad**

  - [ ] Corregir scripts (compatibles con shellcheck)
  - [x] Mover scripts a `./lib/shade`
  - [x] Hacer que los scripts `wallbash*.sh` sean monolíticos para solucionar problemas de wallbash

- [ ] **Mejor Abstracción**

  - [ ] Waybar
  - [x] Hyprlock
  - [x] Animaciones
  - [ ] ...

- [ ] Limpieza
- [ ] **...**

---

Aquí está cómo podemos actualizar las configuraciones específicas de Hyprland de shade sin cambiar las preferencias del usuario. No necesitamos el archivo "userprefs". En su lugar, podemos usar el archivo `hyprland.conf` de shade y realizar los cambios preferidos por el $USER directamente en la configuración. Con este enfoque, no se romperá shade y shade no romperá tus propios dotfiles.

![Estructura de Hyprland](https://github.com/user-attachments/assets/91b35c2e-0003-458f-ab58-18fc29541268)

# ¿Por qué llamarlo shade?

Como el último colaborador en pie, no sé qué pretendía el creador original. Pero creo que es un buen nombre. Solo que no sé qué significa. 🤷‍♂️

Aquí están algunas de mis especulaciones:

- **Hy**prdots **D**otfiles **E**nhanced - Versión mejorada de hyprdots cuando @prasanthrangan introdujo wallbash como nuestro motor principal de gestión de temas.
- **Hy**prland **D**otfiles **E**xtended - Dotfiles extensibles para Hyprland.
- Pero la que más sentido tiene es - **Hy**prland **D**esktop **E**nvironment - ya que Hyprland suele considerarse un gestor de ventanas (WM) para Wayland, no un entorno de escritorio completo, y este dotfile lo convierte en un entorno de escritorio completo.

Siéntete libre de sugerir tu propio significado de shade. 🤔
