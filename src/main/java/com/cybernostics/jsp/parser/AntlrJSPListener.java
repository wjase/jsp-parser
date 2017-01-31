/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cybernostics.jsp.parser;

import java.util.Optional;

/**
 *
 * @author jason //
 */
public class AntlrJSPListener extends JSPParserBaseListener
{

    private final JSPParser parser;

    public AntlrJSPListener(JSPParser parser)
    {
        this.parser = parser;
    }

    @Override
    public void enterJspDocument(JSPParser.JspDocumentContext ctx)
    {;
    }

    @Override
    public void enterJspElement(JSPParser.JspElementContext ctx)
    {
        System.out.println("Element:" + ctx.toStringTree());
        Optional<JSPParser.HtmlContentContext> content = Optional.ofNullable(ctx.htmlContent());
        System.out.println("has content" + content.isPresent());
        ctx.atts.stream()
                .filter(att -> att.name != null)
                .forEach(att -> System.out.println(att.name.getText() + getAttValue(att.value)));

    }

    @Override
    public void enterScriptlet(JSPParser.ScriptletContext ctx)
    {
    }

    @Override
    public void enterJspDirective(JSPParser.JspDirectiveContext ctx)
    {
        System.out.println("JSP Directive:" + ctx.name.getText() + ctx.getRuleIndex());
        ctx.atts.stream().forEach(att -> System.out.println(att.name.getText() + "=>" + att.value.toStringTree()));
        super.enterJspDirective(ctx); //To change body of generated methods, choose Tools | Templates.
    }

    private String cap(String input)
    {
        if (input.length() > 50)
        {
            return input.substring(0, 50) + "...";
        }
        return input;
    }

    private String getAttValue(JSPParser.HtmlAttributeValueContext value)
    {
        return "=>" + (value != null ? value.toStringTree() : "nil");
    }

    @Override
    public void enterHtmlAttributeValueExpr(JSPParser.HtmlAttributeValueExprContext ctx)
    {
        System.out.println("Expresion:" + ctx.toStringTree());
    }

}
