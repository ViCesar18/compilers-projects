warning:15:9: cast from 'int' to 'char' of different size
    c = (char) i; /*meio certo*/  i << -1; /*errado*/
        ^
error:semantic:15:37: left shift count is negative
    c = (char) i; /*meio certo*/  i << -1; /*errado*/
                                    ^