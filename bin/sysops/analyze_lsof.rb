# frozen_string_literal: true

require 'set'

# Analyzes lsof output, looking for problems e.g. one process using a lot of nodes.
#
# Example output of `lsof -u`:
#
# COMMAND     PID  USER   FD      TYPE             DEVICE   SIZE/OFF                NODE NAME
# loginwind   551 jared  cwd       DIR               1,15        640                   2 /
# loginwind   551 jared  txt       REG               1,15    2706208 1152921500312132489 /System/Library/CoreServices/loginwindow.app/Contents/MacOS/loginwindow
# loginwind   551 jared  txt       REG               1,15        110 1152921500312130264 /System/Library/CoreServices/SystemVersion.bundle/English.lproj/SystemVersion.strings
# loginwind   551 jared  txt       REG               1,15     137016 1152921500312129970 /System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/SystemAppearance.car
# loginwind   551 jared  txt       REG               1,15     193280 1152921500312231469 /System/Library/LoginPlugins/FSDisconnect.loginPlugin/Contents/MacOS/FSDisconnect
# loginwind   551 jared  txt       REG               1,15     305280 1152921500312231418 /System/Library/LoginPlugins/DisplayServices.loginPlugin/Contents/MacOS/DisplayServices
# loginwind   551 jared  txt       REG               1,15     237952              929241 /private/var/db/timezone/tz/2024a.1.0/icutz/icutz44l.dat
# loginwind   551 jared  txt       REG               1,15    1464472 1152921500312226809 /System/Library/Keyboard Layouts/AppleKeyboardLayouts.bundle/Contents/Resources/AppleKeyboardLayouts-L.dat
# loginwind   551 jared  txt       REG               1,15     237983 1152921500312226811 /System/Library/Keyboard Layouts/AppleKeyboardLayouts.bundle/Contents/Resources/InfoPlist.loctable
class AnalyzeLsof
  def initialize(lsof_output_stream)
    @lsof_output_stream = lsof_output_stream
  end

  def analyze
    lines = @lsof_output_stream.readlines(chomp: true)
    lines.shift # discard header
    handles = lines.map { |l| parse(l) }
    num_pids(handles)
    node_hogs(handles)
  end

  private

  def parse(l)
    data = l.split(/\s+/)
    {
      command: data[0],
      pid: data[1].to_i,
      user: data[2],
      fd: data[3],
      type: data[4],
      device: data[5],
      size: data[6],
      node: data[7].to_i,
      name: data[8],
    }
  end

  def node_hogs(handles)
    hogs = handles.each_with_object({}) { |handle, acc|
      pid = handle.fetch(:pid)
      acc[pid] ||= Set.new
      acc[pid].add(handle.fetch(:node))
    }.sort_by { |pid, nodes| nodes.size }.reverse.take(3)
    hogs.each do |pid, nodes|
      puts format('PID %d has %d nodes', pid, nodes.length)
    end
  end

  def num_pids(handles)
    n = handles.map { |h| h.fetch(:pid) }.sort.uniq.length
    puts format('%d PIDs', n)
  end
end

AnalyzeLsof.new($stdin).analyze
