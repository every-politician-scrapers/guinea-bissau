#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Entered'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[name start end].freeze
    end

    def vacant?
      super || itemLabel.include?('?') || itemLabel.include?('No Legislative')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
