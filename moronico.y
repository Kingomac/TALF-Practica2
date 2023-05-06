%{
  #include <stdio.h>
  extern FILE *yyin;
  extern int yylex();

  void yyerror(char *s);

  #define YYDEBUG 1

%}

%define parse.error verbose

%token ABSTRACTO     AND          ASOCIATIVA  BOOLEANO 
%token CABECERA      CADENA       CASO        CARACTER 
%token CARGA         CLASE        CONJUNTO    CONSTANTE 
%token CUERPO        CTC_BOOLEANA CTC_CADENA  CTC_CARACTER 
%token CTC_ENTERA    CTC_REAL     CONSTRUCTOR CUANDO
%token CUATRO_PTOS   DESCENDENTE  DESPD       DESPI 
%token DESTRUCTOR    DE           DEVOLVER    DOS_PTOS 
%token EJECUTA       ELEMENTO     EN          ENTERO 
%token ENTONCES      EQ           ESPECIFICO  EXCEPTO 
%token FICHERO       FINAL        FINALMENTE  FLECHA_DOBLE 
%token FUNCION       GEQ          GENERICO    HASTA 
%token IDENTIFICADOR INTERFAZ     LANZAR      LEQ 
%token LISTA         MIENTRAS     MODIFICABLE NEQ 
%token OTRO          OR           PAQUETE     PARA 
%token PATH          POTENCIA     PRIVADO     PROBAR 
%token PROCEDIMIENTO PROGRAMA     PUBLICO     REAL 
%token REGISTRO      REPITE       SALIR       SEA 
%token SEMIPUBLICO   SI           SINO        TIPO           VARIABLE


%right OR
%right AND
%nonassoc '!'
%left '<' '>' LEQ GEQ EQ NEQ
%left '@'
%left '&'
%left DESPI DESPD
%left '+' '-'
%left '*' '/' '%'
%right POTENCIA


%start programa

%%

/********************************/
/* programas, paquetes y cargas */
/********************************/

programa: definicion_programa
        | definicion_paquete
        | error { yyerrok; yyclearin; };

definicion_programa: PROGRAMA nombre ';' bloque_programa;

nombre: IDENTIFICADOR                    { printf("\n  nombre_dec -> IDENTIFICADOR"); }
      | nombre CUATRO_PTOS IDENTIFICADOR { printf("\n  nombre_dec -> nombre_dec :: IDENTIFICADOR"); };

nombre_lista: nombre  
            | nombre ',' nombre_lista;
            
bloque_programa:                                                                                   bloque_instrucciones { printf("\n bloque_programa -> '{' bloq_instruc'}'");}
               | declaracion_cargas                                                                bloque_instrucciones { printf("\n bloque_programa -> '{' declaracion_cargas bloq_instruc'}'");}
               |                    declaracion_tipos                                              bloque_instrucciones { printf("\n bloque_programa -> '{' declarac_tipos bloq_instruc'}'");}
               | declaracion_cargas declaracion_tipos                                              bloque_instrucciones { printf("\n bloque_programa -> '{' declaracion_cargas declarac_tipos bloq_instruc'}'");}
               |                                      declaracion_constantes                       bloque_instrucciones { printf("\n bloque_programa -> '{' declarac_const bloq_instruc'}'");}
               | declaracion_cargas                   declaracion_constantes                       bloque_instrucciones { printf("\n bloque_programa -> '{' declaracion_cargas declarac_const bloq_instruc'}'");}
               |                    declaracion_tipos declaracion_constantes                       bloque_instrucciones { printf("\n bloque_programa -> '{' declarac_tipos declarac_const bloq_instruc'}'");}
               | declaracion_cargas declaracion_tipos declaracion_constantes                       bloque_instrucciones { printf("\n bloque_programa -> '{' declaracion_cargas declarac_tipos declarac_const bloq_instruc'}'");}
               |                                                             declaracion_variables bloque_instrucciones { printf("\n bloque_programa -> '{' declarac_var bloq_instruc'}'");}
               | declaracion_cargas                                          declaracion_variables bloque_instrucciones { printf("\n bloque_programa -> '{' declaracion_cargas declarac_var bloq_instruc'}'");}
               |                    declaracion_tipos                        declaracion_variables bloque_instrucciones { printf("\n bloque_programa -> '{' declarac_tipos declarac_var bloq_instruc'}'");}
               | declaracion_cargas declaracion_tipos                        declaracion_variables bloque_instrucciones { printf("\n bloque_programa -> '{' declaracion_cargas declarac_tipos declarac_var bloq_instruc'}'");}
               |                                      declaracion_constantes declaracion_variables bloque_instrucciones { printf("\n bloque_programa -> '{' declarac_tipos declarac_const declarac_var bloq_instruc'}'");}
               | declaracion_cargas                   declaracion_constantes declaracion_variables bloque_instrucciones { printf("\n bloque_programa -> '{' declaracion_cargas declarac_const declarac_var bloq_instruc'}'");}
               |                    declaracion_tipos declaracion_constantes declaracion_variables bloque_instrucciones { printf("\n bloque_programa -> '{' declarac_tipos declarac_const declarac_var bloq_instruc'}'");}
               | declaracion_cargas declaracion_tipos declaracion_constantes declaracion_variables bloque_instrucciones { printf("\n bloque_programa -> '{' declaracion_cargas declarac_tipos declarac_const declarac_var bloq_instruc'}'");};

bloque_instrucciones: '{' instrucciones '}' { printf("\n   bloque_instruccion  ->  '{' instrucciones '}'");};

definicion_paquete: PAQUETE nombre ';' seccion_cabecera seccion_cuerpo {printf("\n definicion paquete -> PAQUETE nombre ; seccion_cabecera seccion_cuerpo");};

seccion_cabecera: CABECERA { printf("\n CABECERA ");};
                | CABECERA declaracion_cargas { printf("\n CABECERA -> '{' declarac_cargas'}'");}
                | CABECERA                    declaracion_tipos { printf("\n CABECERA -> '{' declarac_tipos'}'");}
                | CABECERA declaracion_cargas declaracion_tipos { printf("\n CABECERA -> '{' declarac_cargas declarac_tipos'}'");}
                | CABECERA                                      declaracion_constantes { printf("\n CABECERA -> '{' declarac_const'}'");}
                | CABECERA declaracion_cargas                   declaracion_constantes { printf("\n CABECERA -> '{' declarac_cargas declarac_const'}'");}
                | CABECERA                    declaracion_tipos declaracion_constantes { printf("\n CABECERA -> '{' declarac_tipos declarac_const '}'");}
                | CABECERA declaracion_cargas declaracion_tipos declaracion_constantes { printf("\n CABECERA -> '{' declarac_cargas declarac_tipos declarac_const'}'");}
                | CABECERA                                                             declaracion_variables { printf("\n CABECERA -> '{' declarac_var'}'");}
                | CABECERA declaracion_cargas                                          declaracion_variables { printf("\n CABECERA -> '{' declarac_cargas declarac_var'}'");}
                | CABECERA                    declaracion_tipos                        declaracion_variables { printf("\n CABECERA -> '{' declarac_tipos declarac_var'}'");}
                | CABECERA declaracion_cargas declaracion_tipos                        declaracion_variables { printf("\n CABECERA -> '{' declarac_cargas declarac_tipos declarac_var'}'");}
                | CABECERA                                      declaracion_constantes declaracion_variables { printf("\n CABECERA -> '{' declarac_const declarac_var'}'");}
                | CABECERA declaracion_cargas                   declaracion_constantes declaracion_variables { printf("\n CABECERA -> '{' declarac_cargas declarac_const declarac_var'}'");}
                | CABECERA                    declaracion_tipos declaracion_constantes declaracion_variables { printf("\n CABECERA -> '{' declarac_tipos declarac_const declarac_var'}'");}
                | CABECERA declaracion_cargas declaracion_tipos declaracion_constantes declaracion_variables { printf("\n CABECERA -> '{' declarac_cargas declarac_tipos declarac_const declarac_var'}'");};
                | CABECERA                                                                                   declaracion_interfaces { printf("\n CABECERA -> '{' declarac_interf'}'");} 
                | CABECERA declaracion_cargas                                                                declaracion_interfaces { printf("\n CABECERA -> '{' declarac_cargas declarac_interf'}'");}
                | CABECERA                    declaracion_tipos                                              declaracion_interfaces { printf("\n CABECERA -> '{' declarac_tipos declarac_interf'}'");}
                | CABECERA declaracion_cargas declaracion_tipos                                              declaracion_interfaces { printf("\n CABECERA -> '{' declarac_cargas declarac_tipos declarac_interf'}'");}
                | CABECERA                                      declaracion_constantes                       declaracion_interfaces { printf("\n CABECERA -> '{' declarac_const declarac_interf'}'");}
                | CABECERA declaracion_cargas                   declaracion_constantes                       declaracion_interfaces { printf("\n CABECERA -> '{' declarac_cargas declarac_const declarac_interf'}'");}
                | CABECERA                    declaracion_tipos declaracion_constantes                       declaracion_interfaces { printf("\n CABECERA -> '{' declarac_tipos declarac_const  declarac_interf'}'");}
                | CABECERA declaracion_cargas declaracion_tipos declaracion_constantes                       declaracion_interfaces { printf("\n CABECERA -> '{' declarac_cargas declarac_tipos declarac_const declarac_interf'}'");}
                | CABECERA                                                             declaracion_variables declaracion_interfaces { printf("\n CABECERA -> '{' declarac_var declarac_interf'}'");}
                | CABECERA declaracion_cargas                                          declaracion_variables declaracion_interfaces { printf("\n CABECERA -> '{' declarac_cargas declarac_var declarac_interf'}'");}
                | CABECERA                    declaracion_tipos                        declaracion_variables declaracion_interfaces { printf("\n CABECERA -> '{' declarac_tipos declarac_var declarac_interf'}'");}
                | CABECERA declaracion_cargas declaracion_tipos                        declaracion_variables declaracion_interfaces { printf("\n CABECERA -> '{' declarac_cargas declarac_tipos declarac_var declarac_interf'}'");}
                | CABECERA                                      declaracion_constantes declaracion_variables declaracion_interfaces { printf("\n CABECERA -> '{' declarac_const declarac_var declarac_interf'}'");}
                | CABECERA declaracion_cargas                   declaracion_constantes declaracion_variables declaracion_interfaces { printf("\n CABECERA -> '{' declarac_cargas declarac_const declarac_var declarac_interf'}'");}
                | CABECERA                    declaracion_tipos declaracion_constantes declaracion_variables declaracion_interfaces { printf("\n CABECERA -> '{' declarac_tipos declarac_const declarac_var declarac_interf'}'");}
                | CABECERA declaracion_cargas declaracion_tipos declaracion_constantes declaracion_variables declaracion_interfaces { printf("\n CABECERA -> '{' declarac_cargas declarac_tipos declarac_const declarac_var declarac_interf'}'");};

seccion_cuerpo:  CUERPO                                                                 declaracion_subprograma_mas { printf("\n CUERPO -> '{' declarac_subrog'}'");}
              | CUERPO declaracion_tipos                                               declaracion_subprograma_mas { printf("\n CUERPO -> '{' declarac_tipos declarac_subrog'}'");}
              | CUERPO                   declaracion_constantes                        declaracion_subprograma_mas { printf("\n CUERPO -> '{' declarac_const declarac_subrog'}'");}
              | CUERPO declaracion_tipos declaracion_constantes                        declaracion_subprograma_mas { printf("\n CUERPO -> '{' declarac_tipos declarac_const declarac_subrog'}'");}
              | CUERPO                                          declaracion_variables  declaracion_subprograma_mas { printf("\n CUERPO -> '{' declarac_var declarac_subrog'}'");}
              | CUERPO declaracion_tipos                        declaracion_variables  declaracion_subprograma_mas { printf("\n CUERPO -> '{' declarac_tipos declarac_var declarac_subrog'}'");}
              | CUERPO                   declaracion_constantes declaracion_variables  declaracion_subprograma_mas { printf("\n CUERPO -> '{' declarac_const declarac_var declarac_subrog'}'");}
              | CUERPO declaracion_tipos declaracion_constantes declaracion_variables  declaracion_subprograma_mas { printf("\n CUERPO -> '{' declarac_tipos declarac_const declarac_var declarac_subrog'}'");};


declaracion_cargas: CARGA declaracion_carga_lista ';';

declaracion_carga: nombre  
                 | nombre EN PATH
                 | nombre  '(' nombre_lista ')'
                 | nombre EN PATH '(' nombre_lista ')';

declaracion_carga_lista: declaracion_carga
                       | declaracion_carga ',' declaracion_carga_lista;

/************************/
/* tipos (incl. clases) */
/************************/

declaracion_tipos: TIPO declaraciones_tipos {printf(" declaracion_tipo  ->  TIPO "); } ;

declaracion_tipo: nombre '=' tipo_no_estructurado_o_nombre_tipo ';' {printf("\n   declarac_tipo  ->  nom  =  tipo_no_estructurado_o_nombre"); }
                | nombre '=' tipo_estructurado                      {printf("\n  declarac_tipo -> nom = tipo_estructurado");};

declaraciones_tipos: declaracion_tipo
                   | declaracion_tipo declaraciones_tipos;                    

tipo_no_estructurado_o_nombre_tipo: nombre                {printf("\n   tipo_no_estructurado_o_nombre  ->  nombre");}
                                  | tipo_escalar          {printf("\n   tipo_no_estructurado_o_nombre  ->  tipo_escalar");}
                                  | tipo_fichero          {printf("\n   tipo_no_estructurado_o_nombre -> tipo_fichero");}
                                  | tipo_enumerado        {printf("\n   tipo_no_estructurado_o_nombre -> tipo_enumerado");}
                                  | tipo_lista            {printf("\n   tipo_no_estructurado_o_nombre -> tipo_lista");}
                                  | tipo_lista_asociativa {printf("\n   tipo_no_estructurado_o_nombre -> tipo_lista_asociativa");}
                                  | tipo_conjunto         {printf("\n   tipo_no_estructurado_o_nombre -> tipo_conjunto");};

tipo_estructurado: tipo_registro {printf("tipo_estructurado -> tipo_registro");}
                 | declaracion_clase;

tipo_escalar: ENTERO   {printf("\n   tipo_escalar  ->  ENTERO");} 
            | REAL     {printf("\n   tipo_escalar  ->  REAL");} 
            | BOOLEANO {printf("\n   tipo_escalar -> BOOLEANO");} 
            | CARACTER {printf("\n   tipo_escalar -> CARACTER");}  
            | CADENA   {printf("\n   tipo_escalar -> CADENA");};            

tipo_fichero: FICHERO {printf("\n   tipo_fichero -> FICHERO");} ;

tipo_enumerado: '(' expresion_const_lista ')' {printf("\n tipo_enumerado -> expres_constant_list");};

tipo_lista: LISTA DE tipo_no_estructurado_o_nombre_tipo                     {printf("\n tipo_lista -> LISTA DE tipo_no_estruct_o_nom_tipo");}
          | LISTA '[' rango_lista ']' DE tipo_no_estructurado_o_nombre_tipo {printf("\n tipo_lista -> LISTA rango DE tipo_no_estruct_o_nom_tipo ");};    

tipo_lista_asociativa: LISTA ASOCIATIVA DE tipo_no_estructurado_o_nombre_tipo;

rango: expresion DOS_PTOS expresion
     | expresion DOS_PTOS expresion DOS_PTOS expresion;   

rango_lista: rango
           | rango ',' rango_lista;         

tipo_conjunto: CONJUNTO DE tipo_no_estructurado_o_nombre_tipo;

tipo_registro: REGISTRO '{' declaracion_campo_mas '}';

declaracion_campo: nombre_lista ':' tipo_no_estructurado_o_nombre_tipo ';';

declaracion_campo_mas: declaracion_campo
                     | declaracion_campo declaracion_campo_mas;                     

/*************************************/
/* constantes, variables, interfaces */
/*************************************/

declaracion_constantes: CONSTANTE declaracion_constante_mas {printf("\n   declarac_constantes -> CONSTANTE declaracion_constantes");} ;

declaracion_constante: nombre ':' tipo_no_estructurado_o_nombre_tipo '=' valor_constante ';' {printf("\n  decl_const -> nom : tipo_no_str_o_nom = valor_const"); } ; 

declaracion_constante_mas: declaracion_constante {printf("\n   decl_consts  ->  decl_const"); }
                         | declaracion_constante declaracion_constante_mas;        

valor_constante: expresion                     {printf("\n  valor_const -> expresion"); }
               | '[' valor_constante_lista ']' {printf("\n  valor_const  ->  '[' valor_consts ']'"); }
               | '[' clave_valor_lista ']'     {printf("\n  valor_const  ->  '[' clave_valores ']'"); }
               | '[' campo_valor_lista ']'     {printf("\n  valor_const  ->  '[' campo_valores ']'"); };

valor_constante_lista: valor_constante
                     | valor_constante ',' valor_constante_lista;

clave_valor_lista: clave_valor
                 | clave_valor ',' clave_valor_lista;

campo_valor_lista: campo_valor
                 | campo_valor ',' campo_valor_lista;

clave_valor: CTC_CADENA FLECHA_DOBLE valor_constante {printf("\n clave_valor -> cadena => valor_cte"); } ;

campo_valor: nombre FLECHA_DOBLE valor_constante {printf("\n campo_valor ->  nombre => valor_cte"); } ;

declaracion_variables: VARIABLE declaracion_variable_mas; 

declaracion_variable : nombre_lista ':' tipo_no_estructurado_o_nombre_tipo ';'
                     | nombre_lista ':' tipo_no_estructurado_o_nombre_tipo '=' valor_constante ';';

declaracion_variable_mas: declaracion_variable
                        | declaracion_variable declaracion_variable_mas {printf("\n declarac_var ->  declarac_var"); } ;                    

declaracion_interfaces: INTERFAZ cabecera_subprograma_mas ';' {printf("\n  declarac_interf -> INTERFAZ cabecera_subprog"); } ;

/*************************/
/* declaración de clases */
/*************************/

declaracion_clase: CLASE                             '{' declaraciones_publicas '}' {printf("clase -> decl_public");}
                 | CLASE FINAL                       '{' declaraciones_publicas '}' {printf(" clase final -> decl_public");}
                 | CLASE        '(' nombre_lista ')' '{' declaraciones_publicas '}' {printf(" clase -> nombre_lista decl_public");}
                 | CLASE FINAL  '(' nombre_lista ')' '{' declaraciones_publicas '}' {printf(" clase final -> nombre_lista decl_public");}
                 | CLASE                             '{' declaraciones_publicas declaraciones_semi '}' {printf(" clase final -> nombre_lista decl_public");}
                 | CLASE FINAL                       '{' declaraciones_publicas declaraciones_semi '}' {printf(" clase final -> decl_public decl_semi");}
                 | CLASE        '(' nombre_lista ')' '{' declaraciones_publicas declaraciones_semi '}' {printf(" clase-> nombre_lista decl_public decl_semi");}
                 | CLASE FINAL  '(' nombre_lista ')' '{' declaraciones_publicas declaraciones_semi '}' {printf(" clase final -> nombre_lista decl_public decl_semi");}
                 | CLASE                             '{' declaraciones_publicas                    declaraciones_privadas '}' {printf(" clase -> decl_public decl_privad");}
                 | CLASE FINAL                       '{' declaraciones_publicas                    declaraciones_privadas '}' {printf(" clase final -> decl_public decl_privad");}
                 | CLASE        '(' nombre_lista ')' '{' declaraciones_publicas                    declaraciones_privadas '}' {printf(" clase -> nombre_lista decl_public decl_privad");}
                 | CLASE FINAL  '(' nombre_lista ')' '{' declaraciones_publicas                    declaraciones_privadas '}' {printf(" clase final -> nombre_lista decl_public decl_privad");}
                 | CLASE                             '{' declaraciones_publicas declaraciones_semi declaraciones_privadas '}' {printf(" clase -> decl_public decl_semi decl_privad");}
                 | CLASE FINAL                       '{' declaraciones_publicas declaraciones_semi declaraciones_privadas '}' {printf(" clase final -> decl_public decl_semi decl_privad");}
                 | CLASE        '(' nombre_lista ')' '{' declaraciones_publicas declaraciones_semi declaraciones_privadas '}' {printf(" clase -> nombre_lista decl_public decl_semi decl_privad");}
                 | CLASE FINAL  '(' nombre_lista ')' '{' declaraciones_publicas declaraciones_semi declaraciones_privadas '}' {printf(" clase final -> nombre_lista decl_public decl_semi decl_privad");};

declaraciones_publicas:         declaracion_componente_mas
                      | PUBLICO declaracion_componente_mas;

declaraciones_semi: SEMIPUBLICO declaracion_componente_mas;

declaraciones_privadas: PRIVADO declaracion_componente_mas;

declaracion_componente_mas: declaracion_componente
                          | declaracion_componente declaracion_componente_mas;

declaracion_componente: declaracion_tipo_anidado
                      | declaracion_constante_anidada
                      | declaracion_atributos
                      | cabecera_subprograma ';'
                      | cabecera_subprograma ';' modificadores ';';

declaracion_tipo_anidado: TIPO declaracion_tipo;

declaracion_constante_anidada: CONSTANTE declaracion_constante;

declaracion_atributos: nombre_lista ':' tipo_no_estructurado_o_nombre_tipo ';';

modificadores: modificador_lista;

modificador_lista: modificador
                 | modificador ',' modificador_lista;

modificador: GENERICO
           | ABSTRACTO
           | ESPECIFICO
           | FINAL;

/****************/
/* subprogramas */
/****************/

declaracion_subprograma: cabecera_subprograma bloque_subprograma {printf("\n  declarac_subprograma -> cabecera_subprograma bloque_subprograma");} ;

declaracion_subprograma_mas: declaracion_subprograma {printf("\n declaracion_subprograma");}
                           | declaracion_subprograma declaracion_subprograma_mas;

cabecera_subprograma: cabecera_funcion       {printf("\n  cabecera_subprograma -> cabecera_funcion");}
                    | cabecera_procedimiento {printf("\n  cabecera_subprograma -> cabecera_procedimiento");}
                    | cabecera_constructor   {printf("\n  cabecera_subprograma -> cabecera_constructor");}
                    | cabecera_destructor    {printf("\n  cabecera_subprograma -> cabecera_destructor");};

cabecera_subprograma_mas: cabecera_subprograma {printf("\n  cabecera_subprog -> cabecera_subprog");}
                        | cabecera_subprograma_mas ';' cabecera_subprograma;                        

cabecera_funcion: FUNCION nombre FLECHA_DOBLE tipo_no_estructurado_o_nombre_tipo                        {printf("\n  cabecera_funcion -> funcion nombre => tipo_no_estruc_o_nombre"); }
                | FUNCION nombre declaracion_parametros FLECHA_DOBLE tipo_no_estructurado_o_nombre_tipo {printf("\n  cabecera_funcion -> funcion nom declaracion_paramametros => tipo_no_estruc_o_nom"); };         

cabecera_procedimiento: PROCEDIMIENTO nombre                        {printf("\n  cabecera_procedimiento -> procedimiento_nom"); }
                      | PROCEDIMIENTO nombre declaracion_parametros {printf("\n  cabecera_procedimiento -> procedimiento_nombre_declaracion_parametros"); };

cabecera_constructor: CONSTRUCTOR nombre                        {printf("\n  cabecera_constructor -> constructor_nom"); }
                    | CONSTRUCTOR nombre declaracion_parametros {printf("\n  cabecera_constructor -> constructor_nombre_declaracion_parametros"); };

cabecera_destructor: DESTRUCTOR nombre {printf("\n  cabecera_destuctor -> destructor_nombre");} ;
declaracion_parametros: '(' lista_parametros_formales ')' {printf("\n  declarac_parametro -> lista_parametro_formales");};

lista_parametros_formales: parametros_formales {printf("\n  lista_parametros_formales -> paramametros_formales");}
                         | lista_parametros_formales ';' parametros_formales;

parametros_formales: nombre_lista ':' tipo_no_estructurado_o_nombre_tipo             {printf("\n  parametros_formales -> nombre : tipo_no_estructurado_o_nombre");}
                   | nombre_lista ':' tipo_no_estructurado_o_nombre_tipo MODIFICABLE {printf("\n  parametros_formales -> nombre : tipo_no_estructurado_o_nombre_modificable");} ;       

//Tambien puedo poner bloque subprogrma
bloque_subprograma: bloque_instrucciones {printf("\n  bloque_subprograma -> bloque_instrucion");}
                  | declaracion_tipos                                              bloque_instrucciones {printf("\n  bloque_subprograma -> declaracion_tipos_bloqque_instruccion");}
                  |                   declaracion_constantes                       bloque_instrucciones {printf("\n  bloque_subprograma -> declarac_constantes_bloque_instrucion");}
                  |                                          declaracion_variables bloque_instrucciones {printf("\n  bloque_subprograma -> declaracion_variable_bloque_instrucion");}
                  | declaracion_tipos                        declaracion_variables bloque_instrucciones {printf("\n  bloque_subprograma -> decl_tip declaracion_variable_bloque_instrucion");}
                  | declaracion_tipos declaracion_constantes                       bloque_instrucciones {printf("\n  bloque_subprograma -> decl_tip declarac_constantes_bloque_instrucion");}
                  |                   declaracion_constantes declaracion_variables bloque_instrucciones {printf("\n  bloque_subprograma -> declarac_constantes_declaracion_variable_bloque_instrucion");}
                  | declaracion_tipos declaracion_constantes declaracion_variables bloque_instrucciones {printf("\n  bloque_subprograma -> declarac_tipo&declarac_const&declarac_variables&bloque_instrucciones");}

/*
bloque_subprograma: bloque_instrucciones declaracion_tipos declaracion_constantes declaracion_variables {printf("\n  bloque_subprograma -> declarac_tipo declarac_const declarac_variables bloque_instrucciones");}
                  | bloque_instrucciones declaracion_tipos declaracion_constantes                       {printf("\n  bloque_subprograma -> declarac_tip declarac_constantes_bloque_instrucion");}
                  | bloque_instrucciones declaracion_tipos                        declaracion_variables {printf("\n  bloque_subprograma -> declarac_tip declaracion_variable_bloque_instrucion");}
                  | bloque_instrucciones declaracion_tipos                                              {printf("\n  bloque_subprograma -> declaracion_tipos_bloqque_instruccion");}
                  | bloque_instrucciones                   declaracion_constantes declaracion_variables {printf("\n  bloque_subprograma -> declarac_constantes_declaracion_variable_bloque_instrucion");}
                  | bloque_instrucciones                   declaracion_constantes                       {printf("\n  bloque_subprograma -> declarac_constantes_bloque_instrucion");}
                  | bloque_instrucciones                                          declaracion_variables {printf("\n  bloque_subprograma -> declaracion_variable_bloque_instrucion");}
                  | bloque_instrucciones                                                                {printf("\n  bloque_subprograma -> bloque_instrucion");}
;          
*/


/*****************/
/* instrucciones */
/*****************/

instruccion: ';'                        { printf("\n  instruc -> ;"); }
           | instruccion_asignacion     { printf("\n  instruc -> instruc_asignac"); }
           | instruccion_salir          { printf("\n  instruc -> instruc_salir"); }
           | instruccion_devolver       { printf("\n  instruc -> instruc_devolver"); }
           | instruccion_llamada        { printf("\n  instruc -> instruc_llamada"); }
           | instruccion_si             { printf("\n  instruc -> instruc_si");}
           | instruccion_casos          { printf("\n  instruc -> instruc_casos");}
           | instruccion_bucle          { printf("\n  instruc -> instruc_bucle");}
           | instruccion_probar_excepto { printf("\n  instruc -> instruc_except");}
           | instruccion_lanzar         { printf("\n  instruc -> instruc_lanzar");};

instrucciones: instruccion               { printf("\n  instruc -> instruc");}
             | instrucciones instruccion { printf("\n  instruc -> instrucions instruc");};             

instruccion_asignacion: objeto '=' expresion ';' {printf("\n  instruc_asignac -> objeto = expresion;"); } ; 

instruccion_salir: SALIR ';'              {printf("\n  instruc_salir -> SALIR ;"); }
                 | SALIR SI expresion ';' {printf("\n  instruc_salir -> SALIR SI expresion ;"); };

instruccion_devolver: DEVOLVER ';'           {printf("\n  instruc_devolver -> DEVOLVER ;"); }
                    | DEVOLVER expresion ';' {printf("\n  instruc_devolver -> DEVOLVER expr ;"); };
      
instruccion_llamada: llamada_subprograma ';' {printf("\n  instruc_llamada -> llamada_subprograma ;"); };
llamada_subprograma: nombre '(' expresion_asterisco ')' {printf("\n  llamamada_subprg -> nombre_declarac '(' expresiones ')' "); }; 

instruccion_si: SI expresion ENTONCES bloque_instrucciones                           { printf("\n  instruc_si -> SI expr ENTONCES bloque_instruc"); }
              | SI expresion ENTONCES bloque_instrucciones SINO bloque_instrucciones { printf("\n  instruc_si -> SI expr ENTONCES bloque_instruc SINO bloque_instruc"); };

instruccion_casos: EN CASO expresion SEA casos ';' { printf("\n  instr_casos -> EN CASO expresion SEA caso"); } ;
caso: entradas FLECHA_DOBLE bloque_instrucciones { printf("\n  caso -> entradas => bloque_instruc"); };

casos: caso       { printf("\n  casos  ->  caso"); }
     | casos caso { printf("\n  casos  ->  casos caso"); };   

entradas: /* Regla vacía */
        | entradas entrada     { printf("\n  entradas  ->  entrada"); }
        | entradas entrada '|' { printf("\n  entradas  ->  entradas entrada '|' "); };

entrada: expresion { printf("\n  entrada -> expresion"); }
       | rango     { printf("\n  entrada -> rango"); }  
       | OTRO      { printf("\n  entrada -> OTRO"); };

instruccion_bucle: clausula_iteracion bloque_instrucciones { printf("\n  instruc_bucle -> clausula_iterac bloq_instruc"); } ;

clausula_iteracion: PARA            nombre EN objeto            { printf("\n  clausula_iterac -> PARA nombre_dec EN objeto"); }
                  | REPITE ELEMENTO nombre EN rango             { printf("\n  clausula_iterac -> REPITE ELEMENTO nombre_dec EN rango"); } 
                  | REPITE ELEMENTO nombre EN rango DESCENDENTE { printf("\n  clausula_iterac -> REPITE ELEMENTO nombre_dec EN rango DESCENDENTE"); }
                  | MIENTRAS        expresion                   { printf("\n  clausula_iterac -> MIENTRAS expresion"); }
                  | REPITE HASTA    expresion                   { printf("\n  clausula_iterac -> REPITE HASTA expresion"); };

instruccion_probar_excepto: PROBAR bloque_instrucciones EXCEPTO clausulas_excepciones                                 { printf("\n  instruc_probar_excepto -> PROBAR bloque_instruc EXCEPTO clausula_excepcion"); }
                          | PROBAR bloque_instrucciones EXCEPTO clausulas_excepciones FINALMENTE bloque_instrucciones { printf("\n  instruc_probar_excepto -> PROBAR bloque_instruc EXCEPTO clausula_excepcion FINALMENTE blpque_instruc"); };

clausula_excepcion: CUANDO nombre EJECUTA bloque_instrucciones  { printf("\n  clausula_excepc -> CUANDO nombre_dec EJECUTA bloque_instruc"); } ;

/* Una o más clausulas excepciones */
clausulas_excepciones: clausula_excepcion                       { printf("\n  clausula_excepciones -> clausula_excepc"); }
                     | clausulas_excepciones clausula_excepcion { printf("\n  clausula_excepciones -> clausula_excepcions claus_excepc"); };

instruccion_lanzar: LANZAR nombre ';' {printf("\n  instruc_lanzar -> LANZAR nombre_d ;"); } ;

/***************/
/* expresiones */
/***************/

/** expresiones aritméticas **/

expresiones_logicas: expresion  OR   expresion
                   | expresion  AND  expresion
                   |            '!'  expresion
                   | expresion  '<'  expresion
                   | expresion  '>'  expresion
                   | expresion  LEQ  expresion
                   | expresion  GEQ  expresion
                   | expresion  EQ   expresion
                   | expresion  NEQ  expresion;

expresiones_binarias: expresion  '@'  expresion
                   | expresion  '&'  expresion
                   | expresion DESPI expresion
                   | expresion DESPD expresion;


expresiones_aritmeticas: expresion   '+'    expresion
                       | expresion   '-'    expresion
                       | expresion   '*'    expresion
                       | expresion   '/'    expresion
                       | expresion   '%'    expresion
                       | expresion POTENCIA expresion;

expresion: expresion_primaria
         | expresiones_logicas
         | expresiones_binarias
         | expresiones_aritmeticas
         | expresion_parentesis;

/* +1 expresiones separadas por coma (1...N) */
expresiones_lista: expresion                      { printf("\n  expresion -> expresion"); }
                | expresiones_lista ',' expresion { printf("\n  expresion -> expresiones ',' expresion"); };

/* número indenifido de expresiones separadas por coma (0...N) */
expresion_asterisco: /* cadena vacía */                  { printf("\n  expresion -> "); }
                     | expresion_asterisco expresion     { printf("\n  expresion -> expresion"); }
                     | expresion_asterisco ',' expresion { printf("\n  expresion -> expresion ',' expresion"); };

expresion_parentesis: '(' expresion ')';

expresion_primaria: expresion_const     { printf("\n  expresion_primaria -> expresion_const"); }
                  | objeto              { printf("\n  expresion_primaria -> obj"); }
                  | llamada_subprograma { printf("\n  expresion_primaria -> llamada_subprograma"); };
                  //| expresion_parentesis   { printf("\n  expresion_primaria -> ( expr )"); };

expresion_const: CTC_ENTERA   { printf("\n  expresion_const -> CTC_ENTERA"); }
               | CTC_REAL     { printf("\n  expresion_const -> CTC_REAL"); }
               | CTC_CADENA   { printf("\n  expresion_const -> CTC_CADENA"); }
               | CTC_CARACTER { printf("\n  expresion_const -> CTC_CARACTER"); }
               | CTC_BOOLEANA { printf("\n  expresion_const -> CTC_BOOLEANA"); };

expresion_const_lista: expresion_const                           { printf("\n  expresion_consts -> expresion_const"); }
                     | expresion_const_lista ',' expresion_const { printf("\n  expresion_consts -> expresion_consts_lista , expresion_const"); };


objeto: nombre 
      | objeto '[' expresiones_lista ']' {printf("\n  obj -> obj '[' expresion ']'"); }
      | objeto '.' IDENTIFICADOR         {printf("\n  obj -> obj '.' IDENTIFICADOR"); };

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