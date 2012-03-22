# encoding: UTF-8

first_invalid = false
last_invalid = 0
total_invalid = 0

1114111.downto(0) do |i|
  begin
    "" << i
  rescue Exception => e
    puts i
    first_invalid ||= i
    last_invalid = i
    total_invalid = total_invalid + 1
  end
end

puts 'first_invalid: ' + first_invalid.to_s
puts 'last_invalid: ' + last_invalid.to_s
puts 'total_invalid: ' + total_invalid.to_s