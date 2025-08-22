class Triangle
  attr_reader :sides, :a, :b, :c

  def initialize(sides)
    @sides = sides.sort
    @a, @b, @c = @sides
  end

  def equilateral?
    return false if a.zero? || b.zero? || c.zero?
    a == b && b == c && c == a 
  end

  def isosceles?
    return false if (a + b) < c 
    a == b || b == c || c == a
  end

  def scalene?
    return false if ((a + b ) < c )
    a != b && b != c && c != a
  end
end