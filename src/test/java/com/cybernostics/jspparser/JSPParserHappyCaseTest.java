package com.cybernostics.jspparser;

import com.cybernostics.jsp.parser.AntlrJSPListener;
import com.cybernostics.jsp.parser.JSPLexer;
import com.cybernostics.jsp.parser.JSPParser;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.BitSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import org.antlr.v4.runtime.ANTLRErrorListener;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Parser;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.atn.ATNConfigSet;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

/**
 *
 * @author jason
 */
@RunWith(Parameterized.class)
public class JSPParserHappyCaseTest
{

    private static Logger LOG = Logger.getLogger(JSPParserHappyCaseTest.class.getName());

    private final File jspFile;

    public JSPParserHappyCaseTest(String name, File JSPFile)
    {
        this.jspFile = JSPFile;

    }

    @Test
    public void shouldParse()
    {

        try
        {
            System.out.println("Testing:" + jspFile.getPath());
            String jspContent = FileUtils.readFileToString(jspFile, Charset.defaultCharset());
            printJSP(jspContent);
        } catch (IOException ex)
        {
            Logger.getLogger(JSPParserHappyCaseTest.class.getName()).log(Level.SEVERE, null, ex);
            Assert.fail("exception thrown");
        }
    }

    @Parameterized.Parameters(name = "{0}")
    public static Iterable<Object[]> data()
    {
        final URL resource = JSPParserHappyCaseTest.class.getClassLoader().getResource("happy_case_files");
        final File file = new File(resource.getFile());
        return Arrays.asList(file.listFiles())
                .stream()
                .filter(it -> it.getName().contains("jsp"))
                //                .filter(it -> it.getName().contains("cset"))
                .sorted()
                .map(eachFile -> Arrays.asList((Object) eachFile.getName(), (Object) eachFile).toArray())
                .collect(Collectors.toList());
    }

    private static void printJSP(String inputText)
    {
        // Get our lexer
        JSPLexer lexer = new JSPLexer(new ANTLRInputStream(inputText));

        // Get a list of matched tokens
        CommonTokenStream tokens = new CommonTokenStream(lexer);

        // Pass the tokens to the parser
        JSPParser parser = new JSPParser(tokens);
        parser.addErrorListener(new ANTLRErrorListener()
        {
            @Override
            public void syntaxError(Recognizer<?, ?> rcgnzr, Object o, int i, int i1, String string, RecognitionException re)
            {
                System.out.println("Syntac Error Line:" + i + ", Col:" + i1);

                throw re;
            }

            @Override
            public void reportAmbiguity(Parser parser, DFA dfa, int i, int i1, BitSet bitset, ATNConfigSet atncs)
            {
                System.out.println("Ambigurity detected Line:" + i + ", Col:" + i1);
            }

            @Override
            public void reportAttemptingFullContext(Parser parser, DFA dfa, int i, int i1, ATNConfigSet atncs)
            {
                System.out.println("AttemptingFullContext:" + i + ", Col:" + i1);
            }

            @Override
            public void reportContextSensitivity(Parser parser, DFA dfa, int i, int i1, ATNConfigSet atncs)
            {
                System.out.println("ContextSensitivity:" + i + ", Col:" + i1);
            }
        });

        printJSPTokens(tokens, lexer);

        // Specify our entry point
        JSPParser.JspDocumentContext documentContext = parser.jspDocument();

        // Walk it and attach our listener
        ParseTreeWalker walker = new ParseTreeWalker();
        AntlrJSPListener listener = new AntlrJSPListener(parser);
        walker.walk(listener, documentContext);
    }

    private static void printJSPTokens(CommonTokenStream tokens, JSPLexer lexer)
    {
        tokens.fill();

        tokens.getTokens().stream().forEach((token) -> tokenInfo(lexer, token));

    }

    private static void tokenInfo(JSPLexer lexer, Token token)
    {
        final int column = token.getCharPositionInLine();
        final String[] tokenNames = lexer.getTokenNames();
        final int type = token.getType();
        final String tokenName = type > 0 ? tokenNames[type] : "<<UNKNOWN>>";
        System.out.println(String.format("(%d,%d) %s -> %s", token.getLine(), column, tokenName, token.getText()));
    }
}
