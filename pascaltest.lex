
%{
	/* Code C */
int outputLexical = 1;	// flag qui permet d'afficher(1)/masquer(0) les messages de l'analyseur lexicale, par défaut (1)
	/* fonction qui affiche un message passé en paramétre */
void output(char* msg) {
	if(outputLexical == 1) {
		printf("Analyseur lexicale: %s\n", msg);
	}
}
	/* chaine de caractéres utilisé avec la fonction output() */
char buffer[50];

#include "pascaltest.tab.h"

%}



%option yylineno

chiffre   [0-9]
lettre    [a-zA-Z]
id        {lettre}({lettre}|{chiffre})*
oprel    ==|<>|<|>|<=|>=|not
opadd    \+|-|or
opmul    \*|\/|div|mod|and
chaine	 \'[^\']*\'
commentaire "{"[^{}]*"}"
blanc			[ \t\n]+
iderror  {chiffre}({lettre}|{chiffre})*
oppaffect  :=
nb        ("-")?{chiffre}+("."{chiffre}+)?(("E"|"e")"-"?{chiffre}+)?
ouvrante  (\()
fermante  (\))
COMMENT_LINE        "//"
NOM_FONCTION  {id}/{blanc}*{ouvrante}[^{}]*{fermante}
%%
"\n" 														    ++yylineno;
"write"															{output(" Keyword :write");}
"read"	                                                        {output(" Keyword :read");}
"writeln"														{output(" Keyword :writeln");}
"readln"	                                                    {output(" Keyword :readln" );}
[bB][eE][gG][iI][nN]    										{output(" Keyword : begin");	 return BEGIN_TOKEN;	}
[dD][oO]			    										{output(" keyword : do "); 	 return DO;	    }
[iI][fF]														{output(" keyword : if ");	 return IF; 	}
[eE][lL][sS][eE]												{output(" keyword : else ");	 return  ELSE;	}
[eE][nN][dD]													{output(" keyword : end ");	 return  END;	}
[fF][uU][nN][cC][tT][iI][oO][nN]								{output(" keyword : function "); return  FUNCTION;}
[iT][nN][tT]													{output(" keyword : int ");		return  INT;}
[pP][rR][oO][cC][eE][dD][uU][rR][eE]							{output(" keyword : procedure ");	return  PROCEDURE;}
[pP][rR][oO][gG][rR][aA][mM]									{output(" keyword : Program ");	return  PROGRAM;}
[tT][hH][eE][nN]												{output(" keyword : this ");		return  THEN;}
[vV][aA][rR]													{output(" keyword : var ");		return  VAR;}
[wW][hH][iI][lL][eE]											{output(" keyword : while ");		return  WHILE;}
[nN][oO][tT]													{output(" keyword : not ");		return  NOT ;}
{id}															{sprintf(buffer, "ID: %s (%d caractere(s))", yytext, yyleng);
																output(buffer);
																return ID;}
{nb}                                                            {	
																	sprintf(buffer, "NB: %s (%d caractere(s))", yytext, yyleng);
																	output(buffer);
																	return NB;	}
{blanc}									{
											/* les caractéres blancs sont à ignorer, on ne retourne rien */
										}

{oprel} 														{
																	sprintf(buffer, " OPREL: %s (%d caractere(s))", yytext, yyleng);
																	output(buffer);
																	return OPREL;	}
{opadd}        													{
																		sprintf(buffer, "OPADD: %s (%d caractere(s))", yytext, yyleng);
																		output(buffer);
																		return OPADD;}
{opmul} 														{
																		sprintf(buffer, "ÖPMULL: %s (%d caractere(s))", yytext, yyleng);
																		output(buffer);
																		return OPMUL;}
{oppaffect}														{
																	sprintf(buffer, "OPAFFECT: %s (%d caractere(s))", yytext, yyleng);
																	output(buffer);
																	return OPAFFECT;}
{ouvrante}                                                     	{
																	sprintf(buffer, "OUVERTE: %s (%d caractere(s))", yytext, yyleng);
																	output(buffer);
																	return OUVERTE;}
{fermante}                                                     	{
																    sprintf(buffer, "FERMANTE: %s (%d caractere(s))", yytext, yyleng);
																	output(buffer);
																	return FERMANTE;}
{chaine}															{
																    	sprintf(buffer, "CHAINE: %s (%d caractere(s))", yytext, yyleng);
																		output(buffer);
																		return CHAINE;}
{iderror}              											{return(stderr,"illegal identifier \'%s\' on line :%d\n",yytext,yylineno);}
. 																{
																	sprintf(buffer, "AUTRE: %s (%d caractere(s))", yytext, yyleng);
																	output(buffer);
																	return *yytext;	}



%%
int yywrap()
{
	return 1;
}
