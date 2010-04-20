# coding: utf-8

# remove_ds_store.rb
#
# +++ usage +++
# $ ruby remove_ds_store.rb /Users/name/dir
# $ /usr/local/bin/ruby19 remove_ds_store.rb /Users/name/dir 'rmf'
#
# +++ history +++
# 2010-04-20
# Mac OS X 10.6.3 
# ruby 1.8.7 (2009-06-08 patchlevel 173) [universal-darwin10.0]
# ruby 1.9.1p378 (2010-01-10 revision 26273)
#
# 2009-09-30
# Mac OS X 10.6.1
# ruby 1.8.7 (2008-08-11 patchlevel 72) [universal-darwin10.0]
# ruby 1.9.1p243 (2009-07-16 revision 24175)
#
# 2008-09-06
# fix: path include space character .
# 2008-01-21
# http://www.midore.net/daybook/2008/01/1200841265.html

require 'find'

class DSStore
  def initialize(path, option)
    @path = path
    @option = option
    @checkdir = FileTest.directory?(path)
    @checkpath = File.exist?(path)
    @list = Array.new
  end

  def ls_or_rm
    return print "not found directory\n" unless @checkpath
    return print "It is not directory\n" unless @checkdir
    return print "not found .DS_Store file\n" if list.empty?
    @list.each{|f|
      file = f =~ /\s/ ? f.gsub(/\s/, "\\ " ) : f
      @option == 'rmf' ? sys_rm(file) : sys_ls(file)
    }
  end

  private

  def list
    Find.find(@path){|path| @list << path if File.basename(path) == ".DS_Store"}
    return @list
  end

  def sys_ls(f)
    gf = f.gsub("&","*")
    system("ls  #{gf}")
  end

  def sys_rm(f)
    system("rm #{f}")
    print "Removed: #{f}\n"
  end

end

t = Time.now
dirpath = Dir.pwd

dir,opt = ARGV[0],ARGV[1]
dirpath = dir unless dir.nil?
option = opt unless opt.nil?
DSStore.new(dirpath, option).ls_or_rm

# time
t2 = Time.now - t
print "\n=>Time: #{t2.to_s}\n"

