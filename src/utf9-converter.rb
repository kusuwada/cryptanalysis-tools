# coding: utf-8
#
# This script change utf-9 <-> ascii.
# utf-9 is rtf joke format.
# [utf-9: rfc4042](https://www.ietf.org/rfc/rfc4042.txt)

# UTF9 Converter.
module UTF9Converter
  def nonet_to_utf8(nonet)
    hex = []
    char_bin = ''
    nonet.scan(/.{1,9}/).each do |block|
      char_bin << block[1..-1]
      if block[0] == '0' then
        hex.push(char_bin.to_i(2).to_s(16))
        char_bin = ''
      end
    end
    hex_to_utf8(hex)
  end

  def base8_to_nonet(base8)
    nonet = ''
    base8.scan(/.{1,3}/).each do |b|
      bin = b.to_i(8).to_s(2).rjust(9, '0')
      nonet << bin
    end
    nonet
  end

  module_function :base8_to_nonet
  module_function :nonet_to_utf8

  def self.hex_to_utf8(hex)
    utf8 = ''
    hex.each do |h|
      utf8 << [h.hex].pack('U')
    end
    utf8
  end

end
