require 'ffi'

module Palindrome 
  extend FFI::Library 
  ffi_lib 'target/release/libpalindrome.dylib'
  attach_function :is_palindrome_from_ruby, [:string], :bool
end

puts Palindrome.is_palindrome_from_ruby("robor")
puts Palindrome.is_palindrome_from_ruby("robot")
puts Palindrome.is_palindrome_from_ruby("roboR")