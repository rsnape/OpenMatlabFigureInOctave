# OpenMatlabFigureInOctave
A very simple `.m` file to read a `.fig` file and plot it in Octave.

This file was recovered from a [deleted Stack Overflow post][2], referenced [in a LaTeX forum here](http://www.latex-community.org/forum/viewtopic.php?f=46&t=4222).  This code in turn was based on another file which is no longer available on the internet but is [reproduced here](http://www.latex-community.org/forum/viewtopic.php?p=78728#p78728).  The original page is [here on the internet archive][1], but the original `.m` file was not archived.

The original authors are acknowledged in the header comment.

## Functionality

Unpacks the struct that is stored in the `.fig` file (which is a specialisation of the `.mat` format).  Detects lines, scatter plots, surface plots within the struct as well as textual elements.

Quote from the author who expanded the original:

> an expanded version I built based on Cibby's code above. This one includes features such as subplots, markers and marker sizes, scatter plots, text, patches, surfaces, and legends: 

## Usage

    fname = "/path/to/my/figure.fig"
    OpenMatlabFigureInOctave(fname)
    
## Contributions

Contributions are welcome - just send in a pull request.

[1]: http://web.archive.org/web/20100713030737/http://www.ee.usyd.edu.au/~cibby/OCTread_FIG.htm
[2]: http://stackoverflow.com/questions/11902650/program-to-open-fig-files-saved-by-matlab/16490536#16490536
