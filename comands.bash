flex lexical.l
bison -d synt.y
gcc parser.c lex.yy.c synt.tab.c -lfl -ly -o compiler.exe
# ./compiler.exe < MiniAlgo.txt
./compiler.exe < fault.txt
rm -rf compiler.exe synt.tab.c lex.yy.c