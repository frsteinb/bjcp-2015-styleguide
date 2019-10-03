
default: bjcp-2015-styleguide-orig.xml orig

cache/2015_Guidelines_Beer.docx:
	if [ ! -d cache ] ; then mkdir cache ; fi
	curl https://www.bjcp.org/docs/2015_Guidelines_Beer.docx -o cache/2015_Guidelines_Beer.docx

cache/bjcp-2015-styleguide-word.xml: cache/2015_Guidelines_Beer.docx
	unzip -p cache/2015_Guidelines_Beer.docx word/document.xml | xmllint --format - > cache/bjcp-2015-styleguide-word.xml

bjcp-2015-styleguide-orig.xml: cache/bjcp-2015-styleguide-word.xml xsl/bjcp-2015-styleguide-doc-to-xml.xsl
	xsltproc xsl/bjcp-2015-styleguide-doc-to-xml.xsl cache/bjcp-2015-styleguide-word.xml | xmllint --format - > bjcp-2015-styleguide-orig.xml

orig: bjcp-2015-styleguide-orig.xml xsl/bjcp-2015-styleguide-split.xsl
	if [ ! -d orig ] ; then mkdir orig ; fi
	xsltproc xsl/bjcp-2015-styleguide-split.xsl bjcp-2015-styleguide-orig.xml

clean:
	rm -rf cache orig
	rm -f bjcp-2015-styleguide-orig.xml

