%option noyywrap

%{



#include "SymTab.h"

SymbolTable s(6);
int line_count=1;

FILE *logout;
FILE *tokenout;


%}

WHITESPACE [ \t\f\r\v]+
NEWLINE \n
LETTER [a-zA-Z]
LETTERORUNDERSCORE [a-zA-Z_]
DIGIT [0-9]
DIGITS {DIGIT}+
INTEGER {DIGITS}
FLOATING_POINT {DIGITS}*(\.{DIGITS})(E[+-]?{DIGITS})?
ID {LETTERORUNDERSCORE}({LETTERORUNDERSCORE}|{DIGIT})*
CHAR [ -~]
CHARS {CHAR}+
CHARACTER ('({CHAR})')
SPECIAL_CHAR '\\[tvar"fb0n]'|'\\\\'
STRING \"([^\"\n]|\\{NEWLINE})*\"


%%


{NEWLINE} {line_count++;}

"if"		{	fprintf(tokenout,"<IF>");		fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);}
"else"		{	fprintf(tokenout,"<ELSE>");		fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);}
"for"		{	fprintf(tokenout,"<FOR>");		fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);}
"while"		{	fprintf(tokenout,"<WHILE>");	fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n",line_count,yytext);}
"do"		{	fprintf(tokenout,"<DO>");		fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);}
"break"		{	fprintf(tokenout,"<BREAK>");	fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n",line_count,yytext);}
"int"		{	fprintf(tokenout,"<INT>");		fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);}
"char"		{	fprintf(tokenout,"<CHAR>");		fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);}
"float"		{	fprintf(tokenout,"<FLOAT>");	fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);}
"double"	{	fprintf(tokenout,"<DOUBLE>");	fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);}
"void"		{	fprintf(tokenout,"<VOID>");		fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);}
"return"	{	fprintf(tokenout,"<RETURN>");	fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n",line_count,yytext);}
"switch"	{	fprintf(tokenout,"<SWITCH>");	fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);}
"case"		{	fprintf(tokenout,"<CASE>");		fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);}
"default"	{	fprintf(tokenout,"<DEFAULT>");	fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);}
"continue"	{	fprintf(tokenout,"<CONTINUE>");	fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n",line_count,yytext);}

{ID}		{
				fprintf(tokenout,"<ID, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);
				s.Insert(string(yytext),"ID");
			}

"++"|"--"	{
				fprintf(tokenout,"<INCOP, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.Insert(string(yytext),"INCOP");
			}

"+"|"-"		{
				fprintf(tokenout,"<ADDOP, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				// There is a '|' in "+"'s rule, this means match execute the action for following rule
				s.Insert(string(yytext),"ADDOP");
			}

"*"|"/"|"%" {
				fprintf(tokenout,"<MULOP, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"MULOP");
				s.Insert(string(yytext),"MULOP");
			}

"<"|"<="|">"|">="|"=="|"!=" 	{
				fprintf(tokenout,"<RELOP, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"RELOP");
				s.Insert(string(yytext),"RELOP");
			}

"="		 	{
				fprintf(tokenout,"<ASSIGNOP, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"ASSIGNOP");
				s.Insert(string(yytext),"ASSIGNOP");
			}

"&&"|"||"	{
				fprintf(tokenout,"<LOGICOP, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"LOGICOP");
				s.Insert(string(yytext),"LOGICOP");
			}

"&"|"|"|"<<"|">>"|"^"	{
				fprintf(tokenout,"<BITOP, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <BITOP> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"BITOP");
				s.Insert(string(yytext),"BITOP");
			}

"!"			{
				fprintf(tokenout,"<NOT, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <NOT> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"NOT");
				s.Insert(string(yytext),"NOT");
			}

"("			{
				fprintf(tokenout,"<LPAREN, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"LPAREN");
				s.Insert(string(yytext),"LPAREN");
			}

")"			{
				fprintf(tokenout,"<RPAREN, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"RPAREN");
				s.Insert(string(yytext),"RPAREN");
			}

"{"			{
				fprintf(tokenout,"<LCURL, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"LCURL");
				s.Insert(string(yytext),"LCURL");
			}

"}"			{
				fprintf(tokenout,"<RCURL, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <RCURL> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"RCURL");
				s.Insert(string(yytext),"RCURL");
			}

"["			{
				fprintf(tokenout,"<LTHIRD, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"LTHIRD");
				s.Insert(string(yytext),"LTHIRD");
			}

"]"			{
				fprintf(tokenout,"<RTHIRD, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <RTHIRD> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"RTHIRD");
				s.Insert(string(yytext),"RTHIRD");
			}

","			{
				fprintf(tokenout,"<COMMA, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"COMMA");
				s.Insert(string(yytext),"COMMA");
			}

";"			{
				fprintf(tokenout,"<SEMICOLON, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"SEMICOLON");
				s.Insert(string(yytext),"SEMICOLON");
			}

{INTEGER} 	{
				fprintf(tokenout,"<CONST_INT, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"CONST_INT");
				s.Insert(string(yytext),"CONST_INT");
			}
			
{FLOATING_POINT} 	{
				fprintf(tokenout,"<CONST_FLOAT, %s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"CONST_FLOAT");
				s.Insert(string(yytext),"CONST_FLOAT");
			}

{CHARACTER}		{
				string str = string(yytext);
    			string subs;
    			subs = str.substr(1,1);
				fprintf(tokenout,"<CONST_CHAR, %s>",subs.data());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,subs.data());
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(subs,"CONST_CHAR");
				s.Insert(subs,"CONST_CHAR");
			}

{STRING}		{
				string str = string(yytext);
    			string subs;
    			subs = str.substr(1,str.size()-2);
    			subs = makeOne(subs,1,&line_count)
				fprintf(tokenout,"<STRING, %s>",subs.data());
				fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",line_count,subs.data());
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(subs,"STRING");
				s.Insert(subs,"STRING");
			}


%%


int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("1505047_log.txt","w");
	tokenout= fopen("1505047_token.txt","w");

	yyin= fin;
	yylex();
	s.PrintAll();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
