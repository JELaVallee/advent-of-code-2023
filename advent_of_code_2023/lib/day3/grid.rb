require 'matrix'

class Grid
  attr_reader :matrix

  def initialize (data:)
    @matrix = Matrix.rows(data.map { |line| line.chars })
  end

  def get_neighbors(row, col)
    neighbors = []

    # Check neighbors to the top, bottom, left, and right
    neighbors << @matrix[row - 1, col] if row > 0
    neighbors << @matrix[row + 1, col] if row < @matrix.row_count - 1
    neighbors << @matrix[row, col - 1] if col > 0
    neighbors << @matrix[row, col + 1] if col < @matrix.column_count - 1

    # Check diagonal neighbors
    neighbors << @matrix[row - 1, col - 1] if row > 0 && col > 0
    neighbors << @matrix[row - 1, col + 1] if row > 0 && col < @matrix.column_count - 1
    neighbors << @matrix[row + 1, col - 1] if row < @matrix.row_count - 1 && col > 0
    neighbors << @matrix[row + 1, col + 1] if row < @matrix.row_count - 1 && col < @matrix.column_count - 1

    neighbors
  end
end