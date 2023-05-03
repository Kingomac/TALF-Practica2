 
%{

  #include <stdio.h>
  extern FILE *yyin;
  extern int yylex();

  #define YYDEBUG 1

%}

%token ABSTRACTO AND ASOCIATIVA BOOLEANO CABECERA CADENA CASO CARACTER CARGA CLASE CONJUNTO CONSTANTE CUERPO CTC_BOOLEANA CTC_CADENA CTC_CARACTER CTC_ENTERA CTC_REAL CONSTRUCTOR CUANDO CUATRO_PTOS DESCENDENTE DESPD DESPI DESTRUCTOR DE DEVOLVER DOS_PTOS EJECUTA ELEMENTO EN ENTERO ENTONCES EQ ESPECIFICO EXCEPTO FICHERO FINAL FINALMENTE FLECHA_DOBLE FUNCION GEQ GENERICO HASTA IDENTIFICADOR INTERFAZ LANZAR LEQ LISTA MIENTRAS MODIFICABLE NEQ OTRO OR PAQUETE PARA PATH POTENCIA PRIVADO PROBAR PROCEDIMIENTO PROGRAMA PUBLICO REAL REGISTRO REPITE SEA SALIR SEMIPUBLICO SI SINO TIPO VARIABLE
%start instruccion
%%

/********************************/
/* programas, paquetes y cargas */
/********************************/

definicion_programa: PROGRAMA IDENTIFICADOR ';';
definicio_paquete: PAQUETE IDENTIFICADOR ';';

/************************/
/* tipos (incl. clases) */
/************************/

/*************************************/
/* constantes, variables, interfaces */
/*************************************/

/****************/
/* subprogramas */
/****************/

/*****************/
/* instrucciones */
/*****************/
instruccion: ';'
          | instruccion_asignacion;

instruccion_asignacion: objeto '=' expresion;

/***************/
/* expresiones */
/***************/
nombre: IDENTIFICADOR;

objeto: nombre
| objeto  expresion 
| objeto IDENTIFICADOR;

expresion: expresion_constante;

expresion_constante: CTC_ENTERA | CTC_REAL | CTC_CADENA | CTC_CARACTER | CTC_BOOLEANA;

%%

int yyerror(char *s) {
  fflush(stdout);
  printf("***************** %s\n",s);
  }

int yywrap() {
  return(1);
  }

int main(int argc, char *argv[]) {

  yydebug = 0;

  if (argc < 2) {
    printf("Uso: ./moronico NombreArchivo\n");
    }
  else {
    yyin = fopen(argv[1],"r");
    yyparse();
    }
  }
