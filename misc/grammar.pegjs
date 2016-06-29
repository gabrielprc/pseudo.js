
    {
      var nnode = function(tag, content, syntax, code) {
        var node = { tag: tag, c: content, index: location().start.column - 1};
        if(syntax !== undefined) {
          node.syntax = syntax;
        }

        if (code !== undefined) {
          node.code = code;
        }

        return node;
      };

      var syn = function(obj, syntax) {
        obj.syntax = syntax;
        return obj;
      };
    }

    start
      = all:block { return nnode('root', [all]); }

    block
      = _* all:expression+ { return nnode('block', all); }

    expression
      = all:type_assignment { return nnode('expression', [all]); }
      / all:value_assignment { return nnode('expression', [all]); }
      / all:list_assignment { return nnode('expression', [all]); }
      / all:invocation { return nnode('expression', [all]); }

    type_assignment
      = a:assignee _ ia:is_a _ id:identifier _* nl
        { return nnode('type_assignment', [a, ia, syn(id, 'type')]); }

    value_assignment
      = a:assignee _ i:is _ v:value _* nl
        { return nnode('value_assignment', [a, i, v]); }

    list_assignment
      = lo:list_operation _ va:value _ tf:to_from _ as:assignee _* nl
        { return nnode('list_assignment', [lo, va, tf, as]); }

    invocation
      = a:identifier _ v:value _* nl
        { return nnode('invocation', [syn(a, 'function'), v]); }

    list_operation
      = all:add { return nnode('list_operation', [all]); }
      / all:take { return nnode('list_operation', [all]); }

    assignee
      = all:variable { return nnode('assignee', [all]); }

    value
      = all:literal { return nnode('value', [all]); }
      / all:variable { return nnode('value', [all]); }

    literal
      = all:string { return nnode('literal', [all], 'literal'); }

    identifier
      = !keyword init:init_identifier_char rest:identifier_char* { return nnode('identifier', [init + rest.join('')]); }

    variable
      = id:identifier rest:variable_rest* { return nnode('variable', [syn(id, 'variable')].concat(rest)); }

    variable_rest
      = _ id:identifier { return syn(id, 'attribute'); }

    is
      = all:'is' { return nnode('is', [all], 'keyword'); }

    is_a
      = all:'is a' { return nnode('is_a', [all], 'keyword'); }

    add
      = all:'add' { return nnode('add', [all], 'keyword'); }

    take
      = all:'take' { return nnode('take', [all], 'keyword'); }

    to_from
      = all:to { return nnode('to_from', ['to from'], 'keyword', 'to'); }
      / all:from { return nnode('to_from', ['to from'], 'keyword', 'from'); }

    string
      = all:string_char_single* { return nnode('string', [all.join('')], undefined, '\'' + all.join('') + '\''); }
      / all:string_char_double* { return nnode('string', [all.join('')], undefined, '\'' + all.join('') + '\''); }

    nl
      = all:[\n]+ { return nnode('nl', all); }

    keyword
      = is !identifier_char
      / is_a !identifier_char
      / add !identifier_char
      / take !identifier_char
      / to !identifier_char
      / from !identifier_char

    to = 'to'
    from = 'from'
    _ = [ \t\r]+
    identifier_char = [a-zA-Z0-9_]
    init_identifier_char = [a-zA-Z_]
    string_char_double = [A-Za-z0-9., \']
    string_char_single = [A-Za-z0-9., \']