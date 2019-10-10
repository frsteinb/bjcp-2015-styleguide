#!/usr/bin/python3

import os
import os.path
import re
import sys
import urllib.parse
import codecs
import time
import datetime

DIR = "/var/www/bjcp-2015-styleguide"
LOGFILE = "%s/web/logfile" % DIR
SNIPPETDIR = "%s/web/snippets" % DIR
LANG = "de"



def log(msg):
    time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    f = open(LOGFILE, "a+")
    f.write("%s %s\n" % (time, msg))
    f.close()



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
f.write('<!-- snippet supplied by %s from %s at %s -->\n' % (user, addr, time))
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

if os.path.isfile(translatedfilename) or os.path.isfile(origfilename):
    if os.path.isfile(translatedfilename):
        log("updating translation file %s/%s.xml based on snippet" % (LANG, id))
        cmd = "xsltproc --stringparam snippet %s %s/xsl/bjcp-2015-styleguide-merge.xsl %s > %s.tmp ; mv %s.tmp %s" % (snippetfilename, DIR, translatedfilename, translatedfilename, translatedfilename, translatedfilename)
        os.system(cmd)
    else:
        log("creating new translation file %s/%s.xml from orig/%s.xml and snippet" % (LANG, id, id))
        cmd = "xsltproc --stringparam snippet %s %s/xsl/bjcp-2015-styleguide-merge.xsl %s > %s" % (snippetfilename, DIR, origfilename, translatedfilename)
        os.system(cmd)
    log("committing to web server local repository")
    cmd = 'cd %s ; git commit %s/%s.xml -m "%s %s by %s from %s"' % (DIR, LANG, id, id, elem, user, addr)
    os.system(cmd)
    log("updating files in the background... otherwise done.")
    cmd = "make -C %s background" % DIR
    os.system(cmd)
else:
    log("neither orig file %s nor translated file %s for id %s exists" % (origfilename, translatedfilename, id))

