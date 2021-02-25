warning:1:14: right shift count >= width of type
#define c1 1 >> 32
             ^
warning:2:14: left shift count >= width of type
#define c2 1 << 33
             ^
SUCCESSFUL COMPILATION.