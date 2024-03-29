#ifndef PARSER_H
#define PARSER_H
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

extern int numligne;
extern char *yytext;
extern FILE *yyin;

typedef struct element
{
    char NomEntier[20];
    char CodeEntier[20];
    bool yess;
} element;

void yyerror();
void insert(char nom[], char code[]);
void print();
int recherche(char entite[]);
void insererType(char entite[], char type[], char scope[]);
void isConst(char entite[]);
int checkconst(char entite[]);
int checkconstintit(char entite[]);
void initconst(char entite[]);
void sauveIDF(char idf[]);
void doubleDeclarationlistIDF(char type[]);
void check_declaration(char C[]);
int editlines(char c[],int size);
void doubleDeclarationlistIDFConst(char type[]);

#endif