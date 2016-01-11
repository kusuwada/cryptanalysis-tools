# coding: utf-8
#
# Environment:
#  gem install [test-unit]

require 'test/unit'
require_relative '../src/utf9-converter'

class TestUTF9Converter < Test::Unit::TestCase

  data(
    'LATIN_CAPITAL_LETTER_A' => ['101', 'A'],
    'LATIN_CAPITAL_LETTER_A_WITH_GRAVE' => ['300', 'À'],
    'GREEK_CAPITAL_LETTER_ALPHA' => ['403221', 'Α'],
    'CJK_IDEOGRAPH_MEANING_LOVE' => ['54133', '愛'],
    'GOTHIC_LETTER_AHSA' => ['40140360', '𐌰'],
    'TAG_LATIN_CAPITAL_LETTER_A' => ['416400101', '󠁁'],
    'PLANE_16_PRIVATE_USE_LAST' => ['420777375', '􏿽'],
    'UCS-4_VALUE_NOT_IN_UNICODE' => ['46453671733', "\xFC\xB4\x97\xAC\xBC\x9B"]
  )
  def test_utf9_base8_to_utf8(data)
    testdata, expected = data
    nonet = UTF9Converter.base8_to_nonet(testdata)
    result = UTF9Converter.nonet_to_utf8(nonet)
    assert_equal(expected, result)
  end

  data(
    'BASE8_FILE_1' => ['./input/utf9-in-base8.txt', 'A愛A']
  )
  def test_utf9_base8_file_to_utf8(data)
    testfile, expected = data
    result = ''
    File.open(testfile) do |f|
      f.each_line do |line|
        nonet = UTF9Converter.base8_to_nonet(line)
        result << UTF9Converter.nonet_to_utf8(nonet)
      end
    end
    assert_equal(expected, result)
  end
end
