extern crate unicode_segmentation;
extern crate libc;

use unicode_segmentation::UnicodeSegmentation;

use libc::{c_char};
use std::ffi::CStr;
use std::str;

#[no_mangle]
pub extern fn is_palindrome_from_ruby(s: *const c_char) -> bool {
    let c_str = unsafe {
        assert!(!s.is_null()); //panic if string is null

        CStr::from_ptr(s) //create c_str from pointer
    };
    let r_str = c_str.to_str().unwrap(); 
    is_palindrome_unicode(r_str)
}

#[no_mangle]
pub extern fn is_palindrome_unicode(string: &str) -> bool {
    string.graphemes(true).eq(string.graphemes(true).rev())
}

#[no_mangle]
pub extern fn is_palindrome(string: &str) -> bool {
    let half_len = string.len()/2;
    string.chars().take(half_len).eq(string.chars().rev().take(half_len))
}

// code on how to move string from ruby to rust from http://jakegoulding.com/rust-ffi-omnibus/string_arguments/
// code for palindrom from https://www.rosettacode.org/wiki/Palindrome_detection#Ruby