# Seguimiento de Alumnos con Dificultades de Aprendizaje

Sistema desarrollado en **Object Pascal** (IDE Lazarus) para la materia Algoritmos y Estructuras de Datos, que permite gestionar y consultar información de alumnos con dificultades de aprendizaje y su evolución a lo largo del tiempo.

## Descripción

El sistema permite registrar alumnos, hacer un seguimiento periódico de su evolución frente a distintas dificultades de aprendizaje, y generar listados y estadísticas a partir de esa información.

Las dificultades contempladas son:

1. Problemas del habla y lenguaje
2. Dificultad para escribir
3. Dificultades de aprendizaje visual
4. Memoria y otras dificultades del pensamiento
5. Destrezas sociales inadecuadas

## Estructura de datos

### Archivo de Alumnos
- Número de Legajo
- Apellido y Nombres
- Fecha de Nacimiento
- Estado (baja lógica)
- Discapacidades: `array [1..5] of boolean`

### Archivo de Evaluaciones
- Número de Legajo
- Fecha de Evaluación (una por alumno por día)
- Valoración de seguimiento por dificultad: `array [1..5] of integer` (rango 0..4)
- Observación (campo de texto libre)

## Funcionalidades

- **Alumnos:** alta, baja, modificación y consulta (ABMC)
- **Seguimiento/Evaluaciones:** alta, modificación y consulta (AMC)
- **Listados:**
  - Alumnos ordenados por Apellido y Nombres
  - Evaluaciones de un alumno determinado
  - Alumnos con una discapacidad determinada
- **Estadísticas:**
  - Distribución de evaluaciones por discapacidad entre dos fechas
  - Discapacidades con mayor grado de dificultad entre dos fechas
  - Opción adicional de libre elección

## Estructura del menú

```
Menú Principal
├── Alumno
│   ├── Alta
│   ├── Baja
│   ├── Modificación
│   └── Consulta
├── Seguimiento
│   ├── Alta
│   ├── Modificación
│   └── Consulta
├── Listados
│   ├── Alumnos (por Apellido y Nombres)
│   ├── Evaluaciones de un alumno
│   └── Alumnos por discapacidad
└── Estadísticas
    ├── Distribución de evaluaciones por discapacidad
    ├── Discapacidades con mayor dificultad
    └── Opción libre
```

## Implementación

- Archivos de acceso aleatorio (**random files**) para alumnos y evaluaciones.
- El archivo de Alumnos se mantiene ordenado mediante **árboles binarios de búsqueda**: uno por Número de Legajo y otro por Apellido y Nombres (clave + posición relativa al maestro).
- El archivo de Evaluaciones se mantiene ordenado por fecha.
- Proyecto modularizado en **Units**.

> [!IMPORTANT] 
## Datos de prueba
Para poder usar los datos de prueba incluidos en el repositorio, es necesario actualizar las rutas de los archivos dentro de las units `TIPO_ARCHIVO1` y `TIPO_ARCHIVO2`, apuntando a la ubicación donde tengas guardados los archivos de datos en tu propia máquina.

## Requisitos

- [Lazarus IDE](https://www.lazarus-ide.org/) (Free Pascal Compiler)
