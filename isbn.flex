import java.io.*;
import java.util.Scanner;
%%
%class isbn
%unicode
%line
%column
%{
	//these variables are defined static because they will be referenced in main, a static method
	static int num[] = {10,9,8,7,6,5,4,3,2,1};
	// 0-English, 7-Chinese
	static String language[] = {"English", "Chinese", "Other"};

	static int num2[] = {1,3};

	private void checkTen(String book) {
		book = book.trim();
		int booklen = book.length();
		if (booklen == 13) {
			int cur = 0;
			int check = 0;

			String[] arr=book.split("[ -]");
			int arrlen = arr.length;

			int langcase = 2; // 默认other

			for (int i = 0; i < arrlen - 1; i++) {
				for (int j = 0; j < arr[i].length(); j++) {
					check += ((arr[i].charAt(j) - '0') * num[cur++]);
				}
			}

			if (arr[0].length() == 1) {
				if (arr[0].equals("0"))
					langcase = 0;
				else if (arr[0].equals("7"))
					langcase = 1;
			}

			String bookend = arr[arrlen - 1];
			int bookCheck = bookend.charAt(0) - '0';
			check = (11- check % 11) % 11;
			if ((bookCheck == check) || (check == 10 && bookend.equals("X")) ) {
				System.out.println(language[langcase] + " " + arr[1]);
			} else {
				System.out.println("Error");
			}
		} else {
			System.out.println("Error");
		}
		
	}

	private void checkThirteen(String book){
		book = book.trim();
		int booklen = book.length();
		String[] arr=book.split("[ -]");
		if (booklen == 17) {

			int cur = 0;
			int check = 0;

			int arrlen = arr.length;

			int langcase = 2; // 默认other

			for (int i = 0; i < arrlen - 1; i++) {
				for (int j = 0; j < arr[i].length(); j++) {
					check += ((arr[i].charAt(j) - '0') * num2[(cur++)%2]);
				}
			}

			if (arr[1].length() == 1) {
				if (arr[1].equals("0"))
					langcase = 0;
				else if (arr[1].equals("7"))
					langcase = 1;
			}

			int bookCheck = arr[arrlen - 1].charAt(0) - '0';
			check = (10 - check % 10) % 10;
			if (bookCheck == check) {
				System.out.println(language[langcase] + " " + arr[2]);
			} else {
				System.out.println("Error");
			}

		} else {
			System.out.println("Error");
		}
	}

	public static void main(String [] args) throws IOException {
		//create a scanner and use the scanner's yylex function
		//if you want standard input, System.in instead of new FileReader(args[0])
		isbn lexer = new isbn(new FileReader(args[0]));
		lexer.yylex();
	}
%}
%type Object //this line changes the return type of yylex into Object
word = [ \t\n\r]+
%%
[ ]*(978|979)[- ][0-9]{1,5}[- ][0-9]{1,7}[- ][0-9]{1,6}[- ][0-9]{1,1}[ ]*      {checkThirteen(yytext());}
[ ]*[0-9]{1,5}[- ][0-9]{1,7}[- ][0-9]{1,6}[- ][0-9X]{1,1}[ ]*                  {checkTen(yytext());}
.+                                                                             {System.out.println("Error");}
{word}                                                                         {}