# frozen_string_literal: true

# Breaks long strings.
#
# Imagine that '"Foo bar"' is a long string. This would return '"Foo " \\\n "bar"'.
#
# I use this to break long strings when I'm working on the `Layout/LineLength` cop.
#
# ```bash
# alias rbreak='pbpaste | ruby /Users/jaredbeck/code/jaredbeck/shellconf/bin/ruby/break_string.rb | pbcopy'
# ```
#
# ```bash
# echo '"Ihre Rücksendung wurde versandt und ist auf dem Weg zurück zu uns. Sobald Ihre Rücksendung"' | ruby /Users/jaredbeck/code/jaredbeck/shellconf/bin/ruby/break_string.rb
# "Ihre Rücksendung wurde versandt und ist auf dem Weg zurück zu uns. " \
# "Sobald Ihre Rücksendung"
# ```
def break_string(input)
  quote = input[0]
  raise 'invalid quotation' unless %w[' "].include?(quote)
  dequoted = input[1..-2]
  delim = [quote, ' \\', "\n", quote].join
  body = (dequoted + '|').scan(/.{0,70}\W/).compact.join(delim)[0..-2]
  output = [quote, body, quote].join
  test_output = eval(output)
  test_input = eval(input)
  unless test_output == test_input
    warn 'output failed to match input'
    warn test_input
    warn test_output
    exit 1
  end
  output
end

raise 'expected 0 args' unless ARGV.length == 0
input = ARGF.read.chomp
raise 'input empty' if input.strip.empty?
print break_string(input)
