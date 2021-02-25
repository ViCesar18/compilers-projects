warning:15:5: cast from 'int' to 'void' of different size
    (void) 666;
    ^
warning:18:22: cast from 'int' to 'char' of different size
    (void)(char)(int)(char)77;
                     ^
warning:18:11: cast from 'int' to 'char' of different size
    (void)(char)(int)(char)77;
          ^
error:semantic:20:9: void value not ignored as it ought to be
    w = (int) f();
        ^