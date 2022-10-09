
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    field :name do
      name_and_position.first.gsub(/^Senhora? /, '')
    end

    field :position do
      name_and_position.last.gsub(';', '').tidy
    end

    field :gender do
      return 'female' if noko.start_with? 'Senhora'
      return 'male'   if noko.start_with? 'Senhor'
    end

    def empty?
      !noko.include?('–')
    end

    private

    def name_and_position
      noko.split(' – ', 2).map(&:tidy)
    end
  end

  class Members
    def member_container
      noko.css('.article-content p').children.map(&:text).map(&:tidy).reject(&:empty?)
    end

    def member_items
      super.reject(&:empty?)
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
