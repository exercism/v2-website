Exercism::PeopleImagesPath = Pathname.new("people")
Exercism::PeopleImages = Dir.entries(Rails.root / "app/assets/images" / Exercism::PeopleImagesPath).select { |s| s =~ /.png$/ }
