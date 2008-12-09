require 'test/unit'
require 'hornsat.rb'

class HornsatTests < Test::Unit::TestCase

  def test_clauses_input_fails_for_non_horn_clauses
    clauses = [[-1, -2, -3, 4], [-1, -2, -3, 4], [1, 2]]
    hornsat = Hornsat.new
    assert_throws :no_horn_clause do
    	hornsat.solve(clauses)
    end
  end

  def test_clauses_input_accepts_target_clause
    clauses = [[-1, -2]]
    hornsat = Hornsat.new
   	hornsat.solve(clauses)
  end

  def test_clauses_input_fails_for_empty_clauses
    clauses = []
    hornsat = Hornsat.new
    assert_throws :empty_clauses do
    	hornsat.solve(clauses)
    end
  end

  def test_clauses_input_accepts_empty_clause
    clauses = [[]]
    hornsat = Hornsat.new
    hornsat.solve(clauses)
  end

  def test_hornsat_input_fails_for_non_fixnum
    clauses = ["a", [47, []]]
    hornsat = Hornsat.new
    assert_throws :illegal_clauses do
      hornsat.solve(clauses)
    end
  end

  def test_clauses_input_fails_for_zero
    clauses = [[0]]
    hornsat = Hornsat.new
    assert_throws :zero_variable_index do
      hornsat.solve(clauses)
    end
  end

  def test_clauses_input_accepts_fact_clause
    clauses = [[47]]
    hornsat = Hornsat.new
    assert_equal([47], hornsat.solve(clauses))
  end

  def test_hornsat_solves_clauses
    clauses = [[1], [3], [-1, -3, 5], [-1, -5, 7], [-2, 1]]
    hornsat = Hornsat.new
    output = hornsat.solve(clauses)
    assert(output.is_a?(Array), "Solve should return a result")
    assert_equal([1, 3, 5, 7], output.sort)
  end

  def test_hornsat_finds_unsaturable
    clauses = [[2], [-2]]
    hornsat = Hornsat.new
    assert_equal(false, hornsat.solve(clauses))
  end
end