#include <stdio.h>
#include <functional>
#include <cstring>


#define MAX 8192 
#define BEST_MOVE_RESULT_LEN 4


using namespace std;


// Getting bash script to get best move for executing
char* get_best_move_cmd(char* moves_history, char* depth, char* path_to_engine){ 
  char c1[] = "echo \"position startpos moves ";
  char c2[] = " \n go depth ";
  char c3[] = " \" | ";
	char *s = new char[strlen(c1) + strlen(moves_history) + strlen(c2) + + strlen(depth) + strlen(c3) + strlen(path_to_engine) + 1];
  strcat(s,c1);
  strcat(s,moves_history);
  strcat(s,c2);
  strcat(s,depth);
  strcat(s,c3);
  strcat(s, path_to_engine);
  return s;
}


// Getting output of best move bash script
char* get_engine_respones_on_cmd(char* cmd, function<char*(char*, char*)> string_agregator, int buffer_size=8192, int num_of_strings=4){
  FILE* pipe_writer;
	char *s = new char[buffer_size];
  char buffer[buffer_size];
  pipe_writer=popen(cmd, "r");
  for (int i=0; i<num_of_strings; i++){
    fgets(buffer, buffer_size, pipe_writer);
    string_agregator(s,buffer);
  }
  pclose(pipe_writer); 
  return s;
}


// Getting best move
char* get_best_move(char* moves_history, char* depth, char* path_to_engine){
  char* s2;
  char* s = get_best_move_cmd(moves_history, depth, path_to_engine);
  s2 = get_engine_respones_on_cmd(s, &strcpy);
  return s2;
}


// Example of usage
int main(int argc, char* argv[]){

  char moves[] = "e2e4 a7a6 a2a3";
  char depth[] = "3";
  char path_to_engine[] = "./engines/stockfish-ubuntu-x86-64-avx2";

  char* s2 = get_best_move(moves, depth, path_to_engine);
  
  fputs(s2, stderr); // bestmove a6a5
  return 0;
}
