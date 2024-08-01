# Main info

- ```char* get_best_move(char* moves_history, char* depth, char* path_to_engine)``` - main function, that used for getting respones from engine.
    - char* moves_history - history of game moves, every move is coded in PGN notation. Each step is separated by space;
    - char* depth - set the level of thinking of enging;
    - char* path_to_engine - path to engine.

- ```char* get_best_move_cmd(char* moves_history, char* depth, char* path_to_engine)``` - create the comand to get best move from engine.
    - char* moves_history - history of game moves, every move is coded in PGN notation. Each step is separated by space;
    - char* depth - set the level of thinking of enging;
    - char* path_to_engine - path to engine.

- ```char* get_engine_respones_on_cmd(char* cmd, function<char*(char*, char*)> string_agregator, int buffer_size=8192, int num_of_strings=4)``` - run bash script and agregate it.
    - char* cmd - bash script;
    - function<char*(char*, char*)> string_agregator - strategy to agregate data;
    - int buffer_size - size of message;
    - int num_of_strings - num of readingg strings;
