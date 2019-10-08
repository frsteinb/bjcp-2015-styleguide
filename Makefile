
DEFILES		= $(shell ls de/*.xml)
FIXFILES	= $(shell ls fix/*.xml)

default: bjcp-2015-styleguide-orig.xml bjcp-2015-styleguide-de.xml bjcp-2015-styleguide-orig.html bjcp-2015-styleguide-de.html web/edit.html

cache/2015_Guidelines_Beer.docx:
	@if [ ! -d cache ] ; then mkdir cache ; fi
	@curl -s https://www.bjcp.org/docs/2015_Guidelines_Beer.docx -o cache/2015_Guidelines_Beer.docx
	@echo "downloaded $@"

cache/bjcp-2015-styleguide-word.xml: cache/2015_Guidelines_Beer.docx
	@unzip -p cache/2015_Guidelines_Beer.docx word/document.xml | xmllint --format - > cache/bjcp-2015-styleguide-word.xml
	@echo "built $@"

bjcp-2015-styleguide-orig.xml: $(FIXFILES) cache/bjcp-2015-styleguide-word.xml xsl/bjcp-2015-styleguide-doc-to-xml.xsl xsl/bjcp-2015-styleguide-split.xsl
	@bash -c 'xsltproc --output bjcp-2015-styleguide-orig.xml xsl/bjcp-2015-styleguide-doc-to-xml.xsl cache/bjcp-2015-styleguide-word.xml 2> >(grep -v "failed to load external entity")'
	@echo "built $@"
	@if [ ! -d orig ] ; then mkdir orig ; fi
	@xsltproc xsl/bjcp-2015-styleguide-split.xsl bjcp-2015-styleguide-orig.xml
	@echo "built orig/"

bjcp-2015-styleguide-de.xml: de bjcp-2015-styleguide-orig.xml $(DEFILES) xsl/bjcp-2015-styleguide-translate.xsl
	@bash -c 'xsltproc --stringparam lang de --output bjcp-2015-styleguide-de.xml xsl/bjcp-2015-styleguide-translate.xsl bjcp-2015-styleguide-orig.xml 2> >(grep -v "failed to load external entity")'
	@echo "built $@"

bjcp-2015-styleguide-orig.html: xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-orig.xml
	@xsltproc xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-orig.xml > bjcp-2015-styleguide-orig.html
	@echo "built $@"

bjcp-2015-styleguide-de.html: xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-de.xml
	@xsltproc xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-de.xml > bjcp-2015-styleguide-de.html
	@echo "built $@"

web/edit.html: xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-de.xml
	@echo "Document update in progress. Please wait a moment and reload..." > web/edit.html
	@xsltproc --stringparam edit yes --stringparam orig bjcp-2015-styleguide-orig.xml xsl/bjcp-2015-styleguide-html.xsl bjcp-2015-styleguide-de.xml > web/edit.html.tmp
	@mv web/edit.html.tmp web/edit.html
	@echo "built $@"

format:
	@for f in de/*.xml ; do xmllint --format $$f | sed -e 's/ standalone="yes"//' > cache/tmp.xml ; cmp -s cache/tmp.xml $$f ; if [ $$? -ne 0 ] ; then cat cache/tmp.xml > $$f ; echo "reformatted $$f" ; fi ; rm cache/tmp.xml ; done

status: bjcp-2015-styleguide-orig.xml
	@-xsltproc --stringparam lang de xsl/bjcp-2015-styleguide-status.xsl bjcp-2015-styleguide-orig.xml 2>&1 | grep -v "failed to load external entity"


check: bjcp-2015-styleguide-orig.xml bjcp-2015-styleguide-de.xml
	@for f in de/*.xml ; do xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd $$f ; done
	@xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd bjcp-2015-styleguide-orig.xml
	@xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd bjcp-2015-styleguide-de.xml

background:
	@echo "updating in the background..."
	@nohup sh -c 'if [ ! -e .background ] ; then touch .background ; rm -f .background-again bjcp-2015-styleguide-de.xml web/edit.html ; make web/edit.html ; rm .background ; if [ -e .background-again ] ; then rm bjcp-2015-styleguide-de.xml web/edit.html ; make background ; fi ; else touch .background-again ; fi' >/dev/null 2>&1 &

install:
	ssh z "cd /var/www ; if [ -d bjcp-2015-styleguide ] ; then cd bjcp-2015-styleguide ; git pull ; else git clone https://github.com/frsteinb/bjcp-2015-styleguide.git ; cd bjcp-2015-styleguide ; mkdir web/snippets ; sudo chgrp -R www-data . ; sudo chmod g+ws . web web/snippets ; make ; fi"

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

