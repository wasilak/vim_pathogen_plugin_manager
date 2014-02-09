#!/usr/bin/env ruby

#-wU

require 'colorize'
require 'optparse'
require 'uri'
require 'fileutils'

Version = [
  0, #major
  1, #minor
]

git_version = `git --version`
git_version = git_version.gsub(/git version /, '').split(".")
unless (git_version[0].to_i >= 1 and git_version[1].to_i >= 8 and git_version[2].to_i >= 5) then
  puts "You need git version 1.8.5.x or greater.".colorize(:red)
end

options = {}

opts = OptionParser.new

opts.banner = "Usage: plugin_manager.rb [options]"

opts.on("-u", "--update", "Update all Vim plugins") do |u|
  options[:action] = "u"
end

opts.on("-i", "--install", "Install Vim plugins from list [bundle.list]") do |i|
  options[:action] = "i"
end

opts.on("-r", "--remove", "Remove Vim plugins not on the list [bundle.list]") do |r|
  options[:action] = "r"
end

opts.on_tail("-h", "--help", "Show this message") do
  puts opts
  exit
end
opts.on_tail("--version", "Show version") do
  puts ::Version.join('.')
  exit
end

begin
  opts.parse!(ARGV)
rescue OptionParser::InvalidOption => e
  puts e
  puts opts
  exit(1)
end

case options[:action]
  when "u"
    print "Updating all plugins...\n".colorize(:yellow)

    # getting Home dir + vim budles dir
    dir = Dir.open Dir.home + "/.vim/bundle/"

    # listing each plugin dir
    dir.each do |file|
      # ignoring . and ..
      unless  ['.', ".."].include?(file) then
        cur_dir = dir.path + file
        print "Updating: ".colorize(:light_blue) + "#{cur_dir}\n".colorize(:green)
        system "git -C #{cur_dir} pull"
      end
    end
  when "i"
    print "Installing all plugins from bundle.list...\n".colorize(:yellow)

    dir = Dir.open Dir.home + "/.vim/bundle/"

    File.open(Dir.home + "/.vim/bundle.list") do |file|
      while link = file.gets
        unless link.length <= 1 or link.strip.match(/^#.*/) then

          # getting last part of URL -> dir name without .git suffix
          last_part = URI(link).path.split('/').last.split('.')

          #removing the .git part
          last_part.pop

          # joining together remaining pieces to get i.e. ctrlp.vim.git
          cur_dir = dir.path + last_part.join(".")

          # only for plugins not yet installed
          unless File.exist? cur_dir  then
            print "Getting: ".colorize(:light_blue) + "#{link.strip}".colorize(:green) + " into ".colorize(:light_blue) + cur_dir.colorize(:light_cyan) + "\n"
            system("git clone #{link.strip} #{cur_dir}")
          else
            print "Plugin: ".colorize(:light_blue) + "#{link.strip}".colorize(:green) + " already installed.\n".colorize(:light_cyan)
          end
        end
      end
    end
  when "r"
    print "Removing plugins not on the list...\n".colorize(:yellow)

    # getting Home dir + vim budles dir
    dir = Dir.open Dir.home + "/.vim/bundle/"

    plugins = [".", ".."]

    # getting bundle.list
    File.open(Dir.home + "/.vim/bundle.list") do |file|
      while link = file.gets
        unless link.length <= 1 or link.strip.match(/^#.*/) then
          # getting last part of URL -> dir name without .git suffix
          last_part = URI(link).path.split('/').last.split('.')

          #removing the .git part
          last_part.pop

          # joining together remaining pieces to get i.e. ctrlp.vim.git
          plugins.push(last_part.join("."))
        end
      end
    end

    #listing each plugin dir
    dir.each do |file|
      #ignoring all plugins on the list
      unless  plugins.include?(file) then
        cur_dir = dir.path + file
        print "Removing: ".colorize(:light_red) + "#{cur_dir}\n".colorize(:green)
        FileUtils.rm_rf cur_dir
      end
    end
  else
    puts opts
    exit(1)
end

print "done :)\n".colorize(:light_magenta)

