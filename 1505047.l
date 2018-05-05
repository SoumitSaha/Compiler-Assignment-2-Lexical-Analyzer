%option noyywrap

%{


FILE *logout;
FILE *tokenout;

#include "SymTab.h"

SymbolTable s(15);
int line_count=1;
int err_count = 0;


%}

WHITESPACE [ \t\f\r\v]+
NEWLINE \n
LETTER [a-zA-Z]
LETTERORUNDERSCORE [a-zA-Z_]
DIGIT [0-9]
DIGITS {DIGIT}+
INTEGER {DIGITS}
FLOAT {DIGITS}*(\.{DIGITS})(E[+-]?{DIGITS})?
IDENTIFIER {LETTERORUNDERSCORE}({LETTERORUNDERSCORE}|{DIGIT})*
CHAR [ -\[]]|[\]-~]
CHARS {CHAR}+
CHARACTER ('({CHAR})')
SPECIAL_CHAR '\\[vtrabf"n0]'|'\\\\'
STRING \"([\\](\n|.)|[^\\\"\n])*\"
UNFINISHED_STRING \"([\\](\n|.)|[^\\\"\n])*

SINGLE_LINE_COMMENT "//"{CHAR}*$ 

MULTILINE_COMMENT_form1_START [\/][\*]
MULTILINE_COMMENT_form1_END [\*][\/]
ANYTHING_WITHOUT_STAR [^\*]
STAR_NOT_SLASH \*[^\/]

MULTILINE_COMMENT_form2 [\/][\/]([^\"\n]|(\\{NEWLINE}))*

MULTILINE_COMMENT_form1 ({MULTILINE_COMMENT_form1_START}({ANYTHING_WITHOUT_STAR}|{STAR_NOT_SLASH})*{MULTILINE_COMMENT_form1_END})
UNFINISHED_COMMENT ({MULTILINE_COMMENT_form1_START}({ANYTHING_WITHOUT_STAR}|{STAR_NOT_SLASH})*)

UNFINISHED_CHAR "'"([^\n\'])*|(\'\\\')
MULTI_CHAR "'"[^\n\']([^\n\'])*"'"

TOO_MANY_DEC_POINT ((([0-9])*)*(\.)+)+((([0-9])*)*(\.)+)+([0-9])*
ILL_FORMED_NUMBER ({INTEGER}|{FLOAT})([E]*{FLOAT}*{INTEGER}*)*

UNRECOGNIZED_CHAR .

%%

{WHITESPACE} {}

{NEWLINE} {line_count++;}

"if"		{	fprintf(tokenout,"<IF> ");			fprintf(logout,"\nLine no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);}
"else"		{	fprintf(tokenout,"<ELSE> ");		fprintf(logout,"\nLine no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);}
"for"		{	fprintf(tokenout,"<FOR> ");			fprintf(logout,"\nLine no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);}
"while"		{	fprintf(tokenout,"<WHILE> ");		fprintf(logout,"\nLine no %d: TOKEN <WHILE> Lexeme %s found\n",line_count,yytext);}
"do"		{	fprintf(tokenout,"<DO> ");			fprintf(logout,"\nLine no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);}
"break"		{	fprintf(tokenout,"<BREAK> ");		fprintf(logout,"\nLine no %d: TOKEN <BREAK> Lexeme %s found\n",line_count,yytext);}
"int"		{	fprintf(tokenout,"<INT> ");			fprintf(logout,"\nLine no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);}
"char"		{	fprintf(tokenout,"<CHAR> ");		fprintf(logout,"\nLine no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);}
"float"		{	fprintf(tokenout,"<FLOAT> ");		fprintf(logout,"\nLine no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);}
"double"	{	fprintf(tokenout,"<DOUBLE> ");		fprintf(logout,"\nLine no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);}
"void"		{	fprintf(tokenout,"<VOID> ");		fprintf(logout,"\nLine no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);}
"return"	{	fprintf(tokenout,"<RETURN> ");		fprintf(logout,"\nLine no %d: TOKEN <RETURN> Lexeme %s found\n",line_count,yytext);}
"switch"	{	fprintf(tokenout,"<SWITCH> ");		fprintf(logout,"\nLine no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);}
"case"		{	fprintf(tokenout,"<CASE> ");		fprintf(logout,"\nLine no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);}
"default"	{	fprintf(tokenout,"<DEFAULT> ");		fprintf(logout,"\nLine no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);}
"continue"	{	fprintf(tokenout,"<CONTINUE> ");	fprintf(logout,"\nLine no %d: TOKEN <CONTINUE> Lexeme %s found\n",line_count,yytext);}

{IDENTIFIER}		{
				fprintf(tokenout,"<ID, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);
				s.Insert(string(yytext),"ID");
				s.PrintAllinFile();
			}

"++"|"--"	{
				fprintf(tokenout,"<INCOP, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <INCOP> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"INCOP");
				//s.PrintAllinFile();
			}

"+"|"-"		{
				fprintf(tokenout,"<ADDOP, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <ADDOP> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"ADDOP");
				//s.PrintAllinFile();
			}


"*"|"/"|"%" {
				cout << "           " << string(yytext) << endl;
				fprintf(tokenout,"<MULOP, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"MULOP");
				//s.PrintAllinFile();
			}

"<"|"<="|">"|">="|"=="|"!=" 	{
				fprintf(tokenout,"<RELOP, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"RELOP");
				//s.PrintAllinFile();
			}

"="		 	{
				fprintf(tokenout,"<ASSIGNOP, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"ASSIGNOP");
				//s.PrintAllinFile();
			}

"&&"|"||"	{
				fprintf(tokenout,"<LOGICOP, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"LOGICOP");
				//s.PrintAllinFile();
			}

"&"|"|"|"<<"|">>"|"^"	{
				fprintf(tokenout,"<BITOP, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <BITOP> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"BITOP");
				//s.PrintAllinFile();
			}

"!"			{
				fprintf(tokenout,"<NOT, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <NOT> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"NOT");
				//s.PrintAllinFile();
			}

"("			{
				fprintf(tokenout,"<LPAREN, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <LPAREN> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"LPAREN");
				//s.PrintAllinFile();
			}

")"			{
				fprintf(tokenout,"<RPAREN, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <RPAREN> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"RPAREN");
				//s.PrintAllinFile();
			}

"{"			{
				fprintf(tokenout,"<LCURL, %s> ",yytext);
				fprintf(logout,"\nine no %d: TOKEN <LCURL> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"LCURL");
				//s.PrintAllinFile();
			}

"}"			{
				fprintf(tokenout,"<RCURL, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <RCURL> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"RCURL");
				//s.PrintAllinFile();
			}

"["			{
				fprintf(tokenout,"<LTHIRD, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <LTHIRD> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"LTHIRD");
				//s.PrintAllinFile();
			}

"]"			{
				fprintf(tokenout,"<RTHIRD, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <RTHIRD> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"RTHIRD");
				//s.PrintAllinFile();
			}

","			{
				fprintf(tokenout,"<COMMA, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <COMMA> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"COMMA");
				//s.PrintAllinFile();
			}

";"			{
				fprintf(tokenout,"<SEMICOLON, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <SEMICOLON> Lexeme %s found\n",line_count,yytext);
				//s.Insert(string(yytext),"SEMICOLON");
				//s.PrintAllinFile();
			}

{INTEGER} 	{
				fprintf(tokenout,"<CONST_INT, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <CONST_INT> Lexeme %s found\n",line_count,yytext);
				s.Insert(string(yytext),"CONST_INT");
				s.PrintAllinFile();
			}
			
{FLOAT} 	{
				fprintf(tokenout,"<CONST_FLOAT, %s> ",yytext);
				fprintf(logout,"\nLine no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
				s.Insert(string(yytext),"CONST_FLOAT");
				s.PrintAllinFile();
			}

{CHARACTER}		{
				string str = string(yytext);
    			string subs;
    			subs = str.substr(1,1);
				fprintf(tokenout,"<CONST_CHAR, %s> ",subs.data());
				fprintf(logout,"\nLine no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,yytext);
				s.Insert(string(yytext),"CONST_CHAR");
				s.PrintAllinFile();
			}

{SPECIAL_CHAR}		{
				string str = string(yytext);
    			string subs;
    			string t2 = "";
    			subs = str.substr(1,2);
    			if(subs == "\t"){
    				char c = '\t';
            		string t1(1,c);
            		t2 = t1;
    			}
    			if(subs == "\n"){
    				char c = '\n';
            		string t1(1,c);
            		t2 = t1;
    			}
    			if(subs == "\\"){
    				char c = '\\';
            		string t1(1,c);
            		t2 = t1;
    			}
    			if(subs == "\""){
    				char c = '\"';
            		string t1(1,c);
            		t2 = t1;
    			}
    			if(subs == "\a"){
    				char c = '\a';
            		string t1(1,c);
            		t2 = t1;
    			}
    			if(subs == "\f"){
    				char c = '\f';
            		string t1(1,c);
            		t2 = t1;
    			}
    			if(subs == "\r"){
    				char c = '\r';
            		string t1(1,c);
            		t2 = t1;
    			}
    			if(subs == "\b"){
    				char c = '\b';
            		string t1(1,c);
            		t2 = t1;
    			}
    			if(subs == "\v"){
    				char c = '\v';
            		string t1(1,c);
            		t2 = t1;
    			}
    			if(subs == "\0"){
    				char c = '\0';
            		string t1(1,c);
            		t2 = t1;
            	}
				fprintf(tokenout,"<CONST_CHAR, %s> ",t2.data());
				fprintf(logout,"\nLine no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,yytext);
				s.Insert(string(yytext),"CONST_CHAR");
				s.PrintAllinFile();
			}

{UNFINISHED_CHAR}		{
				int p = 0;
				for(int i = 0; i<string(yytext).size(); i++){
        			if(string(yytext).at(i) =='\n'){
        				p++;
        			}
    			}
    			fprintf(logout,"\nError at line %d: Unterminated Character %s\n",line_count,yytext);
    			line_count = line_count+p;
    			err_count++;
				}

{MULTI_CHAR}	{
				int p = 0;
				for(int i = 0; i<string(yytext).size(); i++){
        			if(string(yytext).at(i) =='\n'){
        				p++;
        			}
    			}
    			fprintf(logout,"\nError at line %d: Multi character constant error %s\n",line_count,yytext);
    			line_count = line_count+p;
    			err_count++;
				}

{STRING}		{
				int p = 0;
				string str = string(yytext);
    			string subs;
    			subs = str.substr(1,str.size()-2);
    			string strf = "";
    			for(int i = 0; i<subs.size(); i++){
        			if(subs.at(i) =='\\'){
        				if(subs.at(i+1) == '\n'){
            				i = i+1;
            				p++;
            			}
            			else if(subs.at(i+1) == 't'){
            				char c = '\t';
            				string t1(1,c);
            				strf.append(t1);
            				i = i+1;
            			}
            			else if(subs.at(i+1) == '\\'){
            				char c = '\\';
            				string t1(1,c);
            				strf.append(t1);
            				i = i+1;	
            			}
        			}
        			else{
            			char c = subs.at(i);
            			string t1(1,c);
            			strf.append(t1);
        			}
    			}
    			string strff = "";
    			strff.append("\"");
    			strff.append(strf);
    			strff.append("\"");
				fprintf(tokenout,"<STRING, %s> ",strff.data()); // to tokenize ab as "ab"
				//fprintf(tokenout,"<STRING, %s> ",strf.data()); // to tokenize ab as ab
				fprintf(logout,"\nLine no %d: TOKEN <STRING> Lexeme %s found\n",line_count,yytext);
				line_count = line_count + p;
			}

{UNFINISHED_STRING} 	{
				int p = 0;
				for(int i = 0; i<string(yytext).size(); i++){
        			if(string(yytext).at(i) =='\n'){
        				p++;
        			}
    			}
    			fprintf(logout,"\nError at line %d: Unterminated String %s\n",line_count,yytext);
    			line_count = line_count+p;
    			err_count++;
			}

{SINGLE_LINE_COMMENT}|{MULTILINE_COMMENT_form1}|{MULTILINE_COMMENT_form2}	 {
				int p = 0;
				for(int i = 0; i<string(yytext).size(); i++){
        			if(string(yytext).at(i) =='\n'){
        				p++;
        			}
    			}
    			fprintf(logout,"\nLine no %d: TOKEN <COMMENT> Lexeme %s found\n",line_count,yytext);
    			line_count = line_count+p;
			}

{UNFINISHED_COMMENT} 	{
				int p = 0;
				for(int i = 0; i<string(yytext).size(); i++){
        			if(string(yytext).at(i) =='\n'){
        				p++;
        			}
    			}
    			fprintf(logout,"Error at line %d: Unterminated Comment %s\n",line_count,yytext);
    			line_count = line_count+p;
    			err_count++;
			}

{ILL_FORMED_NUMBER} 	{
    			fprintf(logout,"\nError at line %d: Ill Formed Number %s\n",line_count,yytext);
    			err_count++;
			}

{TOO_MANY_DEC_POINT} 	{
    			fprintf(logout,"\nError at line %d: Too Many Decimal Point %s\n",line_count,yytext);
    			err_count++;
			}			

{UNRECOGNIZED_CHAR} 	{
    			fprintf(logout,"\nError at line %d: Unrecognized Char %s\n",line_count,yytext);
    			err_count++;
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
	fprintf(logout,"\nTotal line :%d \n",line_count);
	fprintf(logout,"Total Error :%d \n",err_count);
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
