require File.dirname(__FILE__) + '/../../lib/text_dynamo'
require 'rubygems'
require 'mocha'

describe WeightedDirectedGraph do
  before(:each) do
    @graph = WeightedDirectedGraph.new
  end

  describe "#add_node" do
    it "should contain any nodes which are added" do
      @graph.add_node("a")
      @graph.should satisfy {|g|  g.contains?("a")}
    end

    it "shouldn't overwrite a node's edges" do
      @graph.add_node("a")
      @graph.connect("a", "b")
      @graph.add_node("a")
      @graph.edge_weight("a", "b").should == 1
    end
  end

  describe "#connect" do
    it "should create nodes if they don't exist" do
      @graph.connect("a", "b")
      @graph.should satisfy {|g|  g.contains?("a")}
      @graph.should satisfy {|g|  g.contains?("b")}
    end

    it "should set a default weight of 1" do
      @graph.connect("a", "b")
      @graph.edge_weight("a", "b").should == 1
    end

    it "should allow setting a custom weight" do
      @graph.connect("a", "b", 5)
      @graph.edge_weight("a", "b").should == 5
    end
  end

  describe "#edge_weight" do
    it "should return the weight for two connected nodes" do
      @graph.connect("a", "b", 5)
      @graph.edge_weight("a", "b").should == 5
    end

    it "should return 0 if first node isn't in the graph" do
      @graph.add_node("b")
      @graph.edge_weight("a", "b").should == 0
    end

    it "should return 0 if the second node isn't in the graph" do
      @graph.add_node("a")
      @graph.edge_weight("a", "b").should == 0
    end

    it "should return 0 if the two nodes exist but aren't connected" do
      @graph.add_node("a")
      @graph.add_node("b")
      @graph.edge_weight("a", "b").should == 0
    end
  end

  describe "#out_degree_of" do
    it "should return 0 for newly added nodes" do
      @graph.add_node("a")
      @graph.out_degree_of("a").should == 0
    end

    it "should return the number of edges originating from the node" do
      @graph.add_node("a")
      @graph.connect("a", "b")
      @graph.connect("a", "c")
      @graph.out_degree_of("a").should == 2
    end

    it "should return 0 if node doesn't exist in the graph" do
      @graph.out_degree_of("a").should == 0
    end
  end

  describe "#edges_from" do
    it "should return an empty array if node doesn't exist in the graph" do
      @graph.edges_from("a").should == []
    end

    it "should return a hash all the edges and weights" do
      @graph.connect("a", "b", 3)
      @graph.connect("a", "c", 4)
      @graph.edges_from("a").should == {"b" => 3, "c" => 4}
    end
  end

  describe "#total_weight_from" do
    it "should return 0 if the node doesn't exist in the graph" do
      @graph.total_weight_from("a").should == 0
    end

    it "should return the total weight of all edges originating from the node" do
      @graph.connect("a", "b", 3)
      @graph.connect("a", "c", 4)
      @graph.total_weight_from("a").should == 7
    end
  end
end