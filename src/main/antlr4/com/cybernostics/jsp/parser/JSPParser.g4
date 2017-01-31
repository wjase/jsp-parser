

parser grammar JSPParser;

options { tokenVocab=JSPLexer; }

jspDocument
    : (jspDirective | scriptlet | TOP_WHITESPACES)* xml? (jspDirective | scriptlet | TOP_WHITESPACES)* dtd? (jspDirective | scriptlet | TOP_WHITESPACES)* jspElements*
    ;

jspElements
    : htmlMisc* jspElement htmlMisc*
    ;

jspElement
    : (TOP_OPEN_TAG_START|SUB_TAG_OPEN) name=htmlTagName atts+=htmlAttribute*? TAG_CLOSE htmlContent TOP_CLOSE_TAG_START htmlTagName TAG_CLOSE
    | (TOP_OPEN_TAG_START|SUB_TAG_OPEN) name=htmlTagName atts+=htmlAttribute*? TAG_SLASH_CLOSE
    | (TOP_OPEN_TAG_START|SUB_TAG_OPEN) name=htmlTagName atts+=htmlAttribute*? TAG_CLOSE
    | jspDirective
    | scriptlet
    ;

jspDirective
    : TOP_DIRECTIVE_OPEN name=htmlTagName atts+=htmlAttribute*? TAG_WHITESPACE* TAG_DIRECTIVE_CLOSE
    ;

htmlContent
    : (htmlChardata|jspExpression)* ((jspElement | xhtmlCDATA | htmlComment) (jspExpression|htmlChardata)*)*
    ;

jspExpression
    : JSPEXPR_CONTENT
    ;

htmlAttribute
    : 
      jspElement
    | name=htmlAttributeName TAG_EQUALS value=htmlAttributeValue
    | name=htmlAttributeName
    | scriptlet
    ;

htmlAttributeName
    : TAG_IDENTIFIER
    ;

htmlAttributeValue
    : htmlAttributeValueExpr | htmlAttributeValueConstant 
    ;

htmlAttributeValueExpr
    : ATTVAL_EXPR_VALUE
    ;

htmlAttributeValueConstant
    : ATTVAL_CONST_VALUE
    ;

htmlTagName
    : TAG_IDENTIFIER
    ;

htmlChardata
    : TOP_JSP_STATIC_CONTENT_CHARS_MIXED
    | TOP_JSP_STATIC_CONTENT_CHARS
    | TOP_WHITESPACES
    ;

htmlMisc
    : htmlComment
    | TOP_WHITESPACES
    ;

htmlComment
    : TOP_JSP_COMMENT
    | TOP_JSP_CONDITIONAL_COMMENT
    ;

xhtmlCDATA
    : TOP_CDATA
    ;

dtd
    : TOP_DTD dtdElementName (DTD_PUBLIC publicId)? (DTD_SYSTEM systemId)?  DTD_TAG_CLOSE
    ;

dtdElementName
    : DTD_IDENTIFIER
    ;

publicId
    : DTD_QUOTED;

systemId
    : DTD_QUOTED;

xml: TOP_XML_DECLARATION name=htmlTagName atts+=htmlAttribute*? TAG_CLOSE
    ;

scriptlet
    : TOP_SCRIPTLET_OPEN BLOB_CONTENT TOP_JSP_CLOSE    ;

//script
//    : SCRIPT_OPEN ( SCRIPT_BODY | SCRIPT_SHORT_BODY)
//    ;

//style
//    : STYLE_OPEN ( STYLE_BODY | STYLE_SHORT_BODY)
//    ;
