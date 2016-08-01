var config = require('./config');
var fs = require('fs');
var peg = require('pegjs');

function main() {
	try {
		test();
		build();
	} catch (err) {
		console.error('Error generating parser', err);
	}
}

function build() {
	console.log('Reading grammar');

	var grammarFile = config.project.grammar.dir + config.project.grammar.grammar;

	try {
		var grammar = fs.readFileSync(grammarFile, 'utf8');
	} catch(err) {
		console.error('Grammar file not found');
		throw err;
	}

	try {
		console.log('Building parser');	  
		var parser = peg.buildParser(
			grammar, 
			{
				output: 'source',
				optimize: 'size'
			}
		);

		var parserFilename = config.project.parser.filename;
		
		console.log('Saving parser in ' + parserFilename);
		fs.writeFileSync(parserFilename, parser);
	} catch (err) {
		console.error('Could not build parser');
		throw err;
	}
}

function test() {
	return true;
}


main();


