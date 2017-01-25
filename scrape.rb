#!/usr/bin/env ruby

require 'json'
require 'uri'

require 'bundler'
Bundler.require(:default)

URL = "http://globalgamejam.org/views/ajax"
ARGS = {
  view_name: "games",
  view_display_id: "listing_page",
  view_args: 2017,
  page: 0
}

blob = File.read('games.txt')
games = Set.new((blob || "").split)

while true
  break unless blob = RestClient.post(URL, ARGS)
  puts "Page #{ARGS[:page]}"
  doc = Nokogiri::HTML(JSON.parse(blob)[1]['data'])
  doc.css("ul li a").each do |game|
    next unless game['href'] =~ /\/games\/(.*)$/
    games << URI.decode(Regexp.last_match(1))
  end
  File.open('games.txt', 'w') { |f| f.write(games.to_a.sort.join("\n")) }
  ARGS[:page] += 1
  sleep 5
end
