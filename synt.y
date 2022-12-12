%{
    #include "parser.h"
    #include <string.h>
    int yylex();
    #define YYERROR_VERBOSE 1
    int CodeOp=0;
    extern int numligne;
    extern char *yytext;
    char type[15];
    char nomIdf[20];
%}
%union{
    int entier;
    char *str;
}
%token <str>idf mc_langage mc_var mc_start mc_end mc_function mc_return err 
%token dp vg pvg aff pl mn mul divi eg inf sup diff infeg supeg openb closeb 
%token  mc_boucle mc_cond mc_true mc_false
%token <str>mc_int <str>mc_float <str>mc_bool mc_const <entier>num
%%
s: mc_langage idf mc_var listDeclaration mc_start instructions mc_end 
{printf("syntax correct ✅\n"); YYACCEPT;}
;
listDeclaration: declaration listDeclaration 
               | declaration
;
declaration: declarationSimple 
           | declarationFonction
;
declarationSimple: listvar dp datatype pvg {if(doubleDeclaration(nomIdf)==0){insererType(nomIdf,type);}
else printf("erreur Semantique: double declation de %s, a la ligne %d\n", nomIdf, numligne);}
                 | listconst dp mc_const datatype pvg {isConst(nomIdf);if(doubleDeclaration(nomIdf)==0){
insererType(nomIdf,type);}
else printf("erreur Semantique: double declation de %s, a la ligne %d\n", nomIdf, numligne);}
                | listvar dp mc_const datatype pvg {if(doubleDeclaration(nomIdf)==0){insererType(nomIdf,type);}
else printf("erreur Semantique: double declation de %s, a la ligne %d\n", nomIdf, numligne);}
;
listvar: idf vg listvar 
       | idf {strcpy(nomIdf,$1);}
;
listconst: idf aff num vg listconst {initconst($1);}
         | idf aff num {initconst($1); strcpy(nomIdf,$1);}
;
datatype: mc_int {strcpy(type,$1);}
        | mc_float {strcpy(type,$1);}
        | mc_bool {strcpy(type,$1);}
;
instructions : instruction instructions 
             | instruction
;
instruction: idf aff op pvg {if(checkconst($1)== 1) printf("⚠️  Erreur semantique : Changement de valeur de la constante %s a la ligne %d\n",$1,numligne);}
           | boucle
           | condition
;
op: idf math op
  | num math op
  | idf
  | bool
  | num {if(($1 == 0) && (CodeOp == 4)) printf("⚠️  Erreur semantique: division sur 0 a la ligne %d\n", numligne);}
;
math: pl {CodeOp=1;}
    | mn {CodeOp=2;}
    | mul {CodeOp=3;}
    | divi {CodeOp=4;}
;
bool: mc_true
    | mc_false
;
boucle: mc_boucle openb compare closeb mc_start instructions mc_end
;
condition: mc_cond openb compare closeb mc_start instructions mc_end
;
compare: idf opRelationnels idf 
       | idf opRelationnels num
;
opRelationnels: eg 
              | inf 
              | sup 
              | diff 
              | infeg 
              | supeg
;
declarationFonction: datatype mc_function idf mc_var listDeclaration mc_start instructions return mc_end
;
return: mc_return idf pvg
;
