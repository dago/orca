## Process this file with automake to produce Makefile.in

SUFFIXES = .pod .1 .man .html .txt .pm .pdf .ps

#AUTOMAKE_OPTIONS        =  foreign

#ACLOCAL_M4 = $(top_srcdir)/config/aclocal.m4

CLEANFILES = *.1 *.html *.txt *-dircache *.pm *.pdf *~ core *itemcache *.rej *.orig

POD = rrdtool.pod rrdlast.pod rrdfirst.pod rrdcreate.pod rrdupdate.pod  rrdtutorial.es.pod \
	cdeftutorial.pod rpntutorial.pod rrdgraph.pod  bin_dec_hex.pod \
	rrdfetch.pod rrdrestore.pod rrddump.pod rrdtune.pod rrdresize.pod \
	rrdcgi.pod rrdtutorial.pod rrdinfo.pod rrdxport.pod rrd-beginners.pod

PMP = RRDs.pm RRDp.pm

MAN = $(POD:.pod=.1) $(PMP:.pm=.1) 
TXT = $(MAN:.1=.txt)
HTML = $(POD:.pod=.html) $(PMP:.pm=.html) 
PS = $(MAN:.1=.ps)
PDF = $(MAN:.1=.pdf)

# what should go into the distribution
EXTRA_DIST= $(POD) $(HTML) $(TXT) rrdtool-dump.dtd   rrdtool-xport.dtd  

# some install rules
idocdir = $(prefix)/doc
idoc_DATA = $(POD) $(TXT)
ihtmldir = $(prefix)/html
ihtml_DATA = $(HTML)
imandir = $(mandir)/man1
iman_DATA = $(MAN)

all-local: link txt man html

.pod.1 .pm.1 .pl.1:
	pod2man --release=$(VERSION) --center=RRDtool $<  > $@

.1.txt:
	@NROFF@ -man -Tlp $< > $@ || echo @NROFF@ failed > $@

.1.ps:
	@TROFF@ -man $< > $@

.ps.pdf:
	distill $<

.pm.html .pod.html .pl.html:
	pod2html --infile=$< --outfile=$@ --noindex --htmlroot=. --podpath=. --title=$*

RRDs.pm:
	ln -s $(top_srcdir)/perl-shared/RRDs.pm .

RRDp.pm:
	ln -s $(top_srcdir)/perl-piped/RRDp.pm .

link: RRDp.pm RRDs.pm

man: $(MAN)

html: $(HTML)

txt: $(TXT)

pdf-local: $(PDF)

