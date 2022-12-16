#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <time.h>
#include "synt.tab.h"

extern int numligne;
extern char *yytext;
extern FILE *yyin;
extern char type[15];
extern char nomIdf[20];
clock_t start, end;
double cpu_time_used;

typedef struct
{
    char NomEntite[20];
    char CodeEntite[20];
    char TypeEntite[20];
    bool CONST;
    char init[20];
} TypeTS;

void yyerror();
void insert(char nom[], char code[]);
void print();
int recherche(char entite[]);
int doubleDeclaration(char entite[]);
void insererType(char entite[], char type[]);
void isConst(char entite[]);
int checkconst(char entite[]);
void initconst(char entite[]);
void sauveIDF(char idf[]);
void doubleDeclarationlistIDF(char type[]);
void check_declaration(char C[]);
int editlines(char c[], int size);
void doubleDeclarationlistIDFConst(char type[]);

TypeTS ts[100];
int CpTabSym = 0;
char listIDF[20][80];

int main(int argc, char const *argv[])
{
    if (argc > 1)
    {
        yyin = fopen(argv[1], "r");
    }
    start = clock();
    printf("Compilation ......\n");
    yyparse();
    print();
    end = clock();
    cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("Took %.4f seconds to execute \n", cpu_time_used);
}

void print()
{
    printf("\n/****************** Table de symboles ******************/\n");
    printf("_______________________________________________________________________\n");
    printf("|  ##  |   NomEntite  |   CodeEntite |   Type  | Constatnt |   Init   |\n");
    int i = 1;
    while (i < CpTabSym)
    {
        printf("|%4d  |%12s  |%8s      |%7s  |%7s    |%7s   |\n", i, ts[i].NomEntite, ts[i].CodeEntite, ts[i].TypeEntite, ts[i].CONST ? "-> Oui" : "", ts[i].init);
        i++;
    }
    printf("▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔");
    printf("\n/*******************************************************/\n");
}

void insert(char nom[], char code[])
{
    if (recherche(nom) == -1)
    {
        strcpy(ts[CpTabSym].NomEntite, nom);
        strcpy(ts[CpTabSym].CodeEntite, code);
        CpTabSym++;
    }
}

int recherche(char entite[])
{
    int i = 0;
    while (i < CpTabSym)
    {
        if (strcmp(entite, ts[i].NomEntite) == 0)
        {
            return i;
        }

        i++;
    }
    return -1;
}

void insererType(char entite[], char type[])
{
    int posEntite = recherche(entite);
    if (posEntite != -1)
    {
        strcpy(ts[posEntite].TypeEntite, type);
    }
}

int doubleDeclaration(char entite[])
{
    int posEntite = recherche(entite);
    if (strcmp(ts[posEntite].TypeEntite, "") == 0)
        return 0;
    else
        return 1;
}


int checkconst(char entite[])
{
    int posEntite = recherche(entite);
    if (ts[posEntite].CONST == true && strcmp(ts[posEntite].init, "-> oui") == 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

void initconst(char entite[])
{
    int posEntite = recherche(entite);
    strcpy(ts[posEntite].init, "-> oui");
}

int idfcount = 0;
void sauveIDF(char idf[])
{
    strcpy(listIDF[idfcount], idf);
    idfcount++;
}

void doubleDeclarationlistIDF(char type[])
{
    int i;
    int posEntite;
    for (i = 0; i < idfcount; i++)
    {
        posEntite = recherche(listIDF[i]);

        if (strcmp(ts[posEntite].TypeEntite, "") == 0)
        {
            insererType(listIDF[i], type);
        }
        else
        {
            printf("⚠️ ⚠️ ⚠️  Erreur semantique: double declaration de la variable \"%s\" a la ligne %d\n", listIDF[i], numligne);
        }
    }

    for (i = 0; i < idfcount; i++)
    {
        strcpy(listIDF[i], "");
    }
    idfcount = 0;
}









void isConst(char entite[])
{
    int posEntite = recherche(entite);
    ts[posEntite].CONST = true;
}

void doubleDeclarationlistIDFConst(char type[])
{
    int i;
    int posEntite;
    for (i = 0; i < idfcount; i++)
    {
        posEntite = recherche(listIDF[i]);

        if (strcmp(ts[posEntite].TypeEntite, "") == 0)
        {
            insererType(listIDF[i], type);
            isConst(ts[posEntite].NomEntite);
        }
        else
        {
            printf("⚠️ ⚠️ ⚠️  Erreur semantique: double declaration de la variable \"%s\" a la ligne %d\n", listIDF[i], numligne);
        }
    }

    for (i = 0; i < idfcount; i++)
    {
        strcpy(listIDF[i], "");
    }
    idfcount = 0;
}
































void check_declaration(char c[])
{
    int trouv = recherche(c);
    if (strcmp(ts[trouv].TypeEntite, "") == 0)
    {
        printf("⚠️  Errreur semantique a la ligne %d : \"%s\" ==> non déclaré\n", numligne, c);
    }
}
int editlines(char c[], int size)
{
    int count = 0;
    for (int i = 0; i < size; i++)
    {
        if (c[i] == '\n')
        {
            count++;
        }
    }
    return count;
}
void yyerror()
{
    printf("⚠️  Errreur syntaxique a la ligne %d : \"%s\"\n", numligne, yytext);
}
