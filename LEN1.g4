grammar LEN1;

parse
 : from_input | from_file
 ;

from_input
 : stat NEWLINE
 ;

from_file
 : (stat|NEWLINE)* EOF
 ;

stat
 : opciones
 | bloques
 ;

bloques
 : decision_if
 | ciclo_while
 | funcion
 | op_matriz
 ;

opciones
 : assignment
 | log
 | retornar
 | atom NEWLINE
 | OTHER
 ;

assignment
 : variable ASSIGN (assignment|expr)
 ;

decision_if
 : IF condition_block (ELSE IF condition_block)* (ELSE stat_block)?
 ;

ciclo_while
 : WHILE expr stat_block
 ;

log
 : LOG OPAR expr CPAR
 ;

funcion
 : FUNCION ID OPAR (parametro (COMMA parametro)*)? CPAR (NEWLINE|stat)* END
 ;

op_matriz
 :mul_mat OPAR parametro COMMA parametro CPAR (NEWLINE|stat)* END
 |sum_mat OPAR parametro COMMA parametro CPAR (NEWLINE|stat)* END
 ; 
retornar
 : RETORNO OPAR expr CPAR NEWLINE
 ;

condition_block
 : expr NEWLINE? stat_block
 ;

stat_block
 : OBRACE (stat|NEWLINE)* CBRACE
 | stat NEWLINE
 ;

array
 : OKEY (expr (COMMA expr)*)? CKEY
 | OKEY start=expr POINTS (step=expr POINTS)? end=expr CKEY
 | OKEY (matriz) CKEY
 ;
 matriz
 : OKEY(expr(COMMA expr)*)? CKEY
 ;

accessarray
 : variable OKEY expr CKEY
 ;

variable
 : ID (POINT ID)* (OPAR (expr (COMMA expr)*)? CPAR)?
 | ID (POINT ID)* OKEY expr CKEY
 ;

parametro
 : ID (ASSIGN expr)?
 ;

expr
 : 
 | MINUS expr                                   
 | NOT expr                                     
 | left=expr op=(MULT|DIV|MOD) right=expr       
 | left=expr op=(PLUS|MINUS) right=expr         
 | left=expr op=(MENOREQ|MAYOREQ|MENOR|MAYOR) right=expr    
 | left=expr op=(EQ|NEQ) right=expr             
 | left=expr AND right=expr                     
 | left=expr OR right=expr                      
 | OPAR expr CPAR 						        
 | atom                                         
 

atom
 : (INT|FLOAT)  
 | (TRUE|FALSE) 
 | STRING       
 | array
 | matriz		
 | objeto		
 | accessarray  
 | variable		
 ;


objeto
 : OBRACE (keyvalue (COMMA keyvalue)*)? CBRACE
 ;

keyvalue
 : ID POINTS expr
 ;

OR : '||';
AND : '&&';
EQ : '==';
NEQ : '!=';
MAYOR : '>';
MENOR : '<';
MAYOREQ : '>=';
MENOREQ : '<=';
PLUS : '+';
MINUS : '-';
MULT : '*';
DIV : '/';
MOD : '%';
POW : '^';
NOT : '!';

ASSIGN : '=';
OPAR : '(';
CPAR : ')';
OBRACE : '{';
CBRACE : '}';
OKEY : '[';
CKEY : ']';
COMMA : ',';
POINTS: ':';

TRUE : 'true';
FALSE : 'false';
IF : 'if';
ELSE : 'else';
WHILE : 'while';

IN : 'in';
FUNCION: 'funcion';
END: 'end';
RETORNO: 'retorno';
FROM: 'desde';
ASTERISC: 'todo';
POINT: '.';

ID
 : [a-zA-Z_] [a-zA-Z_0-9]*
 ;

INT
 : [0-9]+
 ;

FLOAT
 : [0-9]+ '.' [0-9]*
 | '.' [0-9]+
 ;

STRING
 : '"' (~["\r\n] | '""')* '"'
 ;
COMMENT
 : '#' ~[\r\n]* -> skip
 ;
SPACE
 : [ \t\r] -> skip
 ;
NEWLINE
 : [\n]
 ;
OTHER
 : .
 ;