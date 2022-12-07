require 'bundler'
Bundler.require

def evaluate(tree, genv, lenv)
  case tree[0]
  when 'lit'
    tree[1]
  when '+'
    if lenv['plus_count']
      lenv['plus_count'] = lenv['plus_count'] + 1
    else
    end
    evaluate(tree[1], genv, lenv) + evaluate(tree[2], genv, lenv)
  when '-'
    evaluate(tree[1], genv, lenv) - evaluate(tree[2], genv, lenv)
  when '*'
    evaluate(tree[1], genv, lenv) * evaluate(tree[2], genv, lenv)
  when '/'
    evaluate(tree[1], genv, lenv) / evaluate(tree[2], genv, lenv)
  when '%'
    evaluate(tree[1], genv, lenv) % evaluate(tree[2], genv, lenv)
  when '**'
    evaluate(tree[1], genv, lenv) ** evaluate(tree[2], genv, lenv)
  when '=='
    evaluate(tree[1], genv, lenv) == evaluate(tree[2], genv, lenv)
  when '!='
    evaluate(tree[1], genv, lenv) != evaluate(tree[2], genv, lenv)
  when '<'
    evaluate(tree[1], genv, lenv) < evaluate(tree[2], genv, lenv)
  when '<='
    evaluate(tree[1], genv, lenv) <= evaluate(tree[2], genv, lenv)
  when '>'
    evaluate(tree[1], genv, lenv) > evaluate(tree[2], genv, lenv)
  when '>='
    evaluate(tree[1], genv, lenv) >= evaluate(tree[2], genv, lenv)
  when '&&'
    evaluate(tree[1], genv, lenv) && evaluate(tree[2], genv, lenv)
  when 'func_call'
    args = []
    i = 0
    while tree[i + 2]
      args[i] = evaluate(tree[i + 2], genv, lenv)
      i = i + 1
    end

    func = genv[tree[1]]
    if func[0] == 'builtin'
      minruby_call(func[1], args)
    else
      new_lenv = {}
      params = func[1]
      i = 0
      while params[i]
        new_lenv[params[i]] = args[i]
        i = i + 1
      end
      evaluate(func[2], genv, new_lenv)
    end
  when 'func_def'
    genv[tree[1]] = ['user_defined', tree[2], tree[3]]
  when 'stmts'
    i = 1
    last = nil
    while tree[i]
      last = evaluate(tree[i], genv, lenv)
      i = i + 1
    end
    last
  when 'var_assign'
    lenv[tree[1]] = evaluate(tree[2], genv, lenv)
  when 'var_ref'
    lenv[tree[1]]
  when 'if'
    if evaluate(tree[1], genv, lenv)
      evaluate(tree[2], genv, lenv)
    else
      evaluate(tree[3], genv, lenv)
    end
  when 'while'
    while evaluate(tree[1], genv, lenv)
      evaluate(tree[2], genv, lenv)
    end
  when 'while2'
    begin
      evaluate(tree[2], genv, lenv)
    end while evaluate(tree[1], genv, lenv)
  when 'ary_new'
    ary = []
    i = 0
    while tree[i + 1]
      ary[i] = evaluate(tree[i + 1], genv, lenv)
      i = i + 1
    end
    ary
  when 'ary_ref'
    array = evaluate(tree[1], genv, lenv)
    index = evaluate(tree[2], genv, lenv)
    array[index]
  when 'ary_assign'
    array = evaluate(tree[1], genv, lenv)
    index = evaluate(tree[2], genv, lenv)
    value = evaluate(tree[3], genv, lenv)
    array[index] = value
  when 'hash_new'
    hsh = {}
    i = 0
    while tree[i + 1]
      key = evaluate(tree[i + 1], genv, lenv)
      val = evaluate(tree[i + 2], genv, lenv)
      hsh[key] = val
      i = i + 2
    end
    hsh
  else
    pp(tree)
  end
end

# def max(tree)
#   if tree[0] == 'lit'
#     tree[1]
#   else
#     left = max(tree[1])
#     right = max(tree[2])
#     [left, right].max
#   end
# end
# p(max(minruby_parse('1 + 2 * 3'))) # => 3
# p(max(minruby_parse('1 + 4 + 3'))) # => 4

str = minruby_load()
tree = minruby_parse(str)
genv = {
  'p' => ['builtin', 'p'],
  'require' => ['builtin', 'require'],
  'minruby_parse' => ['builtin', 'minruby_parse'],
  'minruby_load' => ['builtin', 'minruby_load'],
  'minruby_call' => ['builtin', 'minruby_call'],
}
lenv = {
  'plus_count' => 0,
}
evaluate(tree, genv, lenv)
