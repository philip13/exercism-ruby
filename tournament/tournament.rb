class Tournament
  POINTS = { "win" => 3, "draw" => 1, "loss" => 0}
  INVERT_RESULT = { "win" => "loss", "loss" => "win", "draw" => "draw" }

  def self.tally(input)
    new(input).tally
  end

  def initialize(input)
    @matches = input.split("\n")
  end

  def tally
    header = "#{'Team'.ljust(31)}| MP |  W |  D |  L |  P\n"

    teams = @matches.each_with_object({}) do |line, teams|
      next if line.empty?
      team1, team2, result_t1 = line.split(";")

      result_t2 = INVERT_RESULT[result_t1]
      add_match_played(team1, result_t1, teams)
      add_match_played(team2, result_t2, teams)
    end

    format_rows(header, teams)
  end

  def add_match_played(team, result, teams)
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

  def format_rows(header, teams)
    output = header
    teams_sorted = teams.sort do |(team_a, stats_a), (team_b, stats_b)|
      result = stats_b[:points] <=> stats_a[:points]
      result.zero? ? team_a <=> team_b : result
    end.to_h

    teams_sorted.each_key do |team_name|
      stats = teams[team_name]
      output << format("%-31s| %2d | %2d | %2d | %2d | %2d\n",
        team_name,
        stats[:matches_played],
        stats[:won],
        stats[:drawn],
        stats[:lost],
        stats[:points]
      )
    end
    output
  end
end