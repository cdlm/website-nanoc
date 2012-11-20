---
title: Citezen
---
<%= render 'partials/markdown_links' %>

# <%= @item[:title] %>

Citezen is a suite of tools for parsing, validating, sorting, and displaying [BibTeX databases][bibtex], integrated with [Pier][].
It aims at replacing and extending [BibTeX][], in Smalltalk; ideally, features would be similar to [BibTeX][], [CrossTeX][], or [CSL][].

[bibtex]: http://www.bibtex.org
[crosstex]: http://www.cs.cornell.edu/people/egs/crosstex/
[csl]: http://xbiblio.sourceforge.net/csl/
[pier]: http://www.piercms.com

### Status

There are several instances of Citezen in use already, to display publication lists in [Pier][] websites, for instance [RMoD](http://rmod.lille.inria.fr/web/pier/publications), [Moose](http://moose.unibe.ch/publications/list), or [Tudor Gîrba's](http://www.tudorgirba.com/publications) websites.

At the moment, the foundations are here but we still need to put it all together so that it becomes a really nice tool in practice; here's what currently exists:

- parsers for `.bib` and `.aux` formats,
- an object model of BibTeX data,
- a system of fill-in phrases to specify how an entry should be formatted independantly of the final format,
- formatters that complete a phrase with data from a BibTeX entry to generate various concrete output formats: plain text, HTML, `.bbl` file for use with LaTeX, `.bib` file to pretty-print/sort/subset bibliographies.

## Loading Citezen

With Metacello:

    Gofer new squeaksource: 'Citezen';
         package: 'ConfigurationOfCitezen';
         load.
    (ConfigurationOfCitezen project latestVersion: #development) load

### Citezen-Pier

This is a package to support ad hoc and fixed queries on a local BibTeX file, and to integrate them into a website powered by the [Pier content management system](http://www.piercms.com).
To try it out, first create a _Bib File_ page, and configure it to point to a local BibTeX file.
You can then also create embeddable components of type _Fixed Query_ and _Query Box_ which should be configured to point to a pre-installed _Bib File_ page.

