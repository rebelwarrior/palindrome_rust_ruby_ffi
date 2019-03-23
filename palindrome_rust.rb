require 'ffi'
require 'benchmark'


module PalindromeRustFFI  
  extend FFI::Library 
  ffi_lib 'target/release/libpalindrome.dylib'
  attach_function :is_palindrome_from_ruby, [:string], :bool
  attach_function :is_palindrome_ascii_from_ruby, [:string], :bool
end

class Palindrome 
  include PalindromeRustFFI
  
  def self.palindrome1?(string)
    string = string.downcase 
    l = string.length - 1 
    half = (l + 1) / 2 
    r = 0
    half.times do |i|
      unless string[i] == string[l - i] 
        r += 1
      end
    end
    r.zero?
  end
  
  def self.palindrome2?(string)
    string = string.downcase
    string == string.reverse 
  end
  
  def self.palindrome3?(string)
    a = string.downcase.split('')
    rev_a = []
    a.each { |x| rev_a.unshift(x) }
    a == rev_a
  end
  
  def self.palindrome4?(string)
    string = string.downcase.split('') 
    l = string.length - 1 
    half = (l + 1) / 2 
    r = 0
    half.times do |i|
      unless string[i] == string[l - i] 
        r += 1
      end
    end
    r.zero?
  end
  
  def self.palindrome5?(string)
    PalindromeRustFFI.is_palindrome_from_ruby(string)
  end
  
  def self.palindrome6?(string)
    PalindromeRustFFI.is_palindrome_ascii_from_ruby(string)
  end
  
end

a = Array.new(2_000) { Random.urandom(rand(10)).dump.encode("UTF-8") }
a.push "ñañ"
puts PalindromeRustFFI.is_palindrome_ascii_from_ruby("ñañ")

include Benchmark

Benchmark.bmbm do |x|
  x.report { a.map{ |s| Palindrome.palindrome1?(s) } }
  x.report { a.map{ |s| Palindrome.palindrome2?(s) } }
  x.report { a.map{ |s| Palindrome.palindrome3?(s) } }
  x.report { a.map{ |s| Palindrome.palindrome4?(s) } }
  x.report { a.map{ |s| Palindrome.palindrome5?(s) } }
  x.report { a.map{ |s| Palindrome.palindrome6?(s) } }
end
