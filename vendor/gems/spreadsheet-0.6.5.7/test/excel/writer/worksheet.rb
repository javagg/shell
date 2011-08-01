#!/usr/bin/env ruby
# Excel::Writer::TestWorksheet -- Spreadsheet -- 20.07.2007 -- zdavatz@ywesee.com

require 'test/unit'
require 'spreadsheet/excel/writer/worksheet'

module Spreadsheet
  module Excel
    module Writer
class TestWorksheet < Test::Unit::TestCase
  def test_need_number
    sheet = Worksheet.new nil, nil
    assert_equal false, sheet.need_number?(10)
    assert_equal false, sheet.need_number?(114.55)
    assert_equal false, sheet.need_number?(0.1)
    assert_equal false, sheet.need_number?(0.01)
    assert_equal false, sheet.need_number?(0 / 0.0) # NaN
    assert_equal true, sheet.need_number?(0.001)
    assert_equal true, sheet.need_number?(10000000.0)
  end
end
    end
  end
end
