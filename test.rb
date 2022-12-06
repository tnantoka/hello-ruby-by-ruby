x = 1
y = x + 2
p(y)

answer = (1 + 2) / 3 * 4 * (56 / 7 + 8 + 9)
p(answer)

plus_count = 0
x = 1 + 2 + 3
p(plus_count)
x = 1 + 2 + 3
p(plus_count)

if 0 == 0
  p(42)
else
  p(43)
end

i = 0
while i < 10
  p(i)
  i = i + 1
end

case 42
when 0
  p(0)
when 1
  p(1)
else
  p(2)
end

i = 1
while i <= 100
  is_fizz = i % 3 == 0
  is_buzz = i % 5 == 0
  if is_fizz && is_buzz
    p("FizzBuzz")
  elsif is_fizz
    p("Fizz")
  elsif is_buzz
    p("Buzz")
  else
    p(i)
  end
  i = i + 1
end

i = 10
begin
  p(i)
  i = i - 1
end while i > 0

p(1, 2, 3)

def add(x, y)
  x + y
end
p(add(1, 1))

def foo()
  x = 0
  p(x)
end

x = 1
foo()
p(x)

def fib(x)
  if x <= 1
    x
  else
    fib(x - 1) + fib(x - 2)
  end
end

i = 0
while i < 10
  p(fib(i))
  i = i + 1
end

def even?(n)
  if n == 0
    true
  else
    odd?(n - 1)
  end
end

def odd?(n)
  if n == 0
    false
  else
    even?(n - 1)
  end
end

p(even?(2))
p(odd?(1))

a = [1, 2, 3, 6 * 7]
a[1] = 'foo'
p(a[1])

h = { 'a' => 1, 'b' => 2 }
p(h['a'])