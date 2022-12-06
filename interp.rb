require 'bundler'
Bundler.require

def evaluate(tree, genv, lenv)
  case tree[0]
  when 'lit'
    tree[1]
  when '+'
    lenv['plus_count'] = lenv['plus_count']&.+ 1
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
  when 'func_call' # TODO:
    args = tree[2..].map { |arg| evaluate(arg, genv, lenv) }
    func = genv[tree[1]]
    if func[0] == 'builtin'
      minruby_call(func[1], args)
    else
      new_lenv = {}
      func[1].each_with_index do |param, i|
        new_lenv[param] = args[i]
      end
      evaluate(func[2], genv, new_lenv)
    end
  when 'func_def'
    genv[tree[1]] = ['user_defined', tree[2], tree[3]]
  when 'stmts'
    last = nil
    tree[1..].each do |stmt|
      last = evaluate(stmt, genv, lenv)
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
    tree[1..].map { |elem| evaluate(elem, genv, lenv) }
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
    tree[1..].each_slice(2).reduce({}) do |hash, (key, value)|
      {
        **hash,
        evaluate(key, genv, lenv) => evaluate(value, genv, lenv)
      }
    end
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

str = minruby_load 
tree = minruby_parse(str)
genv = {
  'p' => ['builtin', 'p']
}
lenv = {}
evaluate(tree, genv, lenv)