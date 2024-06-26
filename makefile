# Compiler
CXX = g++

# Compilation flags
CXXFLAGS = -Iinclude -Wall -Wextra -g

# Source files directory
SRC_DIR = src

# Object files directory
OBJ_DIR = output

# Test files directory
TEST_DIR = tests

UI_DIR = ui

# Library directory
LIB_DIR = lib

# List of source files
SRCS = $(wildcard $(SRC_DIR)/*.cpp)

# List of object files
OBJS = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS))

# Static library name
LIB_NAME = libsudoku.a

# Main target
all: $(LIB_DIR)/$(LIB_NAME) $(OBJ_DIR)/test1.o
	$(CXX) $(OBJS) $(OBJ_DIR)/test1.o -o $(OBJ_DIR)/test1 -L$(LIB_DIR) -lsudoku
	./$(OBJ_DIR)/test1

test:
	$(CXX) -o test $(TEST_DIR)/test2.cpp
	./test

cgi: $(LIB_DIR)/$(LIB_NAME) cgi/protocol.o
	$(CXX) cgi/protocol.o -o cgi/sudoku_generator -L$(LIB_DIR) -lsudoku -static-libstdc++ -static-libgcc

game: $(LIB_DIR)/$(LIB_NAME) game/game.o
	$(CXX) game/game.o -o game/playSudoku -L$(LIB_DIR) -lsudoku -static-libstdc++ -static-libgcc
	./game/playSudoku

# Rule to compile individual source files into object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) -c $< $(CXXFLAGS) -o $@

# Rule to compile test1.cpp into object file
$(OBJ_DIR)/test1.o: $(TEST_DIR)/test1.cpp
	$(CXX) -c $< $(CXXFLAGS) -o $@

cgi/protocol.o: cgi/protocol.cpp
	$(CXX) -c $< $(CXXFLAGS) -o $@

game/game.o: game/game.cpp
	$(CXX) -c $< $(CXXFLAGS) -o $@

# Rule to build static library
$(LIB_DIR)/$(LIB_NAME): $(OBJS)
	ar rcs $@ $^

# Clean target to remove object files, static library, and test executables
clean:
	rm -f $(OBJ_DIR)/*.o $(LIB_DIR)/$(LIB_NAME) $(OBJ_DIR)/test1
