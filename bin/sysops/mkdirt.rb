#!/usr/bin/env ruby -W

require 'fileutils'

class MkdirTouch
  def initialize(path)
    @path = path
  end

  def run
    mkdir
    touch
  end

  private

  def mkdir
    dirname = File.dirname(@path)
    if File.exist?(dirname)
      if !File.directory?(dirname)
        abort 'File already exists: ' + dirname
      end
    else
      FileUtils.mkdir_p(dirname)
    end
  end

  def touch
    FileUtils.touch(@path)
  end
end

MkdirTouch.new(*ARGV).run
