namespace :calculate do
  desc "Calculate Price"
  task calculate_price: :environment do
    count_photos_paid = Photo.get_photos_paid.count
    total_sorts = 0
    Photo.get_photos_paid.each do |photo|
        total_sorts = total_sorts + photo.count_of_sorts
    end

    count_sorting_last_eighteen_hours = Sorting.get_last_eighteen_hours.count
    count_sorting_las_thirty_days = Sorting.get_last_thirty_days.count

    average_sorts_per_twenty_four_hours =  count_sorting_las_thirty_days / 30
    average_sorts_per_eighteen_hours =  average_sorts_per_twenty_four_hours * 0.75

    if count_sorting_last_eighteen_hours > average_sorts_per_eighteen_hours
        g = count_sorting_last_eighteen_hours
    else
        g = average_sorts_per_eighteen_hours
    end

    h = (count_photos_paid * 200) - (total_sorts) / g
    price = 200 * h

    if g < 10000 || price < 200
        price = 200
    end
    @price = Price.new(value_cents: price, currency: "USD")
    @price.save

  end
end