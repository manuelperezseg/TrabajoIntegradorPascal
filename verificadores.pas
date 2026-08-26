unit VERIFICADORES;

{$CODEPAGE UTF8}
interface

uses
  UNIT_ARBOL, TIPOS_ARCHIVO1,TIPOS_ARCHIVO2, UNIT_ARCHIVO_ALUM,UNIT_MANEJO_INTERFACE,SysUtils;


  FUNCTION VERIFICAR_ARCHIVO2(VAR ARCHIVO2:T_ARCHIVO2):INTEGER;
  PROCEDURE DECIR_CONTROL_ALUMNOS(M:STRING; VAR FILA:INTEGER);
  FUNCTION VALOR_BUSQUEDA_EV_PARTICULAR(LEGAJO:SHORTSTRING;FECHA:SHORTSTRING):STRING;
  FUNCTION VALOR_BUSQUEDA_EVACIONES(FECHA:SHORTSTRING; CONTADOR:INTEGER):STRING;
  FUNCTION VALOR_CONTROL(V:INTEGER):STRING; //CONTROLA ERRORES DE PROCESOS DE ALUMNOS
  FUNCTION VALOR_VERIFICADOR(V:INTEGER):STRING;     //CONTROLA ERRORES DE PROCESOS DE EVALUACIONES
  PROCEDURE CARGAR_FECHAS2 (VAR FECHA:ShortString;VAR FILA:INTEGER);
  FUNCTION VERIFICAR_ESTADO (VAR ARCHIVO1:T_ARCHIVO1; VAR RAIZ: T_PUNT; BUSCADO: ShortString):INTEGER;
  FUNCTION DECIR_NOMBRE_DIF (I:INTEGER):STRING;
  FUNCTION DECIR_NOTA_DIF (I:INTEGER):STRING;
  FUNCTION MOSTRAR_FECHA(FECHA: STRING):STRING;
  PROCEDURE MOSTRAR_DIFICULTADES2 (X:T_DATO1; VAR FILA:INTEGER;COL:INTEGER);
  PROCEDURE MOSTRAR_VALORACIONES(X:T_DATO2;VAR FILA:INTEGER);
  PROCEDURE RECORTAR (PALABRA:STRING;COL:INTEGER;LIMITE:INTEGER;VAR FILA:INTEGER;VAR FILAINTERNA:INTEGER);
  PROCEDURE INICIALIZAR(VAR X:T_DATO1);
  PROCEDURE MOSTRAR_NOTAS_SEGUN_DIF2( VAR ARCHIVO1:T_ARCHIVO1;VAR ARBOL_LEGAJOS:T_PUNT;VAR VERIFICAR:INTEGER; LEGAJO:STRING;X:T_DATO2;VAR FILA:INTEGER; VAR COL:INTEGER);
  FUNCTION VALIDAR_LEGAJO(VAR FILA: INTEGER;COL:INTEGER): STRING;
  PROCEDURE MAL_INGRESADO(VAR FILA:INTEGER;COL:INTEGER);
  FUNCTION LEER_OPCION(VAR COL: INTEGER;VAR FILA: INTEGER): CHAR;
 IMPLEMENTATION

 FUNCTION VERIFICAR_ARCHIVO2(VAR ARCHIVO2:T_ARCHIVO2):INTEGER;
 BEGIN
 {$I-};
     RESET(ARCHIVO2);
      IF IORESULT <> 0 THEN
          BEGIN
          VERIFICAR_ARCHIVO2:=-1;
          END ELSE
                IF FILESIZE(ARCHIVO2)=0 THEN
                     BEGIN
                     VERIFICAR_ARCHIVO2:=0;
                     CLOSE(ARCHIVO2);
                     END ELSE
                               VERIFICAR_ARCHIVO2:=1;
{$I+};
 end;



 FUNCTION VALOR_CONTROL(V:INTEGER):STRING; //CONTROLA ERRORES DE PROCESOS DE ALUMNOS
BEGIN
  CASE V OF
    1:VALOR_CONTROL:='Los datos fueron cargados correctamente.';
    2:VALOR_CONTROL:='Registro Modificado Correctamente.';
    20:VALOR_CONTROL:='El alumno fue dado de BAJA correctamente.';
    0:VALOR_CONTROL:='ERROR -> El alumno está dado de baja.';
    -1:VALOR_CONTROL:='ERROR -> Alumno no encontrado';
    -2:VALOR_CONTROL:='ERROR -> Carga de datos abortada.';
    -3:VALOR_CONTROL:='';
    -4:VALOR_CONTROL:='ERROR -> Error al Cargar la Fecha. Carga de datos abortada.';
    -5:VALOR_CONTROL:='ERROR -> Error al Cargar el LEGAJO. Carga de datos abortada.';
     else
      VALOR_CONTROL:='ERROR -> Carga de datos abortada.';
  END;
  end;

FUNCTION VALOR_VERIFICADOR(V:INTEGER):STRING;     //CONTROLA ERRORES DE PROCESOS DE EVALUACIONES
  BEGIN
   CASE V of
   1:VALOR_VERIFICADOR:=('La evaluación fue cargada correctamente.');
   2:VALOR_VERIFICADOR:=('La evaluación fue modificada con éxito.');
   0:VALOR_VERIFICADOR:=('ERROR -> No se puede cargar la evaluación porque el alumno está dado de baja.');
   -1:VALOR_VERIFICADOR:=('ERROR -> No se puede cargar la evaluación porque el alumno no existe o su legajo fue mal ingresado.');
   -2:VALOR_VERIFICADOR:=('ERROR -> No se puede cargar la evaluación porque el alumno ya tiene una evaluación en esa fecha.');
   -3:VALOR_VERIFICADOR:=('ERROR -> Evaluación no encontrada.');
   -4:VALOR_VERIFICADOR:=('ERROR -> Error al Cargar la Fecha. Carga de datos abortada.');
   -5:VALOR_VERIFICADOR:=('ERROR -> El Alumno no tiene evaluaciones asignadas en esa fecha.');
   -6:VALOR_VERIFICADOR:=('ERROR -> Error al Cargar la Fecha. La fecha INICIAL cargada es POSTERIOR que la fecha LÍMITE.');
   -7:VALOR_VERIFICADOR:='ERROR -> Error al Cargar el LEGAJO. Carga de datos abortada.';
   else
    VALOR_VERIFICADOR:= 'ERROR -> Carga de datos abortada.';
  end;
  end;

FUNCTION VALOR_BUSQUEDA_EV_PARTICULAR(LEGAJO:SHORTSTRING;FECHA:SHORTSTRING):STRING;
BEGIN
 VALOR_BUSQUEDA_EV_PARTICULAR:=('La evaluación del alumno con legajo:'+ (LEGAJO) +' en la fecha '+  MOSTRAR_FECHA(FECHA) + ' no fue encontrada');
 END;       //CUANDO DA 10 ES PORQUE SE EJECUTÓ BIEN, SI NO LO ENCUENTRA A VALOR VERIFICADOR LE ASIGNA ESTO

FUNCTION VALOR_BUSQUEDA_EVACIONES(FECHA:SHORTSTRING; CONTADOR:INTEGER):STRING;
VAR
  NUM:STRING;
BEGIN
IF CONTADOR = 0 THEN
VALOR_BUSQUEDA_EVACIONES:=('En la fecha:'+ MOSTRAR_FECHA(FECHA)+' NO se tomaron evaluaciones.') ELSE
    BEGIN
    NUM:=IntToStr(CONTADOR);
    VALOR_BUSQUEDA_EVACIONES:=('Estas fueron las '+NUM+' evaluaciones tomadas el día: ' + MOSTRAR_FECHA(FECHA));
    end;
 END;       //CUANDO DA 10 ES PORQUE SE EJECUTÓ BIEN, SI NO LO ENCUENTRA A VALOR VERIFICADOR LE ASIGNA ESTO



PROCEDURE DECIR_CONTROL_ALUMNOS(M:STRING; VAR FILA:INTEGER);
VAR
  SALIDA:STRING;
BEGIN
FILA:=FILA+3;
  SALIDA:=(M + ' | PRESIONE CUALQUIER TECLA PARA CONTINUAR');
  RECORTAR(SALIDA,5,110,FILA,FILA);
  READKEY1;
END;


PROCEDURE INICIALIZAR_DIFICULTADES (VAR X:T_DATO1);
 VAR
   I:INTEGER;
 BEGIN
  FOR I:= 1 TO 5 DO
  BEGIN
   X.DIFICULTADES[I]:=FALSE;
  end;
 END;

PROCEDURE INICIALIZAR(VAR X:T_DATO1);
BEGIN
 X.APYNOM:='';
 X.FECHANAC:='';
 X.LEGAJO:='';
 X.ESTADO:=0;
 INICIALIZAR_DIFICULTADES(X);
end;

FUNCTION CARD_A_STRING(N: CARDINAL): STRING;
VAR
  NUMEROSTRING: STRING;
BEGIN
  STR(N:0, NUMEROSTRING);  // Convierte el número a string
  CARD_A_STRING :=(NUMEROSTRING);
END;

FUNCTION DECIR_NOMBRE_DIF (I:INTEGER):STRING;            //MODIFICICAR PARA MOSTRAR EL NOMBRE DE LA DIF
  BEGIN
   CASE I OF
     1:DECIR_NOMBRE_DIF:=('*Problemas del habla y lenguaje');
     2:DECIR_NOMBRE_DIF:=('*Dificultad para escribir');
     3:DECIR_NOMBRE_DIF:=('*Dificultades de aprendizaje visual');
     4:DECIR_NOMBRE_DIF:=('*Problemas de memoria y otras dificultades del pensamiento');
     5:DECIR_NOMBRE_DIF:=('*Destrezas sociales inadecuadas');
   end;
  end;


PROCEDURE MOSTRAR_DIFICULTADES2 (X:T_DATO1; VAR FILA:INTEGER;COL:INTEGER);
 VAR
   I:INTEGER;
  BEGIN
   FILA:=FILA-1;
   FOR I:= 1 TO 5 DO
   BEGIN
    IF X.DIFICULTADES[I]= TRUE THEN
    BEGIN
   INC(FILA);
   GOTOXYMIO(COL,FILA);
   WRITE(DECIR_NOMBRE_DIF(I));
    end;
   end;
      END;

FUNCTION DECIR_NOTA_DIF (I:INTEGER):STRING;            //MODIFICICAR PARA MOSTRAR EL NOMBRE DE LA DIF
  BEGIN
   CASE I OF
     1:DECIR_NOTA_DIF:=('AUSENTE');
     2:DECIR_NOTA_DIF:=('INSUFICIENTE');
     3:DECIR_NOTA_DIF:=('REGULAR');
     //3:DECIR_NOTA_DIF:=('MUY BUENO');
     4:DECIR_NOTA_DIF:=('APROBADO');
     5:DECIR_NOTA_DIF:=('SIN ASIGNAR');
   end;
  end;

PROCEDURE MOSTRAR_VALORACIONES(X:T_DATO2;VAR FILA:INTEGER);
VAR
  I:1..5;
  BEGIN
     FOR I:=1 TO 5 DO
        BEGIN
        IF X.VALORXDIF[I] > 0 THEN   //SI LA NOTA NO ES CERO ES PORQUE SE LE ASIGNÓ UN VALOR MANUALMENTE
         BEGIN
         INC(FILA);
         GOTOXYMIO(1,FILA);
         WRITE(DECIR_NOTA_DIF(X.VALORXDIF[I]))        //agregar ui
         END;
        END;
   END;

PROCEDURE RECORTAR(PALABRA: STRING; COL: INTEGER; LIMITE: INTEGER; VAR FILA: INTEGER; VAR FILAINTERNA: INTEGER);
VAR
  AUX, PALABRA_NUEVA: STRING;
  POS_ESP,LARGO: INTEGER;
BEGIN
 LARGO:= LENGTH(PALABRA);
  IF LARGO <= LIMITE THEN
  BEGIN
    GOTOXYMIO(COL, FILAINTERNA);
    WRITE(PALABRA);
  END ELSE
  BEGIN
    POS_ESP := LIMITE;      //PARA VERIFICAR SI EL ULTIMO CARACTER ES UN ESPACIO
    WHILE (POS_ESP > 1) AND (PALABRA[POS_ESP] <> ' ') DO    //BUSCA EL ULTIMO ESPACIO ANTES DEL LIMITE
      DEC(POS_ESP);
    IF POS_ESP = 1 THEN   //SI NO HAY ESPACIO ANTES DEL LIMITE
      POS_ESP := LIMITE;
    AUX := COPY(PALABRA, 1, POS_ESP - 1);    //RECORTA EL TEXTO O LA PALABRA HASTA EL LIMITE O HASTA EL ÚLTIMO ESPACIO
    GOTOXYMIO(COL, FILAINTERNA);
    WRITE(AUX);
    INC(FILAINTERNA);
    IF POS_ESP < LARGO THEN
      PALABRA_NUEVA := COPY(PALABRA, POS_ESP + 1, LARGO - POS_ESP)    //USAR EL RESTO DEL TEXTO QUE FUE RECORTADO
    ELSE
      PALABRA_NUEVA := '';         //SI NO HAY MÁS PARA RECORTAR
    IF PALABRA_NUEVA <> '' THEN     //SI HAY MÁS PARA RECORTAR LLAMA RECURSIVAMENTE
      RECORTAR(PALABRA_NUEVA, COL, LIMITE, FILA, FILAINTERNA);
  end;
END;

PROCEDURE MOSTRAR_NOTAS_SEGUN_DIF2( VAR ARCHIVO1:T_ARCHIVO1;VAR ARBOL_LEGAJOS:T_PUNT;VAR VERIFICAR:INTEGER; LEGAJO:STRING;X:T_DATO2;VAR FILA:INTEGER; VAR COL:INTEGER);
  VAR
     POSICION:INTEGER;
     Y: T_DATO1;
     I:1..5;
   BEGIN
       POSICION:= PREORDEN(ARBOL_LEGAJOS,LEGAJO);
       VERIFICAR:=VERIFICAR_ESTADO(ARCHIVO1,ARBOL_LEGAJOS,LEGAJO);
           IF VERIFICAR=1 THEN
           BEGIN
           Y:=LEER_ARCHIVO_EN_POS(ARCHIVO1,POSICION);
           FOR I := 1 TO 5 DO
              IF Y.DIFICULTADES[I] = TRUE THEN
              BEGIN
              INC(FILA);
               GOTOXYMIO(COL,FILA);
               IF ((X.VALORXDIF[I]>=1) AND (X.VALORXDIF[I]<5)) THEN
               BEGIN
               WRITE(DECIR_NOMBRE_DIF(I),':',DECIR_NOTA_DIF(X.VALORXDIF[I]));
               end ELSE
               WRITE(DECIR_NOMBRE_DIF(I),':',DECIR_NOTA_DIF(5));
              end;
           END;
     end;

FUNCTION MOSTRAR_FECHA(FECHA: STRING):STRING;
VAR
  DIA, MES, ANIO: STRING;
BEGIN
  IF Length(FECHA) = 8 THEN
  BEGIN
    ANIO := Copy(FECHA, 1, 4);   // YYYY
    MES  := Copy(FECHA, 5, 2);   // MM
    DIA  := Copy(FECHA, 7, 2);   // DD
    MOSTRAR_FECHA:= (DIA + '/'+ MES + '/' + ANIO);
  END
END;

FUNCTION CONCATENAR_FECHAS(DIA, MES, ANIO: INTEGER): STRING;   //CONCATENA EN EL FORMATO YYYYMMDD
    VAR
      DIA_STR, MES_STR, ANIO_STR: STRING;
    BEGIN

      STR(ANIO:4, ANIO_STR);
      ANIO_STR := Trim(ANIO_STR);


      IF MES < 10 THEN      //SI EL MES ES MENOR A 10 LE PONE UN CERO ANTES
        MES_STR := '0' + IntToStr(MES)
      ELSE
        STR(MES:0, MES_STR);


      IF DIA < 10 THEN             //SI EL DÍA ES MENOR A 10 LE PONE UN CERO ANTES
        DIA_STR := '0' + IntToStr(DIA)
      ELSE
        STR(DIA:0, DIA_STR);
      CONCATENAR_FECHAS := ANIO_STR + MES_STR + DIA_STR;      // CONCATENA EN FORMATO YYYYMMDD
    END;

FUNCTION INGRESAR_FECHA(VAR DIA: INTEGER; VAR MES: INTEGER; VAR ANIO: INTEGER):STRING; //DA LOS ERRORES POSIBLES O LA CADENA HECHA
BEGIN

        CASE MES OF
          1,3,5,7,8,10,12: BEGIN
                            IF (DIA<1) OR (DIA>31) THEN
                            INGRESAR_FECHA:='ERRORDIA1' ELSE
                                IF (ANIO < 1980) OR (ANIO > 2100) THEN
                                  INGRESAR_FECHA:='ERRORANIO'ELSE
                                             INGRESAR_FECHA:=CONCATENAR_FECHAS(DIA,MES,ANIO);
                            END;
                4,6,9,11: BEGIN
                            IF (DIA<1) OR (DIA>30) THEN
                            INGRESAR_FECHA:='ERRORDIA2' ELSE
                                IF (ANIO < 1980) OR (ANIO > 2100) THEN
                                  INGRESAR_FECHA:='ERRORANIO'ELSE
                                             INGRESAR_FECHA:=CONCATENAR_FECHAS(DIA,MES,ANIO);
                            END;
                      2: BEGIN
                                IF (ANIO < 1980) OR (ANIO > 2100) THEN
                                  INGRESAR_FECHA:='ERRORANIO'ELSE
                                      BEGIN
                                      IF (ANIO - 1980) MOD 4 = 0 THEN      //ANIOS BISIESTOS
                                        BEGIN
                                        IF (DIA<1) OR (DIA>29) THEN
                                        INGRESAR_FECHA:='ERRORDIA3'
                                         ELSE
                                            INGRESAR_FECHA:=CONCATENAR_FECHAS(DIA,MES,ANIO);
                                        END ELSE
                                         BEGIN
                                        IF (DIA<1) OR (DIA>28) THEN
                                        INGRESAR_FECHA:='ERRORDIA4'
                                         ELSE INGRESAR_FECHA:=CONCATENAR_FECHAS(DIA,MES,ANIO);
                                         END;
                                      END;
                            END;

          ELSE
           INGRESAR_FECHA:='ERRORMES'
           END;
END;

FUNCTION LEER_DIA(VAR COL: INTEGER;VAR FILA: INTEGER): STRING;
   VAR
    OP:STRING;
    C:INTEGER;
BEGIN
  C:=0;
 REPEAT
 GOTOXYMIO(COL,FILA);
 WRITE('Ingrese el día (1-31): ');
 READLN(OP);
    IF (LENGTH(OP) > 2) THEN
    BEGIN
      GOTOXYMIO(1,FILA+3);
      WRITE('INGRESE SOLO DOS NÚMEROS COMO MÁXIMO | OPRIMA CUALQUIER TECLA PARA VOLVER A INTENTAR');
      READLN;
      LIMPIARLINEACOL(FILA,COL);
      LIMPIARLINEA(FILA+3);
    END ELSE
   BEGIN
      IF (LENGTH(OP)=2) AND ((OP[1] IN ['0'..'9'])AND (OP[2] IN ['0'..'9'])) THEN
      BEGIN
      LEER_DIA := OP;
      C:=1;
      END ELSE
          IF (LENGTH(OP)=1) AND ((OP[1] IN ['0'..'9'])) THEN
             BEGIN
             LEER_DIA:=OP;
             C:=1;
             END ELSE
              BEGIN
                    //GOTOXYMIO(COL+LENGTH('Ingrese el día (1-31): '),FILA+1);
                    GOTOXYMIO(1,FILA+3);
                    WRITE('INGRESE SOLO DOS NÚMEROS COMO MÁXIMO | OPRIMA CUALQUIER TECLA PARA VOLVER A INTENTAR');
                    READLN;
                    LIMPIARLINEACOL(FILA,COL);
                    LIMPIARLINEA(FILA+3);
              end;
   end;
  UNTIL C=1;
END;

FUNCTION LEER_MES(VAR COL: INTEGER;VAR FILA: INTEGER): STRING;
   VAR
    OP:STRING;
    C:INTEGER;
BEGIN
 C:=0;
 REPEAT
 GOTOXYMIO(COL,FILA);
 WRITE('/Ingrese el mes (1-12): ');
 READLN(OP);
    IF (LENGTH(OP) > 2) THEN
    BEGIN
      GOTOXYMIO(1,FILA+3);
      WRITE('INGRESE SOLO DOS NÚMEROS COMO MÁXIMO | OPRIMA CUALQUIER TECLA PARA VOLVER A INTENTAR');
      READLN;
      LIMPIARLINEACOL(FILA,COL);
      LIMPIARLINEA(FILA+3);
    END ELSE
   BEGIN
      IF (LENGTH(OP)=2) AND ((OP[1] IN ['0'..'9'])AND (OP[2] IN ['0'..'9'])) THEN
      BEGIN
      LEER_MES := OP;
      C:=1;
      END ELSE
          IF (LENGTH(OP)=1) AND ((OP[1] IN ['0'..'9'])) THEN
             BEGIN
             LEER_MES:=OP;
             C:=1;
             END ELSE
              BEGIN
                    GOTOXYMIO(1,FILA+3);
                    WRITE('INGRESE SOLO DOS NÚMEROS COMO MÁXIMO | OPRIMA CUALQUIER TECLA PARA VOLVER A INTENTAR');
                    READLN;
                    LIMPIARLINEACOL(FILA,COL);
                    LIMPIARLINEA(FILA+3);
              end;
   end;
  UNTIL C=1;
END;

FUNCTION LEER_ANIO(VAR COL: INTEGER;VAR FILA: INTEGER): STRING;
   VAR
    OP:STRING;
    I,C:INTEGER;
BEGIN
 C:=0;
 REPEAT
 GOTOXYMIO(COL,FILA);
 WRITE('/Ingrese el año (1980-2100): ');
 READLN(OP);
    IF (LENGTH(OP) <> 4) THEN
    BEGIN
      GOTOXYMIO(1,FILA+3);
      WRITE('INGRESE 4 NÚMEROS PARA EL AÑO | OPRIMA CUALQUIER TECLA PARA VOLVER A INTENTAR');
      READLN;
      LIMPIARLINEACOL(FILA,COL);
      LIMPIARLINEA(FILA+3);
    END ELSE
   BEGIN
       FOR I:=1 TO 4 DO
          BEGIN
            IF OP[I] IN ['0'..'9'] THEN
            C:=C+1;
          end;
       IF C<>4 THEN
               BEGIN
              GOTOXYMIO(1,FILA+3);
              WRITE('INGRESE 4 NÚMEROS PARA EL AÑO | OPRIMA CUALQUIER TECLA PARA VOLVER A INTENTAR');
              READLN;
              LIMPIARLINEACOL(FILA,COL);
              LIMPIARLINEA(FILA+3);
              end ELSE
              LEER_ANIO:=OP;
   end;
  UNTIL (C=4);
END;

FUNCTION ERROR_FECHA(VAR FILA:INTEGER; COL:INTEGER):INTEGER;
  VAR
   RESP:STRING;

BEGIN
INC(FILA);
  REPEAT
    LIMPIARLINEA(FILA+1);
    GOTOXYMIO(1,FILA);
    WRITELN('¿desea volver a intentar? [S/N]: ');
    GOTOXYMIO(COL,FILA);
    READLN(RESP);
  UNTIL((LENGTH(RESP)=1) AND (((RESP = 's') OR (RESP = 'S')) OR ((RESP= 'n') OR (RESP= 'N'))));
  IF ((RESP = 's') OR (RESP = 'S')) THEN
    BEGIN
      ERROR_FECHA:= 0;
    END ELSE
        IF ((RESP= 'n') OR (RESP= 'N')) THEN
         ERROR_FECHA:=-1;
END;


PROCEDURE CARGAR_FECHAS2 (VAR FECHA:ShortString;VAR FILA:INTEGER);
  VAR
   DIA,MES,ANIO:STRING;
   C,COL,COL1,COL2,DIA_NUM,MES_NUM,ANIO_NUM,LARGO:INTEGER;
 BEGIN
   C:=0;
   COL:=1;
   LARGO:= LENGTH('¿desea volver a intentar? [S/N]: ');
   REPEAT
   FILA:=FILA+1;
   COL1:=LENGTH('Ingrese el día (1-31): ')+4;
   COL2:=(COL1*2)+1;
   DIA:=LEER_DIA(COL,FILA);
   MES:=LEER_MES(COL1,FILA);
   ANIO:=LEER_ANIO(COL2,FILA);
   DIA_NUM:=StrToInt(DIA);
   MES_NUM:=StrToInt(MES);
   ANIO_NUM:=StrToInt(ANIO);

       CASE INGRESAR_FECHA(DIA_NUM,MES_NUM,ANIO_NUM) OF
                         'ERRORDIA1':     BEGIN
                                           INC(FILA);
                                           GOTOXYMIO(1,FILA);
                                          WRITE('Error al cargar la fecha. El día debe estar entre 1 y 31.');
                                          C:=ERROR_FECHA(FILA,LARGO);
                                           end;
                         'ERRORDIA2': BEGIN
                                           INC(FILA);
                                           GOTOXYMIO(1,FILA);
                                           WRITE('Error al cargar la fecha. El día debe estar entre 1 y 30.');
                                           C:=ERROR_FECHA(FILA,LARGO);
                                       end;
                         'ERRORDIA3':  BEGIN
                                           INC(FILA);
                                           GOTOXYMIO(1,FILA);
                                          WRITE('Error al cargar la fecha. En año bisiesto el día debe estar entre 1 y 29.');
                                          C:=ERROR_FECHA(FILA,LARGO)
                                       end;
                         'ERRORDIA4':    BEGIN
                                           INC(FILA);
                                           GOTOXYMIO(1,FILA);
                                          WRITE('Error al cargar la fecha. En día debe estar entre 1 y 28.');
                                          C:=ERROR_FECHA(FILA,LARGO);
                                         end;
                         'ERRORANIO':   BEGIN
                                           INC(FILA);
                                           GOTOXYMIO(1,FILA);
                                          WRITE('Error al cargar la fecha. El año debe estar entre 1980 y 2100.');
                                          C:=ERROR_FECHA(FILA,LARGO);
                                           END;
                         'ERRORMES':  BEGIN
                                           INC(FILA);
                                           GOTOXYMIO(1,FILA);
                                          WRITE('Error al cargar la fecha. El mes debe estar entre 1 y 12.');
                                          C:=ERROR_FECHA(FILA,LARGO);
                                           END;
                         ELSE
                                BEGIN
                                 FECHA:=INGRESAR_FECHA(DIA_NUM,MES_NUM,ANIO_NUM);
                                 C:=1;
                                 END;
       END;
     IF C= 0 THEN
     BEGIN
     FILA:=FILA-2;
     LIMPIARHASTA(FILA,FILA+3);
     FILA:=FILA-1;
     end;
   UNTIL (C=1) OR (C=-1);
   IF C=-1 THEN FECHA:='ERROR';
   END;

FUNCTION VERIFICAR_ESTADO (VAR ARCHIVO1:T_ARCHIVO1; VAR RAIZ: T_PUNT; BUSCADO: ShortString):INTEGER;
 VAR                //ESTE PROCEDIMIENTO BUSCA EL REGISTRO EN EL ARCHIVO A TRAVÉS DE BUSCADO Y VERIFICA EL ESTADO.
  NODO:INTEGER;
  X:T_DATO1;
 BEGIN
    NODO:=PREORDEN(RAIZ,BUSCADO);   //BUSCA EL ALUMNO, LA RAIZ (NOMBRES O LEGAJOS) SE ESPECIFICA EN LA LLAMDA DEL PROC
    IF NODO = -1 THEN
    BEGIN
     VERIFICAR_ESTADO:=-1;  //EL ALUMNO NO EXISTE
      END ELSE
           BEGIN
             X:=LEER_ARCHIVO_EN_POS(ARCHIVO1,NODO); //BUSCA EL REGISTRO EN EL ARCHIVO A TRAVÉS DE LA POS DE NODO Y LO ASGINA EN X
             IF X.ESTADO =0 THEN
               VERIFICAR_ESTADO:=0 ELSE      //ESTÁ DADO DE BAJA
                                   VERIFICAR_ESTADO:=1;
           END;
   END;


FUNCTION VALIDAR_LEGAJO(VAR FILA: INTEGER;COL:INTEGER): STRING;
VAR
  I,C,FILAINTERNA,LONG_LEGAJO: INTEGER;
  R,LEGAJO:STRING;
BEGIN
 C:=0;
 LONG_LEGAJO:=4;
  REPEAT
  FILAINTERNA:=FILA;
  INC(FILAINTERNA);
  GOTOXYMIO(COL,FILAINTERNA);
  WRITE('Escriba el legajo del alumno: ');
  READLN(LEGAJO);
  IF LENGTH(LEGAJO) <> LONG_LEGAJO THEN
  BEGIN
    VALIDAR_LEGAJO := 'ERROR';
  END ELSE
      BEGIN
          FOR I := 1 TO LENGTH(LEGAJO) DO
          BEGIN
            IF NOT (LEGAJO[I] IN ['0'..'9']) THEN
            BEGIN
              VALIDAR_LEGAJO := 'ERROR';
              C:=-1;
            END ELSE
                  IF C<>-1 THEN //SI NO HUBO ERROR EN UN CARACTER ANTERIOR
                  BEGIN
                  VALIDAR_LEGAJO := LEGAJO;
                  C:=1;
                  end;
          END;
      end;
  IF VALIDAR_LEGAJO = 'ERROR' THEN
   BEGIN
   INC(FILAINTERNA);
   GOTOXYMIO(COL,FILAINTERNA);
   WRITE('ERROR AL INGRESAR EL LEGAJO. DEBE SER UNA CADENA DE NUMEROS DE 4 CIFRAS');
   FILAINTERNA:=FILAINTERNA+2;
   REPEAT
     LIMPIARLINEA(FILAINTERNA);
     GOTOXYMIO(COL,FILAINTERNA);
     WRITE('Desea volver a intentar? S/N: ');
     READLN(R);
      IF ((R = 's') OR (R = 'S'))THEN
       BEGIN
       LIMPIARHASTA(FILA,FILAINTERNA);
        C:=0;
       end ELSE
       IF   ((R= 'n') OR (R= 'N')) THEN
        C:=1;
     UNTIL ((LENGTH(R)=1)AND(((R = 's') OR (R = 'S')) OR ((R= 'n') OR (R= 'N'))));
   end;
  until C=1;
  FILA:=FILAINTERNA;
END;

 PROCEDURE MAL_INGRESADO(VAR FILA:INTEGER;COL:INTEGER);
 BEGIN
 IF COL = 1 THEN
  GOTOXYMIO(COL,FILA) ELSE GOTOXYMIO((LENGTH('Ingrese una opción: ')),FILA);
 WRITE('TECLA MAL INGRESADA | OPRIMA CUALQUIER TECLA PARA VOLVER A INTENTAR');
  READLN;
  LIMPIARLINEA(FILA);
 END;

FUNCTION LEER_OPCION(VAR COL: INTEGER;VAR FILA: INTEGER): CHAR;
   VAR
    OP:STRING;
BEGIN
  FILA:=FILA+1;
 REPEAT
 GOTOXYMIO(COL,FILA);
 WRITE('Ingrese una opción: ');
 READLN(OP);
    IF LENGTH(OP) <> 1 THEN
    BEGIN
      IF COL = 1 THEN
      GOTOXYMIO(COL,FILA) ELSE GOTOXYMIO((LENGTH('Ingrese una opción: ')),FILA);
      WRITE('INGRESE SOLO UN CARÁCTER | OPRIMA CUALQUIER TECLA PARA VOLVER A INTENTAR');
      READLN;
      LIMPIARLINEA(FILA);
    END;
  UNTIL LENGTH(OP) = 1;
  LEER_OPCION := OP[1];
END;

 END.
