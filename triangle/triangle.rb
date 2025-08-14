class Triangle
  attr_accessor :sides, :a, :b, :c

  def initialize(sides)
    @sides = sides.sort
    @a, @b, @c = @sides
  end

  def equilateral?
    if a.zero? || b.zero? || c.zero?
      return false
    end
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