# coding: utf-8
#
# This code is only for SECCON 2015 online puzzle.
# https://github.com/SECCON/SECCON2015_online_CTF/tree/master/Unknown/200_QR%20puzzle%20(Windows)
# Before run this script, exec QRpuzzle.exe, and aline the window to top-left.
#
# Environment:
# * This code is only for MacOS.
# * Install ImageMagick to your system.
#   * [ImageMagick](http://www.imagemagick.org/script/index.php)
# * Install ZBar to your system.
#   * [ZBar](http://zbar.sourceforge.net/)
# * gem install [rmagick]
# * mkdir ./work
#
# Outline:
# 1. capture window.
# 2. make qr code.
# 3. read qr code.
# 4. fill answer form.

require 'RMagick'

QR_IMAGE_PREFIX = './work/qr'
QR_IMAGE_FILE = "#{QR_IMAGE_PREFIX}.jpg"

X = [16, 183, 349]
Y = [94, 274, 454]
W = 160
H = 168
REPEAT = 300

def find_place(img)
  px_total = img.columns * img.rows
  rate = [] # [top, bottom, left, right]
  2.times do |y|
    2.times do |x|
      hist = img.crop(x*W/2, y*H/2, W/2, H/2).color_histogram
      rate[(y*2 + x)] = 0 if hist.size == 1
      hist.each do |h|
        next if h[0].to_color != 'black'
        rate[(y*2 + x)] = h[1] * 100 / (px_total / 4)
      end
    end
  end
  p "#{img.filename} #{rate}"
  if rate[0]<10 && rate[1]<20 && rate[2]<20 && rate[3]>40
    return 1
  elsif rate[0]<20 && rate[1]<20 && rate[2]>30 && rate[3]>30
    return 2
  elsif rate[0]<20 && rate[1]<10 && rate[2]>40 && rate[3]<20
    return 3
  elsif rate[0]<15 && rate[1]>25 && rate[2]<15 && rate[3]>25
    return 4
  elsif rate[0]>25 && rate[1]>25 && rate[2]>25 && rate[3]>25
    return 5
  elsif rate[0]>25 && rate[1]<15 && rate[2]>20 && rate[3]<15
    return 6
  elsif rate[0]<20 && rate[1]>40 && rate[2]<10 && rate[3]<20
    return 7
  elsif rate[0]>30 && rate[1]>20 && rate[2]<10 && rate[3]<10
    return 8
  elsif rate[0]>20 && rate[1]<15 && rate[2]<10 && rate[3]<10
    return 9
  end
  raise 'not match any block!'
end

REPEAT.times do |count|
  # 1. capture window.
  3.times do |y|
    3.times do |x|
      `screencapture -R#{X[x]},#{Y[y]},#{W},#{H} #{QR_IMAGE_PREFIX}_#{(y*3)+x+1}.jpg`
    end
  end
  qr = Magick::Image.new(W * 3, H * 3)

  # 2. make qr code.
  img_index = Array.new(9)
  9.times do |n|
    img = Magick::Image.read("#{QR_IMAGE_PREFIX}_#{n+1}.jpg").first.threshold(120)
    index = find_place(img) - 1
    img_index[index] = n
    offs_x = index.modulo(3) * W
    offs_y = index.div(3) * H
    qr.composite!(img, offs_x, offs_y, Magick::OverCompositeOp)
    img.destroy!
  end
  p img_index
  qr.write(QR_IMAGE_FILE)

  # 3. read qr code.
  answer = `zbarimg -q #{QR_IMAGE_FILE}`.split(':')[1]
  puts answer

  # 4. fill answer form.
  pid = `ps awx | grep 'wine' | grep 'QRpuzzle.exe'`.match(/^([0-9]+)/)
  `osascript -e '
    tell application "System Events"
      set frontmost of the first process whose unix id is "#{pid}" to true
      repeat with curItem in "#{answer}"
        keystroke curItem
        delay 0.1
      end repeat
    end tell'
  `
  sleep(5)
end
