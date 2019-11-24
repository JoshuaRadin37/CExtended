
#include "parser_wrapper.h"
#include "generated_files/parser.h"
#include "generated_files/lexer.h"

int parse(char * file) {
   

    FILE* cpp_file = fopen(file, "r");
        
    yyin = cpp_file;
    printf("yy-in now points to %p\n", yyin);
    if(!yyin) {
        perror("fopen");
        exit (EXIT_FAILURE);

    }
    //printf("Receiving input from cpp");
    return yyparse();


    return -1;
}