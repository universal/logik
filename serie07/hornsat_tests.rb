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

  def test_clauses_input_fails_for_target_clause
    clauses = [[-1, -2]]
    hornsat = Hornsat.new
    assert_throws :target_clause_given do
    	hornsat.solve(clauses)
    end
  end

  def test_clauses_input_fails_for_empty_clauses
    clauses = []
    hornsat = Hornsat.new
    assert_throws :empty_clauses do
    	hornsat.solve(clauses)
    end
  end

  def test_clauses_input_fails_for_empty_clause
    clauses = [[]]
    hornsat = Hornsat.new
    assert_throws :empty_clause_given do
      hornsat.solve(clauses)
    end
  end

  def test_hornsat_input_fails_for_non_fixnum
    clauses = ["a", [47, []]]
    hornsat = Hornsat.new
    assert_throws :illegal_clauses do
      hornsat.solve(clauses)
    end
  end

  def test_clauses_input_accepts_fact_clause
    clauses = [[47]]
    hornsat = Hornsat.new
    assert_equal([47], hornsat.solve(clauses))
  end

  def test_hornsat_solves_clauses
    clauses = [[-1, -2, 3], [2], [1, -2]]
    hornsat = Hornsat.new
    assert_equal([1, 2, 3], hornsat.solve(clauses).sort)
  end
end