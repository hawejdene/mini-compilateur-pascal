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
 

		%error-verbose

		%%

		programme:
			PROGRAM  ID ';' declaration instruction_composee '.'		{output_syn("fin du programme :) ");}
		|	PROGRAM  ID error {		yyerror ("  point virgule  manquant ! ") ; }
		|   PROGRAM  error ';' {	yyerror (" Nom du programme invalide ! ") ; }
		|    PROGRAM  ID ';' declaration instruction_composee error		{output_syn("point manquant ");}
		;

		declaration:
			declaration_var declarations_sous_programmes
		;
		declaration_var:
			declaration_var VAR liste_identificateurs ':' INT ';'
		|	/* chaine vide */
		|	declaration_var VAR liste_identificateurs ':' error  {	yyerror("  mot cle 'int' introuvable !!") ; }
		|   declaration_var VAR liste_identificateurs error INT  {	yyerror("  declaration ':' invalide !!") ; }
		;

		liste_identificateurs:
			ID
		|	liste_identificateurs ',' ID
		|   liste_identificateurs error ID { yyerror("  identificateurs invalides ! ") ; }
		;

		declarations_sous_programmes:
			declarations_sous_programmes declarations_sous_programme ';'
		|	/* chaine vide */
		|   declarations_sous_programmes declarations_sous_programme error  { yyerror("  point virgule manquant ! ") ; }
		;

		declarations_sous_programme:
			entete_sous_programme declaration instruction_composee
		;
		entete_sous_programme:
			FUNCTION ID arguments ':' INT ';'
		|   PROCEDURE ID arguments ';'
		|   FUNCTION error arguments ':' INT ';' {		 yyerror(" identifiant invalide ! ") ;	    }
		|   FUNCTION ID arguments error INT ';'  { 		 yyerror(" declaration invalide ! ") ; 		}
		|   FUNCTION ID arguments ':' error ';'  {		 yyerror("  mot cle 'int' introuvable !!") ; }
		|   FUNCTION ID arguments ':' INT error  {		 yyerror ("  point virgule  manquant ! ") ; }
|       |   PROCEDURE error arguments {		 yyerror(" identifiant invalide ! ") ;	    }
		|   PROCEDURE ID arguments  {		 yyerror ("  point virgule  manquant ! ") ; }

		;
		arguments:
		 	 OUVERTE liste_parametres FERMANTE 
		 |  /* chaine vide */
		 |    error liste_parametres FERMANTE  {		 yyerror(" paranthese ouvrante manquante ! ") ;	    }
		 |    OUVERTE liste_parametres error  {		 yyerror(" paranthese fermante manquante ! ") ;	    }
		;
		liste_parametres:
			parametre
		|	liste_parametres ';' parametre
		;
		parametre:
			ID ':' INT
		|	VAR ID ':' INT
		;
		instruction_composee:
			BEGIN_TOKEN instruction_operationnelles END
		;
		instruction_operationnelles:
			liste_instructions
		| /* chaine vide */
		;
		liste_instructions:
			instruction ';'
		|	liste_instructions  instruction ';'
		|  	instruction error {	yyerror ("  point virgule  d'instruction manquant :( ") ;}
		;
		instruction:
			appel_de_procedure
		|	instruction_composee
		| 	IF expression THEN instruction ELSE instruction
		|	WHILE expression DO instruction
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
		|	liste_expressions ',' expression
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
			ID
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
			sprintf(str, "Erreur (ligne n %d) : %s\n", yylineno,s);
			printf(str);

		}
		extern FILE *yyin;
		int main()
		{
		 yyparse();
		 return 0;
		}
