namespace :tmp do
  desc "destroy photos tmp"
  task destroy_photos: :environment do
    Photo.destroy_photos_tmp.each do |photo|
        photo.destroy
    end
  end
end