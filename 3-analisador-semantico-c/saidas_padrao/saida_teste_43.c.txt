warning:5:20: 'int*'/'char*' type mismatch in conditional expression
    p = (char)(i?&i:&c);
                   ^
warning:5:9: cast from 'int*' to 'char' of different size
    p = (char)(i?&i:&c);
        ^
error:semantic:5:7: incompatible types when assigning to type 'int*' from type 'char'
    p = (char)(i?&i:&c);
      ^