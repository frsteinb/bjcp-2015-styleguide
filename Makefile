
default: bjcp-2015-styleguide-orig.xml orig bjcp-2015-styleguide-de.xml bjcp-2015-styleguide-orig.html bjcp-2015-styleguide-de.html

cache/2015_Guidelines_Beer.docx:
	if [ ! -d cache ] ; then mkdir cache ; fi
	curl https://www.bjcp.org/docs/2015_Guidelines_Beer.docx -o cache/2015_Guidelines_Beer.docx

cache/bjcp-2015-styleguide-word.xml: cache/2015_Guidelines_Beer.docx
	unzip -p cache/2015_Guidelines_Beer.docx word/document.xml | xmllint --format - > cache/bjcp-2015-styleguide-word.xml

bjcp-2015-styleguide-orig.xml: cache/bjcp-2015-styleguide-word.xml xsl/bjcp-2015-styleguide-doc-to-xml.xsl
	xsltproc xsl/bjcp-2015-styleguide-doc-to-xml.xsl cache/bjcp-2015-styleguide-word.xml > bjcp-2015-styleguide-orig.xml

orig: bjcp-2015-styleguide-orig.xml xsl/bjcp-2015-styleguide-split.xsl
	if [ ! -d orig ] ; then mkdir orig ; fi
	xsltproc xsl/bjcp-2015-styleguide-split.xsl bjcp-2015-styleguide-orig.xml

bjcp-2015-styleguide-de.xml: orig de xsl/bjcp-2015-styleguide-translate.xsl
	xsltproc --stringparam lang de xsl/bjcp-2015-styleguide-translate.xsl bjcp-2015-styleguide-orig.xml > bjcp-2015-styleguide-de.xml

bjcp-2015-styleguide-orig.html: xsl/bjcp-2015-styleguide-html.xsl
	xsltproc xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-orig.xml > bjcp-2015-styleguide-orig.html

bjcp-2015-styleguide-de.html: xsl/bjcp-2015-styleguide-html.xsl
	xsltproc xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-de.xml > bjcp-2015-styleguide-de.html

test: bjcp-2015-styleguide-orig.xml bjcp-2015-styleguide-de.xml
	xmllint --noout bjcp-2015-styleguide-orig.xml
	xmllint --noout bjcp-2015-styleguide-de.xml

clean:
	rm -rf cache orig
	rm -f bjcp-2015-styleguide-orig.xml
	rm -f bjcp-2015-styleguide-de.xml
	rm -f bjcp-2015-styleguide-orig.html
	rm -f bjcp-2015-styleguide-de.html

