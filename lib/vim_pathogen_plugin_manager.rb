require "vim_pathogen_plugin_manager/version"
require 'optparse'
require 'uri'
require 'colorize'

module VimPathogenPluginManager

  class Manager

    def initialize
      # getting Home dir + vim budles dir
      @dir = Dir.open Dir.home + "/.vim/bundle/"
      @bundle_list = Dir.home + "/.vim/bundle.list"
    end

    def parse_options
      @options = {}

      @opts = OptionParser.new

      @opts.banner = "Usage: plugin_manager.rb [options]"

      @opts.on("-u", "--update", "Update all Vim plugins") do |u|
        @options[:action] = "u"
      end

      @opts.on("-i", "--install", "Install Vim plugins from list [bundle.list]") do |i|
        @options[:action] = "i"
      end

      @opts.on("-r", "--remove", "Remove Vim plugins not on the list [bundle.list]") do |r|
        @options[:action] = "r"
      end

      @opts.on("-p", "--path [path_to_file]", "Path to [bundle.list]") do |p|
        @options[:path] = p
      end

      @opts.on_tail("-h", "--help", "Show this message") do
        puts @opts
        exit
      end

      @opts.on_tail("--version", "Show version") do
        puts VimPathogenPluginManager::VERSION
        exit
      end

      @opts.on_tail("--usage", "Show usage example") do
        puts "Example usage (install plugins)".colorize(:yellow) + " vim_pathogen_plugin_manager -i -p /home/user/custom_bundle.list".colorize(:light_blue)
        exit
      end

      begin
        @opts.parse!(ARGV)
      rescue OptionParser::InvalidOption => e
        puts e
        puts @opts
      end
    end

    def run
      valid_option = true

      if @options[:path] then
        @bundle_list = @options[:path]
      end

      case @options[:action]
        when "u"
          update
        when "i"
          install
        when "r"
          remove
        else
          puts @opts
          valid_option = false
      end

      if valid_option then
        print "done :)\n".colorize(:light_magenta)
      end
    end

    private

    def update
      print "Updating all plugins...\n".colorize(:yellow)

      # listing each plugin dir
      @dir.each do |file|
        # ignoring . and ..
        unless  ['.', ".."].include?(file) then
          cur_dir = @dir.path + file
          print "Updating: ".colorize(:light_blue) + "#{cur_dir}\n".colorize(:green)
          system "git -C #{cur_dir} pull"
        end
      end
    end

    def install
      print "Installing all plugins from bundle.list...\n".colorize(:yellow)

      File.open @bundle_list do |file|
        while link = file.gets
          unless link.length <= 1 or link.strip.match(/^#.*/) then

            # getting last part of URL -> dir name without .git suffix
            last_part = URI(link).path.split('/').last.split('.')

            #removing the .git part
            last_part.pop

            # joining together remaining pieces to get i.e. ctrlp.vim.git
            cur_dir = @dir.path + last_part.join(".")

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
    end

    def remove
      print "Removing plugins not on the list...\n".colorize(:yellow)

      plugins = [".", ".."]

      # getting bundle.list
      File.open @bundle_list do |file|
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
      @dir.each do |file|
        #ignoring all plugins on the list
        unless  plugins.include?(file) then
          cur_dir = @dir.path + file
          print "Removing: ".colorize(:light_red) + "#{cur_dir}\n".colorize(:green)
          FileUtils.rm_rf cur_dir
        end
      end
    end
  end

  def self.check_git_version
    git_version = `git --version`
    git_version = git_version.gsub(/git version /, '').split(".")
    unless (git_version[0].to_i >= 1 and git_version[1].to_i >= 8 and git_version[2].to_i >= 5) then
      puts "You need git version 1.8.5.x or greater.".colorize(:red)
    end
  end

end
