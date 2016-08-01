var tests = {
  good: [
    {
      name: 'Variable declaration',
      input: 'var test is 2',
      output: {
        'type': 'Program',
        'body': [
          {
            'type': 'VariableDeclaration',
            'declarations': [
              {
                'type': 'VariableDeclarator',
                'id': {
                    'type': 'Identifier',
                    'name': 'test'
                },
                'init': {
                  'type': 'Literal',
                  'value': 2
                }
              }
            ]
          }
        ]
      }
    }
  ]
}

module.exports = tests;