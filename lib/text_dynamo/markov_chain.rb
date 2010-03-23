require File.dirname(__FILE__) + '/weighted_directed_graph'

class MarkovChain
  attr_accessor :graph

  def initialize
    @graph = WeightedDirectedGraph.new
  end

  def increment_probability(a, b)
    new_weight = @graph.edge_weight(a, b) + 1

    @graph.connect(a, b, new_weight)
  end

  def random_walk(start)
    current = start
    walk    = [current]

    while @graph.out_degree_of(current) > 0
      edges     = @graph.edges_from(current)
      total     = @graph.total_weight_from(current)
      selection = rand(total) + 1

      count = 0
      current = edges.select do |node, weight|
        count += weight
        count >= selection
      end.first.first

      walk << current
    end

    walk
  end
end