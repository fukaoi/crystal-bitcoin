HOME_DIR   = $(HOME)/.crystal-nodejs
JS_DIR     = ${HOME_DIR}/js/bitcoin

all:

# need folders
	@if [ ! -d ${JS_DIR}/ ]; then \
		mkdir -p ${JS_DIR}; \
	fi
	
	@npm i && npm run build

	@if [ ! -d ${JS_DIR}/node_modules ]; then \
		cp -r ${PWD}/node_modules ${JS_DIR}/; \
	fi

.PHONY: clean
clean:
	rm -rf ${JS_DIR}/*

.PHONY: secure_check
secure_check:
	RAW_JS=true crystal spec
	cd ./lib/nodejs && make audit
