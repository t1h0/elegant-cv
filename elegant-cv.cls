% elegant-cv.cls

% \documentstyle{elegant-cv}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Tilman Hornung <mail@tilmanhornung.de>, tilmanhornung.de
% Based on the resume class (github.com/treyhunner/resume), copyright (C) 2010 by Trey Hunner
% Also influenced by Awesome-CV (github.com/posquit0/Awesome-CV): Claud D. Park <posquit0.bj@gmail.com>, posquit0.com
%
% Copying and distribution of this file - with or without modification -
% are permitted in any medium without royalty, provided the copyright
% notice and this notice are preserved. This file is offered as-is,
% without any warranty.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{elegant-cv}[2025/01/06 v1.0 Elegant-CV class]

\LoadClass[12pt,a4paper]{article}

% Page layout
\usepackage[a4paper,margin=1.27cm, bottom=2.54cm, footskip=1.27cm]{geometry}
\usepackage{fancyhdr}
% Text appearance
\usepackage{fontspec}
\usepackage[parfill]{parskip} 
\usepackage{bm}
\usepackage{xcolor}
% Content
\usepackage{pdfpages}
\usepackage{graphicx}
\usepackage[export]{adjustbox}
\usepackage{float}
% Control sequences
\usepackage{environ}
\usepackage{ifthen}
\usepackage{etoolbox}
\usepackage{xstring}
\usepackage{iflang}

\setmainfont{Latin Modern Roman}

\AtEndPreamble{

  \newcommand\pdftitle{CV}
  \IfLanguageName{german}{
    \renewcommand{\pdftitle}{Lebenslauf}}{}

  \fancyfoot[C]{\color{lightgray}\@name~$\cdot$~\pdftitle}
  \fancyfoot[R]{\color{lightgray}\thepage}

  \usepackage{hyperref}
  \hypersetup{
    pdftitle =  \pdftitle,
    pdfauthor = \@name,
    pdfcreator = \@name,
    colorlinks,
    linkcolor=blue,
    urlcolor=blue,
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEAD: Commands for printing name, address, picture, websites, etc.

\def \name#1{\def\@name{#1}}        % \name command can be used to set name
\def \@name {}                      % Set \@name to empty by default

% \address command can be used to set first address
\let \@address \relax
\def \address #1{
  \def \@address {#1}
}
% \contact command can be used to set contact
\let \@contact \relax
\def \contact #1{
  \def \@contact {#1}
}

% \picture command can be used to set picture
\let \@picture \relax
\def \picture #1{
  \def \@picture {#1}
}

% \printsubheader is used to style the subheader
\def \printsubheader #1{
  {
      \centering#1

    }
  \par
  \subheaderskip
}


% \printname is used to print the name as a page header
\def \printname {
  {
      \centering\textbf{\MakeUppercase{\namesize\@name}}

    }
  \par
  \nameskip
}

% for websites

% Command to add a website
\def\website#1#2{%
  \listadd{\websites}{\href{#1}{#2}}
}

% Joinlist command to join strings in a list
\def\joinlist#1#2{%
  \def\delim{#1}%
  \newcounter{ilist}%
  \renewcommand*{\do}[1]{%
    \ifnum\value{ilist}=0
      ##1%
    \else
      \delim##1%
    \fi
    \stepcounter{ilist}%
  }%
  \dolistloop{#2}%
}

% Command to print websites
\def\printwebsites#1{
  \@ifundefined{websites}{}{
    {
        \centering\joinlist{#1}{\websites}

      }
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Certificates

% Counter for certificates
\newcounter{icert}

% Will be used to store pdfs to include
\newcommand{\includepdfs}{}

% Command to add a certificate
\newcommand{\cert}[3][]{%
  \ifstrempty{#1}{%
    \stepcounter{icert}%
    \hyperlink{INTERNALCERTREF\theicert.1}{#3}%
    \edef\temp{\noexpand\gappto{\noexpand\includepdfs}{\noexpand\includepdf[pages=-,link,linkname=INTERNALCERTREF\theicert,pagecommand={}]{#2}}}%
    \temp%
  }{%
    \gappto{\includepdfs}{\includepdf[pages=-,link,linkname=#1,pagecommand={}]{#2}}%
    \hyperlink{#1.1}{#3}%
  }%
}

% Command to add a link to a certificate
\newcommand{\certlink}[2]{%
  \hyperlink{#1}{#2}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DOCUMENT: Create the head of the document

% Text of the head of the document
\def\cvheadtext{                     % Begin document
  \printname                        % Print the name specified with \name
  \@ifundefined{@contact}{}{     % Print the address if specified
    \printsubheader{\@address}}
  \@ifundefined{@address}{}{   % Print the contact if specified
    \printsubheader{\@contact}}
  \printwebsites{ | }
}

% Design the head of the document (with or without picture)
\def\cvhead{
  \@ifundefined{@picture}{
    \cvheadtext
  }{
    \centerline{
      \begin{minipage}{.55\textwidth}
        \cvheadtext
      \end{minipage}
      \hfill
      \begin{minipage}{.45\textwidth}
        \begin{figure}[H]
          \includegraphics[width=\textwidth, right]{\@picture}
        \end{figure}
      \end{minipage}
    }
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SECTIONS: Create section headings

% Used to create large resume section
\NewEnviron{cvSection}[1]{
  \sectionskip
  \textbf{\MakeUppercase{#1}}
  \sectionlineskip
  \hrule
  \begin{list}{}{
      \setlength{\itemsep}{.5em}
      \setlength{\leftmargin}{.5em}
      \vspace{-1.5em}
    }
    \item[]
          \BODY
  \end{list}
}

% Used to format job listing
\NewEnviron{cvEntry}[4]{
  %%%%%%%%%%%%%%%%%%%%%% Default Layout: %%%%%%%%%%%%%%%%%%%%%%$%%
  %%    Title (bold)                     Dates (regular)        %%
  %%    Employer (emphasis)              Location (emphasis)    %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$%%%%%
  \item[]
  \textbf{#1}                 \hfill                  {    #2}% Stop a space
  \ifstrempty{#3}{}{
    \\
    \emph{#3}                \hfill                  \emph{#4}% Stop a space
  }

  \ifstrempty{\BODY}{}{
    \begin{list}{$\cdot$}{
        \setlength{\itemsep}{-.5em}
        \setlength{\leftmargin}{1em}
        \vspace{-1.5em}
      }
      \item[]
            \BODY
    \end{list}
  }
}

\def\namesize{\LARGE}
\def\nameskip{\medskip}
\def\subheaderskip{\smallskip}
\def\sectionskip{\bigskip}
\def\sectionlineskip{\medskip}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPTIONS: Define options for the resume class

\DeclareOption{nocert}{
  \renewcommand{\cert}[3][]{#3}
  \renewcommand{\certlink}[2]{#2}
}
\ProcessOptions\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOOTER

\fancyhfoffset{0em}
\renewcommand{\headrulewidth}{0pt}
\fancyhf{}
\pagestyle{fancy}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Include certificate pdfs at the end of the document

\AtEndDocument{
  % Language check
  \newcommand\certheading{Certificates}
  \IfLanguageName{german}{
    \renewcommand{\certheading}{Zertifikate}}{}

  % Include pdfs
  \ifthenelse{\equal{\includepdfs}{}}{}{
    \newpage
    \phantomsection
    \addcontentsline{toc}{part}{\certheading}
    \vspace*{\fill}
    \begin{center}
      {\Huge\certheading}
    \end{center}
    \vspace*{\fill}
    \includepdfs%
  }
}