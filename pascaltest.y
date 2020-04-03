%{

		#include <stdio.h>
		#include <stdlib.h>
		int yylex(void);
		void yyerror(char const *msg);	
		extern int yylineno;

		int outputSyntaxique = 1;
		void output_syn(const char* msg) {
			if(outputSyntaxique == 1) {
				printf("Analyseur syntaxique: %s\n", msg);
	}
}

%}

%debug


		%start programme

		%token ID
		%token NB
		%token OPADD
		%token OPAFFECT
		%token OPMUL
		%token OPREL


		/* Mots clés */

		%token BEGIN_TOKEN
		%token DO
		%token ELSE
		%token END
		%token FUNCTION
		%token IF
		%token NOT
		%token PROCEDURE
		%token PROGRAM
		%token THEN
		%token VAR
		%token WHILE
		%token INT

		%token CHAINE
		%token OUVERTE
		%token FERMANTE
		%token POINT_VIRGULE
		%token DEUX_POINTS
		%token POINT
		%token VIRGULE

		%token WRITE
		%token READ
		%token WRITELN
		%token READLN
		%token COMMERR
		%token COMMERRO
		%token COMMERRON


		%error-verbose

		%%

		programme:
			PROGRAM  ID POINT_VIRGULE declaration instruction_composee POINT		{output_syn("fin du programme :) ");}
		|	PROGRAM  error POINT_VIRGULE declaration instruction_composee POINT		{yyerror(" Nom du programme invalide");}
		|	PROGRAM  ID error declaration instruction_composee POINT		{yyerror(" point virgule manquant");}
		;

		declaration:
			declaration_var declarations_sous_programmes
		;
		declaration_var:
			declaration_var VAR liste_identificateurs DEUX_POINTS INT POINT_VIRGULE
		|	/* chaine vide */
		|	declaration_var VAR liste_identificateurs DEUX_POINTS error  {	yyerror("  mot cle 'int' introuvable !!") ; }
		|   declaration_var VAR liste_identificateurs error INT  {	yyerror("  declaration ':' invalide !!") ; }
		;

		liste_identificateurs:
			ID
		|	liste_identificateurs VIRGULE ID
		|   liste_identificateurs error ID { yyerror("  identificateurs invalides ! ") ; }
		;

		declarations_sous_programmes:
			declarations_sous_programmes declarations_sous_programme POINT_VIRGULE
		|	/* chaine vide */
		;

		declarations_sous_programme:
			entete_sous_programme declaration instruction_composee
		;
		entete_sous_programme:
			FUNCTION ID arguments DEUX_POINTS INT POINT_VIRGULE
		|   PROCEDURE ID arguments POINT_VIRGULE
		|   FUNCTION error arguments DEUX_POINTS INT POINT_VIRGULE {		 yyerror(" identifiant invalide ! ") ;	    }
		|   FUNCTION ID arguments error INT POINT_VIRGULE  { 		 yyerror(" declaration invalide ! ") ; 		}
		|   FUNCTION ID arguments DEUX_POINTS error POINT_VIRGULE  {		 yyerror("  mot cle 'int' introuvable !!") ; }
|       |   PROCEDURE error arguments {		 yyerror(" identifiant invalide ! ") ;	    }

		;
		arguments:
		 	 OUVERTE liste_parametres FERMANTE
		 |  /* chaine vide */
		 |    error liste_parametres FERMANTE  {		 yyerror(" paranthese ouvrante manquante ! ") ;	    }
		 |    OUVERTE liste_parametres error  {		 yyerror(" paranthese fermante manquante ! ") ;	    }
		;
		liste_parametres:
			parametre
		|	liste_parametres POINT_VIRGULE parametre
		;
		parametre:
			ID DEUX_POINTS INT
		|	VAR ID DEUX_POINTS INT
		;
		instruction_composee:
			BEGIN_TOKEN instruction_operationnelles END
		;
		instruction_operationnelles:
			liste_instructions
		| /* chaine vide */
		;
		liste_instructions:
			instruction POINT_VIRGULE
		|	liste_instructions  instruction POINT_VIRGULE
		|  	instruction error {	yyerror ("  point virgule  d'instruction manquant :( ") ;}
		;
		instruction:
			appel_de_procedure
		|	instruction_composee
		| 	IF expression THEN instruction ELSE instruction
		|	WHILE expression DO instruction
		|	WRITELN OUVERTE liste_expressions FERMANTE
		|	WRITE OUVERTE liste_expressions FERMANTE
		|	READ OUVERTE liste_expressions FERMANTE
		|	READLN OUVERTE liste_expressions FERMANTE
		;
		variable:
			ID
		;
		appel_de_procedure:
				ID
		|		ID OUVERTE liste_expressions FERMANTE
		;
		liste_expressions :
			expression
		|	liste_expressions VIRGULE expression
		;
		expression:
			expression_simple
		|	expression_simple OPREL expression_simple
		;
		expression_simple:
			terme
		|	signe terme
		|   expression_simple OPADD terme
		;
		terme:
			facteur
		|	terme OPMUL facteur
		;
		facteur:
		|	ID OUVERTE liste_expressions FERMANTE
		|	NB
		|	OUVERTE expression FERMANTE
		| 	NOT facteur
		| 	CHAINE
		;
		signe:
			'+'
		|	'-'
		;
		%%
		void yyerror(char const *s) {
			extern int yylieneno;
			char str [100];
			sprintf(str, "Erreur [ligne n %d] : %s\n", yylineno,s);
			printf(str);

		}
		extern FILE *yyin;
		int main()
		{
		 yyparse();
		 return 0;
		}
