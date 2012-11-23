.PHONY: static node
NM=node_modules
JADE=$(NM)/jade/bin/jade
COFFEE=$(NM)/coffee-script/bin/coffee

all: static node jades

modules:
	npm install

static:
	$(COFFEE) -c static/js/*.coffee
node:
	$(COFFEE) -c *.coffee
jades:
	$(JADE) static/html/*.jade

start:
	python2 -m SimpleHTTPServer 8000

clean:
	rm -f *.js
	rm -f static/js/*.js
	rm -f static/html/*.html
