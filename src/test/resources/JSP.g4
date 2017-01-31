JSPPage : Body;

JSPTagDef : Body;

Body : 
  	  AllBody 
	| ScriptlessBody

//[ vc: ScriptingEnabled ]
//[ vc: ScriptlessBody ]

AllBody : ( ( '<%--' JSPCommentBody )
        | ( '<%@' DirectiveBody )
        | ( '<jsp:directive.' XMLDirectiveBody )
        | ( '<%!' DeclarationBody )
        | ( '<jsp:declaration' XMLDeclarationBody)
        | ( '<%=' ExpressionBody )
        | ( '<jsp:expression' XMLExpressionBody)
        | ( '<%' ScriptletBody )
        | ( '<jsp:scriptlet' XMLScriptletBody )
        | ( '${' ELExpressionBody )
        | ( '#{' ELExpressionBody )
        | ( '<jsp:text' XMLTemplateText )
        | ( '<jsp:' StandardAction )
        | ( '</' ExtraClosingTag )
        | ( '<' CustomAction CustomActionBody )
        | TemplateText
        )*
        ;

ScriptlessBody : ( ( '<%--' JSPCommentBody )
        | ( '<%@' DirectiveBody )
        | ( '<jsp:directive.' XMLDirectiveBody )
        | ( '<%!' <TRANSLATION_ERROR> )
        | ( '<jsp:declaration'
        <TRANSLATION_ERROR> )
        | ( '<%=' <TRANSLATION_ERROR> )
        | ( '<jsp:expression'
        <TRANSLATION_ERROR> )
        | ( '<%' <TRANSLATION_ERROR> )
        | ( '<jsp:scriptlet'
        <TRANSLATION_ERROR> )
        | ( '${' ELExpressionBody )
        | ( '#{' ELExpressionBody )
        | ( '<jsp:text' XMLTemplateText )
        | ( '<jsp:' StandardAction )
        ( ( '</' ExtraClosingTag )
        | ( '<' CustomAction
        CustomActionBody )
        | TemplateText
        )*
        //[ vc: ELEnabled ]
        ;
TemplateTextBody : ( ( '<%--' JSPCommentBody )
        | ( '<%@' DirectiveBody )
        | ( '<jsp:directive.' XMLDirectiveBody )
        | ( '<%!' <TRANSLATION_ERROR> )
        | ( '<jsp:declaration' <TRANSLATION_ERROR> )
        | ( '<%=' <TRANSLATION_ERROR> )
        | ( '<jsp:expression' <TRANSLATION_ERROR> )
        | ( '<%' <TRANSLATION_ERROR> )
        | ( '<jsp:scriptlet' <TRANSLATION_ERROR> )
        | ( '${' <TRANSLATION_ERROR> )
        | ( '#{' <TRANSLATION_ERROR> )
        | ( '<jsp:text' <TRANSLATION_ERROR> )
        | ( '<jsp:' <TRANSLATION_ERROR> )
        | ( '<' CustomAction <TRANSLATION_ERROR> )
        | TemplateText
        )*
        //[ vc: ELEnabled ]
        ;
JSPCommentBody : ( Char* - ( Char* '--%>' ) ) '--%>'
        | <TRANSLATION_ERROR>
        ;

DirectiveBody : JSPDirectiveBody | TagDefDirectiveBody
//[ vc: TagFileSpecificDirectives ]
        ;
XMLDirectiveBody : XMLJSPDirectiveBody | XMLTagDefDirectiveBody
//[ vc: TagFileSpecificXMLDirectives ]
        ;

JSPDirectiveBody : S? ( ( 'page' S PageDirectiveAttrList )
        | ( 'taglib' S TagLibDirectiveAttrList )
        | ( 'include' S IncludeDirectiveAttrList ))S? '%>'
        | <TRANSLATION_ERROR>
        ; 

XMLJSPDirectiveBody: 
          S?( ( 'page' S PageDirectiveAttrList S? ( '/>' | ( '>' S? ETag ) ))
        | ( 'include' S IncludeDirectiveAttrList S? ( '/>' | ( '>' S? ETag ) )))
        | <TRANSLATION_ERROR>

TagDefDirectiveBody: S?( ( 'tag' S TagDirectiveAttrList )
        | ( 'taglib' S TagLibDirectiveAttrList )
        | ( 'include' S IncludeDirectiveAttrList )
        | ( 'attribute' S AttributeDirectiveAttrList )
        | ( 'variable' S VariableDirectiveAttrList ))S? '%>'
        | <TRANSLATION_ERROR>
        ;

XMLTagDefDirectiveBody: ( ( 'tag' S TagDirectiveAttrList S?( '/>' | ( '>' S? ETag ) ))
        | ( 'include' S IncludeDirectiveAttrList S?( '/>' | ( '>' S? ETag ) ))
        | ( 'attribute' S AttributeDirectiveAttrList S?( '/>' | ( '>' S? ETag ) ))
        | ( 'variable' S VariableDirectiveAttrList S?( '/>' | ( '>' S? ETag ) )))
        | <TRANSLATION_ERROR>

 PageDirectiveAttrList: ATTR[ language, extends, import, session,buffer, 
                autoFlush, isThreadSafe, info, errorPage, isErrorPage,
                contentType, pageEncoding,isELIgnored ]
        //[ vc: PageDirectiveUniqueAttr ]

TagLibDirectiveAttrList: ATTR[ !uri, !prefix ]
        | ATTR[ !tagdir, !prefix ]
        //[ vc: TagLibDirectiveUniquePrefix ]

IncludeDirectiveAttrList:ATTR[ !file ]

TagDirectiveAttrList : ATTR[ display-name, body-content, dynamic-attributes, 
                    small-icon, large-icon, description, example, language,
                    import, pageEncoding, isELIgnored ]
//[ vc: TagDirectiveUniqueAttr ]

AttributeDirectiveAttrList:
                ATTR[ !name, required, fragment, rtexprvalue, type, description ]
//[ vc: UniqueAttributeName ]

VariableDirectiveAttrList: ATTR[ !name-given, variable-class, scope, declare, description ]
        | ATTR[ !name-from-attribute, !alias, variable-class, scope, declare, description ]
//[ vc: UniqueVariableName ]

DeclarationBody : ( Char* - ( Char* '%>' ) ) '%>'
        | <TRANSLATION_ERROR> 

XMLDeclarationBody: ( S? '/>' )
        | ( S? '>' ( ( Char* - ( Char* '<' ) ) CDSect? )* ETag )
        | <TRANSLATION_ERROR>

ExpressionBody : ( Char* - ( Char* '%>' ) ) '%>'
        | <TRANSLATION_ERROR>
//[ vc: ExpressionBodyContent ]

XMLExpressionBody: ( S? '/>' )
    | ( S? '>' ( ( Char* - ( Char* '<' ) ) CDSect? )* ETag )
    | <TRANSLATION_ERROR>
//[ vc: ExpressionBodyContent ]

ELExpressionBody : ELExpression '}'
    | <TRANSLATION_ERROR>

ELExpression : [See EL spec document, production Expression]

ScriptletBody : ( Char* - ( Char* '%>' ) ) '%>'
    | <TRANSLATION_ERROR>

XMLScriptletBody : ( S? '/>' )
    | ( S? '>' ( ( Char* - ( Char* '<' ) ) CDSect? )* ETag )
    | <TRANSLATION_ERROR>

StandardAction : ( 'useBean' StdActionContent )
    | ( 'setProperty' StdActionContent )
    | ( 'getProperty' StdActionContent )
    | ( 'include' StdActionContent )
    | ( 'forward' StdActionContent )
    | ( 'plugin' StdActionContent )
    | ( 'invoke' StdActionContent )
    | ( 'doBody' StdActionContent )
    | ( 'element' StdActionContent )
    | ( 'output' StdActionContent )
    | <TRANSLATION_ERROR>
//[ vc: TagFileSpecificActions ]

StdActionContent : Attributes StdActionBody
//[ vc: StdActionAttributesValid ]

StdActionBody : EmptyBody
    | OptionalBody
    | ParamBody
    | PluginBody
//[ vc: StdActionBodyMatch ]

EmptyBody : '/>'
    | ( '>' ETag )
    | ( '>' S? '<jsp:attribute' NamedAttributes ETag )

TagDependentActionBody : JspAttributeAndBody
    | ( '>' TagDependentBody ETag )

TagDependentBody : Char* - ( Char* ETag )

JspAttributeAndBody: ( '>' S? ( '<jsp:attribute'NamedAttributes )? '<jsp:body'
( JspBodyBody |<TRANSLATION_ERROR> )S? ETag)

ActionBody : JspAttributeAndBody
    | ( '>' Body ETag )
ScriptlessActionBody: JspAttributeAndBody
    | ( '>' ScriptlessBody ETag )
OptionalBody : EmptyBody | ActionBody

ScriptlessOptionalBody:EmptyBody | ScriptlessActionBody

TagDependentOptionalBody: EmptyBody | TagDependentActionBody

ParamBody : EmptyBody
    | ( '>' S? ( '<jsp:attribute' NamedAttributes )? '<jsp:body' (JspBodyParam | <TRANSLATION_ERROR>)
    S? ETag ) | ( S? '>' Param* ETag )

PluginBody : EmptyBody
    | ( '>' S? ( '<jsp:attribute' NamedAttributes )? '<jsp:body' ( JspBodyPluginTags | <TRANSLATION_ERROR> ) S? ETag )
    | ( '>' S? PluginTags ETag )

NamedAttributes : AttributeBody S? ( '<jsp:attribute' AttributeBody S? )*

AttributeBody : ATTR[ !name, trim ] S?
        ( '/>'
        | '></jsp:attribute>'
        | '>' AttributeBodyBody '</jsp:attribute>'
        | <TRANSLATION_ERROR>

AttributeBodyBody : AllBody
        | ScriptlessBody
        | TemplateTextBody
        //[ vc: AttributeBodyMatch ]
JspBodyBody : ( S? JspBodyEmptyBody )
    | ( S? '>' ( JspBodyBodyContent - '' ) '</jsp:body>' )

JspBodyBodyContent: ScriptlessBody | Body | TagDependentBody
//[ vc: JspBodyBodyContent ]

JspBodyEmptyBody : '/>'
    | '></jsp:body>'
    | <TRANSLATION_ERROR>

JspBodyParam : S? '>' S? Param* '</jsp:body>'

JspBodyPluginTags : S? '>' S? PluginTags '</jsp:body>'

PluginTags : ( '<jsp:params' Params S? )? ( '<jsp:fallback' Fallback S? )?

Params : '>' S? ( ( '<jsp:body>' ( ( S? Param+ S? '</jsp:body>' )  | <TRANSLATION_ERROR>
))
| Param+ ) '</jsp:params>' 
