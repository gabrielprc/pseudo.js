var config = {
	project: {
		grammar: {
			dir: __dirname + '/grammar/',
			grammar: 'grammar.pegjs'
		},
		parser: {
			filename: 'parser.js'
		},
		tests: {
			dir: __dirname + '/test/'
		}
	}
}

module.exports = config;