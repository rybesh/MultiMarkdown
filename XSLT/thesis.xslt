<?xml version='1.0' encoding='utf-8'?>

<!-- XHTML-to-Thesis converter by Ryan Shaw
     specifically designed for use with MultiMarkdown created XHTML

     Uses thesis.cls for LaTeX processing.
     
     MultiMarkdown Version 2.0.b6
     
     $Id: manuscript-novel.xslt 499 2008-03-23 13:03:19Z fletcher $
  -->

<xsl:stylesheet
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:html="http://www.w3.org/1999/xhtml"
   version="1.0">

  <xsl:import href="xhtml2latex.xslt"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="html:html/html:head"/>
    <xsl:apply-templates select="html:html/html:body"/>
    <xsl:call-template name="latex-footer"/>
  </xsl:template>

  <xsl:template match="html:head">
    <xsl:call-template name="latex-document-class"/>
    <xsl:call-template name="latex-paper-size"/>
    <xsl:call-template name="latex-header"/>
    <xsl:apply-templates select="*"/>
    <xsl:call-template name="latex-intro"/>
    <xsl:call-template name="latex-front-matter"/>
    <xsl:call-template name="latex-begin-body"/>
  </xsl:template>


  <xsl:template name="latex-document-class">
    <xsl:text>\documentclass[12pt,openany]{thesis}</xsl:text>
  </xsl:template>

  <xsl:template name="latex-paper-size">
  </xsl:template>

  <xsl:template name="latex-header">
    <xsl:text>
\usepackage[american]{polyglossia} % American typographical rules
\usepackage[babel]{csquotes}       % Context sensitive quotation
\usepackage{fontspec}              % Font selecting commands
\usepackage{xunicode}              % Unicode character macros
\usepackage{xltxtra}               % Some fixes and extras for XeTeX
\usepackage[normalem]{ulem}        % Underlining, but don't change \em behavior
\usepackage{setspace}              % Line spacing
\usepackage{longtable}             % Continue tables across pages
\usepackage{appendix}              % Appendix title formatting
\usepackage{draftwatermark}        % Show a DRAFT watermark 

% Hypertext cross-references
\usepackage[hyperfootnotes=false,colorlinks=true,linkcolor=black,citecolor=black,menucolor=black,urlcolor=black]{hyperref} 

% Chicago-style bibliography and notes
\usepackage[strict,backend=biber,babel=other]{biblatex-chicago}

% Fonts
\defaultfontfeatures{Mapping=tex-text,Scale=MatchLowercase}
\setmainfont[BoldFont={Garamond Premier Pro Semibold}]{Garamond Premier Pro}
\setsansfont{Helvetica Neue LT Pro}
\setmonofont{Monaco}
\newfontface\japanese{Hiragino Mincho Pro}
\newfontface\semibold{Garamond Premier Pro Semibold Subhead}

</xsl:text>
  </xsl:template>

  <xsl:template name="latex-intro">
    <xsl:text>
\bibliography{draft}

\setlength{\topmargin}{-0.5in}
\setlength{\textheight}{9in}
\setlength{\evensidemargin}{0in}
\setlength{\oddsidemargin}{0in}
\setlength{\textwidth}{6.5in}
\newcommand{\todo}[1]{(\textbf{TODO: {#1})}}

\begin{document}
    </xsl:text>
  </xsl:template>	

  <xsl:template name="latex-front-matter">
    <xsl:text>
% Administrative ----------------------------------------------------------------

\pagenumbering{roman}
\pagestyle{empty}

%\input{approval}
\input{title}
\input{copyright}

% Front matter ------------------------------------------------------------------

\pagestyle{plain}

\pagebreak

\singlespacing

% Change back to arabic numbered pages
\pagenumbering{arabic}
% Change back to arabic numbered footnotes
\renewcommand{\thefootnote}{\arabic{footnote}}
% Reset footnote counter
\setcounter{footnote}{0}
\setcounter{page}{1}

\section*{Abstract}
\label{abstract}
\input{abstract}

\pagebreak

% Reset page style and footnote counter
\pagenumbering{roman}
\setcounter{page}{1}

\input{dedication}

\setcounter{tocdepth}{1}
\tableofcontents
\vfill

\pagebreak

%\section*{Preface}
%\addcontentsline{toc}{section}{Preface}
%\label{preface}
%\input{preface}
%
%\pagebreak

\chapter*{Acknowledgments}
\addcontentsline{toc}{section}{Acknowledgments}
\label{acknowledgments}
\input{acknow}

\pagebreak
    </xsl:text>
  </xsl:template>

  <xsl:template name="latex-begin-body">
    <xsl:text>
% Chapters ----------------------------------------------------------------------

% Change back to arabic numbered footnotes
\renewcommand{\thefootnote}{\arabic{footnote}}
% Reset footnote counter
\setcounter{footnote}{0}

% Change back to arabic numbered pages
\pagenumbering{arabic}

</xsl:text>
  </xsl:template>

  <xsl:template name="latex-footer">
    <xsl:text>
% Bibliography ------------------------------------------------------------------

\printbibliography[heading=bibintoc,maxnames=10,minnames=7]

% Appendices --------------------------------------------------------------------

\appendix
\appendixpage
\addappheadtotoc

\begin{appendices}

%\pagebreak
%\input{app-cclicense}

\end{appendices}

\end{document}
    </xsl:text>
  </xsl:template>

  <!-- Anchors -->
  <xsl:template match="html:a[@href]">
    <xsl:param name="footnoteId"/>
    <xsl:choose>
      <!-- footnote (my addition)-->
      <xsl:when test="@class = 'footnote'">
	<xsl:text>\footnote{</xsl:text>
	<xsl:apply-templates select="/html:html/html:body/html:div[@class]/html:ol/html:li[@id]" mode="footnote">
	  <xsl:with-param name="footnoteId" select="@href"/>
	</xsl:apply-templates>
	<xsl:text>}</xsl:text>
      </xsl:when>

      <xsl:when test="@class = 'footnote glossary'">
	<xsl:text>\glossary</xsl:text>
	<xsl:apply-templates select="/html:html/html:body/html:div[@class]/html:ol/html:li[@id]" mode="glossary">
	  <xsl:with-param name="footnoteId" select="@href"/>
	</xsl:apply-templates>
	<xsl:text></xsl:text>
      </xsl:when>

      <xsl:when test="@class = 'reversefootnote'">
      </xsl:when>

      <!-- if href is same as the anchor text, then use \href{} 
	   but no footnote -->
      <!-- let's try \url{} again for line break reasons -->
      <xsl:when test="@href = .">
	<xsl:text>\url{</xsl:text>
	<xsl:call-template name="clean-text">
	  <xsl:with-param name="source">
	    <xsl:value-of select="@href"/>
	  </xsl:with-param>
	</xsl:call-template>		
	<xsl:text>}</xsl:text>
      </xsl:when>

      <!-- if href is mailto, use \href{} -->
      <xsl:when test="starts-with(@href,'mailto:')">
	<xsl:text>\href{</xsl:text>
	<xsl:value-of select="@href"/>
	<xsl:text>}{</xsl:text>
	<xsl:call-template name="clean-text">
	  <xsl:with-param name="source">
	    <xsl:value-of select="substring-after(@href,'mailto:')"/>
	  </xsl:with-param>
	</xsl:call-template>		
	<xsl:text>}</xsl:text>
      </xsl:when>
      
      <!-- if href is local anchor, use autoref -->
      <xsl:when test="starts-with(@href,'#')">
	<xsl:text>\autoref{</xsl:text>
	<xsl:value-of select="substring-after(@href,'#')"/>
	<xsl:text>}</xsl:text>
      </xsl:when>
      
      <!-- otherwise, implement an href and put href in footnote
	   for printed version -->
      <xsl:otherwise>
	<xsl:text>\href{</xsl:text>
	<xsl:value-of select="@href"/>
	<xsl:text>}{</xsl:text>
	<xsl:call-template name="clean-text">
	  <xsl:with-param name="source">
	    <xsl:value-of select="."/>
	  </xsl:with-param>
	</xsl:call-template>		
	<xsl:text>}\footnote{\href{</xsl:text>
	<xsl:value-of select="@href"/>
	<xsl:text>}{</xsl:text>
	<xsl:call-template name="clean-text">
	  <xsl:with-param name="source">
	    <xsl:value-of select="@href"/>
	  </xsl:with-param>
	</xsl:call-template>		
	<xsl:text>}}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Footnotes -->

  <xsl:template match="html:li" mode="footnote">
    <xsl:param name="footnoteId"/>
    <xsl:if test="parent::html:ol/parent::html:div/@class = 'footnotes'">
      <xsl:if test="concat('#',@id) = $footnoteId">
	<xsl:apply-templates select="node()" mode="footnote"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="html:p[last()][parent::html:li[parent::html:ol[parent::html:div[@class='footnotes']]]]" mode="footnote">
    <xsl:param name="footnoteId"/>
    <xsl:apply-templates select="node()" mode="footnote"/>
  </xsl:template>

  <xsl:template match="html:em" mode="footnote">
    <xsl:text>{\itshape </xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="html:a[@href]" mode="footnote">
    <xsl:param name="footnoteId"/>
    <xsl:choose>

      <!-- ignore reversefootnotes -->
      <xsl:when test="@class = 'reversefootnote'"></xsl:when>

      <!-- if href is mailto, use \href{} -->
      <xsl:when test="starts-with(@href,'mailto:')">
	<xsl:text>\href{</xsl:text>
	<xsl:value-of select="@href"/>
	<xsl:text>}{</xsl:text>
	<xsl:call-template name="clean-text">
	  <xsl:with-param name="source">
	    <xsl:value-of select="substring-after(@href,'mailto:')"/>
	  </xsl:with-param>
	</xsl:call-template>		
	<xsl:text>}</xsl:text>
      </xsl:when>
			
      <!-- if href is local anchor, use autoref -->
      <xsl:when test="starts-with(@href,'#')">
	<xsl:choose>
	  <xsl:when test=". = ''">
	    <xsl:text>\autoref{</xsl:text>
	    <xsl:value-of select="substring-after(@href,'#')"/>
	    <xsl:text>}</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="."/>
	    <xsl:text> (\autoref{</xsl:text>
	    <xsl:value-of select="substring-after(@href,'#')"/>
	    <xsl:text>})</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
			
      <!-- otherwise, implement an href -->
      <xsl:otherwise>
        <xsl:text>\url{</xsl:text>
	<xsl:call-template name="clean-text">
	  <xsl:with-param name="source">
	    <xsl:value-of select="@href"/>
	  </xsl:with-param>
	</xsl:call-template>		
	<xsl:text>}</xsl:text>        
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>

  <!-- Bibliography to BibTeX conversion -->

  <xsl:template match="html:span[@class='externalcitation']" mode="footnote">
    <xsl:text>\cite</xsl:text>
    <xsl:apply-templates select="html:span" mode="citation"/>
    <xsl:apply-templates select="html:a" mode="citation"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="html:span[@class='externalcitation']">
    <xsl:text>\autocite</xsl:text>
    <xsl:apply-templates select="html:span" mode="citation"/>
    <xsl:apply-templates select="html:a" mode="citation"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Rename Bibliography -->

  <xsl:template name="rename-bibliography">
    <xsl:param name="source" />
    <xsl:text>\renewcommand\bibname{</xsl:text>
    <xsl:value-of select="$source" />
    <xsl:text>}
    </xsl:text>
  </xsl:template>

  <!-- Convert headers into chapters, etc -->
  
  <xsl:template match="html:h1">
    <xsl:text>\chapter{</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="html:h2">
    <xsl:text>\section{</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="html:h3">
    <xsl:text>\subsection{</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="html:h4">
    <xsl:text>\subsubsection{</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="html:h5">
  </xsl:template>

  <xsl:template match="html:h6">
  </xsl:template>

  <!-- code block -->
  <xsl:template match="html:pre/html:code">
    <xsl:text>\begin{adjustwidth}{2.5em}{2.5em}
      \begin{verbatim}

    </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>
      \end{verbatim}
      \end{adjustwidth}

    </xsl:text>
  </xsl:template>

  <!-- Japanese -->
  <xsl:template match="html:span[@lang='ja']">
    <xsl:text>{\japanese </xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

</xsl:stylesheet>
