#!/usr/bin/env ruby
# frozen_string_literal: true

# Example genp record
# -----------------------
#
# keychain: "/Users/jared/Library/Keychains/escaping_the_cloud.keychain"
# class: "genp"
# attributes:
#     0x00000007 <blob>="526 Stewart"
#     0x00000008 <blob>=<NULL>
#     "acct"<blob>="526 Stewart"
#     "cdat"<timedate>=0x32303134313033303031323935385A00  "20141030012958Z\000"
#     "crtr"<uint32>=<NULL>
#     "cusi"<sint32>=<NULL>
#     "desc"<blob>="AirPort network password"
#     "gena"<blob>=<NULL>
#     "icmt"<blob>=<NULL>
#     "invi"<sint32>=<NULL>
#     "mdat"<timedate>=0x32303134313033303031323935385A00  "20141030012958Z\000"
#     "nega"<sint32>=<NULL>
#     "prot"<blob>=<NULL>
#     "scrp"<sint32>=<NULL>
#     "svce"<blob>="AirPort"
#     "type"<uint32>=<NULL>
# data:
# "redacted"
#
# Example inet record
# -------------------
#
# keychain: "/Users/jared/Library/Keychains/escaping_the_cloud.keychain"
# class: "inet"
# attributes:
#     0x00000007 <blob>="www.gocongress.org (jared@jaredbeck.com)"
#     0x00000008 <blob>=<NULL>
#     "acct"<blob>="jared@jaredbeck.com"
#     "atyp"<blob>="form"
#     "cdat"<timedate>=0x32303134313033303031333234385A00  "20141030013248Z\000"
#     "crtr"<uint32>=<NULL>
#     "cusi"<sint32>=<NULL>
#     "desc"<blob>="Web form password"
#     "icmt"<blob>="default"
#     "invi"<sint32>=<NULL>
#     "mdat"<timedate>=0x32303134313033303031333234385A00  "20141030013248Z\000"
#     "nega"<sint32>=<NULL>
#     "path"<blob>=<NULL>
#     "port"<uint32>=0x00000000
#     "prot"<blob>=<NULL>
#     "ptcl"<uint32>="http"
#     "scrp"<sint32>=<NULL>
#     "sdmn"<blob>=<NULL>
#     "srvr"<blob>="www.gocongress.org"
#     "type"<uint32>=<NULL>
# data:
# "redacted"
#

class Record
  attr_accessor :atr, :data, :rec_class

  def initialize
    @atr = {}
  end

  def acct
    atr['acct']
  end

  def multiline
    <<-EOS
Title: #{title}
Acct: #{acct}
Data: #{data}

    EOS
  end

  def title
    atr['0x00000007'] # yup, apple did that
  end
end

class ExtractPW
  STATE_BEFORE_CLASS = 0
  STATE_BEFORE_ATTRS = 1
  STATE_ATTRS = 2
  STATE_DATA = 3

  def initialize(keychain_dump)
    @dump = File.new(keychain_dump)
  end

  def run
    records = parse(@dump)
    records.each do |r|
      puts r.multiline
    end
  end

  private

  def dequote(str)
    str.gsub(/^"/, '').gsub(/"$/, '')
  end

  def parse(file)
    contents = file.read
    records = contents.split(/keychain:/).reject { |r| r.empty? }
    result = []
    records.each do |r|
      rec = Record.new
      state = STATE_BEFORE_CLASS
      r.each_line do |l|
        l.chomp!
        if state == STATE_BEFORE_CLASS
          m = /class: "(\S+)"/.match(l)
          if !m.nil?
            rec.rec_class = m[1]
            state = STATE_BEFORE_ATTRS
          end
        elsif state == STATE_BEFORE_ATTRS
          if l == 'attributes:'
            state = STATE_ATTRS
          end
        elsif state == STATE_ATTRS
          if l == 'data:'
            state = STATE_DATA
          else
            m = /\s+"?([a-z0-9]+)"?\s?(.*)/.match(l)
            raise 'parse error' if m.nil?
            rec.atr[m[1]] = parse_atr_value(m[2])
          end
        elsif state == STATE_DATA
          rec.data = dequote(l)
        end
      end
      result << rec
    end
    result
  end

  def parse_atr_value(v)
    m = v.strip.match(/^<([a-z0-9]+)>=(.*)$/)
    raise 'parse error' if m.nil?
    val = m[2]
    val == '<NULL>' ? nil : dequote(val)
  end

end

ExtractPW.new(*ARGV).run
