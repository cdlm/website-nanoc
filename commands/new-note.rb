# -*- encoding : utf-8 -*-
usage 'create-post [options] title [slug]'
aliases :note, :post
summary 'create a blog post'
description <<___
Create a new post under /notes/ with some basic boilerplate content.
___

required :t, :tags, 'comma-separated post tags (default: none)'
required :d, :date, 'specify created_at date (default: today)'

module Commands

  class CreatePost < ::Nanoc::CLI::CommandRunner
    PREFIX = '/notes/'
    STOP_WORDS = %w(a an the or and for at is)

    def run
      unless arguments.length.between? 1,2
        raise Nanoc::Errors::GenericTrivial, "usage: #{command.usage}"
      end
      @tags = if options.has_key? :tags
                options[:tags].split ','
              else [] end
      @date = if options.has_key? :date
                require 'chronic'
                Chronic.parse options[:date]
              else Date.today end
      @title, @slug = arguments
      @slug = sluggify(@slug || @title)
      apply_yaml_hacks

      require_site
      check_available_identifier identifier
      setup_notification

      site.data_sources.first.create_item content, metadata, identifier
    end

    def identifier
      "#{PREFIX}#{@date.year}/#{@slug}/".cleaned_identifier
    end

    def metadata
      { title: @title, created_at: @date, tags: @tags }
    end

    def content
      <<___
<% excerpt :summary do %>
  here be a front page excerpt
<% end %>

here be some interesting stuff
___
    end

    def sluggify str
      str.downcase.gsub(/[^\w\s-]/, '') \
        .split.reject { |word| STOP_WORDS.include? word } \
        .join '-'
    end

    def check_available_identifier candidate
      unless self.site.items[candidate].nil?
        raise Nanoc::Errors::GenericTrivial,
          "A post already exists at #{candidate}. Please specify a different slug."
      end
    end

    def setup_notification
      Nanoc::NotificationCenter.on(:file_created) do |file_path|
        Nanoc::CLI::Logger.instance.file(:high, :create, file_path)
      end
    end

    private

    def apply_yaml_hacks
      # Does not work…
      # def @tags.to_yaml( opts = {} )
      #   YAML::quick_emit( self, opts ) do |out|
      #     out.scalar nil, "[#{self.join ', '}]", :plain
      #   end
      # end
      def @date.to_yaml( opts = {} )
        YAML::quick_emit( self, opts ) do |out|
          out.scalar nil, self.strftime('%F'), :plain
        end
      end
    end
  end
end

runner Commands::CreatePost
