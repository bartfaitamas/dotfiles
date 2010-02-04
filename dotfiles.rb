#!/usr/bin/env ruby

require 'pathname'
require 'optparse'

#$target_dir = Pathname.new("/tmp/dotfilestest")
#$source_dir = Pathname.new(ENV['HOME']) + "dotfiles"

$target_dir = Pathname.new(ENV['HOME']).realpath
$source_dir = Pathname.new($0).parent.realpath

$dir_excludes = [/^\.$/, /^\.\.$/, /^\.git$/, /bak$/]
$file_excludes = [/~$/, /dotfiles.rb/ ]

$verbose = false
$dry_run = false

module Dotfiles
  class Dotdir
    attr :source_dir
    attr :rel_path

    def initialize(s, t, r)
      @source_dir = s
      @target_dir = t
      @rel_path = r
      throw "#{s + r} doesn't exists" unless (s + r).readable?
    end

    def process
      full_source_dir = @source_dir + @rel_path
      full_target_dir = @target_dir + @rel_path

      puts "Directory: #{full_source_dir} -> #{full_target_dir}" if $verbose

      if not full_target_dir.exist?
        puts "  mkdir: #{full_target_dir}"
        full_target_dir.mkdir unless $dry_run
      end
      
      full_source_dir.each_entry { |entry|
        next if skip? entry
        source_entry = full_source_dir + entry
        Dotdir.new(@source_dir, @target_dir, @rel_path + entry).process if source_entry.directory?
        Dotfile.new(@source_dir, @target_dir, @rel_path + entry).process if source_entry.file?
        
      }
    end

    def skip?(entry)
      p = $dir_excludes.find { |pattern| pattern.match entry }
      puts "  Excludig: '#{entry}' because of /#{p.source}/" if $verbose and not p.nil?
      not p.nil?
    end

  end

  class Dotfile
    BAK_SUFFIX = ".dotfiles_bak"

    attr :rel_path
    attr :source_dir
    attr :target_dir

    def initialize(s, t, r)
      @rel_path = r
      @source_dir = s
      @target_dir = t
    end

    def process
      if skip?
        puts "    Skipping: #{@source_dir + @rel_path}" if $verbose
        return
      end
      
      target_path = @target_dir + @rel_path
      if target_path.exist?
        bakname = next_bak_name(@target_dir + @rel_path)
        puts "    Backing up #{target_path} -> #{bakname}"
        target_path.rename(bakname) unless $dry_run
      end

      puts "    Linking: #{@source_dir + @rel_path} -> #{@target_dir + @rel_path}"
      (@target_dir + @rel_path).make_symlink(@source_dir + @rel_path) unless $dry_run
      
    end

    def next_bak_name(file)
      suffix = BAK_SUFFIX
      counter = 0
      counter += 1 while File.exist?(file.to_s + suffix + counter.to_s)
      file.to_s + suffix + counter.to_s
    end
    
    def skip?
      source_path = @source_dir + @rel_path
      target_path = @target_dir + @rel_path
      
      p = $file_excludes.find { |pattern| pattern.match source_path }
      not p.nil? or (target_path.symlink? and target_path.readlink == source_path)
    end
  end
end


def help(opts)
  puts opts.to_s + "\n"
  
  if $verbose
    puts "target_dir = #{$target_dir}"
    puts "source_dir = #{$source_dir}"
    puts "dir_excludes = #{$dir_excludes.to_s}"
    puts "file_excludes = #{$file_excludes.to_s}"
    puts "verbose = #{$verbose}"
    puts "dry_run = #{$dry_run}"
  end
  exit 0
end

opts = OptionParser.new
opts.on("-sSOURCE", "--source=SOURCE", 
        "Source directory, default ''#{Pathname.new($0).parent.realpath}``") {|s| $source_dir = Pathname.new(s).realpath}
opts.on("-tTARGET", "--target=TARGET", 
        "Target directory, default ''#{ENV['HOME']}``") {|t| $target_dir = Pathname.new(t).realpath}

opts.on("-v", "--verbose") { $verbose = true; }
opts.on("-d", "--dry-run") { $dry_run = true }
opts.on("-h", "--help") { help(opts) }

opts.parse(*ARGV)

Dotfiles::Dotdir.new($source_dir, $target_dir, Pathname.new(".")).process
