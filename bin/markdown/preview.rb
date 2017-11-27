#!/usr/bin/env ruby
# frozen_string_literal: true

begin
  require 'redcarpet'
rescue LoadError => e
  $stderr.puts "Unable to load markdown library, redcarpet: #{e}"
  $stderr.puts 'Try: gem install redcarpet'
  exit(1)
end

# preview.rb takes a single argument, the path to a markdown source
# file, and writes the rendered html to stdout.
#
# Example:
#
#     preview.rb README.md > /tmp/preview.html && open /tmp/preview.html
#

class MarkdownPreview

  attr_reader :in_file

  def initialize(in_file)
    @in_file = in_file
  end

  def run
    md_source = File.read(in_file)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    puts markdown.render(md_source)
  end

  private

  def extensions
    { fenced_code_blocks: true }
  end

  def renderer
    Redcarpet::Render::HTML.new(render_options = {})
  end
end

MarkdownPreview.new(*ARGV).run
