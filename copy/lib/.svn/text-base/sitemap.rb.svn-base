
class Sitemap
  require 'fastercsv'
  require 'design.rb'
  require 'rubygems'
  require 'fileutils'
  require 'builder'
  require 'logger'
  require 'csv'
  require 'uri'
  
  @log = Logger.new(File.open('log/sitemap.log','a'))
  
  # This method creates the script that will generate the sitemap xmls for cleartrip

  def self.generate_sitemap(static = "")
    log "-------------------Start-------------------"
    #create output directory if doesnt exist !
    self.create_output_dir()
    
    # delete previous content from output directory
    if CLEARTRIP["DELETE_OP_DIR_CONTENT"] == "Y"
      log "Deleting old xml files.."
      Dir[CLEARTRIP["OUTPUT_DIR"] + "*.xml"].each do |file_name|
        File.delete(file_name)
      end
    end
    
    # copy static file into sitemap directory
    unless static == ""
      begin
        FileUtils.cp static, CLEARTRIP["OUTPUT_DIR"] + CLEARTRIP["STATIC_FILE_NAME"]
        log "Static xml file #{static} copied into output directory."
      rescue
        log "Wrong static xml file path provided."
      end
    else
      log "No Static xml file path provided."
    end
    
    # generate xml for designs
    generate_design_xmls()

    # generate xml for learning
    generate_learning_xmls

    # generate xml for learning
    generate_game_xmls

    # generate xml for learning
    generate_news_xmls


    #generates site index file with all the xml urls in it
    generate_sitemap_index()
    
  end

  def self.create_output_dir()
    
    unless File.directory?(CLEARTRIP["OUTPUT_DIR"])
      curr = "/"
      CLEARTRIP["OUTPUT_DIR"].split('/').each do |dir|
        unless File.directory?(curr + dir)
          FileUtils.mkdir(curr + dir)
          log "Created directory : " + curr + dir
        end
        curr << dir << "/"
      end
      log "Output Directory created successful."
      
    end
    
    
  end

  def self.generate_design_xmls

    log "Fetching designs info :"
    #    hotels = Net::HTTP.get(URI.parse(CLEARTRIP["STATION_CSV_URL"]))
    designs = Design.find_all_active_for_xml
    log "generating design xmls :"
    i = 1
    file_count = 1
    loc = []
    designs.each_with_index do |design,index|
      loc << escape(CLEARTRIP["SITE_URL"] + 'designs/design/'+ design.permalink)
      i = i + 1
      if i >= CLEARTRIP["XML_NODE_LIMIT"] or index == (designs.size - 1)
        xm = Builder::XmlMarkup.new(:indent => 2 )
        xm.instruct!
        xm.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do | us |
          loc.each do |url|
            us.url do |u|
              u.loc(url)
            end
          end
        end

        f= File.new(CLEARTRIP["OUTPUT_DIR"] + "designs-#{file_count.to_s}.xml",'w')
        f << xm.target!
        f.close
        log "Created designs-#{file_count.to_s}.xml file with #{i.to_s} nodes."
        # clearing the variables
        loc = []
        file_count += 1
        i = 1
      end
    end # design.each

    #    log "Total " + hotels.length.to_s + " hotels."
    #    log "Total " + file_count.to_s + " stations xmls."
    #    log "Deleting temp files.."
    #    File.delete( CLEARTRIP["OUTPUT_DIR"] + 'stations.txt')
    log "Done."

  end

  def self.generate_learning_xmls

    log "Fetching learnings info :"
    #    hotels = Net::HTTP.get(URI.parse(CLEARTRIP["STATION_CSV_URL"]))
    learnings = Learning.find_all_active_for_xml
    log "generating learning xmls :"
    i = 1
    file_count = 1
    loc = []
    learnings.each_with_index do |learning,index|
      loc << escape(CLEARTRIP["SITE_URL"] + 'learnings/learning/'+ learning.permalink)
      i = i + 1
      if i >= CLEARTRIP["XML_NODE_LIMIT"] or index == (learnings.size - 1)
        xm = Builder::XmlMarkup.new(:indent => 2 )
        xm.instruct!
        xm.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do | us |
          loc.each do |url|
            us.url do |u|
              u.loc(url)
            end
          end
        end

        f= File.new(CLEARTRIP["OUTPUT_DIR"] + "learnings-#{file_count.to_s}.xml",'w')
        f << xm.target!
        f.close
        log "Created learnings-#{file_count.to_s}.xml file with #{i.to_s} nodes."
        # clearing the variables
        loc = []
        file_count += 1
        i = 1
      end
    end # design.each

    #    log "Total " + hotels.length.to_s + " hotels."
    #    log "Total " + file_count.to_s + " stations xmls."
    #    log "Deleting temp files.."
    #    File.delete( CLEARTRIP["OUTPUT_DIR"] + 'stations.txt')
    log "Done."

  end

  def self.generate_game_xmls

    log "Fetching game info :"
    #    hotels = Net::HTTP.get(URI.parse(CLEARTRIP["STATION_CSV_URL"]))
    games = Game.find_all_active_for_xml
    log "generating game xmls :"
    i = 1
    file_count = 1
    loc = []
    games.each_with_index do |game,index|
      loc << escape(CLEARTRIP["SITE_URL"] + 'games/game/'+ game.permalink)
      i = i + 1
      if i >= CLEARTRIP["XML_NODE_LIMIT"] or index == (games.size - 1)
        xm = Builder::XmlMarkup.new(:indent => 2 )
        xm.instruct!
        xm.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do | us |
          loc.each do |url|
            us.url do |u|
              u.loc(url)
            end
          end
        end

        f= File.new(CLEARTRIP["OUTPUT_DIR"] + "games-#{file_count.to_s}.xml",'w')
        f << xm.target!
        f.close
        log "Created games-#{file_count.to_s}.xml file with #{i.to_s} nodes."
        # clearing the variables
        loc = []
        file_count += 1
        i = 1
      end
    end # design.each

    #    log "Total " + hotels.length.to_s + " hotels."
    #    log "Total " + file_count.to_s + " stations xmls."
    #    log "Deleting temp files.."
    #    File.delete( CLEARTRIP["OUTPUT_DIR"] + 'stations.txt')
    log "Done."

  end

  def self.generate_news_xmls

    log "Fetching news info :"
    #    hotels = Net::HTTP.get(URI.parse(CLEARTRIP["STATION_CSV_URL"]))
    news = News.find_all_active_for_xml
    log "generating news xmls :"
    i = 1
    file_count = 1
    loc = []
    news.each_with_index do |new,index|
      loc << escape(CLEARTRIP["SITE_URL"] + 'news/news/'+ new.permalink)
      i = i + 1
      if i >= CLEARTRIP["XML_NODE_LIMIT"] or index == (news.size - 1)
        xm = Builder::XmlMarkup.new(:indent => 2 )
        xm.instruct!
        xm.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do | us |
          loc.each do |url|
            us.url do |u|
              u.loc(url)
            end
          end
        end

        f= File.new(CLEARTRIP["OUTPUT_DIR"] + "news-#{file_count.to_s}.xml",'w')
        f << xm.target!
        f.close
        log "Created news-#{file_count.to_s}.xml file with #{i.to_s} nodes."
        # clearing the variables
        loc = []
        file_count += 1
        i = 1
      end
    end # design.each

    #    log "Total " + hotels.length.to_s + " hotels."
    #    log "Total " + file_count.to_s + " stations xmls."
    #    log "Deleting temp files.."
    #    File.delete( CLEARTRIP["OUTPUT_DIR"] + 'stations.txt')
    log "Done."

  end

  def self.escape(url)
    URI.escape(url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    url
  end
  
  def self.generate_sitemap_index
    
    dir = Dir[CLEARTRIP["OUTPUT_DIR"] + "/*.xml"]
    log "creating sitemap index :"
    
    xm = Builder::XmlMarkup.new(:indent => 2 )
    xm.instruct!
    xm.sitemapindex(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do | si |
      dir.each do |filename|
        si.sitemap do |s|
          s.loc((CLEARTRIP["OUTPUT_URL"] + filename.split('/').last))
          s.lastmod(File.open(filename,'r').mtime.to_date.to_s)
          
        end
      end
    end
    
    # delete old sitemap index if already exists
    log "deleting old sitemap file if exists.."
    of = File.delete(CLEARTRIP["OUTPUT_DIR"] + "sitemap.xml") if File.exist?(CLEARTRIP["OUTPUT_DIR"] + "sitemap.xml")
    
    f= File.new(CLEARTRIP["OUTPUT_DIR"] + "sitemap.xml",'w')
    f << xm.target!
    f.close
    log "Sitemap index created successfully."
    log "-------------------Done--------------------\n"
  end
  
  def self.log(message)
    message =  Time.now.to_s(:db) + " : " + message
    @log.debug message
    puts message
  end
  
end
