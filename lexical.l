%{
    #include "synt.tab.h"
    #include "parser.h"
    #include <stdio.h>
    int numligne =1;
    extern YYSTYPE yylval;
%}
%option noyywrap
%option yylineno

lettre [a-zA-Z]
chiffre [0-9]
numint [-]?{chiffre}+               
numflt [-]?{chiffre}+(.{chiffre}+)?
idf {lettre}({lettre}|{chiffre}|"_"{lettre}|{chiffre})* 
cmnt \{([^}])*\}
%%
LANGAGE return mc_langage;
Function return mc_func;
VAR return mc_var;
BEGIN return mc_start;
END return mc_end;
INT {yylval.str = strdup(yytext); return mc_int;}
FLOAT {yylval.str = strdup(yytext); return mc_float;}
BOOL {yylval.str = strdup(yytext); return mc_bool;}
CONST {yylval.str = strdup(yytext); return mc_const;}
Return return mc_return;
While return mc_boucle;
If return mc_cond;
True return mc_true;
False return mc_false;
{numint} {yylval.entier=atoi(yytext); return numint;}
{numflt} {yylval.reel=atof(yytext); return numflt;}
{idf} {if (yyleng <=12) {yylval.str = strdup(yytext);insert(yytext,"idf"); return idf;}
else printf("Erreur lexicale : \"%s\" trop longue\nLongueur maximale : 12 Caractere\n",yytext); return err;};
{cmnt} {numligne += editlines(yytext,yyleng);}
: return dp;
; return pvg;
, return vg;
= return aff;
"+" return pl;
"-" return mn;
"*" return mul;
"/" return divi;
"<" return inf;
">" return sup;
"<=" return infeg;
"<>" return diff; 
">=" return supeg;  
"==" return eg;
"(" return openb;
")" return closeb;
[ \t] 
\n numligne++;
. {printf(" ❌❌❌ Erreur lexicale a la ligne : %d : \"%s\" \n",numligne,yytext); return err;}

