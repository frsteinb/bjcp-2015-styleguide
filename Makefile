
DEFILES		= $(shell ls de/*.xml)
FIXFILES	= $(shell ls fix/*.xml)

# Target Language
LANG		= de

# Google Translate API configuration
PROJECTID	= bjcp-styleguide-1570890297003
LOCATION	= us-central1
GLOSSARYID	= bjcp-en-de-glossary

default: bjcp-2015-styleguide-orig.xml bjcp-2015-styleguide-de.xml web/bjcp-2015-styleguide-orig.xml web/bjcp-2015-styleguide-de.xml web/bjcp-2015-styleguide-de-auto.xml wordpress-orig.sql wordpress-de.sql wordpress-hbcon.sql bjcp-2015-styleguide-orig.pdf bjcp-2015-styleguide-de.pdf

cache/2015_Guidelines_Beer.docx:
	@if [ ! -d cache ] ; then mkdir cache ; fi
	@echo "downloading $@"
	@curl -s https://www.bjcp.org/docs/2015_Guidelines_Beer.docx -o cache/2015_Guidelines_Beer.docx

cache/bjcp-2015-styleguide-word.xml: cache/2015_Guidelines_Beer.docx
	@echo "building $@"
	@unzip -p cache/2015_Guidelines_Beer.docx word/document.xml | xmllint --format - > cache/bjcp-2015-styleguide-word.xml

bjcp-2015-styleguide-orig.xml: $(FIXFILES) cache/bjcp-2015-styleguide-word.xml xsl/bjcp-2015-styleguide-doc-to-xml.xsl xsl/bjcp-2015-styleguide-split.xsl
	@echo "building $@"
	@bash -c 'xsltproc --output bjcp-2015-styleguide-orig.xml xsl/bjcp-2015-styleguide-doc-to-xml.xsl cache/bjcp-2015-styleguide-word.xml 2> >(grep -v "failed to load external entity")'
	@if [ ! -d orig ] ; then mkdir orig ; fi
	@echo "building orig/"
	@xsltproc xsl/bjcp-2015-styleguide-split.xsl bjcp-2015-styleguide-orig.xml

bjcp-2015-styleguide-de.xml: de bjcp-2015-styleguide-orig.xml $(DEFILES) xsl/bjcp-2015-styleguide-translate.xsl
	@echo "building $@"
	@bash -c 'xsltproc --stringparam lang de --output bjcp-2015-styleguide-de.xml xsl/bjcp-2015-styleguide-translate.xsl bjcp-2015-styleguide-orig.xml 2> >(grep -v "failed to load external entity")'

web/bjcp-2015-styleguide-orig.xml: bjcp-2015-styleguide-orig.xml
	@cp bjcp-2015-styleguide-orig.xml web/

web/bjcp-2015-styleguide-de.xml: bjcp-2015-styleguide-de.xml
	@cp bjcp-2015-styleguide-de.xml web/

web/bjcp-2015-styleguide-de-auto.xml: cache/bjcp-2015-styleguide-de-auto.xml
	@cp cache/bjcp-2015-styleguide-de-auto.xml web/bjcp-2015-styleguide-de-auto.xml

format:
	@for f in de/*.xml ; do xmllint --format $$f | sed -e 's/ standalone="yes"//' > cache/tmp.xml ; cmp -s cache/tmp.xml $$f ; if [ $$? -ne 0 ] ; then echo "reformatting $$f" cat cache/tmp.xml > $$f ; ; fi ; rm cache/tmp.xml ; done

status: bjcp-2015-styleguide-orig.xml
	@-xsltproc --stringparam lang de xsl/bjcp-2015-styleguide-status.xsl bjcp-2015-styleguide-orig.xml 2>&1 | grep -v "failed to load external entity"

check: bjcp-2015-styleguide-orig.xml bjcp-2015-styleguide-de.xml
	@for f in de/*.xml ; do xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd $$f ; done
	@xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd bjcp-2015-styleguide-orig.xml
	@xmllint --noout --schema xsd/bjcp-styleguide-2015.xsd bjcp-2015-styleguide-de.xml

wordpress-orig.sql: bjcp-2015-styleguide-orig.xml xsl/wordpress-posts.xsl xsl/config-orig.xsl
	@echo "building $@"
	@cp xsl/config-orig.xsl cache/config-current.xsl
	@xsltproc --stringparam tableprefix wp xsl/wordpress-posts.xsl bjcp-2015-styleguide-orig.xml > wordpress-orig.sql

wordpress-de.sql: bjcp-2015-styleguide-de.xml xsl/wordpress-posts.xsl xsl/config-orig.xsl xsl/config-de.xsl
	@echo "building $@"
	@cp xsl/config-de.xsl cache/config-current.xsl
	@xsltproc --stringparam tableprefix wp --stringparam lang de xsl/wordpress-posts.xsl bjcp-2015-styleguide-de.xml > wordpress-de.sql

wordpress-hbcon.sql: bjcp-2015-styleguide-de.xml xsl/wordpress-posts.xsl xsl/config-orig.xsl xsl/config-de.xsl
	@echo "building $@"
	@cp xsl/config-de.xsl cache/config-current.xsl
	@xsltproc --stringparam userid 4 --stringparam tableprefix wp --stringparam lang de xsl/wordpress-posts.xsl bjcp-2015-styleguide-de.xml > wordpress-hbcon.sql

bjcp-2015-styleguide-orig.fo: bjcp-2015-styleguide-orig.xml xsl/fo.xsl xsl/config-orig.xsl
	@cp xsl/config-orig.xsl cache/config-current.xsl
	@xsltproc xsl/fo.xsl bjcp-2015-styleguide-orig.xml > bjcp-2015-styleguide-orig.fo

bjcp-2015-styleguide-orig.pdf: bjcp-2015-styleguide-orig.fo
	@echo "building $@"
	@fop -q bjcp-2015-styleguide-orig.fo bjcp-2015-styleguide-orig.pdf 2>&1 | egrep -v '(org.apache.fop.events.LoggingEventListener processEvent|Rendered page)'

bjcp-2015-styleguide-de.fo: bjcp-2015-styleguide-de.xml xsl/fo.xsl xsl/config-de.xsl 
	@cp xsl/config-de.xsl cache/config-current.xsl
	@xsltproc --stringparam lang de xsl/fo.xsl bjcp-2015-styleguide-de.xml > bjcp-2015-styleguide-de.fo

bjcp-2015-styleguide-de.pdf: bjcp-2015-styleguide-de.fo
	@echo "building $@"
	@fop -q bjcp-2015-styleguide-de.fo bjcp-2015-styleguide-de.pdf 2>&1 | egrep -v '(org.apache.fop.events.LoggingEventListener processEvent|Rendered page)'

clean:
	@echo "cleanup"
	@rm -rf orig
	@rm -f bjcp-2015-styleguide-orig.xml
	@rm -f bjcp-2015-styleguide-de.xml
	@rm -f web/bjcp-2015-styleguide-orig.xml
	@rm -f web/bjcp-2015-styleguide-de.xml
	@rm -f web/bjcp-2015-styleguide-de-auto.xml
	@rm -f wordpress-remove.sql wordpress-orig.sql wordpress-de.sql wordpress-hbcon.sql
	@rm -f bjcp-2015-styleguide-orig.fo bjcp-2015-styleguide-de.fo
	@rm -f bjcp-2015-styleguide-orig.pdf bjcp-2015-styleguide-de.pdf
	@rm -f cache/config-current.xsl
	@rm -f cache/bjcp-2015-styleguide-word.xml

distclean: clean
	@echo "complete cleanup"
	@rm -rf cache

## Web Editor stuff -- this works only with additional manual adjustments

background:
	@nohup sh -c 'if [ ! -e .background ] ; then touch .background ; rm -f .background-again bjcp-2015-styleguide-de.xml web/bjcp-2015-styleguide-de.xml ; make ; if [ -e .git-push ] ; then rm .git-push ; git pull ; git push ; fi ; rm .background ; if [ -e .background-again ] ; then rm bjcp-2015-styleguide-de.xml web/bjcp-2015-styleguide-de.xml ; make background ; fi ; else touch .background-again ; fi' >/dev/null 2>&1 &

install-home:
	ssh z "cd /var/www ; if [ -d bjcp-2015-styleguide ] ; then cd bjcp-2015-styleguide ; sudo -u www-data git pull ; sudo -u www-data make ; else sudo -u www-data git clone https://github.com/frsteinb/bjcp-2015-styleguide.git ; cd bjcp-2015-styleguide ; sudo -u www-data mkdir web/snippets ; sudo -u www-data make ; fi"

install-hbcon:
	ssh hbcon "cd /var/data/docker/bjcp/webroot ; if [ -d bjcp-2015-styleguide ] ; then cd bjcp-2015-styleguide ; git pull ; make ; else git clone https://github.com/frsteinb/bjcp-2015-styleguide.git ; cd bjcp-2015-styleguide ; mkdir web/snippets ; make ; fi ; chmod -R o+w ."

apply:
	@if [ -d web/snippets ] ; then for f in web/snippets/*.xml ; do xsltproc xsl/bjcp-2015-styleguide-apply.xsl $$f ; echo "applied $$f" ; done ; else echo "nothing to apply from web/snippets" ; fi
	@if [ -d $(HOME)/bjcp/snippets ] ; then for f in $(HOME)/bjcp/snippets/*.xml ; do xsltproc xsl/bjcp-2015-styleguide-apply.xsl $$f ; echo "applied $$f" ; done ; else echo "nothing to apply from $(HOME)/bjcp/snippets" ; fi
	@make format

## Google Translate stuff -- this works only for users with a properly configured Google Cloud setup

translate: cache/bjcp-2015-styleguide-de-auto.xml

cache/bjcp-2015-styleguide-de-auto.xml:
	@if [ "$$GOOGLE_APPLICATION_CREDENTIALS" ] ; then echo "starting Google translation, be patient..." ; cat bjcp-2015-styleguide-orig.xml | ./translate | xmllint --format - > cache/bjcp-2015-styleguide-de-auto.xml ; else if [ `hostname` != "zbox" ] ; then echo "downloading auto-translated version" ; curl -s https://familie-steinberg.org/bjcp-styleguide/bjcp-2015-styleguide-de-auto.xml > cache/bjcp-2015-styleguide-de-auto.xml ; fi ; fi

delete-glossary:
	curl -X DELETE -H "Authorization: Bearer "`gcloud auth application-default print-access-token` https://translation.googleapis.com/v3beta1/projects/$(PROJECTID)/locations/$(LOCATION)/glossaries/$(GLOSSARYID)

## WordPress stuff

wordpress-orig: wordpress-orig.sql
	scp wordpress-orig.sql z:/tmp ; ssh Z 'mysql wordpress < /tmp/wordpress-orig.sql'

wordpress-de: wordpress-de.sql
	scp wordpress-de.sql z:/tmp ; ssh Z 'mysql wordpress < /tmp/wordpress-de.sql'

wordpress-remove.sql:
	echo 'DELETE FROM `wp_posts` WHERE post_content LIKE "<!-- auto-generated bjcp post -->%";' > wordpress-remove.sql

wordpress-remove: wordpress-remove.sql
	mysql wordpress < wordpress-remove.sql

## Exports Hacks to HBCon Nextcloud

export-orga: wordpress-hbcon.sql bjcp-2015-styleguide-orig.fo bjcp-2015-styleguide-de.fo bjcp-2015-styleguide-orig.pdf bjcp-2015-styleguide-de.pdf
	if [ `hostname -s` == "alu" ] ; then cp wordpress-hbcon.sql bjcp-2015-styleguide-orig.fo bjcp-2015-styleguide-de.fo bjcp-2015-styleguide-orig.pdf bjcp-2015-styleguide-de.pdf $$HOME/HBCon/BJCP/fsb/ ; fi
