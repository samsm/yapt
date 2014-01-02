require 'erb'
require 'rainbow'

module Yapt
  class View
    def self.extract_display_config(args)
      display = args.detect {|a| a =~ /\Av(iew)?[=:]/ }
      args.delete(display)
      display ? display.split(/[=:]/).last : nil
    end

    def initialize(stories)
      @stories = stories
    end

    def display(template_name)
      template_path = "#{template_dir}/#{template_name}.erb"
      if File.exists?(template_path)
        template = IO.read template_path
        ERB.new(template, 0, '-').result(binding)
      else
        raise "#{template_path} missing!"
      end
    end

    def template_dir
      "#{File.dirname(__FILE__)}/templates"
    end
  end
end
