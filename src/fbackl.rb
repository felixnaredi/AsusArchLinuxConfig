#!/usr/bin/env ruby


class Brightness

  DIR = '/sys/class/backlight/intel_backlight'
  MAXPATH = "#{DIR}/max_brightness"
  BRGPATH = "#{DIR}/brightness"
  
  def max()
    (open MAXPATH).read.to_i
  end

  def get()
    (open BRGPATH).read.to_i
  end

  def get_ratio()
    get.to_f / max.to_f
  end

  def vratio(ratio)
    (max * ratio).to_i
  end

  def set(value, ratio = false)
    value = vratio value if ratio
    (open BRGPATH, 'w').write value
  end    

end

b = Brightness.new

case ARGV.shift
when '-g', '--get'
  puts "#{(b.get_ratio * 100).to_i}%"
when '-s', '--set'
  b.set ARGV.shift.to_f / 100, true
when '-a', '--add'
  b.set b.get_ratio + (ARGV.shift.to_f / 100), true
end
