.PHONY: help all generate_files clean dirs
help:
	@echo "use make (all|dirs|clean|help|generate_files)"

SOURCE_DIR :=src
BUILD_DIR :=build
STATIC_DIR :=static
GEN_DIR =$(SOURCE_DIR)/generated_files
BUILT_GEN_DIR = $(BUILD_DIR)/generated_files
EXEC :=cexc
FLAGS=-Wall -Werror -std=c99
C_FILES = $(shell find src -type f -a -name '*.c') 
O_FILES = $(patsubst $(SOURCE_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_FILES))

LEX_FILE := lexer.l
PARSER_FILE := syntax.y


all: generate_files $(BUILD_DIR)/$(EXEC)

generate_files:  $(BUILT_GEN_DIR)/parser.o $(BUILT_GEN_DIR)/lexer.o

dirs: $(BUILD_DIR) $(GEN_DIR) $(BUILT_GEN_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(GEN_DIR):
	mkdir -p $(GEN_DIR)

$(BUILT_GEN_DIR): $(BUILD_DIR)
	mkdir -p $(BUILT_GEN_DIR)


$(GEN_DIR)/parser.c: static/$(PARSER_FILE) | $(GEN_DIR)
	bison -dy -o $(GEN_DIR)/parser.c $(STATIC_DIR)/$(PARSER_FILE)

$(GEN_DIR)/lexer.c: static/$(LEX_FILE) | $(GEN_DIR)
	flex --header-file=$(GEN_DIR)/lexer.h -o $(GEN_DIR)/lexer.c $(STATIC_DIR)/$(LEX_FILE)

$(BUILT_GEN_DIR)/%.o: $(GEN_DIR)/%.c | $(BUILT_GEN_DIR)
	$(CC) -w -c -o $@ $<

$(BUILD_DIR)/$(EXEC): $(O_FILES) 
	$(CC) -o $@ $(BUILD_DIR)/*.o $(BUILD_DIR)/*/*.o

$(O_FILES): $(BUILD_DIR)/%.o : $(SOURCE_DIR)/%.c | $(BUILD_DIR)
	$(CC) -c -o $@ $< 

clean:
	rm -rf $(BUILD_DIR) $(GEN_DIR)

