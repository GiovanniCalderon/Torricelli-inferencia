%% This program is  free software; you can redistribute  it and/or modify
%% it under the  terms of the GNU General Public  License as published by
%% the Free Software Foundation; either  version 2 of the License, or (at
%% your option) any later version.

%% This program  is distributed in the  hope that it will  be useful, but
%% WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
%% MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
%% General Public License for more details.

%% You  should have received  a copy  of the  GNU General  Public License
%% along  with  this  program;  if   not,  write  to  the  Free  Software
%% Foundation, Inc.,  59 Temple Place, Suite 330,  Boston, MA 02111-1307,
%% USA.

%% This is file `amca.cls', the class file for publications
%% of AMCA (Asociacion Argentina de Mecanica Computacional).
%% http://www.amcaonline.org.ar
%% This file is maintained by the AMCA Publication Style Committee.
%% For support contact see http://www.amcaonline.org.ar/
%% 
%% (originally written by Ton van den Boogaard for WCCM IV).
%% 
%% $Id texstuff-1.0.10-18-g74ee5ff Sat Jun 9 23:27:40 2007 -0300$
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{amcaGCS_EDO}[2002/06/10 AMCA paper class]
%
\DeclareOption{10pt}{\OptionNotUsed}
\DeclareOption{11pt}{\OptionNotUsed}
\DeclareOption{twocolumn}{\OptionNotUsed}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
%
\def\amcalanguage{1}
\DeclareOption{spanish}{
  \def\amcalanguage{0}
}
\def\amcapagenumbers{0}
\DeclareOption{pagenumbers}{
  \def\amcapagenumbers{1}
}
%
\DeclareOption{english}{
  \def\amcalanguage{1}
}
%
\DeclareOption{portuguese}{
  \def\amcalanguage{2}
}
%
\def\amcauselinks{1}
\DeclareOption{links}{
  \def\amcauselinks{1}
}
\DeclareOption{nolinks}{
  \def\amcauselinks{0}
}
%
\ProcessOptions\relax
%
\LoadClass[11pt]{article}
%
\RequirePackage{calc}
\RequirePackage{indentfirst}
%
%% Title
%
\renewcommand{\@maketitle}{%
  \newpage
  \null

%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{minipage}[t][1cm][t]{15.5cm}
  \begin{flushright}
    \scriptsize
    \vspace{-50pt}
   % \includegraphics[clip,scale=0.25]{Figuras/OIP.jpg}
    {\fontsize{10}{10}\bf Reportes de GECS. \smallpencil}\\
    {Temas  de Ecuaciones Diferenciales}\\
    $\circledast$ Apuntes usados para clase, 2025\\
    Bucaramanga,  Colombia\\
    %Universidad de Los Andes, La
    %Hechicera, M\'erida 5101, Venezuela\\
    %\copyright 
    
  \end{flushright}
\vspace{-70pt}\hspace{-12pt}
\includegraphics[clip,scale=1.0]{Figuras/Firma.jpg}
\end{minipage}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % \vspace{2cm}%


  \begin{center}%
  \let \footnote \thanks
   {\fontsize{14}{16}\selectfont \bfseries \MakeUppercase{\@title} \par}%
%    {\LARGE \selectfont \bfseries \@title \par}%
    \vskip 12pt%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
      \bfseries   \@author
      \end{tabular}\par}%
     \end{center}%
} % end of \@maketitle


%  {\begin{center}%
%     {\fontsize{14}{16}\selectfont \bfseries \MakeUppercase{\@title} \par}%
%     \vspace{12pt}%
%     {
%        \lineskip .5em%
%        {\setlength{\tabcolsep}{0in}
%        \begin{tabular}[t]{c}%
%          \bfseries \@author
%        \end{tabular}\par} }%
%  \end{center}}% end of \parbox
%  } % end of \@maketitle

%\newcommand{\abstractname}{Abstract}
\renewenvironment{abstract}{%
      \noindent \bfseries \abstractname.%
      \mdseries\small%
}{\thispagestyle{empty}%
%\pagebreak   % cambio del estilo de ENIEF2007 Argentina
}
%
\newenvironment{keywords}
{\noindent\textbf{\keywordsname: }}
{\vspace{12pt}}
%
\renewenvironment{thebibliography}[1]
     {\section*{\refname
        \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \parsep 0pt
            \itemsep 0pt
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
%
\renewcommand{\thesubsection}   {\textup{\thesection.\arabic{subsection}}}
\renewcommand{\thesubsubsection}{\textup{%
    \thesubsection .\arabic{subsubsection}}}
%
\renewcommand{\section}{\@startsection{section}{1}{0mm}%
                                     {-12pt}%
                                     {6pt}%
                                     {\bfseries\normalsize\MakeUppercase}}%
\renewcommand{\subsection}{\@startsection{subsection}{2}{0mm}%
                                     {-12pt}%
                                     {6pt}%
                                     {\bfseries\normalsize}}%







\newcommand{\heading}[1]{\gdef\@heading{#1}}


\def\ps@myheadings{%
    \def\@oddfoot{\normalfont\hfil\thepage\hfil}
    \let\@evenfoot\@oddfoot
    \def\@evenhead{%
        \parbox[t][11.5pt][t]{\textwidth}{%
%\parbox[t][12.5pt][t]{\textwidth}{%
        \centering
        \normalfont
        \fontsize{10}{10}\selectfont
        \@heading\\
\vspace{-.25cm}
        \rule{\textwidth}{.7pt}%
     }
    }%
    \let\@oddhead\@evenhead
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
}




%
% Previously in class `mecom'
\setlength{\oddsidemargin}{0mm}
%\setlength{\evensidemargin}{0mm}
%\setlength{\textheight}{210mm}
%\setlength{\textwidth}{160mm}
\setlength{\textfloatsep}{12pt}
\setlength{\abovedisplayskip}{6pt}
\setlength{\belowdisplayskip}{6pt}
\setlength{\parindent}{5mm}
\setlength{\abovecaptionskip}{6pt}
\setlength{\belowcaptionskip}{6pt}
%
% Previously in `instructions.tex'
\setlength{\textwidth}{16cm}
\setlength{\textheight}{22cm}
%\setlength{\oddsidemargin}{-0.04cm}
%\setlength{\topmargin}{8.1mm}
\setlength{\headheight}{0mm}
\setlength{\headsep}{5mm}
%make-pdf
%\setlength{\affilsep}{0pt}
%
\renewcommand{\@makecaption}[2]{%
  \vspace{\abovecaptionskip}%
  {\fontsize{09}{12}\selectfont
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi}
  \vskip\belowcaptionskip}
%
\def\voidaffil{$\mskip 0mu$}
%
\RequirePackage[noblocks]{authblk}
\renewcommand\Authands{ and }
\renewcommand{\Affilfont}{\mdseries\itshape\small}
\renewcommand{\Authfont}{\bfseries}
%
%\RequirePackage{natbib}
%\bibliographystyle{amca}
%\bibliographystyle{unsrt}   %%%%% AQUIIIIIIIIIIIIIIIIIIIIIIIIII
%\bibpunct{(}{)}{;}{a}{,}{,}
%\setlength{\bibsep}{0pt}
%
\ifnum \amcapagenumbers = 0
\pagestyle{empty}
\fi
%
%
\ifnum \amcalanguage = 0
  \renewcommand\Authand{ y }%
  \renewcommand\Authands{ y }
  \RequirePackage[spanish]{babel}
  \def\keywordsname{Palabras claves}
  \def\amcabtxand{y}
  \addto\captionsspanish{%
     \def\tablename{Tabla}}%
\fi
%
\ifnum \amcalanguage = 1
  \renewcommand\Authand{ and }%
  \renewcommand\Authands{ and }
  \RequirePackage[english]{babel}
  \def\keywordsname{Keywords}
  \def\amcabtxand{and}
\fi
%
\ifnum \amcalanguage = 2
  \renewcommand\Authand{ e }%
  \renewcommand\Authands{ e }
  \RequirePackage[portuguese]{babel}
  \def\keywordsname{Palabras chave}
  \def\amcabtxand{e}
\fi
%
\ifnum \amcauselinks = 1
% Use color links
\RequirePackage{color}
\definecolor{url}{rgb}{0.8,0.,0.}
\RequirePackage[colorlinks,linkcolor=blue,%
                urlcolor=url,citecolor=blue,%
                plainpages=false,pdfpagelabels]{hyperref}
\RequirePackage{nameref,url}
\def\UrlFont{\mdseries}
\fi
%
\RequirePackage{times}



  \pagestyle{myheadings}
