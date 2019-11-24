
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include "parser_wrapper.h"


int main(int argc, char* argv[]) {
    printf("Hello, World!\n");

    mkdir("temp", 0777);
    mkdir("output", 0777);

    // howdy

    if (argc > 1) {
        for (size_t i = 1; i < argc; i++)
        {
            parse(argv[i]);
        }
        
    }

    system("rm -r temp");
    return 0;
}