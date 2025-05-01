module Chess
  FILES = ("A".."H").freeze
  RANKS = (1..8).freeze

  def self.valid_square?(rank, file)
    RANKS.include?(rank) && FILES.include?(file)
  end

  def self.nick_name(first_name, last_name)
    return "" if first_name.empty? || last_name.empty?

    "#{first_name[..1]}#{last_name[-2..]}".upcase
  end

  def self.move_message(first_name, last_name, square)
    nickname = nick_name(first_name, last_name)
    file, rank = square[0], square[1].to_i

    if valid_square?(rank, file)
      "#{nickname} moved to #{square}"
    else
      "#{nickname} attempted to move to #{square}, but that is not a valid square"
    end
  end
end
