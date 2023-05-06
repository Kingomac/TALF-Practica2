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

/** Operadores asociativos por la izquierda **/
/*%right OR AND POTENCIA*/ 
/** Operadores unarios no asociativos **/
/*%nonassoc '-' '!'*/

%right AND OR
%left LEQ GEQ NEQ EQ
%left '^' '@'
%left '&'
%left '<' '>'
%nonassoc '-'
%left '+'
%left '*' '/'
%left '%'

%start instruccion_casos

%%

/*AUX*/ /*Hay muchas definiciones recursivas que pueden necesitar ; o una mejor definicion de expresion*/
nombre: IDENTIFICADOR 
      | IDENTIFICADOR CUATRO_PTOS nombre 
;

nombre_mas: nombre  
          | nombre nombre_mas
;          

/********************************/
/* programas, paquetes y cargas */
/********************************/

bloque_instrucciones: '{' instruccion_mas '}' { printf("\n   bloque_instruccion  ->  '{' instrucciones '}'");};

/************************/
/* tipos (incl. clases) */
/************************/

declaracion_tipos: TIPO declaracion_tipo_mas {printf(" declaracion_tipo  ->  TIPO "); } ;  //Como termino esto??

declaracion_tipo: nombre '=' tipo_no_estructurado_o_nombre_tipo ';' {printf("\n   declarac_tipo  ->  nom  =  tipo_no_estructurado_o_nombre"); }
                | nombre '=' tipo_estructurado {printf("\n  declarac_tipo -> nom = tipo_estructurado");};

declaracion_tipo_mas: declaracion_tipo
                    | declaracion_tipo declaracion_tipo_mas;                    

tipo_no_estructurado_o_nombre_tipo: nombre;  
                                  | tipo_escalar {printf("\n   tipo_no_estructurado_o_nombre  ->  tipo_escalar");}
                                  | tipo_fichero {printf("\n   tipo_no_estructurado_o_nombre -> tipo_fichero");}
                                  | tipo_enumerado {printf("\n   tipo_no_estructurado_o_nombre -> tipo_enumerado");}
                                  | tipo_lista {printf("\n   tipo_no_estructurado_o_nombre -> tipo_lista");}
                                  | tipo_lista_asociativa {printf("\n   tipo_no_estructurado_o_nombre -> tipo_lista_asociativa");}
                                  | tipo_conjunto {printf("\n   tipo_no_estructurado_o_nombre -> tipo_conjunto");};                                                                   

tipo_estructurado: tipo_registro {printf("tipo_estructurado -> tipo_registro");};  /*Falta declaracion de clase */

tipo_escalar: ENTERO {printf("\n   tipo_escalar  ->  ENTERO");} 
            | REAL {printf("\n   tipo_escalar  ->  REAL");} 
            | BOOLEANO {printf("\n   tipo_escalar -> BOOLEANO");} 
            | CARACTER {printf("\n   tipo_escalar -> CARACTER");}  
            | CADENA {printf("\n   tipo_escalar -> CADENA");} 
;            

tipo_fichero: FICHERO {printf("\n   tipo_fichero -> FICHERO");} ;

tipo_enumerado: '(' expresion_ctc_mas ')';

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

/*************************************/
/* constantes, variables, interfaces */
/*************************************/

declaracion_constantes: CONSTANTE declaracion_constante_mas {printf("\n   decl_consts -> CONSTANTE declarac_consts");} ;

declaracion_constante: nombre ':' tipo_no_estructurado_o_nombre_tipo '=' valor_constante ';' {printf("\n  decl_const -> nom : tipo_no_str_o_nom = valor_const"); } ; 

declaracion_constante_mas: declaracion_constante {printf("\n   decl_consts  ->  decl_const"); }
                         | declaracion_constante declaracion_constante_mas
;        

/*Real shit*/
valor_constante: expresion {printf("\n  valor_const -> expr"); }
               | '[' valor_constante_mas ']' {printf("\n  valor_const  ->  '[' valor_consts ']'"); }
               | '[' clave_valor_mas ']' {printf("\n  valor_const  ->  '[' clave_valores ']'"); }
               | '[' campo_valor_mas ']' {printf("\n  valor_const  ->  '[' campo_valores ']'"); }
;

valor_constante_mas: valor_constante
                   | valor_constante ',' valor_constante_mas
;

clave_valor_mas: clave_valor
               | clave_valor ',' clave_valor_mas
;

campo_valor_mas: campo_valor
               | campo_valor ',' campo_valor_mas
;               

clave_valor: CTC_CADENA FLECHA_DOBLE valor_constante {printf(""); } ;

campo_valor: nombre FLECHA_DOBLE valor_constante {printf(""); } ;

declaracion_variables: VARIABLE declaracion_variable_mas;

declaracion_variable : nombre_mas ':' tipo_no_estructurado_o_nombre_tipo ';'
                     | nombre_mas ':' tipo_no_estructurado_o_nombre_tipo '=' valor_constante ';'
;

declaracion_variable_mas: declaracion_variable
                        | declaracion_variable declaracion_variable_mas
;                      

declaracion_interfaces: INTERFAZ cabecera_subprograma_mas {printf("\n  decl_intf -> INTERFAZ cabs_subprg"); } ;

/****************/
/* subprogramas */
/****************/

declaracion_subprograma: cabecera_subprograma bloque_subprograma {printf("\n  declarac_subprograma -> cabecera_subprograma bloque_subprograma");} ;

cabecera_subprograma: cabecera_funcion {printf("\n  cabecera_subprograma -> cabevera_funcion");}
                    | cabecera_procedimiento {printf("\n  cabecera_subprograma -> cabecera_procedimiento");}
                    | cabecera_constructor {printf("\n  cabecera_subprograma -> cabecera_constructor");}
                    | cabecera_destructor {printf("\n  cabecera_subprograma -> cabecera_destructor");}
;

cabecera_subprograma_mas: cabecera_subprograma ';' {printf("\n  cabecera_subprog -> cabecera_subprog");}
                        | cabecera_subprograma cabecera_subprograma_mas
;                        


cabecera_funcion: FUNCION nombre FLECHA_DOBLE tipo_no_estructurado_o_nombre_tipo {printf("\n  cabecera_funcion -> funcion nombre => tipo_no_estruc_o_nombre"); }
                | FUNCION nombre declaracion_parametros FLECHA_DOBLE tipo_no_estructurado_o_nombre_tipo {printf("\n  cabecera_funcion -> funcion nom declaracion_paramametros => tipo_no_estruc_o_nom"); }
;         

cabecera_procedimiento: PROCEDIMIENTO nombre {printf("\n  cabecera_procedimiento -> procedimiento_nom"); }
                      | PROCEDIMIENTO nombre declaracion_parametros {printf("\n  cabecera_procedimiento -> procedimiento_nombre_declaracion_parametros"); }
;

cabecera_constructor: CONSTRUCTOR nombre {printf("\n  cabecera_constructor -> constructor_nom"); }
                    | CONSTRUCTOR nombre declaracion_parametros {printf("\n  cabecera_constructor -> constructor_nombre_declaracion_parametros"); }
;

cabecera_destructor: DESTRUCTOR nombre {printf("\n  cabecera_destuctor -> destructor_nombre");} ;

declaracion_parametros: '(' lista_parametros_formales ')' {printf("\n  declarac_parametro -> lista_parametro_formales");};

lista_parametros_formales: parametros_formales {printf("\n  lista_parametros_formales -> paramametros_formales");} //Esta recursividad esta bien?? (definida asi en el pfd)
                         | lista_parametros_formales ';' parametros_formales
;

parametros_formales: nombre_mas ':' tipo_no_estructurado_o_nombre_tipo {printf("\n  parametros_formales -> nombre : tipo_no_estructurado_o_nombre");}  //Uno o mas nombres revisar
                   | nombre_mas ':' tipo_no_estructurado_o_nombre_tipo MODIFICABLE {printf("\n  parametros_formales -> nombre : tipo_no_estructurado_o_nombre_modificable");} 
;       

//Tambien puedo poner bloque subprogrma
bloque_subprograma: bloque_instrucciones {printf("\n  bloque_subprograma -> bloque_instrucion");}
                  | declaracion_tipos bloque_instrucciones {printf("\n  bloque_subprograma -> declaracion_tipos_bloqque_instruccion");}
                  | declaracion_constantes bloque_instrucciones {printf("\n  bloque_subprograma -> declarac_constantes_bloque_instrucion");}
                  | declaracion_variables bloque_instrucciones {printf("\n  bloque_subprograma -> declaracion_variable_bloque_instrucion");}
                  | declaracion_tipos declaracion_variables bloque_instrucciones {printf("\n  bloque_subprograma -> decl_tip declaracion_variable_bloque_instrucion");}
                  | declaracion_tipos declaracion_constantes bloque_instrucciones {printf("\n  bloque_subprograma -> decl_tip declarac_constantes_bloque_instrucion");}
                  | declaracion_constantes declaracion_variables bloque_instrucciones {printf("\n  bloque_subprograma -> declarac_constantes_declaracion_variable_bloque_instrucion");}
                  | declaracion_tipos declaracion_constantes declaracion_variables bloque_instrucciones {printf("\n  bloque_subprograma -> declarac_tipo&declarac_const&declarac_variables&bloque_instrucciones");}
;          

/*****************/
/* instrucciones */
/*****************/

instruccion: ';' { printf("\n  instrucion -> ;");}
           | instruccion_asignacion { printf("\n  instrucion -> instrucion_asignacion");}
           | instruccion_salir { printf("\n  instrucion -> instrucion_salir");}
           | instruccion_devolver { printf("\n  instrucion -> instrucion_devolver");}
           | instruccion_llamada { printf("\n  instrucion -> instrucion_llamada");}
           | instruccion_si { printf("\n  instrucion -> instruccion_si");}
           | instruccion_casos { printf("\n  instrucion -> instrucion_casos");}
           | instruccion_bucle { printf("\n  instrucion -> instruccion_bucle"); }
           | instruccion_probar_excepto { printf("\n  instrucion -> instrucion_probar_excepto");}
           | instruccion_lanzar { printf("\n  instrucion -> instrucion_lanzar");};

instruccion_mas: instruccion { printf("\n  instrucion -> instruccion");}
               | instruccion instruccion_mas;

instruccion_asignacion: objeto '=' expresion ';' {printf("\n  instr_asignacion -> objeto = exp"); };


instruccion_salir: SALIR ';' {printf("\n  instrucion_salir -> salir"); }
                 | SALIR SI expresion ';' {printf("\n  instrucion_salir -> salir_si_exp ;"); };

instruccion_devolver: DEVOLVER ';' {printf("\n  instrucion_devolver -> devolver"); }
                    | DEVOLVER expresion ';' {printf("\n  instrucion_devol -> devolver_exp"); };

instruccion_llamada: llamada_subprograma ';' {printf("\n  instruccion_llamada -> llamada_subprograma"); } ;

llamada_subprograma: nombre {printf("\n  llamada_subprograma -> nombre"); }
                   | nombre '(' ')' {printf("\n  llamada_subprograma -> nombre () "); }
                   | nombre '(' expresion_lista ')' {printf("\n  llamada_subprograma -> nombre ( expression ) "); };

instruccion_si: SI expresion ENTONCES bloque_instrucciones {printf("\n  instruccion_si -> si_exp_entonces_bloque_instruccion"); }
              | SI expresion ENTONCES bloque_instrucciones SINO bloque_instrucciones {printf("\n  instruccion_si -> si_exprresion_entonces_bloque_instrucion"); }; 

instruccion_casos: EN CASO expresion SEA caso_mas';' {printf("\n  instruccion_casos -> en_caso_expresion_casos"); } ;

caso: entradas FLECHA_DOBLE bloque_instrucciones {printf("\n  caso -> entradas => bloque_instrucion"); } ; 

caso_mas: caso
        | caso caso_mas;

entradas: entrada //Falta esto aqui
        | entrada '|' entradas;

entrada: expresion {printf("\n  entrada -> expresion"); }
       | rango {printf("\n  entrada -> rango"); }
       | OTRO {printf("\n  entrada -> OTRO"); };


instruccion_bucle: clausula_iteracion bloque_instrucciones {printf("\n  instruccion_bucle -> clausula_iteracion&bloque_instruciones"); } ;

clausula_iteracion: PARA nombre EN objeto {printf("\n  clausula_iteracion -> para_nombre_en_objeto"); }
                  | REPITE ELEMENTO nombre EN rango {printf("\n  clausula_iteracion -> repite_elemento_nom_en_rango"); } 
                  | REPITE ELEMENTO nombre EN rango DESCENDENTE {printf("\n  clausula_iteracion -> repite_elemento_nom_en_rango_descendente"); }
                  | MIENTRAS expresion {printf("\n  clausula_iteracion -> mientras_espresion"); }
                  | REPITE HASTA expresion {printf("\n  clausula_iteracion -> repite_hasta_expresion"); }
;   

instruccion_probar_excepto: PROBAR bloque_instrucciones EXCEPTO clausula_excepcion_mas {printf("\n  instrucion_probar_excepto -> probar_bloque_instrucion_excepto_clausula_excepcion_mas"); }
                          | PROBAR bloque_instrucciones EXCEPTO clausula_excepcion_mas FINALMENTE bloque_instrucciones {printf("\n  instrucion_probar_excepto -> instrucion_probar_excepto -> probar_bloque_instrucion_excepto_clausula_excepcion_mas_finalmente_bloque_instrucion"); }
;                          

clausula_excepcion: CUANDO nombre EJECUTA bloque_instrucciones {printf("\n  clasula_ejecuta -> cuando_nombre_ejecuta_bloque_instrucion"); } ;

clausula_excepcion_mas: clausula_excepcion {printf("\n  clausula_ejecutas -> clausula_excepcion"); }
                      | clausula_excepcion clausula_excepcion_mas 
;                    

instruccion_lanzar: LANZAR nombre ';' {printf("\n  instruccion_lanzar -> lanzar_nombre"); } ; 


/***************/
/* expresiones */
/***************/

/** expresiones aritméticas **/
expresion_negativa: '-' expresion_ctc_entera { printf("\n expr -> negativa"); };

expresion_potencia: expresion_numerica POTENCIA expresion_ctc_entera { printf("\n expr -> potencia"); }
                  | expresion_numerica POTENCIA expresion_ctc_real { printf("\n expr -> potencia"); };

expresion_numerica: expresion_ctc_entera
                  | expresion_ctc_real
                  | expresion_negativa
                  | expresion_potencia;

expresion_multiplicacion: expresion '*' expresion;
expresion_division: expresion '/' expresion;
expresion_modulo: expresion '%' expresion;
expresion_resta: expresion '-' expresion;
expresion_suma: expresion '+' expresion;

expresion_aritmetica: expresion_multiplicacion { printf("\n expr -> multiplicacion"); }
         | expresion_division { printf("\n expr -> division"); }
         | expresion_modulo { printf("\n expr -> modulo"); }
         | expresion_resta { printf("\n expr -> resta"); }
         | expresion_suma { printf("\n expr -> suma"); };

/** expresiones lógicas **/
expresiones_logicas: expresion '<' expresion { printf("\n expr -> menor que"); }
                   | expresion '>' expresion { printf("\n expr -> mayor que"); }
                   | expresion NEQ expresion { printf("\n expr -> distinto"); }
                   | expresion LEQ expresion { printf("\n expr -> menor o igual"); }
                   | expresion GEQ expresion { printf("\n expr -> mayor o igual"); }
                   | expresion AND expresion { printf("\n expr -> and"); }
                   | expresion OR expresion { printf("\n expr -> or"); }
                   | expresion EQ expresion { printf("\n expr -> eq"); };

/** expresiones binarias **/
expresion_bin_and:expresion '&' expresion;
expresion_bin_or: expresion '^' expresion;
expresion_bin_xor: expresion '@' expresion;

expresion_binaria: expresion_bin_and { printf("\n expr -> binaria and"); }
                 | expresion_bin_or { printf("\n expr -> binaria or"); }
                 | expresion_bin_xor { printf("\n expr -> binaria xor"); };


expresion: expresion_aritmetica
          | expresion_binaria
          | expresiones_logicas
          | expresion_numerica
          | expresion_ctc_booleana
          | expresion_ctc_caracter
          | expresion_ctc_cadena
          | IDENTIFICADOR
          | '(' expresion_aritmetica ')'
          | '(' expresion_binaria ')'
          | '(' expresiones_logicas ')'
          | '(' expresion_numerica ')'
          | '(' expresion_ctc_booleana ')'
          | '(' expresion_ctc_caracter ')'
          | '(' expresion_ctc_cadena ')'
          | '(' IDENTIFICADOR ')';

/*expresion_mas: expresion
             | expresion expresion_mas ;
*/

expresion_lista: expresion
               | expresion ',' expresion_lista; 

expresion_asterisco: expresion
                   | expresion expresion_asterisco;

expresion_ctc_entera: CTC_ENTERA { printf("\n expr_ctc -> CTC_ENTERA"); };

expresion_ctc_real: CTC_REAL { printf("\n expr_ctc_real -> CTC_REAL"); };

expresion_ctc_cadena: CTC_CADENA { printf("\n expr_ctc_cadena -> CTC_CADENA"); };

expresion_ctc_caracter: CTC_CARACTER { printf("\n expr_ctc_caracter -> CTC_CARACTER"); };

expresion_ctc_booleana: CTC_BOOLEANA { printf("\n expr_ctc_booleana -> CTC_BOOLEANA"); };

expresion_ctc: expresion_ctc_entera
             | expresion_ctc_real
             | expresion_ctc_cadena
             | expresion_ctc_caracter
             | expresion_ctc_booleana;

expresion_ctc_mas: expresion_ctc
                  | expresion_ctc expresion_ctc_mas;

expresion_primaria: expresion_ctc
                  | objeto
                  | llamada_subprograma
                  | '(' expresion ')';


objeto: nombre {printf("\n  obj -> nom"); }
      | objeto '[' expresion_lista ']' {printf("\n  obj -> obj '[' expr ']'"); }
      | objeto '.' IDENTIFICADOR {printf("\n  obj -> obj '.' IDENTIFICADOR"); };

%%

void yyerror(char *s) {
  fflush(stdout);
  printf("%s\n",s);
}

int yywrap() {
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
  printf("\n\n");
}