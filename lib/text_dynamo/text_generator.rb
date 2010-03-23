require File.dirname(__FILE__) + '/markov_chain'

class TextGenerator
  attr_reader :markov_chain

  def initialize
    @markov_chain = MarkovChain.new
  end

  def seed(text)
    sentences(text).each do |sentence|
      words = sentence.split(" ")

      0.upto(words.length - 2) do |i|
        @markov_chain.increment_probability(words[i], words[i + 1])
      end
    end
  end

  def sentences(text)
    text       = clean_paragraphs(text)
    seperators = /([.!?])/
    sentences  = []
    sentence   = ""

    text.split(seperators).each do |part|
      if part =~ seperators
        sentences << sentence.strip + part
        sentence = ""
      else
        sentence = part
      end
    end

    sentences
  end

  def generate(start)
    @markov_chain.random_walk(start).join(" ")
  end

private

  def clean_paragraphs(text)
    text = text.gsub(/\n\s*\n/m, ".")
    text << "." unless text =~ /[.!?]$/
    text
  end
end