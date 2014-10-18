#!/bin/ruby
# Copyright (C) 2014 Nicolas Hammond
# Script to take as input various CSV files and create output in "players" directory.
# Each player that is listed in the CSV files will have an entry in players.

require 'time'

# Slurp in winners file
#Year,Event,Place,Player 1,
#1946,Wernher Open Pairs,1,A. Mitchell Barnes,0
data = File.read("winners.csv")

players = Array.new
winners = Array.new
player_db = Hash.new { |h, k| h[k] = Hash.new(0) }
#ph = Hash.new { Array.new }
#win = Hash.new
# ph = Array.new

# Create an arrary to hold list of winners with 5 or 10 NABC wins
winners5 = Array.new
winners10 = Array.new

# ph = Hash.new
first_line = 1
CSV_DELIMITER = ","

today = Time.now
d1 = today.strftime("%Y-%m-%d")

# Refs
#fishbein_ref = "<ref>{{cite news
# | title = "Fishbein"
# | author = 
# | publisher = American Contract Bridge League
# | url = #{event[:url]}
# | page = #{event[:page]}
# | date = #{date}
# | accessdate = #{d1} }}</ref>"
#  end
#fishbein_ref = "<
#fishbein_ref = "<ref>{{cite news

von_zedtwitz_ref = "<ref>[http://www.fpabridge.org/vonzedtwitz.htm Foundation for the Preservation and Advancement of Bridge - von Zedtwitz Award]</ref>"
blackwood_ref = "<ref>[http://www.fpabridge.org/blackwood.htm Foundation for the Preservation and Advancement of Bridge - Blackwood Award]</ref>"
wbf_ref = "<ref>[http://www.worldbridge.org/world-team-championships.aspx World Team Championship Winners]</ref>"
transnational_ref = "<ref>[http://www.worldbridge.org/transnational-open-teams.aspx World Transational Open Teams Winners]</ref>"
rosenblum_ref = "<ref>[http://www.worldbridge.org/world-open-teams.aspx Rosenblum Cup Winners]</ref>"
world_senior_teams_ref = "<ref>[http://www.worldbridge.org/senior-teams.aspx World Senior Teams Winners]</ref>"
# | title = "Fishbein"
# | author = 
# | publisher = American Contract Bridge League
# | url = #{event[:url]}
# | page = #{event[:page]}
# | date = #{date}
# | accessdate = #{d1} }}</ref>"
#  end
#fishbein_ref = "<


# Read in events from events.csv , with xref
event_data = File.read("events.csv")
events = Array.new
events_db = Hash.new { |h, k| h[k] = Hash.new(0) }
event_data.each_line do |csv_row|
	fields = csv_row.chomp.split(CSV_DELIMITER).map(&:strip)
  name = fields[0]
  e = events_db[name]
  e[:name] = fields[1]
  e[:title] = fields[2]
  e[:url] = fields[3]
  e[:page] = fields[4]
  e[:date] = fields[5]
end

# Read in HOF data
acbl_hof_data = File.read("acbl_hof.csv")
acbl_hofs = Array.new
$acbl_hofs_db = Hash.new { |h, k| h[k] = Hash.new(0) }
acbl_hof_data.each_line do |csv_row|
	fields = csv_row.chomp.split(CSV_DELIMITER).map(&:strip)
  year = fields[0]
  name = fields[1]
  ref = fields[2]
  e = $acbl_hofs_db[name]
  e[:year] = year
  e[:ref] = ref
end

# Read in mapping from player name to WBF ID
wbf_id_data = File.read("wbf_ids.csv")
wbf_ids = Array.new
$wbf_ids_db = Hash.new { |h, k| h[k] = Hash.new(0) }
wbf_id_data.each_line do |csv_row|
	fields = csv_row.chomp.split(CSV_DELIMITER).map(&:strip)
  name = fields[0]
  id = fields[1]
  e = $wbf_ids_db[name]
  e[:id] = id
end

# Data with positions.
# Generic routine to read a CSV file that has format
# Year,Position,Name

def read_year_position_name(file_name)
  data = File.read(file_name)
  winners = Array.new
  data.each_line do |csv_row|
	  fields = csv_row.chomp.split(CSV_DELIMITER).map(&:strip)

    year = fields[0]
    position = fields[1]
    name = fields[2]
    winners << {
      year: year,
      position: position,
      name: name
    }
  end
  return winners
end

# Generic routine to read a CSV file that has format
# Year,Name
def read_award_data(file)
  data = File.read(file)
  winners = Array.new
  data.each_line do |csv_row|
  	fields = csv_row.chomp.split(CSV_DELIMITER).map(&:strip)
    year = fields[0]
    name = fields[1]
    winners << {
      year: year,
      name: name
    }
  end
  winners
end

# Bermuda Bowl
$bermuda_bowl_winners = read_year_position_name("bermuda_bowl.csv")
$buffett_cup_winners = read_year_position_name("buffett_cup.csv")
$venice_cup_winners = read_year_position_name("venice_cup.csv")
$dorsi_bowl_winners = read_year_position_name("dorsi_bowl.csv")
$transnational_teams_winners = read_year_position_name("transnational_teams.csv")
$rosenblum_winners = read_year_position_name("rosenblum.csv")
# World events
$world_open_pairs_winners = read_year_position_name("world_open_pairs.csv")
$world_mixed_pairs_winners = read_year_position_name("world_mixed_pairs.csv")
$world_senior_teams_winners = read_year_position_name("world_senior_teams.csv")

# ACBL King of Bridge (handles queen as well)
$acbl_kob_winners = read_award_data("acbl_kob.csv")
# ACBL Player of the Year
$acbl_poy_winners = read_award_data("acbl_poy.csv")
# Different winners
$fishbein_winners = read_award_data("fishbein.csv")
$goren_winners = read_award_data("goren.csv")
$herman_winners = read_award_data("herman.csv")
$mott_smith_winners = read_award_data("mott-smith.csv")
# More HOF award
$acbl_blackwood_winners = read_award_data("acbl_blackwood.csv")
$acbl_zedtwitz_winners = read_award_data("acbl_zedtwitz.csv")

# Returns 1 if contains first place.
def is_first_place(string)
  if (string.include? "1") then
    return 1
  end
  0
end

# Returns 1 if contains second place and not first place
# e.g. 1/2 is first place, not second.
def is_second_place(string)
  if is_first_place(string) == 1 then
    return 0
  end
  1
end

# Returns 1 if they have an honor
def check_if_has_honor(name)
  # Are they in the ACBL HOF
  has_honor = 0
  in_acbl_hof = 0
  e = $acbl_hofs_db[name]

  if (!e.nil?) then
    i = e.size
    # Are they in?
    if i > 1
      has_honor = 1
      in_acbl_hof = 1
      # Uncomment this to see progress.
      puts "In HOF name=#{name}"
    end
  end

#  puts "name=#{name} h=#{has_honor} hof=#{in_acbl_hof} e=#{e} "
  return has_honor, in_acbl_hof
end

# Returns 1 if they have an award
def check_if_has_award(name)
  # Are they in the ACBL HOF
  has_award = 0
  in_acbl_kob = check_if_in_acbl_kob(name)
  in_acbl_poy = check_if_in_acbl_poy(name)
  in_fishbein = check_if_in_fishbein(name)
  in_goren = check_if_in_goren(name)
  in_herman = check_if_in_herman(name)
  in_mott_smith = check_if_in_mott_smith(name)
  in_blackwood = check_if_in_blackwood(name)
  in_zedtwitz = check_if_in_zedtwitz(name)

  if ((in_fishbein == 1) || 
      (in_acbl_kob == 1) || 
      (in_acbl_poy == 1) || 
      (in_blackwood == 1) ||
      (in_zedtwitz == 1) ||
      (in_goren == 1) || 
      (in_herman == 1) || 
      (in_mott_smith == 1)) then
    has_award = 1
  end

  return has_award, in_acbl_kob, in_acbl_poy, in_fishbein, in_goren, in_herman, in_mott_smith, in_blackwood, in_zedtwitz
end

# Returns 1 if they are in the Bermuda bowl
# Not used any more.
#def check_if_in_bermuda_bowl(name)
#  $bermuda_bowl_winners.each do |winner|
#    if (winner[:name] == name) then
#      return 1
#    end
#  end
#  return 0
#end

# Generic routine to check if a player is listed in an award_winners array
def check_if_in_award(award_winners, name)
  award_winners.each do |winner|
    if (winner[:name] == name) then
      return 1
    end
  end
  return 0
end

# Check if in ACBL King of Bridge
def check_if_in_acbl_kob(name)
  check_if_in_award($acbl_kob_winners, name)
end

# Check if in ACBL player of year
def check_if_in_acbl_poy(name)
  check_if_in_award($acbl_poy_winners, name)
end

# Check if in Fishbein
def check_if_in_fishbein(name)
  check_if_in_award($fishbein_winners, name)
end

# Check if in Goren
def check_if_in_goren(name)
  check_if_in_award($goren_winners, name)
end

# Check if in Herman
def check_if_in_herman(name)
  check_if_in_award($herman_winners, name)
end

# Check if in Mott-Smith
def check_if_in_mott_smith(name)
  check_if_in_award($mott_smith_winners, name)
end

# Check if in Blacwood
def check_if_in_blackwood(name)
  check_if_in_award($acbl_blackwood_winners, name)
end

# Check if in Zedtwitz
def check_if_in_zedtwitz(name)
  check_if_in_award($acbl_zedtwitz_winners, name)
end

# Returns a Wikipidea reference from the event file.
# When we start to get other publishers, update this routine
def get_reference(event)
  s = ""

  return s if (event[:title].nil?)

  if (event[:title].to_s.length > 1) then
    date = event[:date]
    today = Time.now
    d1 = today.strftime("%Y-%m-%d")
    s = "<ref>{{cite news
 | title = #{event[:title]}
 | author = 
 | publisher = American Contract Bridge League
 | url = #{event[:url]}
 | page = #{event[:page]}
 | date = #{date}
 | accessdate = #{d1} }}</ref>"
  end

  return s
end

# Get ACBL Hall of Fame reference
def get_hof_reference(name, hof_id)
  today = Time.now
  d1 = today.strftime("%Y-%m-%d")
  s = "<ref>{{cite web 
 | title = Hall of Fame
 | author = 
 | publisher = ACBL
 | url = http://www.acbl.org/about/hall-of-fame/members/#{hof_id}
 | date = 
 | accessdate = #{d1} }}</ref>"
 s
end

# Returns the year/position data for a player
# returns nentries, years (in string format)
def get_year_position_data(winners, player_name, position)
  nentries = 0
  i_position = position.to_i
  years = Array.new

  winners.each do |winner|
    if (winner[:name] == player_name) then
      if (winner[:position].to_i == i_position) then
        nentries = nentries + 1
        years << winner[:year].to_i
      end
    end
  end

  if (nentries > 0) then
    years.sort!
    years.uniq!
    years_s = years.join(", ")
  else
    years_s = ""
  end

  return nentries, years_s
end

# Returns the bermuda bowl data for a player
# returns nentries, years (in string)
def get_bermuda_bowl_data(player_name, position)
  get_year_position_data($bermuda_bowl_winners, player_name, position)
end

def get_buffett_cup_data(player_name, position)
  get_year_position_data($buffett_cup_winners, player_name, position)
end

def get_venice_cup_data(player_name, position)
  get_year_position_data($venice_cup_winners, player_name, position)
end

def get_dorsi_bowl_data(player_name, position)
  get_year_position_data($dorsi_bowl_winners, player_name, position)
end

def get_transnational_teams_data(player_name, position)
  get_year_position_data($transnational_teams_winners, player_name, position)
end

def get_rosenblum_data(player_name, position)
  get_year_position_data($rosenblum_winners, player_name, position)
end

def get_world_mixed_pairs_data(player_name, position)
  get_year_position_data($world_mixed_pairs_winners, player_name, position)
end

def get_world_open_pairs_data(player_name, position)
  get_year_position_data($world_open_pairs_winners, player_name, position)
end

def get_world_senior_teams_data(player_name, position)
  get_year_position_data($world_senior_teams_winners, player_name, position)
end


# Returns the bermuda bowl data for a player
# returns nentries, years (in string)
def get_award_data(award_data, player_name, position)
  nentries = 0
  i_position = position.to_i
  years = Array.new

  award_data.each do |winner|
    if (winner[:name] == player_name) then
      nentries = nentries + 1
      years << winner[:year].to_i
    end
  end

  # If we have some entries, sort, make unique, then combine
  if (nentries > 0) then
    years.sort!
    years.uniq!
    years_s = years.join(", ")
  else
    years_s = ""
  end

  return nentries, years_s
end

# returns nentries, years (in string)
def get_acbl_kob_data(player_name, position)
  get_award_data($acbl_kob_winners, player_name, position)
end

def get_acbl_poy_data(player_name, position)
  get_award_data($acbl_poy_winners, player_name, position)
end

def get_fishbein_data(player_name, position)
  get_award_data($fishbein_winners, player_name, position)
end

def get_goren_data(player_name, position)
  get_award_data($goren_winners, player_name, position)
end

def get_herman_data(player_name, position)
  get_award_data($herman_winners, player_name, position)
end

def get_mott_smith_data(player_name, position)
  get_award_data($mott_smith_winners, player_name, position)
end

def get_blackwood_data(player_name, position)
  get_award_data($acbl_blackwood_winners, player_name, position)
end

def get_zedtwitz_data(player_name, position)
  get_award_data($acbl_zedtwitz_winners, player_name, position)
end

# This is from the winners.csv file
# Create an array for each line
data.each_line do |csv_row|
	fields = csv_row.chomp.split(CSV_DELIMITER).map(&:strip)
  if (first_line == 1) then
	  first_line = 0
		next
	end

	year = fields[0]
	event_name = fields[1]
	place = fields[2]
  player = fields[3]

  pdf = player_db[player]
  pdf[:wins] ||= 0
  is_first = place
  pdf[:wins] = pdf[:wins] + 1

  players << player

  winners << { 
	  year: fields[0],
		event_name: fields[1],
		place: fields[2],
		player: fields[3]
	}

  winner = {
	  year: fields[0],
		event_name: fields[1],
		place: fields[2],
		player: fields[3]
  }
end

########
## Main routine
########
#
Dir.mkdir("players") unless File.directory?("players")
player_db.each do |ph,pk|

# We can speed it up by using the data in the 5winners or 10winners file
# Comment in/out as need. Comment out line above if you do.
#file_name = "5winners.txt"
#win5 = File.read(file_name)
#win5.each_line do |ph|
#  ph.chomp!
#  puts "Player_db #{h} = #{k} "

  # If this is a blank line, slip
  next if (ph.size <= 1)

  # Filename to be created
  file_name = "players/" + ph.to_s
  File.open(file_name, "w") do |fd|

    # Count the number of NABC wins
    nnabc_wins = 0
    nnabc_seconds = 0
    win_events = Hash.new
    winners.each do |w|
     # Count first place only
      if (ph == w[:player]) then
        if (is_first_place(w[:place]) == 1) then
          nnabc_wins = nnabc_wins + 1
          event_name = w[:event_name]
          win_events[event_name] = 1
        end
        # Count second place
        if (is_second_place(w[:place]) == 1) then
          nnabc_seconds = nnabc_seconds + 1
        end
      end
    end

    # Remember winners with more than 5 NABCs
    if (nnabc_wins >= 5) then
      winners5 << ph.to_s
    end

    # Remember winners with more than 10 NABCs
    if (nnabc_wins >= 10) then
      winners10 << ph.to_s
    end

    # Check to see if they have an honor
    has_honor, in_acbl_hof = check_if_has_honor(ph)
    in_acbl_hof = in_acbl_hof.to_i

    # Check to see if they have an award
    has_award, in_acbl_kob, in_acbl_poy, in_fishbein, in_goren, in_herman, in_mott_smith, in_blackwood, in_zedtwitz = check_if_has_award(ph)

    # Handle names like John R. Crawford
    # Store name in first_names, last_name
    names = ph.split(" ")
    nnames = names.size
    if (nnames == 2) then
      first_names = names[0]
      last_name = names[1]
    else
      first_names = names[0] + " " + names[1]
      last_name = names[2]
    end

    # Header
    # We always put American, but may not be. Need to manually edit if not
    fd.puts "'''#{ph}''' is an [[United States|American]] [[Contract bridge|bridge]] player."

    fd.puts ""

    # Clear out the hof reference variable
    hof_ref = ""

    # Are they in the HOF?
    if (in_acbl_hof == 1) then
      hof = $acbl_hofs_db[ph]
      year = hof[:year]
      ref = hof[:ref]
      # hof_ref is the Wikipedia citation
      hof_ref = get_hof_reference(ph, ref)
      fd.puts "#{last_name} was inducted into the [[American Contract Bridge League]]'s Hall of Fame in #{year}.#{hof_ref}"
    end

    # Wikipedia does not like it if we create a stub entry.
#    fd.puts "== Early Life=="
    # May not be true, but 
#    fd.puts "#{ph} was born in America."
    fd.puts ""
    fd.puts "==Bridge accomplishments=="
    fd.puts ""

    # Find out if this player has an honor
    if (has_honor == 1) then
      fd.puts "===Honors==="
      fd.puts ""

      if (in_acbl_hof == 1) then
        hof = $acbl_hofs_db[ph]
        fd.puts "* ACBL Hall of Fame #{hof[:year]} #{hof_ref}"
      end
      fd.puts ""
    end

    # Do they have an award?
    if (has_award == 1) then
      fd.puts "===Awards==="
      fd.puts ""

      if (in_acbl_kob == 1) then
        nentries, years_s = get_acbl_kob_data(ph, 1)
        # Can only win it once
        fd.puts "* [[ACBL King or Queen of Bridge]] #{years_s}"
      end
      if (in_acbl_poy == 1) then
        nentries, years_s = get_acbl_poy_data(ph, 1)
        fd.puts "* ACBL Player of the Year (#{nentries}) #{years_s}"
      end
      if (in_fishbein == 1) then
        nentries, years_s = get_fishbein_data(ph, 1)
        fd.puts "* [[Fishbein Trophy]] (#{nentries}) #{years_s}"
      end
      if (in_goren == 1) then
        nentries, years_s = get_goren_data(ph, 1)
        fd.puts "* [[Goren Trophy]] (#{nentries}) #{years_s}"
      end
      if (in_herman == 1) then
        nentries, years_s = get_herman_data(ph, 1)
        fd.puts "* [[Herman Trophy]] (#{nentries}) #{years_s}"
      end
      if (in_mott_smith == 1) then
        nentries, years_s = get_mott_smith_data(ph, 1)
        fd.puts "* [[Mott-Smith Trophy]] (#{nentries}) #{years_s}"
      end
      if (in_blackwood == 1) then
        nentries, years_s = get_blackwood_data(ph, 1)
        fd.puts "* Blackwood Award #{years_s} #{blackwood_ref}"
      end
      if (in_zedtwitz == 1) then
        nentries, years_s = get_zedtwitz_data(ph, 1)
        fd.puts "* von Zedtwitz Award #{years_s} #{von_zedtwitz_ref}"
      end
      fd.puts ""
    end

    fd.puts "===Wins==="
    fd.puts ""

    # Check for Bermuda Bowl
    nentries, years_s = get_bermuda_bowl_data(ph, 1)
    if (nentries > 0) then
      fd.puts "* [[Bermuda Bowl]] (#{nentries}) #{years_s} #{wbf_ref}"
      fd.puts ""
    end

    # Check for Venice Cup
    nentries, years_s = get_venice_cup_data(ph, 1)
    if (nentries > 0) then
      fd.puts "* [[Venice Cup]] (#{nentries}) #{years_s} #{wbf_ref}"
      fd.puts ""
    end

    # Check for d'Orsi Cup
    nentries, years_s = get_dorsi_bowl_data(ph, 1)
    if (nentries > 0) then
      fd.puts "* [[Senior Bowl (bridge)|d'Orsi Senior Bowl]] (#{nentries}) #{years_s} #{wbf_ref}"
      fd.puts ""
    end

    # Check for Transnational Teams
    nentries, years_s = get_transnational_teams_data(ph, 1)
    if (nentries > 0) then
      fd.puts "* [[World Transnational Open Teams Championship]] (#{nentries}) #{years_s} #{transnational_ref}"
      fd.puts ""
    end

    # Check for Rosenblum
    nentries, years_s = get_rosenblum_data(ph, 1)
    if (nentries > 0) then
      fd.puts "* [[Rosenblum Cup]] (#{nentries}) #{years_s} #{rosenblum_ref}"
      fd.puts ""
    end

    # World open pairs
    nentries, years_s = get_world_open_pairs_data(ph, 1)
    if (nentries > 0) then
      fd.puts "* [[World Open Pairs Championships]] (#{nentries}) #{years_s}"
      fd.puts ""
    end

    # World mixed pairs
    nentries, years_s = get_world_mixed_pairs_data(ph, 1)
    if (nentries > 0) then
      fd.puts "* [[World Mixed Pairs Championships]] (#{nentries}) #{years_s}"
      fd.puts ""
    end

    # World senior teams
    nentries, years_s = get_world_senior_teams_data(ph, 1)
    if (nentries > 0) then
      fd.puts "* [[World Senior Teams Championships]] (#{nentries}) #{years_s}"
      fd.puts ""
    end

    # Check for Buffett Cup Bowl
    nentries, years_s = get_buffett_cup_data(ph, 1)
    if (nentries > 0) then
      fd.puts "* [[Buffett Cup]] (#{nentries}) #{years_s} #{wbf_ref}"
      fd.puts ""
    end

    if (nnabc_wins > 0) then
      fd.puts "* [[North American Bridge Championships]] (#{nnabc_wins})"

      win_events.each do |h,k|
        years = Array.new
        winners.each do |w|
        # Print their first place
          if (ph == w[:player]) then
            if (is_first_place(w[:place]) == 1) then
              if (h == w[:event_name]) then
                years << w[:year].to_i
              end
            end
          end
        end

        years.sort!
        years.uniq!
        years_s = years.join(", ")
        event_name = events_db[h][:name]

        ref = get_reference(events_db[h])
        fd.puts "** #{event_name} (#{years.count}) #{years_s} #{ref}"

      end
    end

#** [[Vanderbilt Trophy|Vanderbilt]] (3) 1979, 2000, 2003
#** [[Spingold]] (8) 1993, 1994, 1995, 1996, 1998, 1999, 2004, 2006
#** [[Reisinger]] (4) 1976, 1980, 2004, 2005
#** [[Mitchell Board-a-Match Teams|Men's Board-a-Match Teams]] (3) 1955, 1962, 1966
#More 2bd
#* United States Bridge Championships (XX)

    fd.puts ""
    fd.puts "===Runners-up==="
    fd.puts ""

    # Check for Bermuda Bowl
    nentries, years_s = get_bermuda_bowl_data(ph, 2)

    if (nentries > 0) then
      fd.puts "* [[Bermuda Bowl]] (#{nentries}) #{years_s} #{wbf_ref}"
      fd.puts ""
    end

    # Check for Venice Cup
    nentries, years_s = get_venice_cup_data(ph, 2)
    if (nentries > 0) then
      fd.puts "* [[Venice Cup]] (#{nentries}) #{years_s} #{wbf_ref}"
      fd.puts ""
    end

    # Check for d'Orsi Cup
    nentries, years_s = get_dorsi_bowl_data(ph, 2)
    if (nentries > 0) then
      fd.puts "* [[Senior Bowl (bridge)|d'Orsi Senior Bowl]] (#{nentries}) #{years_s} #{wbf_ref}"
      fd.puts ""
    end

    # Check for Transnational Teams
    nentries, years_s = get_transnational_teams_data(ph, 2)
    if (nentries > 0) then
      fd.puts "* [[World Transnational Open Teams Championship]] (#{nentries}) #{years_s} #{transnational_ref}"
      fd.puts ""
    end

    # Check for Rosenblum
    nentries, years_s = get_rosenblum_data(ph, 2)
    if (nentries > 0) then
      fd.puts "* [[Rosenblum Cup]] (#{nentries}) #{years_s} #{rosenblum_ref}"
      fd.puts ""
    end

    # World open pairs
    nentries, years_s = get_world_open_pairs_data(ph, 2)
    if (nentries > 0) then
      fd.puts "* [[World Open Pairs]] (#{nentries}) #{years_s}"
      fd.puts ""
    end

    nentries, years_s = get_world_mixed_pairs_data(ph, 2)
    if (nentries > 0) then
      fd.puts "* [[World Mixed Pairs]] (#{nentries}) #{years_s}"
      fd.puts ""
    end

    # World senior teams
    nentries, years_s = get_world_senior_teams_data(ph, 2)
    if (nentries > 0) then
      fd.puts "* [[World Senior Teams Championships]] (#{nentries}) #{years_s}"
      fd.puts ""
    end

    # Check for Buffett Cup Bowl
    nentries, years_s = get_buffett_cup_data(ph, 2)
    if (nentries > 0) then
      fd.puts "* [[Buffett Cup]] (#{nentries}) #{years_s} #{wbf_ref}"
      fd.puts ""
    end

    if (nnabc_seconds > 0) then
      fd.puts "* [[North American Bridge Championships]]"

      win_events = Hash.new
      winners.each do |w|
       # Print their second + higher place
        if ph == w[:player] then
          if is_second_place(w[:place]) == 1 then
            event_name = w[:event_name]
            win_events[event_name] = 1
          end
        end
      end

      win_events.each do |h,k|
        years = Array.new
        winners.each do |w|
        # Print their second place
          if ph == w[:player] then
            if is_second_place(w[:place]) == 1 then
              if (h == w[:event_name]) then
                years << w[:year].to_i
              end
            end
          end
        end

        years.sort!
        years.uniq!
        years_s = years.join(", ")
        event_name = events_db[h][:name]
        ref = get_reference(events_db[h])
        fd.puts "** #{event_name} (#{years.count}) #{years_s} #{ref}"
      end
    end


    # Trailer
    fd.puts ""
    fd.puts "==Notes=="
    fd.puts "{{reflist}}"
    fd.puts ""
    fd.puts "==External links=="

    # If they are in HOF, put it here
    if (in_acbl_hof == 1) then
      hof = $acbl_hofs_db[ph]
      fd.puts "* {{ACBLhof|#{hof[:ref]}}}"
    end

    # Need to get the WBF data
    wbf_data = $wbf_ids_db[ph]
    has_id = 0
    if (!wbf_data.nil?) then
      id = wbf_data[:id]
      if ((!id.nil?) && (id.to_i > 0)) then
      puts "ph=#{ph} wbf_data=#{wbf_data} id=#{id}"
        has_id = 1
      end
    end

    if (has_id == 1) then
      fd.puts "* {{WBFpeople|#{id}|#{ph}}}"
    end
    fd.puts "{{WPCBIndex}}"
    fd.puts ""
    fd.puts "{{Persondata <!-- Metadata: see [[Wikipedia:Persondata]]. -->"
    fd.puts "| NAME              = #{last_name}, #{first_names}"
    fd.puts "| ALTERNATIVE NAMES ="
    fd.puts "| SHORT DESCRIPTION = American contract bridge player"
    fd.puts "| DATE OF BIRTH     ="
    fd.puts "| PLACE OF BIRTH    ="
    fd.puts "| DATE OF DEATH     ="
    fd.puts "| PLACE OF DEATH    ="
    fd.puts "}}"
    fd.puts "{{DEFAULTSORT:#{last_name}, #{first_names}}}"
    fd.puts "[[Category:American bridge players]]"
    fd.puts ""
    fd.puts "{{Bridge-game-stub}}"
  end
end

# Print the 5 winners
file_name = "5winners.txt"
File.open(file_name, "w") do |fd|
  winners5.each do |w|
    fd.puts "#{w}"
  end
end

file_name = "10winners.txt"
File.open(file_name, "w") do |fd|
  winners10.each do |w|
    fd.puts "#{w}"
  end
end
