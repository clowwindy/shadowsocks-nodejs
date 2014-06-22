###
// The functions in source file is from phpjs
// https://github.com/kvz/phpjs
// See license below
//
// Copyright (c) 2013 Kevin van Zonneveld (http://kvz.io)
// and Contributors (http://phpjs.org/authors)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//   SOFTWARE.
###

inet_pton = (a) ->

  # http://kevin.vanzonneveld.net
  # +   original by: Theriault
  # *     example 1: inet_pton('::');
  # *     returns 1: '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0' (binary)
  # *     example 2: inet_pton('127.0.0.1');
  # *     returns 2: '\x7F\x00\x00\x01' (binary)
  r = undefined
  m = undefined
  x = undefined
  i = undefined
  j = undefined
  f = String.fromCharCode
  m = a.match(/^(?:\d{1,3}(?:\.|$)){4}/) # IPv4
  if m
    m = m[0].split(".")
    m = f(m[0]) + f(m[1]) + f(m[2]) + f(m[3])

    # Return if 4 bytes, otherwise false.
    return (if m.length is 4 then m else false)
  r = /^((?:[\da-f]{1,4}(?::|)){0,8})(::)?((?:[\da-f]{1,4}(?::|)){0,8})$/
  m = a.match(r) # IPv6
  if m

    # Translate each hexadecimal value.
    j = 1
    while j < 4

      # Indice 2 is :: and if no length, continue.
      continue  if j is 2 or m[j].length is 0
      m[j] = m[j].split(":")
      i = 0
      while i < m[j].length
        m[j][i] = parseInt(m[j][i], 16)

        # Would be NaN if it was blank, return false.
        return false  if isNaN(m[j][i]) # Invalid IP.
        m[j][i] = f(m[j][i] >> 8) + f(m[j][i] & 0xFF)
        i++
      m[j] = m[j].join("")
      j++
    x = m[1].length + m[3].length
    if x is 16
      return m[1] + m[3]
    else return m[1] + (new Array(16 - x + 1)).join("\u0000") + m[3]  if x < 16 and m[2].length > 0
  false # Invalid IP.
inet_ntop = (a) ->

  # http://kevin.vanzonneveld.net
  # +   original by: Theriault
  # *     example 1: inet_ntop('\x7F\x00\x00\x01');
  # *     returns 1: '127.0.0.1'
  # *     example 2: inet_ntop('\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\1');
  # *     returns 2: '::1'
  i = 0
  m = ""
  c = []
  if a.length is 4 # IPv4
    a += ""
    [
      a.charCodeAt(0)
      a.charCodeAt(1)
      a.charCodeAt(2)
      a.charCodeAt(3)
    ].join "."
  else if a.length is 16 # IPv6
    i = 0
    while i < 16
      group = (a.slice(i, i + 2)).toString("hex")

      #replace 00b1 => b1  0000=>0
      group = group.slice(1)  while group.length > 1 and group.slice(0, 1) is "0"
      c.push group
      i += 2
    c.join(":").replace(/((^|:)0(?=:|$))+:?/g, (t) ->
      m = (if (t.length > m.length) then t else m)
      t
    ).replace m or " ", "::"
  else # Invalid length
    false
exports.inet_pton = inet_pton
exports.inet_ntop = inet_ntop