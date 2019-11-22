
#include "parser_wrapper.h"
#include "generated_files/parser.h"
#include "generated_files/lexer.h"

int parse(char * file) {
   

    

    // USE C PREPROCESSOR

    int fds[2];
    if (pipe(fds) < 0) {
        perror("fork");
        exit (EXIT_FAILURE);
    }


    int pid = fork();
    if (pid == 0) /* child */ {
        //close(fds[0]);

        dup2(fds[1], STDOUT_FILENO);
        char *const command[4] = {
            "cpp",
            "-P",
            file,
            NULL
        };

        execvp(command[0], command);
    } else { /* parent */
        //close(fds[1]);
        
        FILE *cpp_file = fdopen(fds[0], "r");
        if(!cpp_file) {
            perror("cpp file failiure");
            exit (EXIT_FAILURE);
        }
        
        yyin = cpp_file;
        printf("yy-in now points to %p\n", yyin);
        if(!yyin) {
            perror("fopen");
            exit (EXIT_FAILURE);

        }
        //printf("Receiving input from cpp");
        return yyparse();
    }

    return -1;
}