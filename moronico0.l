%{
#include <stdio.h>
#include "moronico.h"

int linea = 1;
%}

%x COMENTARIO


PATH (\")([\.]{0,2}\/[a-zA-Z0-9_]+)+(\.[a-zA-Z]+)(\")

CTC_ENTERA_OCTAL \\[0-7]+
CTC_ENTERA_DECIMAL [0-9]+
CTC_ENTERA_HEX \\[xX][0-9a-fA-F]+
CTC_REAL [+-]{0,1}[0-9]+((\'[0-9]+)|(\^[+-]{0,1}[0-9]+)|(\'[0-9]+)(\^[+-]{0,1}[0-9]+))

CTC_BOOLEANA "verdadero"|"falso"

CARACTER_SIN_COMILLAS ((\\[\'\"\?\\abfnrtv])|(\\([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4]))|(\\([0-7]{1,2}|[0-3][0-7]{2}))|(\\x([0-9a-fA-F]{1,2}))|[^\"\n])
CTC_CADENA (\")({CARACTER_SIN_COMILLAS}|\\\n)*(\")
CTC_CARACTER (\'){CARACTER_SIN_COMILLAS}(\')

CUATRO_PTOS "::"
DOS_PTOS ".."


OPERADOR_ARITMETICO "+"|"-"|"*"|"/"|"%"|"modulo"
OPERADOR_ACCESO_MEMORIA [\[\]\.]
OPERADOR_RELACIONAL "<"|">"
OPERADOR_BIT "@"|"~"|"&"
OPERADOR_ASIGNACION "="

POTENCIA "**"

DESPD "->" 
DESPI "<-"

EQ ":=" 
LEQ "=<"
NEQ "!=" 
GEQ ">=" 
NOT "!"
AND "/\\"
OR "\\/" 

FLECHA_DOBLE "=>"


IDENTIFICADOR [a-zA-Z_][a-zA-Z0-9_]*
DELIMITADORES "{"|"}"|"("|")"|":"|";"|","|\|

%%

{PATH} { printf("\nlinea %d, path: %s", linea, yytext);}

{CTC_CARACTER} { printf("\nlinea %d, constante caracter: %s", linea, yytext); return CTC_CARACTER; }
{CTC_REAL} {printf("\nlinea %d, constante real: %s", linea, yytext); return CTC_REAL;}
{CTC_ENTERA_OCTAL} { printf("\nlinea %d, constante entera octal: %s", linea, yytext); return CTC_ENTERA; }
{CTC_ENTERA_DECIMAL} { printf("\nlinea %d, constante entera decimal: %s", linea, yytext); return CTC_ENTERA; }
{CTC_ENTERA_HEX} { printf("\nlinea %d, constante entera hex: %s", linea, yytext); return CTC_ENTERA; }
{CTC_CADENA} {int i; for (i=0; yytext[i];i++) if(yytext[i]=='\n')linea++ ; printf("\nlinea %d, constante cadena: %s", linea, yytext); return CTC_CADENA; }
{CTC_BOOLEANA} {printf("\nlinea %d, constante booleana: %s", linea, yytext); return CTC_BOOLEANA; }

{CUATRO_PTOS} { printf("\nlinea %d, delimitador: %s", linea, yytext); return CUATRO_PTOS; }
{DOS_PTOS} { printf("\nlinea %d, delimitador: %s", linea, yytext); return DOS_PTOS; }
{FLECHA_DOBLE} { printf("\nlinea %d, delimitador: %s", linea, yytext); return FLECHA_DOBLE; }
{DELIMITADORES} { printf("\nlinea %d, delimitador: %s", linea, yytext); return yytext[0];}

{OPERADOR_ARITMETICO} {printf("\nlinea %d, operador: %s", linea, yytext); return yytext[0];};
{OPERADOR_ASIGNACION} {printf("\nlinea %d, operador: %s", linea, yytext);  return yytext[0];};
{OPERADOR_ACCESO_MEMORIA} {printf("\nlinea %d, operador: %s", linea, yytext); return yytext[0];};
{OPERADOR_RELACIONAL} {printf("\nlinea %d, operador: %s", linea, yytext); return yytext[0];};
{OPERADOR_BIT} {printf("\nlinea %d, operador: %s", linea, yytext); return yytext[0];};

{POTENCIA} {printf("\nlinea %d, operador: %s", linea, yytext);return POTENCIA;};
{DESPD} {printf("\nlinea %d, operador: %s", linea, yytext);return DESPD;};
{DESPI} {printf("\nlinea %d, operador: %s", linea, yytext);return DESPI;};
{EQ} {printf("\nlinea %d, operador: %s", linea, yytext);return EQ;};
{LEQ} {printf("\nlinea %d, operador: %s", linea, yytext);return LEQ;};
{NEQ} {printf("\nlinea %d, operador: %s", linea, yytext);return NEQ;};
{GEQ} {printf("\nlinea %d, operador: %s", linea, yytext);return GEQ;};
{NOT} {printf("\nlinea %d, operador: %s", linea, yytext); return yytext[0];};
{AND} {printf("\nlinea %d, operador: %s", linea, yytext); return AND;};
{OR} {printf("\nlinea %d, operador: %s", linea, yytext);return OR;};


(?i:abstracto) { printf("\nlinea %d, palabra reservada: abstracto", linea); return ABSTRACTO; };
(?i:asociativa) { printf("\nlinea %d, palabra reservada: asociativa", linea); return ASOCIATIVA; };
(?i:booleano) { printf("\nlinea %d, palabra reservada: booleano", linea); return BOOLEANO; };
(?i:cabecera) { printf("\nlinea %d, palabra reservada: cabecera", linea); return CABECERA; };
(?i:cadena) { printf("\nlinea %d, palabra reservada: cadena", linea); return CADENA; };
(?i:caso) { printf("\nlinea %d, palabra reservada: caso", linea); return CASO; };
(?i:caracter) { printf("\nlinea %d, palabra reservada: caracter", linea); return CARACTER; };
(?i:clase) { printf("\nlinea %d, palabra reservada: clase", linea); return CLASE; };
(?i:conjunto) { printf("\nlinea %d, palabra reservada: conjunto", linea); return CONJUNTO; };
(?i:constante) { printf("\nlinea %d, palabra reservada: constante", linea); return CONSTANTE; };
(?i:cuerpo) { printf("\nlinea %d, palabra reservada: cuerpo", linea); return CUERPO; };
(?i:constructor) { printf("\nlinea %d, palabra reservada: constructor", linea); return CONSTRUCTOR; };
(?i:cuando) { printf("\nlinea %d, palabra reservada: cuando", linea); return CUANDO; };
(?i:descendente) { printf("\nlinea %d, palabra reservada: descendente", linea); return DESCENDENTE; };
(?i:destructor) { printf("\nlinea %d, palabra reservada: destructor", linea); return DESTRUCTOR; };
(?i:de) { printf("\nlinea %d, palabra reservada: de", linea); return DE; };
(?i:devolver) { printf("\nlinea %d, palabra reservada: devolver", linea); return DEVOLVER; };
(?i:carga) { printf("\nlinea %d, palabra reservada: carga", linea); return CARGA; };
(?i:elemento) { printf("\nlinea %d, palabra reservada: elemento", linea); return ELEMENTO; };
(?i:ejecuta) { printf("\nlinea %d, palabra reservada: ejecuta", linea); return EJECUTA; };
(?i:en) { printf("\nlinea %d, palabra reservada: en", linea); return EN; };
(?i:entero) { printf("\nlinea %d, palabra reservada: entero", linea); return ENTERO; };
(?i:entonces) { printf("\nlinea %d, palabra reservada: entonces", linea); return ENTONCES; };
(?i:especifico) { printf("\nlinea %d, palabra reservada: especifico", linea); return ESPECIFICO; };
(?i:excepto) { printf("\nlinea %d, palabra reservada: excepto", linea); return EXCEPTO; };
(?i:fichero) { printf("\nlinea %d, palabra reservada: fichero", linea); return FICHERO; };
(?i:final) {printf("\nlinea %d, palabra reservada: final", linea); return FINAL;};
(?i:finalmente) {printf("\nlinea %d, palabra reservada: finalmente", linea); return FINALMENTE;};
(?i:funcion) {printf("\nlinea %d, palabra reservada: funcion", linea); return FUNCION;};
(?i:generico) {printf("\nlinea %d, palabra reservada: generico", linea); return GENERICO;};
(?i:hasta) {printf("\nlinea %d, palabra reservada: hasta", linea); return HASTA;};
(?i:interfaz) {printf("\nlinea %d, palabra reservada: interfaz", linea); return INTERFAZ;};
(?I:lanzar) {printf("\nlinea %d, palabra reservada: lanzar", linea); return LANZAR;};
(?i:lista) {printf("\nlinea %d, palabra reservada: lista", linea); return LISTA;};
(?i:mientras) {printf("\nlinea %d, palabra reservada: mientras", linea); return MIENTRAS;};
(?i:modificable) {printf("\nlinea %d, palabra reservada: modificable", linea); return MODIFICABLE;};
(?i:otro) {printf("\nlinea %d, palabra reservada: otro", linea); return OTRO;};
(?i:paquete) {printf("\nlinea %d, palabra reservada: paquete", linea); return PAQUETE;};
(?i:para) {printf("\nlinea %d, palabra reservada: para", linea); return PARA;};
(?i:privado) {printf("\nlinea %d, palabra reservada: privado", linea); return PRIVADO;};
(?i:probar) {printf("\nlinea %d, palabra reservada: probar", linea); return PROBAR;};
(?i:procedimiento) {printf("\nlinea %d, palabra reservada: procedimiento", linea); return PROCEDIMIENTO;};
(?i:programa) {printf("\nlinea %d, palabra reservada: programa", linea); return PROGRAMA; };
(?i:publico) {printf("\nlinea %d, palabra reservada: publico", linea); return PUBLICO;};
(?i:real) {printf("\nlinea %d, palabra reservada: real", linea); return REAL;};
(?i:registro) {printf("\nlinea %d, palabra reservada: registro", linea); return REGISTRO;};
(?i:repite) {printf("\nlinea %d, palabra reservada: repite", linea); return REPITE;};
(?i:salir) {printf("\nlinea %d, palabra reservada: salir", linea); return SALIR;};
(?i:sea) {printf("\nlinea %d, palabra reservada: sea", linea); return SEA;};
(?i:semipublico) {printf("\nlinea %d, palabra reservada: semipublico", linea); return SEMIPUBLICO;};
(?i:si) {printf("\nlinea %d, palabra reservada: si", linea); return SI;};
(?i:sino) {printf("\nlinea %d, palabra reservada: sino", linea); return SINO;};
(?i:tipo) {printf("\nlinea %d, palabra reservada: tipo", linea); return TIPO;};
(?i:variable) { printf("\nlinea %d, palabra reservada: %s", linea, yytext); return VARIABLE; };


"//".* ;

"/*" BEGIN(COMENTARIO);
<COMENTARIO>.|\n {
  if(yytext[0] == '\n') linea++;
} ;
<COMENTARIO>"*/" BEGIN(INITIAL);


{IDENTIFICADOR} { printf("\nlinea %d, identificador: %s", linea, yytext); }

\n {linea++;}

[^\s\t\n\r ] { printf("\nlinea, %d, error: %s", linea, yytext); }

%%
