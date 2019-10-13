
DEFILES		= $(shell ls de/*.xml)
FIXFILES	= $(shell ls fix/*.xml)

LANG		= de

PROJECTID	= bjcp-styleguide-1570890297003
LOCATION	= us-central1
GLOSSARYID	= bjcp-en-de-glossary

default: bjcp-2015-styleguide-orig.xml bjcp-2015-styleguide-de.xml bjcp-2015-styleguide-orig.html bjcp-2015-styleguide-de.html web/bjcp-2015-styleguide-orig.xml web/bjcp-2015-styleguide-de.xml web/bjcp-2015-styleguide-orig.html web/bjcp-2015-styleguide-de.html web/bjcp-2015-styleguide-de-auto.xml

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

web/bjcp-2015-styleguide-orig.xml: bjcp-2015-styleguide-orig.xml
	cp bjcp-2015-styleguide-orig.xml web/

web/bjcp-2015-styleguide-de.xml: bjcp-2015-styleguide-de.xml
	cp bjcp-2015-styleguide-de.xml web/

web/bjcp-2015-styleguide-de-auto.xml: bjcp-2015-styleguide-de-auto.xml
	cp bjcp-2015-styleguide-de-auto.xml web/bjcp-2015-styleguide-de-auto.xml

web/bjcp-2015-styleguide-orig.html: bjcp-2015-styleguide-orig.html
	cp bjcp-2015-styleguide-orig.html web/

web/bjcp-2015-styleguide-de.html: bjcp-2015-styleguide-de.html
	cp bjcp-2015-styleguide-de.html web/

format:
	@for f in de/*.xml ; do xmllint --format $$f | sed -e 's/ standalone="yes"//' > cache/tmp.xml ; cmp -s cache/tmp.xml $$f ; if [ $$? -ne 0 ] ; then cat cache/tmp.xml > $$f ; echo "reformatted $$f" ; fi ; rm cache/tmp.xml ; done

status: bjcp-2015-styleguide-orig.xml
	@-xsltproc --stringparam lang de xsl/bjcp-2015-styleguide-status.xsl bjcp-2015-styleguide-orig.xml 2>&1 | grep -v "failed to load external entity"

check: bjcp-2015-styleguide-orig.xml bjcp-2015-styleguide-de.xml
	@for f in de/*.xml ; do xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd $$f ; done
	@xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd bjcp-2015-styleguide-orig.xml
	@xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd bjcp-2015-styleguide-de.xml

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

## Web Editor stuff -- this works only with additional manual adjustments

background:
	@nohup sh -c 'if [ ! -e .background ] ; then touch .background ; rm -f .background-again bjcp-2015-styleguide-de.xml web/bjcp-2015-styleguide-de.xml ; make ; rm .background ; if [ -e .background-again ] ; then rm bjcp-2015-styleguide-de.xml web/bjcp-2015-styleguide-de.xml ; make background ; fi ; else touch .background-again ; fi' >/dev/null 2>&1 &

install:
	ssh z "cd /var/www ; if [ -d bjcp-2015-styleguide ] ; then cd bjcp-2015-styleguide ; sudo -u www-data git pull ; sudo -u www-data make ; else sudo -u www-data git clone https://github.com/frsteinb/bjcp-2015-styleguide.git ; cd bjcp-2015-styleguide ; sudo -u www-data mkdir web/snippets ; sudo -u www-data make ; fi"

apply:
	if [ -d web/snippets ] ; then for f in web/snippets/*.xml ; do xsltproc xsl/bjcp-2015-styleguide-apply.xsl $$f ; echo "applied $$f" ; done ; fi

## Google Translate stuff -- this works only for users with a properly configured Google Cloud setup

delete-glossary:
	curl -X DELETE -H "Authorization: Bearer "`gcloud auth application-default print-access-token` https://translation.googleapis.com/v3beta1/projects/$(PROJECTID)/locations/$(LOCATION)/glossaries/$(GLOSSARYID)

bjcp-2015-styleguide-de-auto.xml: bjcp-2015-styleguide-orig.xml
	cat bjcp-2015-styleguide-orig.xml | ./translate | xmllint --format - > bjcp-2015-styleguide-de-auto.xml

