.PHONY: static node
all: static node jades

static:
	coffee -c static/js/*.coffee

node:
	coffee -c *.coffee

jades:
	node_modules/jade/bin/jade static/html/*.jade

start:
	python2 -m SimpleHTTPServer 8000

clean:
	rm -f *.js
	rm -f static/js/*.js
	rm -f static/html/*.html
