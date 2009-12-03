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
    <xsl:text>\documentclass[11pt]{thesis}</xsl:text>
  </xsl:template>

  <xsl:template name="latex-paper-size">
  </xsl:template>

  <xsl:template name="latex-header">
    <xsl:text>
\usepackage{ifpdf}
\ifpdf
  \usepackage[pdftex]{geometry} % Use pdftex driver for page layout
\else
  \usepackage{color}            % Color management
  \usepackage{geometry}         % Page layout
\fi
\usepackage[american]{babel}    % American typographical rules
\usepackage[utf8]{inputenc}     % Use UTF-8 input encoding
\usepackage[T1]{fontenc}        % Use T1 font encoding for accents
\usepackage[normalem]{ulem}     % Underlining, but don't change \em behavior
%\usepackage{pslatex}
\usepackage{setspace}           % Line spacing
\usepackage{longtable}          % Continue tables across pages
\usepackage{appendix}           % Appendix title formatting
\usepackage{draftwatermark}     % Show a DRAFT watermark 
\usepackage{hyperref}           % Hypertext cross-references

% Chicago-style bibliography and notes
\usepackage[strict,backend=bibtex8,bibencoding=inputenc]{biblatex-chicago}

%% The lucimatx package is what I use to get the Lucida Bright font in my
%% thesis.  You can get it from pctex.com (
%% http://pctex.com/Lucida_Fonts.html ).  That typeface costs money, so
%% I've commented this out... you should be able to find and install all
%% the other packages for free.
%\usepackage[lucidasmallscale, nofontinfo]{lucimatx}

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

\input{approval}

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
\label{sec:abs}
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

\section*{Preface}
\addcontentsline{toc}{section}{Preface}
\label{sec:preface}
\input{preface}

\pagebreak

\section*{Acknowledgments}
\addcontentsline{toc}{section}{Acknowledgments}
\label{sec:acknowledgments}
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
% Appendices --------------------------------------------------------------------

\appendix
\appendixpage
\addappheadtotoc

\begin{appendices}

\pagebreak
\input{app-cclicense}

\end{appendices}

\end{document}
    </xsl:text>
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
    <xsl:text>\label{cha:</xsl:text>
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
    <xsl:text>\label{sec:</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="html:h3">
  </xsl:template>

  <xsl:template match="html:h4">
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

</xsl:stylesheet>
