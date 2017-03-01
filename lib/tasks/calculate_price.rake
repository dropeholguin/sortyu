namespace :calculate do
  desc "Calculate Price"
  task calculate_price: :environment do
    count_photos_paid = Photo.get_photos_paid.count
    count_sorting_last_eighteen_hours = Sorting.get_last_eighteen_hours.count
    count_sorting_las_thirty_days = Sorting.get_last_thirty_days.count

    average_sorts_per_twenty_four_hours =  count_sorting_las_thirty_days / 30
    average_sorts_per_eighteen_hours =  average_sorts_per_twenty_four_hours * 0.75

    if count_sorting_last_eighteen_hours > average_sorts_per_eighteen_hours
        g = count_sorting_last_eighteen_hours
    else
        g = average_sorts_per_eighteen_hours
    end

    h = count_photos_paid / g
    price = 2 * h

    if price < 2
        price = 2
    end
    @price = Price.new(value: price)
    @price.save
  end
end