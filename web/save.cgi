#!/usr/bin/python3

import os
import sys
import urllib.parse

print("Content-Type: text/plain")
print()

if "QUERY_STRING" in os.environ:
    form = urllib.parse.parse_qs(os.environ["QUERY_STRING"], keep_blank_values=False, strict_parsing=False, encoding='utf-8', errors='replace', max_num_fields=50)
else:
    form = {}
    
if "id" in form:
    id = form["id"][0]
else:
    id = "unknown"
    
if "elem" in form:
    elem = form["elem"][0]
else:
    elem = "unknown"
    
if "user" in form:
    user = form["user"][0]
else:
    user = "unknown"

if "REMOTE_ADDR" in os.environ:
    addr = os.environ["REMOTE_ADDR"]
else:
    addr = "unknown"


data = sys.stdin.buffer.read()

msg = "received %d bytes for id %s elem %s from %s by %s" % (len(data), id, elem, addr, user)

f = open ("/var/log/bjcp-styleguide/log", "w+")
f.write("%s\n" % msg)
f.close()

f = open ("/var/log/bjcp-styleguide/data", "wb")
f.write(data)
f.close()

# TODO: parse, create response, show error response on client, write xml on server, git commit, 
