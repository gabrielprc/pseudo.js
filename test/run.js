var config = require('../config');
var fs = require('fs');
var test = require('tape');
var tests = require('./tests');
var peg = require('pegjs');

function run() {
	var parser = buildParser();
	runGoodTests(parser);
	// runBadTests(parser);
}

function buildParser() {
	var grammarFile = config.project.grammar.dir + config.project.grammar.grammar;

	try {
		var grammar = fs.readFileSync(grammarFile, 'utf8');
	} catch(err) {
		console.error('Grammar file not found');
		throw err;
	}

	try {
		console.log('Building parser');

		var parser = peg.buildParser(grammar);
		return parser
	} catch (err) {
		console.error('Could not build parser');
		throw err;
	}
}

function runGoodTests(parser) {
	runTests(tests.good, parser);
}

function runBadTests(parser) {
	runTests(tests.bad, parser);
}

function runTests(tests, parser) {
	for (var i = 0; i < tests.length; i++) {
		runTest(tests[i], parser);
	}
}

function runTest(t, parser) {
	test(t.name, function(assert) {
		var actualOutput = parser.parse(t.input);
		assert.deepLooseEqual(actualOutput, t.output);
		assert.end();
	});
}


run();