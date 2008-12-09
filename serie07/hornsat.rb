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
    
    # Select the first clause that is of length 1 and not yet in l
    while fact = m.select {|c| c.length == 1 && !l.include?(c[0])}.first
      # Set i to variable in fact clause
      i = fact.first
      # Push i to l
      l.push i
      # Select clauses in M with negative i
      m.select {|c| c.include?(-i)}.each do |c|
        # Delete clause from M
        m.delete c
        # Remove i from clause
        c.delete(-i)
        # Push clause back to M
        m.push c
      end
    end
    
    # return sorted list of variables
    return l.sort
  end
  
private
  def validate(clauses)
	# Check for valid clauses format and invalid clauses as input for HornSAT
	clauses.each do |c|
	  throw :illegal_clauses unless c.is_a? Array
	  if c.empty?
		throw :empty_clause_given
	  end
	  positive_literals = c.select {|v| v > 0}.length
	  # Check for non horn clauses
	  if positive_literals > 1
		throw :no_horn_clause
	  end
	  # Check for target clauses (no positive literal)
	  if positive_literals == 0
		throw :target_clause_given
	  end
	  c.each do |v|
		throw :illegal_clauses unless v.is_a? Fixnum
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