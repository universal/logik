class Hornsat
  def solve(clauses)
    # Check for empty clauses
    if clauses.empty?
      throw :empty_clauses, "No clauses given"
    end

    # Check for invalid clauses for HornSAT
    clauses.each do |c|
      if c.empty?
        puts "Empty clause given"
        return false
      end
      positive_literals = c.select {|v| v > 0}.length
      # Check for non horn clauses
      if positive_literals > 1
      	throw :no_horn_clause, "[#{c.join(',')}] is not a horn clause"
      	return false
      end
      # Check for target clauses (no positive literal)
      if positive_literals == 0
      	puts "Clause {#{c.join(',')}} is a target clause"
      	return false
      end
    end
    
    l = []
    
    # Select the first clause that is of length 1 and not yet in l
    while fact = clauses.select {|c| c.length == 1 && !l.include?(c[0])}.first
      # Set i to variable in fact clause
      i = fact.first
      # Push i to l
      l.push i
      # Select clauses with negative i
      clauses.select {|c| c.include?(-i)}.each do |c|
        # Delete clause from set auf clauses
        clauses.delete c
        # Remove i from clause
        c.delete(-i)
        # Push clause back to set of clauses
        clauses.push c
      end
    end
    
    return l
  end
end