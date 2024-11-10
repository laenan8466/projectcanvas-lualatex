% File: projectcanvas-lualatex.cls
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{projectcanvas-lualatex}[2024/11/10 Custom LuaLaTeX Document Class with Two-Column Layout and Boxes]

\LoadClass[12pt]{article}

% ---------------------------------------------------------------------------- %
%                              CLASS OPTION                                    %
% ---------------------------------------------------------------------------- %

% Packages for formatting
\RequirePackage{geometry}     % Page margins and layout
\RequirePackage{xcolor}       % Colors
\RequirePackage{tcolorbox}    % Boxes with rounded corners
\RequirePackage{multicol}     % Multi-column text
% \RequirePackage{changepage}    % Adjust width of columns
% Draw things (needed for the header). Load before color package!
\RequirePackage{tikz}


% ---------------------------------------------------------------------------- %
%                                LENGTH & SIZES & COLORS                       %
% ---------------------------------------------------------------------------- %

% Definition of colors (user can modify these)
\definecolor{main}{RGB}{11, 59, 24}
\definecolor{title}{RGB}{11, 59, 24}

\definecolor{boxcolor}{RGB}{161, 180, 63}
\definecolor{acent}{RGB}{56, 108, 95}

% Size of the margin
\newlength{\margin}
\setlength{\margin}{15mm}

% Size of the left column
\newlength{\leftcol}
\setlength{\leftcol}{32 mm}

% Height of the header
\newlength{\hdrheight}
\setlength{\hdrheight}{35mm}

% Height of the Name&Picture on first page
\newlength{\fhdrheight}
\setlength{\fhdrheight}{\hdrheight}

% Vertical space between rows/paragraphs
\newlength{\vspacepar}
\setlength{\vspacepar}{0.6\baselineskip}

% Horizontal space before and after vertical bar (|) between address and
% the contact details
\newlength{\hspaddress}
\setlength{\hspaddress}{1em}

% Horizontal space after font awesome icons
\newcommand{\FAspace}{\hspace{0.5 em}}

% Left indentation (before the bullet) of an itemized list
\setlength{\leftmargini}{2em}


% ---------------------------------------------------------------------------- %
%                                     FONTS                                    %
% ---------------------------------------------------------------------------- %

% # REQUIRED PACKAGES
% Needed to run XeLaTeX
\RequirePackage{fontspec}
% Important to add, else fontawesome will not work with XeLaTeX
\defaultfontfeatures{
  Path = Fonts/
}
% Load cool icons, such as the linked in logo
\RequirePackage{fontawesome}

\setmainfont{SourceSansPro}[
  Path = Fonts/,
  Extension = .otf ,
  UprightFont = *-Light,
  ItalicFont = *-LightIt,
  BoldFont = *-Semibold,
]

\newfontfamily\titlefont{AdventPro}[
  Path = Fonts/,
  Extension = .ttf,
  UprightFont = *-ExtraLight,
  BoldFont = *-SemiBold,
]


% Page and margin settings
\geometry{a4paper, top=\fhdrheight, bottom=2cm, left=\margin, right=\margin}
\setlength{\parindent}{0pt}   % No paragraph indentation


% ---------------------------------------------------------------------------- %
%                                   HEADER                                     %
% ---------------------------------------------------------------------------- %

% Separator with a horizontal space before and after. Is used in the header as
% a separator between address and contact details
\newcommand{\sep}{\hspace{\hspaddress} | \hspace{\hspaddress}}

% This places a header on top of the page.
% #1 First name
% #2 Last name
% #3 = Address
% #4 = Phone, mail and LinkedIn
\newcommand{\header}[4]{%
  \begin{tikzpicture}[remember picture, overlay]
    % Colored bar on top of the page
    \node[
        below right,
        fill=main,
        minimum height=\fhdrheight,%\hdrheight,
        minimum width=\paperwidth,
        outer sep=0,
      ] (headerblock) at (current page.north west) {};
    % Node for the name
    \node[
        anchor= south west,
        text=white,
        %inner sep=0.25 cm, % this correct the offset
        xshift = \margin,
        yshift = -0.4 cm,
      ] (name) at (headerblock.west) {%
        \fontsize{40pt}{32pt}\color{white}%
        {\titlefont \textbf{#1~}\par}
        };
    % Website/Repository
    \node[
        anchor=north west,
        text=white,
        % xshift=0.02 cm,
      ] (website) at (name.south west)  {#2\par};
    % Name Author
    \node[
        anchor=base east,
        text=white,
        % yshift=-0.1 cm,
        xshift=-\margin ,
      ] (authorname) at (headerblock.east |- name.base) {%
      \fontsize{18pt}{16pt}\color{white}%
      \titlefont\textbf{#3}\par};
    % Phone/mail/nationality
    \node[
        anchor=base east,
        text=white,
        % yshift=-0.25 cm,
        ] (authorcontact) at (authorname.east |- website.base) {#4\par};

    % \draw[dashed] (name.base) -- (authorname.base east) -- (authorcontact.base east) -- (website.base); % Debug for aligment
\end{tikzpicture}
}

% Places a picture on the top left of the page
\newcommand{\photo}[1]{%
  \begin{tikzpicture}[remember picture, overlay]
    \node[
        anchor=north west,
        inner sep=0 pt,
        outer sep=0 pt,
      ] at (current page.north west)
        {\includegraphics[height=\fhdrheight]{#1}\par};
  \end{tikzpicture}%
  % Fix when picture is added, else the text moves down.
  \vspace*{-1.5\baselineskip}
  \vspace*{\efhdrheight} % corrects if header has different height for the first page
}%



% ---------------------------------------------------------------------------- %
%                                     BOXES                                    %
% ---------------------------------------------------------------------------- %

% Definition of flexible two-column layout
\newenvironment{flexcolumns}[2]{
    \setlength{\columnsep}{0.5\margin}  % Column separation space
    \begin{multicols}{2}
    %   \begin{adjustwidth}{#1}{#2}  % Adjust column widths
    }{
    %   \end{adjustwidth}
    \end{multicols}
    }

% Style for the boxes
\newtcolorbox{topicbox}[2][]{%
  colback=#2!8!white,    % Background color with transparency
  colframe=#2,            % Frame color
  coltitle=white,         % Title color
  fonttitle=\bfseries\fontsize{14pt}{12pt}\titlefont,    % Bold title
  rounded corners,        % Rounded corners
%   sharp corners=south,    % Only bottom corners are sharp
  title=#1,               % Box title
  boxrule=2pt,            % Border thickness
  width=\linewidth,       % Box width (automatically adjustable)
  top=6pt, bottom=8pt,    % Vertical padding
  left=4pt, right=4pt     % Horizontal padding
}


