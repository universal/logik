class Hornsat
  def solve(clauses, validate_input = true)
    # Check for empty clauses
    if clauses.empty?
      throw :empty_clauses
    end

    validate(clauses) if validate_input
    
    l = []
    # Clone clauses to M
    m = clauses.map {|a| a.clone}
    
    # Select the variable from the first unit clause that is not yet in l
    while fact = m.select {|c| c.length == 1 && !l.include?(c[0])}.first
      i = fact.first
      # Push i to l
      l.push i
      # Select clauses in M with negative i
      m.map {|c| c.delete(-i)}
    end

    if m.include?([])
      return false
    else
      return l.sort
    end
  end
  
private
  def validate(clauses)
  # Check for valid clauses format and invalid clauses as input for HornSAT
  clauses.each do |c|
    throw :illegal_clauses unless c.is_a? Array
    positive_literals = c.select {|v| v > 0}.length
    # Check for non horn clauses
    if positive_literals > 1
    throw :no_horn_clause
    end
    c.each do |v|
    throw :illegal_clauses unless v.is_a? Fixnum
    throw :zero_variable_index if v == 0
    end
    end
  end
end

# Make this file directly runnable "ruby hornsat.rb [[-1,2],[3]]"
if __FILE__ == $0
  hornsat = Hornsat.new
  clauses = eval(ARGV[0])
  output = hornsat.solve(clauses)
  puts output.inspect
end
