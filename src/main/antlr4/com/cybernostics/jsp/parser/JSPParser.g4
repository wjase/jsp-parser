

parser grammar JSPParser;

options { tokenVocab=JSPLexer; }

jspDocument
    : (jspDirective | scriptlet | WHITESPACES)* xml? (jspDirective | scriptlet | WHITESPACES)* dtd? (jspDirective | scriptlet | WHITESPACES)* jspElements*
    ;

jspElements
    : htmlMisc* jspElement htmlMisc*
    ;

jspElement
    : (TAG_BEGIN) name=htmlTagName atts+=htmlAttribute*? TAG_END htmlContent* CLOSE_TAG_BEGIN htmlTagName TAG_END
    | (TAG_BEGIN) name=htmlTagName atts+=htmlAttribute*? TAG_SLASH_END
    | (TAG_BEGIN) name=htmlTagName atts+=htmlAttribute*? TAG_END
    | jspDirective
    | scriptlet
    ;

jspDirective
    : DIRECTIVE_BEGIN name=htmlTagName atts+=htmlAttribute*? TAG_WHITESPACE* DIRECTIVE_END
    ;

htmlContent
    : htmlChardata
    | jspExpression
    | jspElement 
    | xhtmlCDATA 
    | htmlComment 
    | scriptlet
    ;

jspExpression
    : EL_EXPR
    ;

htmlAttribute
    : 
      jspElement
    | name=htmlAttributeName EQUALS value=htmlAttributeValue
    | name=htmlAttributeName
    | scriptlet
    ;

htmlAttributeName
    : TAG_IDENTIFIER
    ;

htmlAttributeValue
    : QUOTE? htmlAttributeValueExpr  QUOTE?
    | QUOTE htmlAttributeValueConstant? QUOTE
    | htmlQuotedElement 
    ;

htmlAttributeValueExpr
    : EL_EXPR
    ;

htmlAttributeValueConstant
    : ATTVAL_ATTRIBUTE
    ;

htmlQuotedElement
    : QUOTE? jspElement QUOTE?
    ;

htmlTagName
    : TAG_IDENTIFIER
    ;

htmlChardata
    : JSP_STATIC_CONTENT_CHARS_MIXED
    | JSP_STATIC_CONTENT_CHARS
    | WHITESPACES
    ;

htmlMisc
    : htmlComment
    | htmlChardata
    | jspExpression
    | scriptlet
    ;

htmlComment
    : JSP_COMMENT_START htmlCommentText? JSP_COMMENT_END 
    | JSP_CONDITIONAL_COMMENT
    ;

htmlCommentText
    : JSP_COMMENT_TEXT+?
    ;

xhtmlCDATA
    : CDATA
    ;

dtd
    : DTD dtdElementName (DTD_PUBLIC publicId)? (DTD_SYSTEM systemId)?  TAG_END
    ;

dtdElementName
    : DTD_IDENTIFIER
    ;

publicId
    : DTD_QUOTED;

systemId
    : DTD_QUOTED;

xml: XML_DECLARATION name=htmlTagName atts+=htmlAttribute*? TAG_END
    ;

scriptlet
    : SCRIPTLET_OPEN BLOB_CONTENT JSP_END    ;

