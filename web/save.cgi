#!/usr/bin/python3

import os
import os.path
import re
import sys
import urllib.parse
import codecs
import time
import datetime
import subprocess



#DIR = "/var/www/bjcp-2015-styleguide"
DIR = "%s/.." % os.environ["CONTEXT_DOCUMENT_ROOT"]
LOGFILE = "%s/web/logfile" % DIR
SNIPPETDIR = "%s/web/snippets" % DIR
LANG = "de"



def log(msg):
    time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    f = open(LOGFILE, "a+")
    f.write("%s %s\n" % (time, msg))
    f.close()



def docmd(cmd):
    log("executing: %s" % cmd)
    try:
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
        stdout, stderr = p.communicate()
        for line in stdout.decode("utf-8").split("\n"):
            log("--- %s" % (line))
        if p.returncode != 0:
            log("command failed (return code %d)" % (p.returncode))
    except Exception as error:
        log("ERROR: %s" % (error))



os.chdir(DIR)

print("Content-Type: text/plain; charset=UTF-8")
print("")

if "QUERY_STRING" in os.environ:
    form = urllib.parse.parse_qs(os.environ["QUERY_STRING"], keep_blank_values=False, strict_parsing=False, encoding='utf-8', errors='replace', max_num_fields=50)
else:
    form = {}
    
level = None

if "id" in form:
    id = form["id"][0]
    id = re.sub(r'[^a-zA-Z0-9\-]+', '', id)
    if re.match(r'^[0-9]+$', id):
        level = 1
    elif re.match(r'^[0-9]+[A-Z]-.*$', id):
        level = 3
        id1 = re.sub(r'^([0-9]+)[A-Z]-.*$', r'\1', id)
        id2 = re.sub(r'^([0-9]+[A-Z])-.*$', r'\1', id)
    else:
        level = 2
        id1 = re.sub(r'^([0-9]+).*$', r'\1', id)
else:
    id = "unknown"
    
if "elem" in form:
    elem = form["elem"][0]
    elem = re.sub('[^a-z\-]+', '', elem)
else:
    elem = "unknown"
    
if "user" in form:
    user = form["user"][0]
    elem = re.sub('[^a-zA-Z0-9_+@\-]+', '', elem)
else:
    user = "unknown"

if "REMOTE_ADDR" in os.environ:
    addr = os.environ["REMOTE_ADDR"]
else:
    addr = "unknown"


data = sys.stdin.buffer.read()
len = len(data)
data = data.decode("utf-8")

time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
filename = "snippet-%s-%d.xml" % (time.replace(" ", "-").replace(":", "-"), os.getpid())
snippetfilename = "%s/%s" % (SNIPPETDIR, filename)
msg = "received %d bytes for id %s elem %s from %s by %s to %s" % (len, id, elem, addr, user, filename)

log(msg)

f = codecs.open(snippetfilename, "w", "utf-8")
f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
f.write('<styleguide xmlns="http://heimbrauconvention.de/bjcp-styleguide/2015">\n')
#f.write('<!-- snippet supplied by %s from %s at %s -->\n' % (user, addr, time))
if level == 1:
    f.write('  <category id="%s">\n' % id)
    f.write('    <%s date="%s" author="%s" addr="%s">%s</%s>\n' % (elem, time, user, addr, data, elem))
    f.write('  </category>\n')
elif level == 2:
    f.write('  <category id="%s">\n' % id1)
    f.write('    <subcategory id="%s">\n' % id)
    f.write('      <%s date="%s" author="%s" addr="%s">%s</%s>\n' % (elem, time, user, addr, data, elem))
    f.write('    </subcategory>\n')
    f.write('  </category>\n')
elif level == 3:
    f.write('  <category id="%s">\n' % id1)
    f.write('    <subcategory id="%s">\n' % id2)
    f.write('      <subcategory id="%s">\n' % id)
    f.write('        <%s date="%s" author="%s" addr="%s">%s</%s>\n' % (elem, time, user, addr, data, elem))
    f.write('      </subcategory>\n')
    f.write('    </subcategory>\n')
    f.write('  </category>\n')
else:
    f.write('  <!-- ID %s could not be parsed -->\n')
 
f.write('</styleguide>\n')
f.close()

origfilename = "%s/orig/%s.xml" % (DIR, id)
translatedfilename = "%s/%s/%s.xml" % (DIR, LANG, id)
doadd = not os.path.isfile(translatedfilename)

if os.path.isfile(translatedfilename) or os.path.isfile(origfilename):

    log("applying snippet to %s directory" % LANG)
    cmd = "xsltproc xsl/bjcp-2015-styleguide-apply.xsl %s" % (snippetfilename)
    docmd(cmd)

    log("reformatting %s/%s.xml" % (LANG, id))
    cmd = 'xmllint --format %s/%s.xml | sed -e \'s/ standalone="yes"//\' > cache/tmp.xml ; cmp -s cache/tmp.xml %s/%s.xml ; if [ $? -ne 0 ] ; then cat cache/tmp.xml > %s/%s.xml ; fi ; rm cache/tmp.xml' % (LANG, id, LANG, id, LANG, id)
    docmd(cmd)

    if doadd:
        log("adding new file %s/%s.xml to local repository" % (LANG, id))
        cmd = 'git add %s/%s.xml' % (LANG, id)
        docmd(cmd)

    log("committing to local repository")
    cmd = 'git commit -q -m "%s %s by %s from %s" %s/%s.xml' % (id, elem, user, addr, LANG, id)
    docmd(cmd)

    if os.path.isfile("/var/www/.ssh/id_rsa"):
        log("pushing to GitHub repository")
        cmd = 'git push'
        docmd(cmd)

    log("updating files in the background... otherwise done.")
    cmd = "make background"
    docmd(cmd)

else:
    log("neither orig file %s nor translated file %s for id %s exists" % (origfilename, translatedfilename, id))

