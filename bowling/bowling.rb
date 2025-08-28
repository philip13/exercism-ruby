class Game
  attr_reader :frames, :frame_on
  BowlingError = ArgumentError

  def initialize
    @frames = (1..10).map { |i| Frame.new(i) }
    @frame_on = 0
  end

  def roll pins
    assert_values pins
    @frame_on += 1 if @frames[@frame_on]&.balls&.zero?
    frame = @frames[@frame_on] || Frame.new( frame_on + 1)
    frame.add_score pins
    @frames[@frame_on] = frame
  end

  def score
    total = 0
    @frames.each_with_index do |frame, index|
      total += frame&.score
      if frame.spare?
        total += @frames[index + 1].throws.first
      end

      if frame.strike?
        next if frame.num_turn == 10
        next_frame = @frames[index + 1]
        total += next_frame.throws[0]
        total += next_frame.throws[1].nil? ? @frames[index + 2].throws[0] : next_frame.throws[1]
      end
    end
    total
  end

  def assert_values pins
    raise BowlingError if pins < 0 || pins > 10 
  end
end

class Frame
  attr_reader :balls, :pins, :status, :throws, :num_turn
  BowlingError = Game::BowlingError
  def initialize num_turn
    @num_turn = num_turn
    @balls = num_turn == 10 ? 3 : 2 
    @pins = 10
    @throws = []
    @status = "initial"
  end

  def add_score pins_down
    assert_pins_down pins_down
    # TODO: reset pins when @throws sum == 10
    
    @throws << pins_down
    @pins -= pins_down
    @balls -= 1
    update_status
  end

  def add_score?
    @balls > 0
  end

  def update_status
    @status = "open" if @balls == 0 && score < 10
    @status = "spare" if @balls == 0 && score == 10
    if @balls == 1 && score == 10 && num_turn != 10
      @status = "strike"
      @balls = 0
    end
  end

  def score
    @throws.reduce(0) { |val, f| val + f }
  end

  def open?
    @status == "open"
  end

  def spare?
    @status == "spare"
  end

  def strike?
    @status == "strike"
  end

  private
  def assert_pins_down pins_down
    last = @throws.last.to_i
    if num_turn != 10 && (last != 10) && ((last + pins_down) > 10)
      raise Game::BowlingError
    end
    if num_turn == 10 && last < 10 && ((last + pins_down) > 10) && pins_down != 10
      raise Game::BowlingError
    end
  end
end
