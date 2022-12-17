%{
    #include "parser.h"
    #include <string.h>
    int yylex();
    #define YYERROR_VERBOSE 1
    int CodeOp=0;
    extern int numligne;
    extern char *yytext;
    char type[6];
    char nomIdf[20];
    char currScope[30] = "Main";
%}
%union{
    int entier;
    float reel;
    char *str;
}
%token <str>idf mc_var mc_start mc_end mc_return err mc_langage mc_func
%token dp vg pvg aff pl mn mul divi eg inf sup diff infeg supeg openb closeb 
%token  mc_boucle mc_cond mc_true mc_false
%token <str>mc_int <str>mc_float <str>mc_bool mc_const <entier>numint <reel>numflt
%%
s: mc_langage idf mc_var listDeclaration mc_start instructions mc_end 
{printf("\n✅✅✅  Syntax correct\n"); YYACCEPT;}
;
listDeclaration: declaration listDeclaration 
               | declaration
;
declaration: declarationSimple 
           | declarationFonction
;
declarationSimple: listvar dp datatype pvg {doubleDeclarationlistIDF(type);}
                 | listconst dp mc_const datatype pvg {doubleDeclarationlistIDFConst(type);} 
                | listvar dp mc_const datatype pvg {doubleDeclarationlistIDFConst(type);} 
;
listvar: idf vg listvar {sauveIDF($1);}
       | idf {sauveIDF($1);}
;
listconst: idf aff num vg listconst {sauveIDF($1); initconst($1); strcpy(nomIdf,$1);}
         | idf aff num {sauveIDF($1); initconst($1); strcpy(nomIdf,$1);}
;
datatype: mc_int {strcpy(type,$1);}
        | mc_float {strcpy(type,$1);}
        | mc_bool {strcpy(type,$1);}
;
instructions : instruction instructions 
             | instruction
;
instruction: idf aff op pvg {check_declaration($1); if(checkconst($1)== 1) printf("⚠️ ⚠️ ⚠️  Erreur semantique : Changement de valeur de la constante \"%s\" a la ligne %d\n",$1,numligne);
if (checkconstintit($1) == 1) initconst($1);}
           | boucle
           | condition
;
op: idf math op
  | num math op
  | idf
  | bool
  | num 
;
math: pl {CodeOp=1;}
    | mn {CodeOp=2;}
    | mul {CodeOp=3;}
    | divi {CodeOp=4;}
;
num: numint {if(($1 == 0) && (CodeOp == 4)) printf("⚠️ ⚠️ ⚠️  Erreur semantique: division sur 0 a la ligne %d\n", numligne);}
   | numflt {if(($1 == 0) && (CodeOp == 4)) printf("⚠️ ⚠️ ⚠️  Erreur semantique: division sur 0 a la ligne %d\n", numligne);}
;
bool: mc_true
    | mc_false
;
boucle: mc_boucle openb cond closeb mc_start instructions mc_end
;
condition: mc_cond openb cond closeb mc_start instructions mc_end
;
cond: idf opRelationnels idf {check_declaration($1); check_declaration($3);}
       | idf opRelationnels num {check_declaration($1);}
       | num opRelationnels num;
;
opRelationnels: eg 
              | inf 
              | sup 
              | diff 
              | infeg 
              | supeg
;
declarationFonction: datatype mc_func idf {strcpy(currScope,$3);} mc_var listDeclaration mc_start instructions return mc_end{strcpy(currScope,"Main");}
;
return: mc_return idf pvg {check_declaration($2);}
      | mc_return num pvg
;
