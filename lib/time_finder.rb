require 'csv'
require 'date'

day_of_week = { 0 => 'Sunday', 1 => 'Monday', 2 => 'Tuesday', 3 => 'Wednesday',
                4 => 'Thursday', 5 => 'Friday', 6 => 'Saturday'}

def get_sorted_tally(array)
  array.sort.tally
end

def find_peak(tally_hash)
  tally_hash.select { |item, tally| tally == tally_hash.values.max }.keys
end

def get_date_obj(date)
  DateTime.strptime(date, '%m/%d/%y %H:%M')
end

def list_str(array)
  case array.length
  when 0
    nil
  when 1
    array[0]
  when 2
    array.join(' and ')
  else
    last = array.pop
    array.join(', ') + ", and #{last}"
  end
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

dates = contents.map do |row|
  date = row[:regdate]
  get_date_obj(date)
end

hours = dates.map do |date|
  date.hour
end

hour_tally = get_sorted_tally(hours)

peak_hours = find_peak(hour_tally)

peak_hours_str = list_str(peak_hours)

if peak_hours.length == 1
  puts "The peak hour for traffic is #{peak_hours_str}."
else
  puts "The peak hours for traffic are #{peak_hours_str}."
end

days_of_week = dates.map(&:wday)

day_tally = get_sorted_tally(days_of_week)

peak_days = find_peak(day_tally)

peak_day_str = list_str(peak_days.map { |day| day_of_week[day] })

if peak_days.length == 1
  puts "The peak day of the week is #{peak_day_str}."
else
  puts "The peak days of the week are #{peak_day_str}."
end
