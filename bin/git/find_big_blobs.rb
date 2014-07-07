#!/usr/bin/env ruby -w
head, threshold = ARGV
head ||= 'HEAD'
Megabyte = 1000 ** 2
threshold = (threshold || 0.1).to_f * Megabyte
commit_count = 0

big_files = {}

IO.popen("git rev-list #{head}", 'r') do |rev_list|
  rev_list.each_line do |commit|
    commit_count += 1
    commit.chomp!
    biggest_found = {}
    for object in `git ls-tree -zrl #{commit}`.split("\0")
      bits, type, sha, size, path = object.split(/\s+/, 5)
      size = size.to_i
      if size > biggest_found.fetch(:size, 0)
        biggest_found = { path: path, size: size}
      end
      if size >= threshold
        big_files[sha] = [path, size, commit]
      end
    end
    puts '%s %7d %s %d %d %s' % [
      Time.now.strftime('%H:%M:%S'),
      commit_count,
      commit,
      big_files.size,
      biggest_found.fetch(:size, 0),
      biggest_found.fetch(:path, '')
    ]
  end
end

big_files.each do |sha, (path, size, commit)|
  where = `git show -s #{commit} --format='%h: %cr'`.chomp
  puts "%4.1fM\t%s\t(%s)" % [size.to_f / Megabyte, path, where]
end
