# frozen_string_literal: true

require 'active_support/all'
require 'sorbet-runtime'

class DoRuboCopTodos
  extend T::Sig

  sig { void }
  def run
    cop_name = delete_one_todo
    system 'rubocop -A'
    system 'git diff'
    puts 'Does the diff look good? Hit enter to continue'
    gets
    system 'git add --all .'
    system format(%q(git commit -m '%s'), cop_name)
  end

  private

  sig { returns(String) }
  def delete_one_todo
    todo_lines = File.readlines('.rubocop_todo.yml')
    raise 'todo file is empty' if todo_lines.empty?
    todo = todo_source_range(todo_lines)
    File
      .open('.rubocop_todo.yml', 'w')
      .write(antislice(todo_lines, todo.source_range).join)
    todo.cop_name
  end

  sig { params(ary: T::Array[String], range: T::Range[Integer]).returns(T::Array[String]) }
  def antislice(ary, range)
    slice1 = Array.wrap(ary[0, range.begin])
    slice2 = Array.wrap(ary[range.end, ary.length])
    slice1 + slice2
  end

  # Returns a range of line numbers defining the first to-do item.
  #
  # ```
  # # Offense count: 5
  # # Cop supports --auto-correct.
  # # Configuration parameters: AllowMultipleStyles, EnforcedHashRocketStyle, EnforcedColonStyle, EnforcedLastArgumentHashStyle.
  # # SupportedHashRocketStyles: key, separator, table
  # # SupportedColonStyles: key, separator, table
  # # SupportedLastArgumentHashStyles: always_inspect, always_ignore, ignore_implicit, ignore_explicit
  # Layout/HashAlignment:
  #   Exclude:
  #     - 'app/graphql/mutations/update_branding.rb'
  #     - 'app/graphql/mutations/update_dhl_account_settings.rb'
  #     - 'app/graphql/types/return_location_type.rb'
  # ```
  sig { params(todo_lines: T::Array[String]).returns(Todo) }
  def todo_source_range(todo_lines)
    # Find the first line that's neither blank nor a comment.
    x = todo_lines.find_index { |line| line.present? && !line.start_with?('#') }
    cop_name = todo_lines[x].chomp(":\n")

    # Find the blank line after that.
    z = x.upto(todo_lines.length - 1).find { |i| todo_lines[i].blank? }

    # Work backwards to find the blank line above this to-do's comments.
    y = x.downto(0).find { |i| todo_lines[i].blank? }

    Todo.new(cop_name: cop_name, source_range: y..z)
  end

  class Todo < T::Struct
    const :cop_name, String
    const :source_range, T::Range[Integer]
  end
end

DoRuboCopTodos.new(*ARGV).run
