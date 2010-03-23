class WeightedDirectedGraph
  def initialize
    @adj_matrix = {}
  end

  def add_node(name)
    matrix[name] ||= {}
  end

  def connect(a, b, weight = 1)
    add_node(a) unless contains?(a)
    add_node(b) unless contains?(b)
    matrix[a][b] = weight
  end

  def edge_weight(a, b)
    weight = matrix[a][b] if contains?(a)
    weight || 0
  end

  def contains?(name)
    !matrix[name].nil?
  end

  def out_degree_of(name)
    degree = matrix[name].keys.size if contains?(name)
    degree || 0
  end

  def edges_from(name)
    matrix[name] || []
  end

  def total_weight_from(name)
    sum = matrix[name].values.inject{|sum, n| sum + n} if contains?(name)
    sum || 0
  end

private

  def matrix
    @adj_matrix
  end
end