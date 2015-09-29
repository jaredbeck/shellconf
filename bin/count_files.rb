#!/usr/bin/env ruby

require "pathname"

class CountFiles
  def new
  end

  def run
    print sort counts
  end

  private

  def counts
    extensions.each_with_object({}) { |ext, hsh|
      hsh[ext] = hsh[ext].to_i + 1
    }
  end

  def extensions
    file_names.map { |n| n.split('.').last }
  end

  def file_names
    file_paths.map { |p| p.basename.to_s }
  end

  def file_paths
    Dir.glob('**/*').map { |p| Pathname.new(p) }
  end

  def print(counts)
    counts.each do |ext, count|
      puts format("%-20s\t%d", ext, count)
    end
  end

  def sort(counts)
    counts.sort_by { |ext, count| ext }
  end
end

CountFiles.new(*ARGV).run
