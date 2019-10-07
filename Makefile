
DEFILES		= $(shell ls de/*.xml)
FIXFILES	= $(shell ls fix/*.xml)

default: bjcp-2015-styleguide-orig.xml bjcp-2015-styleguide-de.xml bjcp-2015-styleguide-orig.html bjcp-2015-styleguide-de.html bjcp-2015-styleguide-de-edit.html

cache/2015_Guidelines_Beer.docx:
	@if [ ! -d cache ] ; then mkdir cache ; fi
	@curl -s https://www.bjcp.org/docs/2015_Guidelines_Beer.docx -o cache/2015_Guidelines_Beer.docx
	@echo "downloaded $@"

cache/bjcp-2015-styleguide-word.xml: cache/2015_Guidelines_Beer.docx
	@unzip -p cache/2015_Guidelines_Beer.docx word/document.xml | xmllint --format - > cache/bjcp-2015-styleguide-word.xml
	@echo "built $@"

bjcp-2015-styleguide-orig.xml: $(FIXFILES) cache/bjcp-2015-styleguide-word.xml xsl/bjcp-2015-styleguide-doc-to-xml.xsl xsl/bjcp-2015-styleguide-split.xsl
	@-xsltproc --output bjcp-2015-styleguide-orig.xml xsl/bjcp-2015-styleguide-doc-to-xml.xsl cache/bjcp-2015-styleguide-word.xml 2>&1 | grep -v "failed to load external entity"
	@echo "built $@"
	@if [ ! -d orig ] ; then mkdir orig ; fi
	@xsltproc xsl/bjcp-2015-styleguide-split.xsl bjcp-2015-styleguide-orig.xml
	@echo "built orig/"

bjcp-2015-styleguide-de.xml: de bjcp-2015-styleguide-orig.xml $(DEFILES) xsl/bjcp-2015-styleguide-translate.xsl
	@-xsltproc --stringparam lang de --output bjcp-2015-styleguide-de.xml xsl/bjcp-2015-styleguide-translate.xsl bjcp-2015-styleguide-orig.xml 2>&1 | grep -v "failed to load external entity"
	@echo "built $@"

bjcp-2015-styleguide-orig.html: xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-orig.xml
	@xsltproc xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-orig.xml > bjcp-2015-styleguide-orig.html
	@echo "built $@"

bjcp-2015-styleguide-de.html: xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-de.xml
	@xsltproc xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-de.xml > bjcp-2015-styleguide-de.html
	@echo "built $@"

bjcp-2015-styleguide-de-edit.html: xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-de.xml
	@xsltproc --stringparam edit yes --stringparam orig bjcp-2015-styleguide-orig.xml xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-de.xml > bjcp-2015-styleguide-de-edit.html
	@echo "built $@"

format:
	@for f in de/*.xml ; do xmllint --format $$f | sed -e 's/ standalone="yes"//' > cache/tmp.xml ; cmp -s cache/tmp.xml $$f ; if [ $$? -ne 0 ] ; then cat cache/tmp.xml > $$f ; echo "reformatted $$f" ; fi ; rm cache/tmp.xml ; done

status: bjcp-2015-styleguide-orig.xml
	@-xsltproc --stringparam lang de xsl/bjcp-2015-styleguide-status.xsl bjcp-2015-styleguide-orig.xml 2>&1 | grep -v "failed to load external entity"


check: bjcp-2015-styleguide-orig.xml bjcp-2015-styleguide-de.xml
	@for f in de/*.xml ; do xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd $$f ; done
	@xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd bjcp-2015-styleguide-orig.xml
	@xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd bjcp-2015-styleguide-de.xml

install: bjcp-2015-styleguide-de-edit.html
	scp bjcp-2015-styleguide-de-edit.html web/bjcp-styleguide.css web/edit-bjcp.js web/edit.css web/edit.js web/pell.css web/pell.js z:/var/www/bjcp-styleguide/

clean:
	@rm -rf orig
	@rm -f bjcp-2015-styleguide-orig.xml
	@rm -f bjcp-2015-styleguide-de.xml
	@rm -f bjcp-2015-styleguide-orig.html
	@rm -f bjcp-2015-styleguide-de.html
	@rm -f bjcp-2015-styleguide-de-edit.html
	@echo "cleanup done"

distclean: clean
	@rm -rf cache
	@echo "complete cleanup done"

