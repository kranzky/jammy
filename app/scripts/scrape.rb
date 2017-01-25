#!/usr/bin/env ruby

require './app/boot'

def _get_sites
  url = "http://globalgamejam.org/2017/jam-sites"
  page = 0
  while true
    puts "Page #{page}"
    break unless response = RestClient.get("#{url}?page=#{page}")
    doc = Nokogiri::HTML(response.body)
    doc.css("div.l-main li.views-row").each do |row|
      title = row.children.css("div.jam-site-title a")[0]
      options = {
        year: title['href'].split('/')[1].to_i,
        slug: File.basename(title['href']),
        name: title.text,
        country: row.children.css("div.jam-site-meta a")[0]['href'][-2..-1]
      }
      next if Models::Site(year: options[:year], slug: options[:slug]).present?
      site = Models::Site.new(options)
      site.save
    end
    page += 1
    sleep 5
  end
end

_get_sites
