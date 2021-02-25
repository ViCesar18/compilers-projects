warning:5:20: 'int*'/'char*' type mismatch in conditional expression
    c = (char)(i?&i:&c);
                   ^
warning:5:9: cast from 'int*' to 'char' of different size
    c = (char)(i?&i:&c);
        ^
SUCCESSFUL COMPILATION.