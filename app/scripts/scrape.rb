#!/usr/bin/env ruby

require './app/boot'

VideoInfo.provider_api_keys = {
  youtube: ENV['YOUTUBE_API_KEY'],
  vimeo: ENV['VIMEO_API_KEY']
}

def check(uri)
  url = URI.parse(uri)
  req = Net::HTTP.new(url.host, url.port)
  req.request_head(url.path).code.to_i
end

def add_game(year, url)
  return if Models::Game.find(year: year, url: url)
  return unless response = RestClient.get(url)
  doc = Nokogiri::HTML(response.body)
  name = doc.css("h1").text
  image = doc.css("div.featured-image img").first.try(:[], 'src').gsub(/\?itok=.*$/, '')
  video = doc.css('div.field--name-field-game-video-link a').first.try(:[], 'href')
  play = doc.css('div.field--name-field-game-play-now a').first.try(:[], 'href')
  game = Models::Game.new({
    year: year,
    url: url,
    name: name,
    image: image,
    video: video,
    play: play
  })
  game.save if game.valid?
end

def games_2017
  url = "http://globalgamejam.org/2017/games"
  page = 0
  while true
    puts "Page #{page}"
    break unless response = RestClient.get("#{url}?page=#{page}")
    doc = Nokogiri::HTML(response.body)
    doc.css("div.l-content li.views-row a").each do |link|
      add_game(2017, "http://globalgamejam.org#{link['href']}")
    end
    page += 1
  end
end

def games_2016
  url = "http://globalgamejam.org/2016/games"
  page = 0
  while true
    puts "Page #{page}"
    break unless response = RestClient.get("#{url}?page=#{page}")
    doc = Nokogiri::HTML(response.body)
    doc.css("div.l-content li.views-row a").each do |link|
      add_game(2016, "http://globalgamejam.org#{link['href']}")
    end
    page += 1
  end
end

def games_2015
  url = "http://globalgamejam.org/2015/games"
  page = 0
  while true
    puts "Page #{page}"
    break unless response = RestClient.get("#{url}?page=#{page}")
    doc = Nokogiri::HTML(response.body)
    doc.css("div.l-content li.views-row a").each do |link|
      add_game(2015, "http://globalgamejam.org#{link['href']}")
    end
    page += 1
  end
end

def games_2014
  url = "http://globalgamejam.org/2014/games"
  page = 0
  while true
    puts "Page #{page}"
    break unless response = RestClient.get("#{url}?page=#{page}")
    doc = Nokogiri::HTML(response.body)
    doc.css("div.l-content li.views-row a").each do |link|
      add_game(2014, "http://globalgamejam.org#{link['href']}")
    end
    page += 1
  end
end

def games_2013
  url = "http://2013.globalgamejam.org/games/2013"
  page = 0
  while true
    puts "Page #{page}"
    break unless response = RestClient.get("#{url}?page=#{page}")
    doc = Nokogiri::HTML(response.body)
    doc.css("table td").each do |item|
      image = item.css("div.views-field-field-screenshot img").first['src'].gsub('thumbnail', 'large')
      next if image =~ /default_images/
      link = item.css("div.views-field-title a").first
      name = link.text
      next if Models::Game.find(name: name)
      next unless response2 = RestClient.get("http://2013.globalgamejam.org#{link['href']}")
      doc2 = Nokogiri::HTML(response2.body)
      video = doc2.css("div.pane-node-field-video-link a").first
      link = doc2.css("div.pane-node-field-play-now a").first
      game = Models::Game.new({
        name: name,
        image: image,
        video: video.present? ? video['href'] : nil,
        link: link.present? ? link['href'] : nil,
        year: 2013
      })
      game.save
    end
    page += 1
  end
end

def find_game(url, recurse=true)
  case url
  when /\.swf$/
    return [url, :flash]
  when /\.zip$/
    return [nil, nil]
  when /\.apk$/
    return [nil, nil]
  when /airconsole\.com/
    return [nil, nil]
  when /gamejolt\.com/
    return [nil, nil]
  when /mega\.nz/
    return [nil, nil]
  when /globalgamejam\.org/
    return [nil, nil]
  when /google\.com/
    return [nil, nil]
  when /googletagmanager/
    return [nil, nil]
  when /youtube\.com/
    return [nil, nil]
  when /unity3d\.com/
    return [nil, nil]
  when /twitter\.com/
    return [nil, nil]
  when /rockvomit/
    return [url, :html5]
  when /cargowaves/
    return [url, :html5]
  when /sumonami/
    return [url, :html5]
  end
  response =
    begin
      if (url !~ /http/)
        RestClient.get("http:" + url)
      else
        RestClient.get(url)
      end
    rescue => e
      puts "ERROR: #{e.message}"
    end
  return [nil, nil] if response.nil?
  if response.code != 200
    puts "CODE: #{response.code}"
    return [nil, nil]
  end
  doc = Nokogiri::HTML(response.body)
  doc.css("script").map { |s| s['src'] }.compact.each do |src|
    case src
    when /scratch\.mit/i
      return [url, :scratch]
    when /\/c2runtime/i
      return [url, :construct2]
    when /\/unityloader/i
      return [url, :unity]
    when /\/phaser/i
      return [url, :phaser]
    when /\/supruntime/i
      return [url, :superpowers]
    when /\/three\./
      return [url, :three]
    when /\/rpg_core\./
      return [url, :rpgmaker]
    end
  end
  return [url, :construct2] if response.body =~ /construct 2/i
  return [url, :twine] if response.body =~ /tw-story/i
  return [url, :pico8] if response.body =~ /pico8/i
  if doc.css("canvas").present?
    return [url, :html5]
  end
  if recurse
    doc.css("iframe").map { |i| i['src'] }.compact.each do |src|
      if src !~ /\/\//
        debugger
      end
      retval = find_game(src, false)
      return retval if retval.first.present?
    end
    doc.css("object").map { |i| i['data'] }.compact.each do |src|
      if src !~ /\/\//
        debugger
      end
      retval = find_game(src, false)
      return retval if retval.first.present?
    end
    doc.css("embed").map { |i| i['src'] }.compact.each do |src|
      if src !~ /\/\//
        debugger
      end
      retval = find_game(src, false)
      return retval if retval.first.present?
    end
  end
  return [url, :html5] if response.body =~ /vue\.js/i
  [url, :check]
end

def check_plays
  Models::Game.order(:id).each do |game|
    next if game.play.blank?
    next if game.id < 10622
    puts "* #{game.id}:#{game.name}"
    url, engine = find_game(game.play)
    next if game.play == url && game.engine == engine && engine != "check" && engine != "delete"
    if url.nil?
      game.engine = "delete"
    else
      game.play = url
      game.engine = engine.to_s
    end
    game.save
  end
end

def check_videos
  Models::Game.each do |game|
    next if game.video.blank?
    video =
      begin
        VideoInfo.new(game.video)
      rescue => e
        puts e
      end
    puts "#{game.id}:#{game.name}:#{game.video}"
    if video && video.available?
      game.video = video.embed_url
    else
      if video && video.provider.present?
        game.video = video.embed_url
      else
        game.video = nil
      end
    end
    game.save
  end
end

def check_images
  Models::Game.each do |game|
    next if game.id < 3170
    code = check(game.image)
    puts "#{game.id}:#{code}:#{game.name}"
    next if code == 200
    response = RestClient.get(game.url)
    doc = Nokogiri::HTML(response.body)
    image = doc.css("div.featured-image img").first.try(:[], 'src')
    if image.nil?
      puts "!!! DESTROY !!!"
      puts game.url
      debugger
      next
    end
    image.gsub!(/\?itok=.*$/, '')
    if game.image != image && check(image) == 200
      game.image = image
      game.save
    else
      image.gsub!('globalgamejam.org/system/files', 'ggj.s3.amazonaws.com')
      if game.image != image && check(image) == 200
        game.image = image
        game.save
      else
        image.gsub!('__normal', '__wide')
        if game.image != image && check(image) == 200
          game.image = image
          game.save
        else
          puts "!!! DESTROY !!!"
          puts game.url
          debugger
        end
      end
    end
  end
end

def repair_urls
  url = "http://globalgamejam.org/2017/games"
  page = 0
  while true
    lookup = {}
    puts "Page #{page}"
    break unless response = RestClient.get("#{url}?page=#{page}")
    doc = Nokogiri::HTML(response.body)
    doc.css("div.l-content li.views-row a").each do |link|
      title = link.css('div.views-field-title').text
      title.gsub!(/^\s*/, '')
      title.gsub!(/\s*$/, '')
      lookup[title] = "http://globalgamejam.org#{link['href']}"
    end
    lookup.each do |name, url|
      Models::Game.where(name: name, year: 2017).all.each do |game|
        next if game.url =~ /globalgamejam/
        game.play = game.url
        game.url = url
        ap game
        debugger
      end
    end
    page += 1
  end
end

def fix_dupes
  dupes = Hash.new { |hash, key| hash[key] = 0 }
  Models::Game.where(year: 2017).map(&:url).each { |url| dupes[url] += 1 }
  dupes.select! { |url, count| count > 1 }
  dupes.keys.each do |url|
    Models::Game.where(url: url).all.each do |game|
      ap game
      debugger
    end
  end
end

def get_country(url)
  return unless response = RestClient.get(url)
  doc = Nokogiri::HTML(response.body)
  name = doc.css("span.country").first.text
  name = "Hong Kong" if name == "Hong Kong S.A.R., China"
  name = "Palestine" if name == "Palestinian Territory"
  name = "Macao" if name == "Macao S.A.R., China"
  ISO3166::Country.find_country_by_name(name).try(:alpha2)
end

def scrape_country
  sites = {}
  Models::Game.all.each do |game|
    next if game.country.present?
    next unless response = RestClient.get(game.url)
    doc = Nokogiri::HTML(response.body)
    site = doc.css("div.field--name-og-group-ref a").first.try(:[], 'href')
    sites[site] ||= get_country(site) if site.present?
    country = sites[site]
    game.country = country
    ap game
    if country.blank?
      puts "??? COUNTRY"
      debugger
    end
    play = doc.css('div.field--name-field-game-play-now a').first.try(:[], 'href')
    if play != game.play
      if game.play =~ /globalgamejam.org/
        puts "*** FIX BAD ***"
        game.play = play
      elsif game.play.present? && game.play !~ /\/\//
        puts "*** FIX SWF ***"
        game.play = play
      elsif play.present? && game.play !~ /^\/\//
        puts "??? PLAY"
        debugger
      end
    end
    game.save
  end
end

# TODO: add key for sorting (filename of URL)

# TODO: deal with delete/check/html5 games and eyeball the others

# TODO: scrape description so we can show inline, in a pop-up with tabs

# TODO: build UX (sidebar with controls, search box at top, infinite scroll with back-to-top, dialog on click with slider to show info, video, play, with full screen controls)

# TODO: add rating and share to twitter

# TODO: update these stats: (official, screenshot, plus video, plus play now)
#   + 2017: 7260,5509,925,790
#   + 2016: 6867,4376,611,679
#   + 2015: 5438,3525,556,844
#   + 2014: 4284,2759,443,819
#   + tots: 23849,16169,2535,3144
