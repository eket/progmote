.PHONY: static node
NM=node_modules
JADE=$(NM)/jade/bin/jade
COFFEE=$(NM)/coffee-script/bin/coffee

JSLIB=static/js/lib

JS_LODASH=$(NM)/lodash/lodash.min.js
JS_ONECOLOR=$(NM)/onecolor/one-color.js
JS_SOCKETIO=$(NM)/socket.io/node_modules/socket.io-client/dist/socket.io.min.js
JS_ZEPTO=$(NM)/zepto/zepto.min.js

all: static node jades

modules:
	npm install
	cp $(JS_LODASH) $(JSLIB)
	cp $(JS_ONECOLOR) $(JSLIB)
	cp $(JS_SOCKETIO) $(JSLIB)
	cp $(JS_ZEPTO) $(JSLIB)

static:
	$(COFFEE) -c static/js/*.coffee
node:
	$(COFFEE) -c *.coffee
jades:
	$(JADE) static/html/*.jade

start:
	serve

clean:
	rm -f *.js
	rm -f static/js/*.js
	rm -f static/html/*.html
