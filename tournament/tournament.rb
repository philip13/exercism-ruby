module Tournament
  POINTS = { "win" => 3, "draw" => 1, "loss" => 0}
  INVERT_RESULT = { "win" => "loss", "loss" => "win", "draw" => "draw" }

  
  def self.tally(input)
    teams = Hash.new
    header = "#{'Team'.ljust(31)}| MP |  W |  D |  L |  P\n"

    input.each_line do |line|
      line = line.gsub("\n", "")
      unless line.empty?
        row = line.split(";")
        team1, team2, result = row[0], row[1], row[2]        
        result_2 = INVERT_RESULT[result]
        
        teams = self.add_match_played(team1, result, teams)
        teams = self.add_match_played(team2, result_2, teams)
      end
    end

    format_rows(header, teams)
  end

  def self.add_match_played(team, result, teams)
    team = team.to_sym
    unless teams.include?(team)
      teams[team] = { matches_played: 0, won: 0, drawn: 0, lost: 0, points: 0 }
    end
    teams[team][:matches_played] += 1

    case result
    when "win"
      teams[team][:won] += 1
      teams[team][:points] += POINTS['win']
    when "draw"
      teams[team][:drawn] += 1
      teams[team][:points] += POINTS['draw']
    when "loss"
      teams[team][:lost] += 1
    end
    return teams
  end

  def self.format_rows(header, teams)
    output = header
    teams_sorted = teams.sort do |(team_a, stats_a), (team_b, stats_b)|
      result = stats_b[:points] <=> stats_a[:points]
      result.zero? ? team_a.to_s <=> team_b.to_s : result
    end.to_h

    teams_sorted.each_key do |team_name|
      stats = teams[team_name.to_sym]
      
      output << "#{team_name.to_s.ljust(31)}|  #{stats[:matches_played]} |  #{stats[:won]} |  #{stats[:drawn]} |  #{stats[:lost]} | #{format(stats[:points])}\n"
    end
    output.to_s
  end

  def self.format(num)
    num.to_s.rjust(2, ' ')
  end
end