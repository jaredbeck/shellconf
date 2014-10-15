#!/usr/bin/env ruby

require 'redcarpet'

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
