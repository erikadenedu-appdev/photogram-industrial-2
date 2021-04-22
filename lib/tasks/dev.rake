task sample_data: :environment do
  p "Creating sample data"

  if Rails.env.development?
    Comment.destroy_all 
    Like.destroy_all 
    Photo.destroy_all
    FollowRequest.destroy_all
    User.destroy_all 
  end

  u = User.new 
    u.username = "pikachu"
    u.email = u.username.downcase.gsub(/\s+/, "") + "@example.com"
    u.password = "password"
    u.save 
    p u.username  

  11.times do 
    u = User.new
    u.username = Faker::Games::Pokemon.name
    u.email = u.username.downcase.gsub(/\s+/, "") + "@example.com"
    u.password = "password"
    u.save 
    p u.username
  end 
  p "#{User.count} users have been created."

  users = User.all

  users.each do |first_user|
    users.each do |second_user| 
      if rand < 0.75 
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.values.sample 
        )
      end 

      if rand < 0.75 
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.values.sample 
        )
      end 
    end 
  end 

  p "#{FollowRequest.count} follow requests have been created"

  users.each do |user| 
    rand(15).times do 
      photo = user.own_photos.create( 
        caption: Faker::Movie.quote,
        image: "https://robohash.org/#{rand(99999)}"
      )
      
      user.followers.each do |follower| 
        if rand < 0.5 
          photo.fans << follower 
        end 

        if rand < 0.25 
          photo.comments.create(
            body: Faker::Movie.quote,
            author: follower
          )
        end 
      end
    end 
  end 

  p "#{Photo.count} photos have been created" 
  p "#{Like.count} likes have been created"
  p "#{Comment.count} comments have been created"
end