%{
  #include <stdio.h>
  extern FILE *yyin;
  extern int yylex();

  void yyerror(char *s);

  #define YYDEBUG 1

%}

%token ABSTRACTO AND ASOCIATIVA BOOLEANO 
%token CABECERA CADENA CASO CARACTER 
%token CARGA CLASE CONJUNTO CONSTANTE 
%token CUERPO CTC_BOOLEANA CTC_CADENA CTC_CARACTER 
%token CTC_ENTERA CTC_REAL CONSTRUCTOR CUANDO
%token CUATRO_PTOS DESCENDENTE DESPD DESPI 
%token DESTRUCTOR DE DEVOLVER DOS_PTOS 
%token EJECUTA ELEMENTO EN ENTERO 
%token ENTONCES EQ ESPECIFICO EXCEPTO 
%token FICHERO FINAL FINALMENTE FLECHA_DOBLE 
%token FUNCION GEQ GENERICO HASTA 
%token IDENTIFICADOR INTERFAZ LANZAR LEQ 
%token LISTA MIENTRAS MODIFICABLE NEQ 
%token OTRO OR PAQUETE PARA 
%token PATH POTENCIA PRIVADO PROBAR 
%token PROCEDIMIENTO PROGRAMA PUBLICO REAL 
%token REGISTRO REPITE SALIR SEA 
%token SEMIPUBLICO SI SINO TIPO VARIABLE

%right OR
%right AND
%nonassoc NEGACION
%left '<' '>' LEQ GEQ EQ
%left '@'
%left '~'
%left '&'
%left DESPI DESPD
%left '+' '-'
%left '*' '/' '%'
%right POTENCIA

%start programa

%%
//Poner todos los operadores (falta el unario) y prints. Dividir el programa por partes con los comentarios

/********************************/
/* programas, paquetes y cargas */
/********************************/

programa: definicion_programa
        | definicion_paquete
;

definicion_programa: PROGRAMA nombre ';' bloque_programa ;

nombre: IDENTIFICADOR 
      | IDENTIFICADOR CUATRO_PTOS nombre 
;

nombre_mas: nombre  
          | nombre nombre_mas
;  

bloque_programa: bloque_instrucciones

               | declaracion_cargas bloque_instrucciones
               | declaracion_tipos bloque_instrucciones
               | declaracion_constantes bloque_instrucciones
               | declaracion_variables bloque_instrucciones

               | declaracion_cargas declaracion_tipos bloque_instrucciones
               | declaracion_cargas declaracion_constantes bloque_instrucciones
               | declaracion_cargas declaracion_variables bloque_instrucciones
               | declaracion_tipos declaracion_constantes bloque_instrucciones
               | declaracion_tipos declaracion_variables bloque_instrucciones
               | declaracion_constantes declaracion_variables bloque_instrucciones

               | declaracion_cargas declaracion_tipos declaracion_constantes bloque_instrucciones
               | declaracion_cargas declaracion_tipos declaracion_variables bloque_instrucciones
               | declaracion_cargas declaracion_constantes declaracion_variables bloque_instrucciones
               | declaracion_tipos declaracion_constantes declaracion_variables bloque_instrucciones

               | declaracion_cargas declaracion_tipos declaracion_constantes declaracion_variables bloque_instrucciones
;                         

bloque_instrucciones: '{' instruccion_mas '}' { printf("\n  blq_instrs -> '{' instrs '}'");} ;

definicion_paquete: PAQUETE nombre ';' seccion_cabecera seccion_cuerpo;

seccion_cabecera: CABECERA

                | CABECERA declaracion_cargas
                | CABECERA declaracion_tipos
                | CABECERA declaracion_constantes
                | CABECERA declaracion_variables
                | CABECERA declaracion_interfaces

                | CABECERA declaracion_cargas declaracion_tipos
                | CABECERA declaracion_cargas declaracion_constantes
                | CABECERA declaracion_cargas declaracion_variables
                | CABECERA declaracion_cargas declaracion_interfaces
                | CABECERA declaracion_tipos declaracion_constantes
                | CABECERA declaracion_tipos declaracion_variables
                | CABECERA declaracion_tipos declaracion_interfaces
                | CABECERA declaracion_constantes declaracion_variables
                | CABECERA declaracion_constantes declaracion_interfaces
                | CABECERA declaracion_variables declaracion_interfaces

                | CABECERA declaracion_cargas declaracion_tipos declaracion_constantes
                | CABECERA declaracion_cargas declaracion_tipos declaracion_variables
                | CABECERA declaracion_cargas declaracion_tipos declaracion_interfaces
                | CABECERA declaracion_cargas declaracion_constantes declaracion_variables
                | CABECERA declaracion_cargas declaracion_constantes declaracion_interfaces
                | CABECERA declaracion_cargas declaracion_variables declaracion_interfaces
                | CABECERA declaracion_tipos declaracion_constantes declaracion_variables
                | CABECERA declaracion_tipos declaracion_constantes declaracion_interfaces
                | CABECERA declaracion_tipos declaracion_variables declaracion_interfaces
                | CABECERA declaracion_constantes declaracion_variables declaracion_interfaces

                | CABECERA declaracion_cargas declaracion_tipos declaracion_constantes declaracion_variables
                | CABECERA declaracion_cargas declaracion_tipos declaracion_constantes declaracion_interfaces
                | CABECERA declaracion_cargas declaracion_tipos declaracion_variables declaracion_interfaces
                | CABECERA declaracion_cargas declaracion_constantes declaracion_variables declaracion_interfaces
                | CABECERA declaracion_tipos declaracion_constantes declaracion_variables declaracion_interfaces

                | CABECERA declaracion_cargas declaracion_tipos declaracion_constantes declaracion_variables declaracion_interfaces
;

seccion_cuerpo: CUERPO declaracion_subprograma_mas;

              | CUERPO declaracion_tipos declaracion_subprograma_mas
              | CUERPO declaracion_constantes declaracion_subprograma_mas
              | CUERPO declaracion_variables declaracion_subprograma_mas
              
              | CUERPO declaracion_tipos declaracion_constantes declaracion_subprograma_mas
              | CUERPO declaracion_tipos declaracion_variables declaracion_subprograma_mas
              | CUERPO declaracion_constantes declaracion_variables declaracion_subprograma_mas
              
              | CUERPO declaracion_tipos declaracion_constantes declaracion_variables declaracion_subprograma_mas
;              

declaracion_cargas: CARGA declaracion_carga_mas ';' ;         

declaracion_carga: nombre 
                 | nombre EN PATH
                 | nombre nombre_mas
                 | nombre EN PATH nombre_mas
;

declaracion_carga_mas: declaracion_carga
                     | declaracion_carga ',' declaracion_cargas 
;     

/************************/
/* tipos (incl. clases) */
/************************/

declaracion_tipos: TIPO declaracion_tipo_mas {printf("\n  decl_tipos -> TIPO "); } ;  //Como termino esto??

declaracion_tipo: nombre '=' tipo_no_estructurado_o_nombre_tipo ';' {printf("\n  decl_tipo -> nom = tipo_no_str_o_nom"); }
                | nombre '=' tipo_estructurado {printf("\n  decl_tipo -> nom = tipo_str"); }
;

declaracion_tipo_mas: declaracion_tipo
                    | declaracion_tipo declaracion_tipo_mas
;                    

tipo_no_estructurado_o_nombre_tipo: nombre  
                                  | tipo_escalar {printf("\n  tipo_no_str_o_nom -> tipo_escalar");}
                                  | tipo_fichero {printf("\n  tipo_no_str_o_nom -> tipo_fichero");}
                                  | tipo_enumerado {printf("\n  tipo_no_str_o_nom -> tipo_enumerado");}
                                  | tipo_lista {printf("\n  tipo_no_str_o_nom -> tipo_lista");}
                                  | tipo_lista_asociativa {printf("\n  tipo_no_str_o_nom -> tipo_lista_asociativa");}
                                  | tipo_conjunto {printf("\n  tipo_no_str_o_nom -> tipo_conjunto");}
;                                                                   

tipo_estructurado: tipo_registro {printf("\n  tipo_str -> tipo_registro"); }
                 | declaracion_clase {printf("\n  tipo_str -> decl_clase"); }
;

tipo_escalar: ENTERO {printf("\n  tipo_escalar -> ENTERO");} 
            | REAL {printf("\n  tipo_escalar -> REAL");} 
            | BOOLEANO {printf("\n  tipo_escalar -> BOOLEANO");} 
            | CARACTER {printf("\n  tipo_escalar -> CARACTER");}  
            | CADENA {printf("\n  tipo_escalar -> CADENA");} 
;            

tipo_fichero: FICHERO {printf("\n  tipo_fichero -> FICHERO");} ;

tipo_enumerado: '(' expresion_constante_mas ')';

tipo_lista: LISTA DE tipo_no_estructurado_o_nombre_tipo
          | LISTA '[' rango_mas ']' DE tipo_no_estructurado_o_nombre_tipo
;    

tipo_lista_asociativa: LISTA ASOCIATIVA DE tipo_no_estructurado_o_nombre_tipo;

rango: expresion DOS_PTOS expresion
     | expresion DOS_PTOS expresion DOS_PTOS expresion
;   

rango_mas: rango
         | rango rango_mas
;         

tipo_conjunto: CONJUNTO DE tipo_no_estructurado_o_nombre_tipo;

tipo_registro: REGISTRO '{' declaracion_campo_mas '}';

declaracion_campo: nombre_mas ';' tipo_no_estructurado_o_nombre_tipo ';';

declaracion_campo_mas: declaracion_campo
                     | declaracion_campo declaracion_campo_mas
;     

declaracion_clase: CLASE '{' declaraciones_publicas '}'
                 | CLASE '{' declaraciones_publicas declaraciones_semi'}'
                 | CLASE '{' declaraciones_publicas declaraciones_privadas'}'
                 | CLASE '{' declaraciones_publicas declaraciones_semi declaraciones_privadas'}'

                 | CLASE FINAL '{' declaraciones_publicas '}'
                 | CLASE FINAL '{' declaraciones_publicas declaraciones_semi'}'
                 | CLASE FINAL '{' declaraciones_publicas declaraciones_privadas'}'
                 | CLASE FINAL '{' declaraciones_publicas declaraciones_semi declaraciones_privadas'}'

                 | CLASE '(' nombre_mas ')' '{' declaraciones_publicas '}'
                 | CLASE '(' nombre_mas ')' '{' declaraciones_publicas declaraciones_semi'}'
                 | CLASE '(' nombre_mas ')' '{' declaraciones_publicas declaraciones_privadas'}'
                 | CLASE '(' nombre_mas ')' '{' declaraciones_publicas declaraciones_semi declaraciones_privadas'}'

                 | CLASE FINAL '(' nombre_mas ')' '{' declaraciones_publicas '}'
                 | CLASE FINAL '(' nombre_mas ')' '{' declaraciones_publicas declaraciones_semi'}'
                 | CLASE FINAL '(' nombre_mas ')' '{' declaraciones_publicas declaraciones_privadas'}'
                 | CLASE FINAL '(' nombre_mas ')' '{' declaraciones_publicas declaraciones_semi declaraciones_privadas'}'
;

declaraciones_publicas: declaracion_componente_mas
                      | PUBLICO declaracion_componente_mas
;

declaraciones_semi: SEMIPUBLICO declaracion_componente_mas;

declaraciones_privadas: PRIVADO declaracion_componente_mas;   

declaracion_componente: declaracion_tipo_anidado
                      | declaracion_constante_anidada
                      | declaracion_atributos
                      | cabecera_subprograma ';'
                      | cabecera_subprograma ';' modificadores ';' 
; 

declaracion_componente_mas: declaracion_componente
                          | declaracion_componente declaracion_componente_mas
;                    

declaracion_tipo_anidado: TIPO declaracion_tipo;

declaracion_constante_anidada: CONSTANTE declaracion_constante;

declaracion_atributos: nombre_mas ':' tipo_no_estructurado_o_nombre_tipo ';' ;

modificadores: modificador
             | modificador ',' modificadores //En el ejemplo es una ',' pero en la definicion no pone nada de ,
;             

modificador: GENERICO
           | ABSTRACTO
           | ESPECIFICO
           | FINAL
;             

/*************************************/
/* constantes, variables, interfaces */
/*************************************/

declaracion_constantes: CONSTANTE declaracion_constante_mas {printf("\n  decl_consts -> CONSTANTE decl_consts"); } ;

declaracion_constante: nombre ':' tipo_no_estructurado_o_nombre_tipo '=' valor_constante ';' {printf("\n  decl_const -> nom : tipo_no_str_o_nom = valor_const"); } ; 

declaracion_constante_mas: declaracion_constante {printf("\n  decl_consts -> decl_const"); }
                         | declaracion_constante declaracion_constante_mas
;        

valor_constante: expresion {printf("\n  valor_const -> expr"); }
               | '[' valor_constante_mas ']' {printf("\n  valor_const -> '[' valor_consts ']'"); }
               | '[' clave_valor_mas ']' {printf("\n  valor_const -> '[' clave_valores ']'"); }
               | '[' campo_valor_mas ']' {printf("\n  valor_const -> '[' campo_valores ']'"); }
;

valor_constante_mas: valor_constante {printf("\n  valor_consts -> valor_const"); }
                   | valor_constante ',' valor_constante_mas
;

clave_valor_mas: clave_valor {printf("\n  claves_valor -> clave_valor"); }
               | clave_valor ',' clave_valor_mas
;

campo_valor_mas: campo_valor {printf("\n  campo_valores -> campo_valor"); }
               | campo_valor ',' campo_valor_mas
;               

clave_valor: CTC_CADENA FLECHA_DOBLE valor_constante {printf("\n  clase_valor -> CTC_CADENA => valor_const"); } ;

campo_valor: nombre FLECHA_DOBLE valor_constante {printf("\n  campo_valor -> nom => valor_const"); } ;

declaracion_variables: VARIABLE declaracion_variable_mas {printf("\n  decl_var -> VARIABLE decl_vars"); } ;

declaracion_variable : nombre_mas ':' tipo_no_estructurado_o_nombre_tipo ';' {printf("\n  decl_var -> noms : tipo_no_str_o_nom ;"); }
                     | nombre_mas ':' tipo_no_estructurado_o_nombre_tipo '=' valor_constante ';' {printf("\n  decl_var -> noms : tipo_no_str_o_nom = valor_const ;"); }
;

declaracion_variable_mas: declaracion_variable {printf("\n  decl_vars -> decl_var"); }
                        | declaracion_variable declaracion_variable_mas
;                      

declaracion_interfaces: INTERFAZ cabecera_subprograma_mas {printf("\n  decl_intf -> INTERFAZ cabs_subprg"); } ;

/****************/
/* subprogramas */
/****************/

declaracion_subprograma: cabecera_subprograma bloque_subprograma {printf("\n  declr_subprg -> cab_subprg blq_subprg");} ;

declaracion_subprograma_mas : declaracion_subprograma
                            | declaracion_subprograma declaracion_subprograma_mas //Aqui habia una ',' pero al parecer en el ejemplo no es necesaria
;                            

cabecera_subprograma: cabecera_funcion {printf("\n  cab_subprg -> cab_func");}
                    | cabecera_procedimiento {printf("\n  cab_subprg -> cab_proced");}
                    | cabecera_constructor {printf("\n  cab_subprg -> cab_constr");}
                    | cabecera_destructor {printf("\n  cab_subprg -> cab_destr");}
;

cabecera_subprograma_mas: cabecera_subprograma ';' {printf("\n  cabs_subprg -> cab_subprg");}
                        | cabecera_subprograma ';' cabecera_subprograma_mas
;                        

cabecera_funcion: FUNCION nombre FLECHA_DOBLE tipo_no_estructurado_o_nombre_tipo {printf("\n  cab_func -> FUNCION nom => tipo_no_str_o_nom"); }
                | FUNCION nombre declaracion_parametros FLECHA_DOBLE tipo_no_estructurado_o_nombre_tipo {printf("\n  cab_func -> FUNCION nom decl_params => tipo_no_str_o_nom"); }
;         

cabecera_procedimiento: PROCEDIMIENTO nombre {printf("\n  cab_proced -> PROCEDIMIENTO nom"); }
                      | PROCEDIMIENTO nombre declaracion_parametros {printf("\n  cab_proced -> PROCEDIMIENTO nom decl_params"); }
;

cabecera_constructor: CONSTRUCTOR nombre {printf("\n  cab_constr -> CONSTRUCTOR nom"); }
                    | CONSTRUCTOR nombre declaracion_parametros {printf("\n  cab_constr -> CONSTRUCTOR nom decl_params"); }
;

cabecera_destructor: DESTRUCTOR nombre {printf("\n  cab_destr -> DESTRUCTOR nom");} ;

declaracion_parametros: '(' lista_parametros_formales ')' {printf("\n  decl_params -> list_params_form");};

lista_parametros_formales: parametros_formales {printf("\n  list_params_form -> params_form");} //Esta recursividad esta bien?? (definida asi en el pfd)
                         | lista_parametros_formales ';' parametros_formales
;

parametros_formales: nombre_mas ':' tipo_no_estructurado_o_nombre_tipo {printf("\n  params_form -> noms : tipo_no_str_o_nom");}  //Uno o mas nombres revisar
                   | nombre_mas ':' tipo_no_estructurado_o_nombre_tipo MODIFICABLE {printf("\n  params_form -> noms : tipo_no_str_o_nom MODIFICABLE");} 
;       

//Tambien puedo poner bloque subprogrma
bloque_subprograma: bloque_instrucciones {printf("\n  blq_subprg -> blq_instr");}
                  | declaracion_tipos bloque_instrucciones {printf("\n  blq_subprg -> decl_tip blq_instr");}
                  | declaracion_constantes bloque_instrucciones {printf("\n  blq_subprg -> decl_const blq_instr");}
                  | declaracion_variables bloque_instrucciones {printf("\n  blq_subprg -> decl_var blq_instr");}
                  | declaracion_tipos declaracion_variables bloque_instrucciones {printf("\n  blq_subprg -> decl_tip decl_var blq_instr");}
                  | declaracion_tipos declaracion_constantes bloque_instrucciones {printf("\n  blq_subprg -> decl_tip decl_const blq_instr");}
                  | declaracion_constantes declaracion_variables bloque_instrucciones {printf("\n  blq_subprg -> decl_const decl_var blq_instr");}
                  | declaracion_tipos declaracion_constantes declaracion_variables bloque_instrucciones {printf("\n  blq_subprg -> decl_tip decl_const decl_ var blq_instr");}
;          


/*****************/
/* instrucciones */
/*****************/

instruccion: ';' { printf("\n  instr -> ;");}  //Esta bien puesto??
           | instruccion_asignacion { printf("\n  instr -> instr_asig");}
           | instruccion_salir { printf("\n  instr -> instr_salir");}
           | instruccion_devolver { printf("\n  instr -> instr_devol");}
           | instruccion_llamada { printf("\n  instr -> instr_llmda");}
           | instruccion_si { printf("\n  instr -> instr_si");}
           | instruccion_casos { printf("\n  instr -> instr_casos");}
           | instruccion_bucle { printf("\n  instr -> instr_bucle");}
           | instruccion_probar_excepto { printf("\n  instr -> instr_exc");}
           | instruccion_lanzar { printf("\n  instr -> instr_lanzar");}
;

instruccion_mas: instruccion { printf("\n  instrs -> instr");}
               | instruccion instruccion_mas
;        

instruccion_asignacion: objeto '=' expresion ';' {printf("\n  instr_asig -> objeto = expr"); } ; 


instruccion_salir: SALIR ';' {printf("\n  instr_salir -> SALIR ;"); }
                 | SALIR SI expresion {printf("\n  instr_salir -> SALIR SI expr ;"); }
;                            

instruccion_devolver: DEVOLVER ';' {printf("\n  instr_devol -> DEVOLVER"); }
                    | DEVOLVER expresion ';' {printf("\n  instr_devol -> DESVOLVER expr"); }
;

instruccion_llamada: llamada_subprograma ';' {printf("\n  instr_llmda -> llmda_subprg"); } ;

llamada_subprograma: nombre {printf("\n  llmda_subprg -> nom"); }
                   | nombre '('                     ')' {printf("\n  llmda_subprg -> nom '('       ')' "); }
                   | nombre '(' expresion_asterisco ')' {printf("\n  llmda_subprg -> nom '(' exprs ')' "); }
;

instruccion_si: SI expresion ENTONCES bloque_instrucciones {printf("\n  instr_si -> SI expr ENTONCES blq_instr"); }
              | SI expresion ENTONCES bloque_instrucciones SINO bloque_instrucciones {printf("\n  instr_si -> SI expr ENTONCES blq_instr"); }
;   

instruccion_casos: EN CASO expresion SEA caso_mas';' {printf("\n  instr_casos -> EN CASO expr casos"); } ;

caso: entradas FLECHA_DOBLE bloque_instrucciones {printf("\n  caso -> entradas => blq_instr"); } ; 

caso_mas: caso {printf("\n  casos -> caso"); } //Esto es necesario??? Es decir, es necesario imprimir algo en pantalla en casos recursivos
        | caso caso_mas
;   

entradas: entrada //Falta esto aqui
        | entrada '|' entradas
;

entrada: expresion {printf("\n  entrada -> expr"); }
       | rango {printf("\n  entrada -> rango"); }
       | OTRO {printf("\n  entrada -> OTRO"); }
;

instruccion_bucle: clausula_iteracion bloque_instrucciones {printf("\n  instr_bucle -> claus_iter blq_instr"); } ;

clausula_iteracion: PARA nombre EN objeto {printf("\n  claus_iter -> PARA nom EN objeto"); }
                  | REPITE ELEMENTO nombre EN rango {printf("\n  claus_iter -> REPITE ELEMENTO nom EN rango"); } 
                  | REPITE ELEMENTO nombre EN rango DESCENDENTE {printf("\n  claus_iter -> REPITE ELEMENTO nom EN rango DESCENDENTE"); }
                  | MIENTRAS expresion {printf("\n  claus_iter -> MIENTRAS expr"); }
                  | REPITE HASTA expresion {printf("\n  claus_iter -> REPITE HASTA expr"); }
;   

instruccion_probar_excepto: PROBAR bloque_instrucciones EXCEPTO clausula_excepcion_mas {printf("\n  instr_prob_exc -> PROBAR blq_instr EXCEPTO claus_excs"); }
                          | PROBAR bloque_instrucciones EXCEPTO clausula_excepcion_mas FINALMENTE bloque_instrucciones {printf("\n  instr_prob_exc -> PROBAR blq_instr EXCEPTO claus_excs FINALMENTE blq_instr"); }
;                          

clausula_excepcion: CUANDO nombre EJECUTA bloque_instrucciones {printf("\n  claus_exc -> CUANDO nom EJECUTA blq_instr"); } ;

clausula_excepcion_mas: clausula_excepcion {printf("\n  claus_excs -> claus_exc"); }
                      | clausula_excepcion clausula_excepcion_mas
;                    

instruccion_lanzar: LANZAR nombre ';' {printf("\n  instr_lanzar -> LANZAR nom"); } ; 


/***************/
/* expresiones */
/***************/

expresion: CTC_ENTERA
         | CTC_CADENA
         | CTC_REAL
         | IDENTIFICADOR
         | expresion '+' expresion
;

expresion_asterisco:  expresion
                   |  expresion expresion_asterisco 
;

expresion_constante: CTC_ENTERA | CTC_REAL | CTC_CADENA | CTC_CARACTER | CTC_BOOLEANA;

expresion_constante_mas: expresion_constante
                       | expresion_constante expresion_constante_mas
;                       

objeto: nombre {printf("\n  obj -> nom"); }
      | objeto '[' expresion ']' {printf("\n  obj -> obj '[' expr ']'"); }
      | objeto '.' IDENTIFICADOR {printf("\n  obj -> obj '.' IDENTIFICADOR"); }
;

%%

void yyerror(char *s) {
  fflush(stdout);
  printf("%s\n",s);
}

int yywrap() {
  //printf("\n");
  return(1);
}

int main(int argc, char *argv[]) {
  yydebug = 0;

  if(argc < 2){
    printf("Uso: ./moronico NombreArchivo\n");
  }
  else{
    yyin = fopen(argv[1],"r");
    yyparse();
  }
}