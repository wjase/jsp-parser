lexer grammar  JSPLexer;

TOP_JSP_COMMENT
    : '<!--' .*? '-->'
    ;

TOP_JSP_CONDITIONAL_COMMENT
    : '<![' .*? ']>'
    ;

TOP_XML_DECLARATION
    : '<?xml' -> pushMode(TAG)
    ;

TOP_CDATA
    : '<![CDATA[' .*? ']]>'
    ;


TOP_DTD
    : '<!DOCTYPE' -> pushMode(IN_DTD)
    ;

WHITESPACE_SKIP
    : WHITESPACE -> skip
    ;

TOP_CLOSE_TAG_START
    : END_ELEMENT_OPEN_TAG -> pushMode(TAG)
    ;

TOP_OPEN_TAG_START
    : BEGIN_ELEMENT_OPEN_TAG -> pushMode(TAG)
    ;

TOP_DIRECTIVE_OPEN
    : ('<%@'|'<jsp:directive') -> pushMode(TAG)
    ;

TOP_DECLARATION_OPEN
    : ('<%!'|'<jsp:declaration') -> pushMode(JSP_BLOB)
    ;

TOP_ECHO_EXPRESSION_OPEN
    : ('<%='|'<jsp:expression') -> pushMode(JSP_BLOB)
    ;

TOP_SCRIPTLET_OPEN
    : ('<%'|'jsp:scriptlet') -> pushMode(JSP_BLOB)
    ;

TOP_EXPRESSION_OPEN
    : ('${'|'#{') ->pushMode(IN_JSP_EXPRESSION)
    ;

TOP_WHITESPACES
    :  (' '|'\t'|'\r'? '\n')+
    ;

fragment IDENTIFIER
    : TAG_NameStartChar TAG_NameChar*
    ;

fragment EL_EXPR_BODY
    : ~[\}]+ 
    ;

fragment EL_EXPR_OPEN
    : ('${'|'#{') 
    ;

fragment EL_EXPR_CLOSE
    : '}' 
    ;

fragment EL_EXPR_TXT
    : EL_EXPR_OPEN EL_EXPR_BODY EL_EXPR_CLOSE
    ;

fragment BEGIN_ELEMENT_OPEN_TAG
    : '<'
    ;

fragment CLOSE_TAG
    : '>'
    ;

fragment END_ELEMENT_OPEN_TAG
    : '</'
    ;

fragment EMPTY_ELEMENT_CLOSE
    : '/>'
    ;

TOP_EL_EXPR
    : EL_EXPR_TXT
    ;


TOP_JSP_STATIC_CONTENT_CHARS_MIXED
    :
        TOP_JSP_STATIC_CONTENT_CHAR+? {(_input.LA(1) == '\$') && (_input.LA(2) == '{')}? -> pushMode(IN_JSP_EXPRESSION)
    ;

TOP_JSP_STATIC_CONTENT_CHARS
    :
        TOP_JSP_STATIC_CONTENT_CHAR+? {(_input.LA(1) == '<') }?
    ;

TOP_JSP_STATIC_CONTENT_CHAR
    : ~[<\$]+
    ;

TOP_JSP_CLOSE
    : '%>' ->popMode
    ;

mode IN_DTD;
//<!DOCTYPE doctypename PUBLIC "publicId" "systemId">

DTD_PUBLIC
     : 'PUBLIC'
     ;

DTD_SYSTEM
     : 'SYSTEM'
     ;

DTD_WHITESPACE_SKIP
    :WHITESPACE+ -> skip
    ;

DTD_QUOTED 
    : DOUBLE_QUOTE DOUBLE_QUOTE_STRING_CONTENT* DOUBLE_QUOTE
    ;

DTD_IDENTIFIER
    : IDENTIFIER
    ;

DTD_TAG_CLOSE
    : TAG_CLOSE -> popMode
    ;

mode JSP_BLOB;


BLOB_CONTENT
    : .
    ;

mode IN_JSP_EXPRESSION;

JSPEXPR_CONTENT
    : EL_EXPR -> popMode
    ;

JSPEXPR_CONTENT_CLOSE
    : ('}' | '%>') -> popMode
    ;

//
// tag declarations
//
mode TAG;

TAG_SLASH_CLOSE
    : EMPTY_ELEMENT_CLOSE -> popMode
    ;

SUB_TAG_OPEN: BEGIN_ELEMENT_OPEN_TAG -> pushMode(TAG);


TAG_CLOSE
    : CLOSE_TAG -> popMode
    ;


TAG_SLASH
    : '/'
    ;

TAG_DIRECTIVE_CLOSE
    : TOP_JSP_CLOSE ->popMode
    ;
//
// lexing mode for attribute values
//
TAG_EQUALS
    : '=' -> pushMode(ATTVALUE)
    ;

TAG_IDENTIFIER
    : IDENTIFIER
    ;

TAG_WHITESPACE
    : WHITESPACE ->skip
    ;

fragment WHITESPACE
    : [ \t\r\n] -> skip
    ;

fragment INLINE_WHITESPACE
      : [ \t]
      ;

fragment
HEXDIGIT
    : [a-fA-F0-9]
    ;

fragment
DIGIT
    : [0-9]
    ;

fragment
TAG_NameChar
    : TAG_NameStartChar
    | '-'
    | '_'
    | '.'
    | DIGIT
    |   '\u00B7'
    |   '\u0300'..'\u036F'
    |   '\u203F'..'\u2040'
    ;

fragment
TAG_NameStartChar
    :   [:a-zA-Z]
    |   '\u2070'..'\u218F'
    |   '\u2C00'..'\u2FEF'
    |   '\u3001'..'\uD7FF'
    |   '\uF900'..'\uFDCF'
    |   '\uFDF0'..'\uFFFD'
    ;

//
// <scripts>
//
mode SCRIPT;

SCRIPT_BODY
    : .*? '</script>' -> popMode
    ;

SCRIPT_SHORT_BODY
    : .*? END_ELEMENT_OPEN_TAG -> popMode
    ;

//
// <styles>
//
mode STYLE;

STYLE_BODY
    : .*? '</style>' -> popMode
    ;

STYLE_SHORT_BODY
    : .*? '</>' -> popMode
    ;

//
// attribute values
//
mode ATTVALUE;

ATTVAL_TAG_OPEN
    :  BEGIN_ELEMENT_OPEN_TAG -> pushMode(TAG)
    ;
// an attribute value may have spaces around the '='
ATTVAL_EXPR_VALUE
    : TOP_WHITESPACES? (
            ('\'' (EL_EXPR) '\'')|
            ('\"' (EL_EXPR) '\"'))  -> popMode
    ;

ATTVAL_CONST_VALUE
    : TOP_WHITESPACES? ATTVAL_ATTRIBUTE  -> popMode
    ;

ATTVAL_ATTRIBUTE
    : SINGLE_QUOTE SINGLE_QUOTE_STRING_CONTENT* SINGLE_QUOTE
    | DOUBLE_QUOTE DOUBLE_QUOTE_STRING_CONTENT* DOUBLE_QUOTE
    | ATTCHARS
    | HEXCHARS
    | DECCHARS;


fragment ATTCHAR
    : '-'
    | '_'
    | '.'
    | '/'
    | '+'
    | ','
    | '?'
    | '='
    | ':'
    | ';'
    | '#'
    | [0-9a-zA-Z]
    ;

fragment ATTCHARS
    : ATTCHAR+ ' '?
    ;

fragment HEXCHARS
    : '#' [0-9a-fA-F]+
    ;

fragment DECCHARS
    : [0-9]+ '%'?
    ;

fragment EL_EXPR_SINGLE
    :SINGLE_QUOTE (EL_EXPR) SINGLE_QUOTE
    ;

fragment EL_EXPR_DOUBLE
    :'"' (EL_EXPR) '"'
    ;

fragment EL_EXPR
    : '${' ~[<}]* '}'
    ;

fragment DOUBLE_QUOTE
    : '"'
    ;

SINGLE_QUOTE_STRING_CONTENT
    : ~[<']
    ;

DOUBLE_QUOTE_STRING_CONTENT
    : ~[<"]
    ;

fragment SINGLE_QUOTE
    : '\''
    ;

