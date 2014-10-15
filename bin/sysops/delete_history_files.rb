#!/usr/bin/env ruby

require 'fileutils'

class DeleteHistoryFiles

  APP_PREFERENCE_DIRS = %w[
    .DownloadManager
    .dvdcss
    .InstallAnywhere
    .tectonicus
    .GoPanda
    .ncftp
    .pentadactyl
  ]

  APP_PREFERENCE_FILES = %w[
    .pentadactylrc
  ]

  DISTURBING_UNKNOWN_FILES = %w[
    .bbbppoae
  ]

  HOME_HISTORY_FILES = %w[
    .lesshst
    .gdb_history
    .gnuplot_history
    .guard_history
    .irb-history
    .irb_history
    .mysql_history
    .pry_history
    .psql_history
    .sqlite_history
  ]

  attr_reader :dry_run

  def initialize(dry_run)
    @dry_run = dry_run
  end

  def run
    files.each do |f|
      utils.rm(f) if File.exist?(f)
    end

    dirs.each  do |d|
      utils.rm_r(d) if Dir.exist?(d)
    end
  end

  private

  def dirs
    APP_PREFERENCE_DIRS.map { |d| home_rel_to_abs(d) }
  end

  def files
    home_rel_files.map { |f| home_rel_to_abs(f) }
  end

  def home_rel_files
    APP_PREFERENCE_FILES + DISTURBING_UNKNOWN_FILES + HOME_HISTORY_FILES
  end

  def home_rel_to_abs(f)
    File.join(Dir.home, f)
  end

  def utils
    dry_run ? FileUtils::DryRun : FileUtils
  end
end

dry_run = ARGV[0] == '--dry-run'
DeleteHistoryFiles.new(dry_run).run
