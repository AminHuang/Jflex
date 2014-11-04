import java.io.*;
import java.util.Stack;

%%

%class token
%unicode
%debug
%full

%state FUNCTION

%{
  private String functionName;
  private int count = 0;
  private String isfun = "0";
  private String notfun = "1";
  private Stack<String> func = new Stack<String>();
%} 

ALPHA=[A-Za-z]
DIGIT=[0-9]
NONNEWLINE_WHITE_SPACE_CHAR=[\ \t\b\012]
NEWLINE=\r|\n|\r\n
IDFORM = {ALPHA}({ALPHA}|{DIGIT}|_)*
KEYWORD=if|int|double|return
ID=!(!{IDFORM} | {KEYWORD})

%%
<YYINITIAL,FUNCTION> {
"#include"                        {return (new Yytoken(1,yytext()));}
"int"                             {return (new Yytoken(19,yytext()));}
"double"                          {return (new Yytoken(20,yytext()));}
"if"                              {return (new Yytoken(21,yytext()));}
"return"                          {return (new Yytoken(22,yytext()));}
\<[_a-zA-Z\.]+>                   {return (new Yytoken(2,yytext()));}
{ID}[ ]*\(\)                      {return (new Yytoken(3,yytext()));}
{ID}[ ]*\(                        {func.push(isfun); yybegin(FUNCTION);  return (new Yytoken(3,yytext()+")"));}
{ID}                              {return (new Yytoken(24,yytext()));}
","                               {return (new Yytoken(6,yytext()));}
";"                               {return (new Yytoken(7,yytext()));}
"{"                               {return (new Yytoken(8,yytext()));}
"}"                               {return (new Yytoken(9,yytext()));}
"+"                               {return (new Yytoken(10,yytext()));}
"-"                               {return (new Yytoken(11,yytext()));}

"*"                               {return (new Yytoken(14,yytext()));}
"/"                               {return (new Yytoken(15,yytext()));}
"<"                               {return (new Yytoken(16,yytext()));}
">"                               {return (new Yytoken(17,yytext()));}
"="                               {return (new Yytoken(18,yytext()));}
[0-9]+                            {return (new Yytoken(23,yytext()));}
\".+\"                            {return (new Yytoken(4,yytext()));}

{NONNEWLINE_WHITE_SPACE_CHAR}+  { }

}

<YYINITIAL> {
"("                               {return (new Yytoken(12,yytext()));}
")"                               {return (new Yytoken(13,yytext()));}
.                                 {   }
}

<FUNCTION> {
    "(" { func.push(notfun); count++; return (new Yytoken(12, yytext())); }
    ")" { if (func.size() >= 2 ) {
            if (func.pop().equals(notfun) )
            return (new Yytoken(12, yytext()));
          } else {
          	func.pop();
            yybegin(YYINITIAL);
          }
        }
    . {   }
  
}

{NEWLINE} { }