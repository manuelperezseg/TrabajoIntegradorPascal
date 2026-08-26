UNIT UNIT_MENUS;
{$CODEPAGE UTF8}
INTERFACE

USES  UNIT_ARBOL, TIPOS_ARCHIVO2,TIPOS_ARCHIVO1,
  UNIT_PROC_EVS, VERIFICADORES, LISTADOS, ESTADISTICAS,UNIT_MANEJO_INTERFACE,UNIT_PROC_ALUM,SysUtils;



PROCEDURE MENU_LEGAJO(VAR ARCHIVO1:T_ARCHIVO1; VAR ARBOL_LEGAJOS:T_PUNT; VAR ARBOL_APYNOM:T_PUNT);
PROCEDURE MENU_SEGUIMIENTO(VAR ARCHIVO1:T_ARCHIVO1; VAR ARCHIVO2:T_ARCHIVO2; VAR ARBOL_LEGAJOS:T_PUNT);
PROCEDURE MENU_LISTADOS(VAR ARCHIVO1:T_ARCHIVO1;VAR ARCHIVO2:T_ARCHIVO2; ARBOLAPYNOM:T_PUNT; ARBOL_LEGAJOS:T_PUNT);
PROCEDURE MENU_ESTADISTICAS(VAR ARCHIVO1:T_ARCHIVO1;ARBOL_LEGAJOS:T_PUNT;VAR ARCHIVO2:T_ARCHIVO2);

IMPLEMENTATION

FUNCTION PEDIR_BUSCADO_ALUMNO(VAR FILA:INTEGER; COL:INTEGER):SHORTSTRING;

BEGIN
 INC(FILA);
GOTOXYMIO(COL,FILA);
      WRITE('Ingrese el LEGAJO del Alumno que quiere buscar: ');
     (PEDIR_BUSCADO_ALUMNO):=VALIDAR_LEGAJO(FILA,COL);   //HACER VALIDACIÓN DE LEGAJO
end;

FUNCTION PEDIR_BUSCADO_ALUMNO2(VAR FILA:INTEGER; COL:INTEGER):SHORTSTRING;

BEGIN
 FILA:=FILA+2;
GOTOXYMIO(COL,FILA);
      WRITE('Ingrese el LEGAJO del Alumno del que quiere mostrar sus evaluaciones');
     (PEDIR_BUSCADO_ALUMNO2):=VALIDAR_LEGAJO(FILA,COL);
end;

PROCEDURE PEDIR_BUSCADO_FECHA(VAR FECHA: SHORTSTRING; VAR CONTROL:INTEGER;VAR FILA:INTEGER; COL:INTEGER);
BEGIN
FILA:=FILA+2;
    GOTOXYMIO(COL,FILA);
    WRITE('Ingrese la Fecha de la Evaluación que quiere buscar');
    CARGAR_FECHAS2(FECHA,FILA);
  IF FECHA = 'ERROR' THEN
  BEGIN
  CONTROL:=-4;
   END ELSE
   IF CONTROL = 10 THEN
     PEDIR_BUSCADO_FECHA(FECHA,CONTROL,FILA,COL);
END;


PROCEDURE MENU_ALUMNO(VAR ARCHIVO1:T_ARCHIVO1; VAR ARBOL_LEGAJOS:T_PUNT; VAR ARBOL_APYNOM:T_PUNT; LEGAJO:SHORTSTRING;VAR FILA:INTEGER);
VAR
  OP:CHAR;
  V,COL:INTEGER;
BEGIN
 v:=-2;
REPEAT
  LIMPIAR_PANTALLA;
FILA:=0;
COL:=1;
INC(FILA);
GOTOXYMIO(1,FILA);
  WRITE( '*** DATOS ACTUALES DEL ALUMNO CON LEGAJO: ',LEGAJO, ' ***');
  MOSTRAR_DATOS(ARCHIVO1,ARBOL_LEGAJOS,LEGAJO,FILA,V);
  FILA:=FILA + 2;
  GOTOXYMIO(1,FILA);
  WRITE( '*** ACCIONES PARA REALIZAR ***');
  INC(FILA);
GOTOXYMIO(1,FILA);
  WRITE('1. Baja del Alumno');
  INC(FILA);
GOTOXYMIO(1,FILA);
  WRITE('2. Modificación de datos del Alumno');
  INC(FILA);
GOTOXYMIO(1,FILA);
  WRITE('0. Volver');
  OP:=LEER_OPCION(COL,FILA);
  CASE OP OF
  '1': BEGIN
     BAJA_ALUMNO (ARCHIVO1,ARBOL_LEGAJOS,LEGAJO,V,FILA);
       IF V= 20 THEN
       BEGIN
       DECIR_CONTROL_ALUMNOS(VALOR_CONTROL(V),FILA);
       OP:='0';
       END;
     END;
  '2': BEGIN
     MODIFICAR_ALUMNO (ARCHIVO1,ARBOL_APYNOM,ARBOL_LEGAJOS,LEGAJO,V,FILA);
     DECIR_CONTROL_ALUMNOS(VALOR_CONTROL(V),FILA);
     END;
  '0':OP:='0';
  ELSE BEGIN
          MAL_INGRESADO(FILA,COL);
       END;
  END;
until OP='0';
END;

PROCEDURE SUBMENU_LEGAJO(VAR ARCHIVO1:T_ARCHIVO1; VAR ARBOL_LEGAJOS:T_PUNT; VAR ARBOL_APYNOM:T_PUNT; LEGAJO:SHORTSTRING;VAR FILA:INTEGER; VAR CONTROL:INTEGER);
VAR
  OP:CHAR;
  V,COL:INTEGER;
BEGIN
  REPEAT
  LIMPIAR_PANTALLA;
   FILA:=5;
   COL:=35;
  GOTOXYMIO(COL,FILA);
  WRITE('ERROR --> El alumno no está cargado o el legajo fue mal ingresado: ');
  FILA:=FILA+2;
  GOTOXYMIO(COL,FILA);
  WRITE('Ingrese 1 para los ingresar datos del alumno con legajo: '+LEGAJO);
  INC(FILA);
  GOTOXYMIO(COL,FILA);
  WRITE('Ingrese 2 para volver a ingresar el legajo.');
  INC(FILA);
  GOTOXYMIO(COL,FILA);
  WRITE('Ingrese 0 para volver la Menú Principal.');
  INC(FILA);
  GOTOXYMIO(1,FILA);
  OP:=LEER_OPCION(COL,FILA);
  CASE OP OF
  '0': BEGIN
    OP:='0';
    CONTROL:=1;
     END;
  '1':BEGIN
     LIMPIAR_PANTALLA;
     FILA:=1;
     CONTROL:=1;
     ALTA_ALUMNO(ARCHIVO1,ARBOL_APYNOM,ARBOL_LEGAJOS,LEGAJO,V,FILA);
     DECIR_CONTROL_ALUMNOS(VALOR_CONTROL(V),FILA);
     END;
  '2': BEGIN
     CONTROL:=0;
     OP:='2';
     END;
  ELSE BEGIN
        MAL_INGRESADO(FILA,COL);
      end;
END;
 UNTIL (CONTROL<>-1);
end;

PROCEDURE MENU_LEGAJO(VAR ARCHIVO1:T_ARCHIVO1; VAR ARBOL_LEGAJOS:T_PUNT; VAR ARBOL_APYNOM:T_PUNT);
  VAR
    LEGAJO:SHORTSTRING;
    CONTROL_LEGAJO,CONTROL,FILA,COL: INTEGER;
 BEGIN
 CONTROL:=-1;
      REPEAT
      FILA:=5;
      COL:=35;
      LIMPIAR_PANTALLA;
      GOTOXYMIO(COL,FILA);
      WRITE( '*** ALUMNOS ***');
      LEGAJO:=VALIDAR_LEGAJO(FILA,COL);                      //HACER VALIDACIÓN DE LEGAJO, MIRAR EL CAMBIO DE LEGAJOS EN PRUEBAS, HACER ERROR PARA LEGAJO MAL CARGADO
      IF LEGAJO = 'ERROR' THEN
      BEGIN
      CONTROL_LEGAJO:=-5;
      DECIR_CONTROL_ALUMNOS(VALOR_CONTROL(CONTROL_LEGAJO),FILA);
      CONTROL:=1;
      end ELSE
      BEGIN
        CONTROL_LEGAJO:=VERIFICAR_ESTADO(ARCHIVO1,ARBOL_LEGAJOS,LEGAJO);
        IF CONTROL_LEGAJO= 1 THEN
         BEGIN
          MENU_ALUMNO(ARCHIVO1,ARBOL_LEGAJOS,ARBOL_APYNOM,LEGAJO,FILA);
          CONTROL:=1;
         END ELSE
               IF CONTROL_LEGAJO = 0 THEN
               BEGIN
               DECIR_CONTROL_ALUMNOS(VALOR_CONTROL(0),FILA);
               CONTROL:=1;
               END ELSE
                   IF CONTROL_LEGAJO = -1 THEN      //NO EXISTE
                     begin
                     SUBMENU_LEGAJO(ARCHIVO1,ARBOL_LEGAJOS,ARBOL_APYNOM,LEGAJO,FILA,CONTROL);
                      END;
        end;
      UNTIL CONTROL =1;
 end;


PROCEDURE MENU_SEGUIMIENTO(VAR ARCHIVO1:T_ARCHIVO1; VAR ARCHIVO2:T_ARCHIVO2; VAR ARBOL_LEGAJOS:T_PUNT);
VAR
  OP:CHAR;
  FECHA: SHORTSTRING;
  LEGAJO:SHORTSTRING;
  V,FILA,COL:INTEGER;
BEGIN
REPEAT
  FILA:=5;
  COL:=45;
  v:=-6;
  LIMPIAR_PANTALLA;
   GOTOXYMIO(6,FILA);
   WRITE('******************************************** MENÚ SEGUIMIENTO ********************************************');
   fila:=fila+2;
   GOTOXYMIO(COL,FILA);
   WRITELN('1. Alta de una evaluación');
   INC(FILA);
   GOTOXYMIO(COL,FILA);
   WRITELN('2. Modificación de una evaluación');
   INC(FILA);
   GOTOXYMIO(COL,FILA);
   WRITELN('3. Ver la Evaluación de un Alumno de una Fecha particular ');
   INC(FILA);
   GOTOXYMIO(COL,FILA);
   WRITELN('0. Volver');
   FILA:=FILA+2;
   OP:=LEER_OPCION(COL,FILA);
  CASE OP OF
  '1': BEGIN
      LIMPIAR_PANTALLA;
      WRITELN('***Alta de Evaluación***');
      FILA:=2;
      ALTA_EV(ARCHIVO2,ARCHIVO1,ARBOL_LEGAJOS,V,FILA);
      DECIR_CONTROL_ALUMNOS(VALOR_VERIFICADOR(V),FILA);
      END;

  '2': BEGIN          //modificar ev
      LIMPIAR_PANTALLA;
      V:=-2;
      WRITE('***Modificación de Evaluación***');
      FILA:=2;
     PEDIR_BUSCADO_FECHA(FECHA,V,FILA,1);
     IF V = -4 THEN
       BEGIN
           DECIR_CONTROL_ALUMNOS(VALOR_VERIFICADOR(V),FILA);
       END ELSE                                            //SI SE CARGÓ BIEN LA FECHA
       BEGIN
         LEGAJO:=PEDIR_BUSCADO_ALUMNO(FILA,1);
         IF LEGAJO ='ERROR' THEN
         BEGIN
         V:=-5;
         DECIR_CONTROL_ALUMNOS(VALOR_CONTROL(V),FILA);
         END ELSE
         MODIFICAR_EVALUACION(ARCHIVO2,ARCHIVO1,ARBOL_LEGAJOS,FECHA,LEGAJO,V,FILA);
         IF V=-10 THEN             //DIÓ ERROR
           BEGIN
              DECIR_CONTROL_ALUMNOS(VALOR_BUSQUEDA_EV_PARTICULAR(LEGAJO,FECHA),FILA);
           END ELSE
            DECIR_CONTROL_ALUMNOS(VALOR_VERIFICADOR(V),FILA);
       END;
     END;
  '3': BEGIN
      LIMPIAR_PANTALLA;
      WRITE('***Mostrar la evaluación de un alumno particular***');
      FILA:=2;
     PEDIR_BUSCADO_FECHA(FECHA,V,FILA,1);
     IF V = -4 THEN
       BEGIN
           FILA:=FILA+1;
           DECIR_CONTROL_ALUMNOS(VALOR_VERIFICADOR(V),FILA);
       END ELSE                                            //SI SE CARGÓ BIEN LA FECHA
       BEGIN
         LEGAJO:=PEDIR_BUSCADO_ALUMNO(FILA,1);
         IF LEGAJO = 'ERROR' THEN
         BEGIN
         V:=-5;
         DECIR_CONTROL_ALUMNOS(VALOR_CONTROL(V),FILA);
         END ELSE
             BEGIN
             CONSULTAR_EV_PARTICULAR  (ARCHIVO1,ARCHIVO2,ARBOL_LEGAJOS,FECHA,LEGAJO,V,FILA);
             IF V = 3 THEN  //SI V NO DA -10 ENTONCES MOSTRÓ EL CONTENIDO DE LO BUSCADO
             BEGIN
             FILA:=FILA+2;
             GOTOXYMIO(1,FILA);
             WRITE('OPRIMA CUALQUIER TECLA PARA CONTINUAR');
             READKEY1;
             END ELSE
             IF V=-10 THEN             //DIÓ ERROR
               BEGIN
                  FILA:=FILA+2;
                  DECIR_CONTROL_ALUMNOS(VALOR_BUSQUEDA_EV_PARTICULAR(LEGAJO,FECHA),FILA);
               END ELSE
                DECIR_CONTROL_ALUMNOS(VALOR_CONTROL(V),FILA);
            END;
       end;
     END;
  '0':OP:='0';
  ELSE  BEGIN
           MAL_INGRESADO(FILA,COL);
        END;
  END;
until OP='0' ;
END;

PROCEDURE MENU_LISTADOS(VAR ARCHIVO1:T_ARCHIVO1;VAR ARCHIVO2:T_ARCHIVO2; ARBOLAPYNOM:T_PUNT; ARBOL_LEGAJOS:T_PUNT);
VAR
  OP:CHAR;
  LEGAJO:SHORTSTRING;
  FECHA: SHORTSTRING;
  FILA,V,CONTADOR,COL:INTEGER;
BEGIN
  REPEAT
  FILA:=5;
  COL:=45;
  LIMPIAR_PANTALLA;
  GOTOXYMIO(6,FILA);
  WRITE('******************************************** MENÚ LISTADOS ********************************************');
  fila:=fila+2;
  GOTOXYMIO(COL,FILA);
  WRITELN('1. Alumnos con dificultades ordenados por Apellido y Nombre');
  INC(FILA);
  GOTOXYMIO(COL,FILA);
  WRITELN('2. Evaluaciones de un determinado alumno');
  INC(FILA);
  GOTOXYMIO(COL,FILA);
  WRITELN('3. Evaluaciones tomadas en una fecha');
  INC(FILA);
  GOTOXYMIO(COL,FILA);
  WRITELN('4. Alumnos con determinada discapacidad');
  INC(FILA);
  GOTOXYMIO(COL,FILA);
  WRITELN('0. Volver');
  fila:=fila+2;
  OP:= LEER_OPCION(COL,FILA);
     CASE OP OF
     '1': BEGIN
          LISTADO_APYNOM(ARBOLAPYNOM,ARCHIVO1,FILA);
        END;
     '2': BEGIN
         LEGAJO:=PEDIR_BUSCADO_ALUMNO2(FILA,45);
         IF LEGAJO = 'ERROR' THEN
         BEGIN
         V:=-5;
         DECIR_CONTROL_ALUMNOS(VALOR_CONTROL(V),FILA);
         END ELSE
         BEGIN
             LISTADO_EVALUACIONES_DE(ARCHIVO2,ARCHIVO1,ARBOL_LEGAJOS,LEGAJO,FILA,V);
              CASE V OF      //SI V= -3, SI V =0, EL ALUMNO ESTÁ DADO DE BAJA, SI V=-1 EL LEGAJO NO FUE ENCONTRADO
                0:BEGIN
                    INC(FILA);
                    GOTOXYMIO(1,FILA);
                    WRITE('El alumno está dado de baja.')
                  end;
                  -3:BEGIN
                    INC(FILA);
                    GOTOXYMIO(1,FILA);
                    WRITE('El alumno no tiene evaluaciones cargadas.')
                  end;
                 -1:BEGIN
                    INC(FILA);
                    GOTOXYMIO(1,FILA);
                    WRITE('El legajo no fue encontrado, fue mal cargado o no existe.')
                  end;
                 ELSE
                  BEGIN
                     FILA:=FILA+1;
                     GOTOXYMIO(1,FILA);
                     WRITELN('ESTAS SON TODAS LA EVALUACIONES DEL ALUMNO, PRESIONE CUALQUIER TECLA PARA VOLVER AL MENÚ ANTERIOR');
                   end;
                end;
               end;
               READKEY1;
           end;
     '4': BEGIN
           LISTADO_ALUM_SEGUN_DIF(ARCHIVO1);
          END;
     '3': BEGIN
         CONTADOR:=0;
         LIMPIAR_PANTALLA;
         WRITE('***Mostrar todas las evaluaciones que se tomaron en una fecha ***');
         FILA:=2;
         PEDIR_BUSCADO_FECHA(FECHA,V,FILA,1);
         IF V = -4 THEN
           BEGIN
               DECIR_CONTROL_ALUMNOS(VALOR_VERIFICADOR(V),FILA);
           END ELSE//SI SE CARGÓ BIEN LA FECHA
               BEGIN
               CONSULTA_EVALUACIONES(ARCHIVO1,ARCHIVO2,ARBOL_LEGAJOS,FECHA,CONTADOR,V,FILA);
                DECIR_CONTROL_ALUMNOS(VALOR_BUSQUEDA_EVACIONES(FECHA,CONTADOR),FILA);
               END;
            END;
        '0':OP:='0';
        ELSE  BEGIN
                MAL_INGRESADO(FILA,COL);
              end;

     END;
     UNTIL OP='0';
     END;

PROCEDURE MENU_ESTADISTICAS(VAR ARCHIVO1:T_ARCHIVO1;ARBOL_LEGAJOS:T_PUNT;VAR ARCHIVO2:T_ARCHIVO2);
VAR
  V,FILA,COL:INTEGER;
  OP:CHAR;
BEGIN
  REPEAT
  FILA:=5;
  COL:=40;
  LIMPIAR_PANTALLA;
   GOTOXYMIO(6,FILA);
   WRITE('******************************************** MENÚ ESTADÍSTICAS ********************************************');
   fila:=fila+2;
   GOTOXYMIO(COL,FILA);
   WRITE('1. Cantidad de evaluaciones por discapacidad entre dos fechas');
   INC(FILA);
   GOTOXYMIO(COL,FILA);
   WRITE('2. Discapacidad con mayor grado de dificultad entre dos fechas');
   INC(FILA);
   GOTOXYMIO(COL,FILA);
   WRITE('3. Cantidad de ausentes y presentes en evaluaciones entre dos fechas');
   INC(FILA);
   GOTOXYMIO(COL,FILA);
   WRITE('0. Volver');
   fila:=fila+2;
    OP:=LEER_OPCION(COL,FILA);
       CASE OP OF
       '1': BEGIN
          LIMPIAR_PANTALLA;
          FILA:=1;
          LLAMAR_CANT_EVS(ARCHIVO1,ARBOL_LEGAJOS,ARCHIVO2,V,FILA);
          IF ((V=-4) OR (V=-6)) THEN
           DECIR_CONTROL_ALUMNOS(VALOR_VERIFICADOR(V),FILA);
          END;
       '2': BEGIN
           LIMPIAR_PANTALLA;
           FILA:=1;
          LLAMAR_MAYORDIF_EVS(ARCHIVO1,ARBOL_LEGAJOS,ARCHIVO2,V,FILA);
          IF ((V=-4) OR (V=-6))  THEN
           DECIR_CONTROL_ALUMNOS(VALOR_VERIFICADOR(V),FILA);

            END;
       '3': BEGIN
           LIMPIAR_PANTALLA;
           FILA:=1;
           LLAMAR_AUSENCIAS_EVS(ARCHIVO1,ARBOL_LEGAJOS,ARCHIVO2,V,FILA);
           IF ((V=-4) OR (V=-6)) THEN
           DECIR_CONTROL_ALUMNOS(VALOR_VERIFICADOR(V),FILA);
            END;
       '0':OP:='0';
          ELSE
            BEGIN
                 MAL_INGRESADO(FILA,COL);
             END;
          end;

  until OP='0' ;
END;

END.
