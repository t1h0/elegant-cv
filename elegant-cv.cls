% elegant-cv.cls

% \documentstyle{elegant-cv}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Tilman Hornung <mail@tilmanhornung.de>, tilmanhornung.de
% Based on the resume class (github.com/treyhunner/resume), copyright (C) 2010 by Trey Hunner
% and on Awesome-CV (github.com/posquit0/Awesome-CV): Claud D. Park <posquit0.bj@gmail.com>, posquit0.com
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
\RequirePackage[a4paper,margin=1.27cm, bottom=2.54cm, footskip=1.27cm]{geometry}
\RequirePackage{fancyhdr}
% Text appearance
\RequirePackage{fontspec}
\RequirePackage[parfill]{parskip}
\RequirePackage{bm}
\RequirePackage{xcolor}
% Content
\RequirePackage{fontawesome5}
\RequirePackage{pdfpages}
\RequirePackage{graphicx}
\RequirePackage[export]{adjustbox}
\RequirePackage{float}
% Control sequences
\RequirePackage{environ}
\RequirePackage{ifthen}
\RequirePackage{etoolbox}
\RequirePackage{xstring}
\RequirePackage{iflang}

\setmainfont{Latin Modern Roman}

\AtEndPreamble{

  \newcommand\pdftitle{CV}
  \IfLanguageName{german}{
    \renewcommand{\pdftitle}{Lebenslauf}}{}

  \fancyfoot[C]{\color{lightgray}\@name~$\cdot$~\pdftitle}
  \fancyfoot[R]{\color{lightgray}\thepage}

  \RequirePackage{hyperref}
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
% Icon Setup
\def\iconsep{\space}
\def\contactsep{\space$\cdot$\space}
\def\websitesep{\space|\space}
\def\techstackicon{{\scriptsize\faLayerGroup}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Joinlist command to join strings in a list
\newcounter{ilist}%
\def\joinlist#1#2{%
  \def\delim{#1}%
  \setcounter{ilist}{0}%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEAD: Commands for printing name, address, picture, websites, etc.

\def \@name {}
\def \name#1{\def\@name{#1}}        % \name command can be used to set name

% \address command
\let \@address \relax
\def \address #1{
  \def \@address {#1}
}

% \phone command
\newcommand*{\phone}[2]{
  \listadd{\contacts}{\faMobile\iconsep\href{tel:#1}{#2}}
}
% \mail command
\newcommand*{\mail}[1]{
  \listadd{\contacts}{\faEnvelope\iconsep\href{mailto:#1}{#1}}
}
% \homepage command
\def\homepage#1#2{%
  \listadd{\websites}{\faHome\iconsep\href{#1}{#2}}
}
% \github command
\def\github#1{%
  \listadd{\websites}{\faGithubSquare\iconsep\href{https://github.com/#1}{#1}}
}
% \linkedin command
\def\linkedin#1{%
  \listadd{\websites}{\faLinkedin\iconsep\href{https://www.linkedin.com/in/#1}{#1}}
}
% \picture command can be used to set picture
\let \@picture \relax
\def \picture #1{
  \def \@picture {#1}
}

%%% Print commands %%%

% \printname is used to print the name as a page header
\def \printname {
  {
      \centering\textbf{\MakeUppercase{\namesize\@name}}
      \par
    }
  \nameskip
}

% \printaddress is used to style the subheader
\def \printaddress{
  \@ifundefined{@address}{}{
    {
        \centering\@address
        \par
      }
    \subheaderskip
  }
}

% \printcontacts
\def\printcontacts{
  \@ifundefined{contacts}{}{
    {
        \centering\joinlist{\contactsep}{\contacts}%
        \par
      }
    \subheaderskip
  }
}

% \printwebsites
\def\printwebsites{
  \@ifundefined{websites}{}{
    {
        \centering\joinlist{\websitesep}{\websites}%
        \par
      }
    \subheaderskip
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
  \hyperlink{#1}{#2}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DOCUMENT: Create the head of the document

% Text of the head of the document
\def\cvheadtext{                     % Begin document
  \printname%                        % Print the name specified with \name
  \printaddress%
  \printcontacts%
  \printwebsites%
}

% Design the head of the document (with or without picture)
\def\cvhead{
  \@ifundefined{@picture}{
    \cvheadtext
  }{
    \centerline{
      \begin{minipage}{.65\textwidth}
        \cvheadtext%
      \end{minipage}
      \hfill%
      \begin{minipage}{.35\textwidth}
        \begin{figure}[H]
          \includegraphics[width=\textwidth, right]{\@picture}%
        \end{figure}
      \end{minipage}
    }
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SECTIONS: Create section headings

% Tech-Stack Indicator

\newcommand{\techstack}[1][\techstackicon~Tech-Stack]{%
  #1%
}

% Used to create large resume section
\NewEnviron{cvSection}[2][]{
  \sectionskip
  \ifstrempty{#1}{
    \textbf{\MakeUppercase{#2}}
  }{
    \textbf{\MakeUppercase{#2}} \hfill #1{\parfillskip0pt\par}%
  }
  \sectionlineskip
  \hrule
  \begin{list}{}{
      \setlength{\itemsep}{.5em}
      \setlength{\leftmargin}{.5em}
      \vspace{-1.5em}
    }
    \item[]%
          \BODY%
  \end{list}
}



% Used to format job listing
\NewEnviron{cvEntry}[5][]{
  %%%%%%%%%%%%%%%%%%%%%% Default Layout: %%%%%%%%%%%%%%%%%%%%%%$%%
  %%    Title (bold)                     Dates (regular)        %%
  %%    Employer (emphasis)              Location (emphasis)    %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$%%%%%
  \item[]
  \textbf{#2}                 \hfill                  {    #3}%
  \ifstrempty{#4}{}{
    \\
    \emph{#4}                \hfill                  \emph{#5}%
  }
  \par
  \ifstrempty{#1\BODY}{}{
    \begin{list}{\textbullet}{
        \setlength{\itemsep}{-.5em}
        \setlength{\leftmargin}{1em}
        % \vspace{-1.5em}
      }
      \ifstrempty{#1}{
      \vspace{-1.5em}\item[]
            }{
      \item[\techstackicon] \techstack[#1]%
            }%
            \BODY%
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
      {\Huge\certheading}%
    \end{center}
    \vspace*{\fill}%
    \includepdfs%
  }
}