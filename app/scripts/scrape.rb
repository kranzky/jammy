#!/usr/bin/env ruby

require './app/boot'

def _get_sites(year)
  url =
    case year
      when 2014,2015,2016,2017 then "http://globalgamejam.org/#{year}/jam-sites"
      when 2013 then "http://2013.globalgamejam.org/locations"
      when 2010,2011,2012 then "http://archive.globalgamejam.org/Locations/#{year}"
      when 2009 then "http://archive.globalgamejam.org/game_browser"
    end
  page = 0
  while true
    puts "Page #{page}"
    break unless response = RestClient.get("#{url}?page=#{page}")
    doc = Nokogiri::HTML(response.body)
    rows =
      case year
        when 2017 then doc.css("div.l-main li.views-row")
        when 2010,2011,2012,2013 then doc.css("table.views-table tr")
        when 2009 then doc.css('select#edit-tid option')
      end
    rows.each do |row|
      next if row.css("th").length > 0
      title =
        case year
          when 2017 then row.children.css("div.jam-site-title a").first
          when 2010,2011,2012,2013 then row.css("td.views-field-title a").first
          when 2009 then row.text
        end
      country =
        case year
          when 2017 then row.children.css("div.jam-site-meta a")[0]['href'][-2..-1]
          when 2013 then row.css("td.views-field-field-country").first.text
          when 2012 then row.css("td.views-field-tid-2").text
          when 2010,2011 then row.css("td.views-field-tid-2 img").first['title']
          when 2009 then title.split(', ').last.gsub(/ - .*/, '')
        end
      country.gsub!(/^[[:space:]]*/i, '')
      country.gsub!(/[[:space:]]*$/i, '')
      args = {
        year: year == 2009 ? 2009 : title['href'].split('/')[-2].to_i,
        slug: year == 2009 ? title.tr(' ', '').tr(',', '-').downcase : File.basename(title['href']),
        name: year == 2009 ? title.gsub(country, '').tr(',', ' ').gsub(/ +/, ' ').strip : title.text,
        country: country
      }
      raise if year != args[:year]
      site = Models::Site.find_or_create(args)
      site.save
    end
    page += 1
    sleep 5
  end
end

def _get_users(site)
  url =
    case site.year
      when 2014,2015,2016,2017 then "http://globalgamejam.org/#{year}/jam-sites"
      when 2013 then "http://2013.globalgamejam.org/sites/2013/#{site.slug}/jammers"
      when 2010,2011,2012 then "http://archive.globalgamejam.org/sites/#{site.year}/#{site.slug}/jammers"
    end
  return unless url
  page = 0
  while true
    puts "Page #{page}"
    break unless response = RestClient.get("#{url}?page=#{page}")
    doc = Nokogiri::HTML(response.body)
    rows =
      case site.year
        when 2017 then doc.css("div.l-main li.views-row")
        when 2010,2011,2012,2013 then doc.css("table.views-view-grid td")
      end
    rows.each do |row|
      next if row.css("div").length == 0
      slug = File.basename(row.css("a").first['href'])
      name = row.css("div.views-field-title").first.text
      name.gsub!(/^[[:space:]]*/i, '')
      name.gsub!(/[[:space:]]*$/i, '')
      args = {
        slug: slug,
        name: name,
        image: row.css("img").first['src']
      }
      user = Models::User.find_or_create(args)
      user.save
      next if site.users(reload: true).include?(user)
      site.add_user(user)
    end
    page += 1
    sleep 5
    break
  end
end

Models::Site.where(year: 2011).each do |site|
  _get_users(site)
end
