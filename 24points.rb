class WrongFormat < RuntimeError
end

class Solver

  class Node
    NUM = 0
    ADD = 1
    SUB = 2
    MUL = 3
    DIV = 4
    attr_accessor :value
    attr_accessor :operator
    attr_accessor :left
    attr_accessor :right

    def self.new_num(value)
      n = self.new
      n.value = Rational(value)
      n.operator = NUM
      n
    end

    def +(other)
      n = self.class.new
      n.left = self
      n.right = other
      n.value = @value + other.value
      n.operator = ADD
      n
    end

    def -(other)
      n = self.class.new
      n.left = self
      n.right = other
      n.value = @value - other.value
      n.operator = SUB
      n
    end

    def *(other)
      n = self.class.new
      n.left = self
      n.right = other
      n.value = @value * other.value
      n.operator = MUL
      n
    end

    def /(other)
      n = self.class.new
      n.left = self
      n.right = other
      n.operator = DIV
      begin
        n.value = @value / other.value
        n
      rescue
        nil
      end
    end

    def description
      case @operator
      when NUM
        @value.to_i.to_s
      when ADD
        "(#{@left.description})+(#{@right.description})"
      when SUB
        "(#{@left.description})-(#{@right.description})"
      when MUL
        "(#{@left.description})*(#{@right.description})"
      when DIV
        "(#{@left.description})/(#{@right.description})"
      else
        nil
      end
    end
  end

  def solve(nums)
    nodes = nums.map { |x| Node.new_num(x) }
    step nodes
  end

  def step(nodes)
    if nodes.size == 1
      final_node = nodes[0]
      if final_node.value == 24
        puts nodes[0].description
      end
      return
    end
    (0...nodes.size).each { |i|
      ((i + 1)...nodes.size).each { |j|
        rest = []
        left = nil
        right = nil
        nodes.each_with_index do |v, index|
          if index == i
            left = v
          elsif index == j
            right = v
          else
            rest << v
          end
        end

        [left + right, left - right, right - left,
         left * right, left / right, right / left].compact.each { |new_node|
          step(rest + [new_node])
        }
      }
    }
  end
end

puts "Please input four numbers(divided by space)"
num_s = gets
begin
  num_ia = num_s.split.map { |x|
    if /^\d+$/ !~ x
      raise WrongFormat
    else
      x.to_i
    end
  }
  if num_ia.size != 4
    raise WrongFormat
  end
  p num_ia
  Solver.new.solve(num_ia)
rescue WrongFormat
  puts "Wrong format"
end