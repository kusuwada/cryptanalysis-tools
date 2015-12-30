# coding: utf-8
#
# This is for decryption of substitution cipher.
#
# Environment:
#  gem install [pry]

require 'pry'

# module
module Substitution
  @map = {}
  def self.mapping(cipher, plane)
    puts "#{cipher} => #{plane}"
    add_map(cipher, plane)
  end

  def self.decrypt(cipher)
    answer = decryption(cipher)
    puts "answer: #{answer}"
  end

  def self.show
    puts @map
  end

  def self.clear
    @map = {}
  end

  def self.help
    puts 'Usage: mapping {cipher} {plane}: create mapping.'
    puts '       decrypt {cipher}: decrypt use created mapping.'
    puts '       show:  show exist mapping.'
    puts '       clear: clear exist mapping.'
    puts '       help:  show usage.'
    puts '       exit:  exit'
  end

private

  def self.add_map(cipher, plane)
    raise 'different length input.' if cipher.length != plane.length
    cipher.each_char.with_index do |c, i|
      if !@map[c].nil? && @map[c] != plane[i]
        raise "this is not substitution-cipher.
               '#{c}' is already mapped to '#{@map[c]}'"
      else
        @map[c] = plane[i]
      end
    end
  end

  def self.decryption(cipher)
    answer = ""
    cipher.each_char.with_index do |c, i|
      if @map[c].nil?
        puts 'there is missing mapping. use ? for it.'
        answer << '?'
      else
        answer << @map[c]
      end
    end
    answer
  end
end

# pry command
Pry.commands.block_command 'mapping' do |cipher, plane|
  Substitution.mapping(cipher, plane)
end
Pry.commands.block_command 'decrypt' do |cipher|
  Substitution.decrypt(cipher)
end
Pry.commands.block_command 'show' do
  Substitution.show
end
Pry.commands.block_command 'clear' do
  Substitution.clear
end
Pry.commands.block_command 'help' do
  Substitution.help
end

Pry.prompt = [
   proc{'sc> '},
   proc{'sc* '},
]

# main
Substitution.help
pry
