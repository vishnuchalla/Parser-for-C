%token INT FLOAT CHAR DOUBLE VOID
%token FOR WHILE 
%token IF ELSE PRINTF 
%token STRUCT 
%token NUM ID
%token INCLUDE
%token DOT

%right '='
%left AND OR
%left '<' '>' LE GE EQ NE LT GT

%{
#include <stdio.h>
#include <stdlib.h>
extern FILE *fp;

%}

%%

start:	Function 
	| Declaration
	;

/* Declaration block */
Declaration: Type Assignment ';' 
        | StructStmt ';'
	| Assignment ';'  	
	| FunctionCall ';' 	
	| ArrayUsage ';'	
	| Type ArrayUsage ';'  	
	| error	
	;

/* Assignment block */
Assignment: ID '=' Assignment
	| ID '=' FunctionCall
	| ID '=' ArrayUsage
	| ArrayUsage '=' Assignment
	| ID ',' Assignment
	| NUM ',' Assignment
	| ID '+' Assignment
	| ID '-' Assignment
	| ID '*' Assignment
	| ID '/' Assignment	
	| NUM '+' Assignment
	| NUM '-' Assignment
	| NUM '*' Assignment
	| NUM '/' Assignment
        | NUM '%' Assignment
        | ID '%' Assignment
        | ID '>' '=' Assignment
        | ID '<' '=' Assignment
        | NUM '^' Assignment
	| '\'' Assignment '\''	
	| '(' Assignment ')'
	| '-' '(' Assignment ')'
	| '-' NUM
	| '-' ID
        | '+' '+' ID
        | ID '+' '+'
        | '-' '-' ID
        | ID '-' '-'
	|   NUM
	|   ID
	;

/* Struct Statement */
StructStmt : STRUCT ID '{' Type Assignment '}' ';'
	;

/* Function Call Block */
FunctionCall : ID'('')'
	| ID'('Assignment')'
	;

/* Array Usage */
ArrayUsage : ID'['Assignment']'
	;

/* Function block */
Function: Type ID '(' ArgListOpt ')' CompoundStmt 
	;
ArgListOpt: ArgList
	|
	;
ArgList:  ArgList ',' Arg
	| Arg
	;
Arg:	Type ID
	;
CompoundStmt:	'{' StmtList '}'
	;
StmtList:	StmtList Stmt
	|
	;
Stmt:	WhileStmt
	| Declaration
	| ForStmt
	| IfStmt
        | elStmt
	| PrintFunc
	| ';'
	;

/* Type Identifier block */
Type:	INT 
	| FLOAT
	| CHAR
	| DOUBLE
	| VOID 
        | CHAR '*'
        | FLOAT '*'
        | INT '*'
        | DOUBLE '*'
        | VOID '*'
	;

/* Loop Blocks */ 
WhileStmt: WHILE '(' Expr ')' Stmt  
	| WHILE '(' Expr ')' CompoundStmt 
	;

/* For Block */
ForStmt: FOR '(' Expr ';' Expr ';' Expr ')' Stmt 
       | FOR '(' Expr ';' Expr ';' Expr ')' CompoundStmt 
       | FOR '(' Expr ')' Stmt 
       | FOR '(' Expr ')' CompoundStmt 
	;

/* IfStmt Block */
IfStmt : IF '(' Expr ')' 
	 	Stmt 
       | IF '(' Expr ')'
                CompoundStmt
	;
elStmt : ELSE 
         Stmt
       ;

/* Print Function */
PrintFunc : PRINTF '(' Expr ')' ';'
	;

/*Expression Block*/
Expr:	
	| Expr LE Expr 
	| Expr GE Expr
	| Expr NE Expr
	| Expr EQ Expr
	| Expr GT Expr
	| Expr LT Expr
	| Assignment
	| ArrayUsage
	;
%%
#include <ctype.h>
#include "lex.yy.c"
int count=0;
int sml=1;
int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	
        if(!yyparse())
                {char *smiley = "\xE2\x98\xBB";   // "smiley face"
                printf("%s", smiley);
		printf(" Parsing complete\n");}
	else{
                char *smiley = "\xE2\x98\xB9";   // "pouting face"
                printf("%s", smiley);
		printf(" Parsing failed\n");
	    }
	fclose(yyin);
    return 0;
}
         
void yyerror(char *s) {
        char *smiley = "\xE2\x98\xB9";   // "pouting face"
        printf("%s", smiley);
	printf(" %d : %s %s\n", yylineno, s, yytext );
}         

