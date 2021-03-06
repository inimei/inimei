# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u = User.create!(name: 'Example User',
             email: 'example@railstutorial.org',
             admin: true)

AuthInfo.create!(user: u,
                 password: 'foobar',
                 password_confirmation: 'foobar',
                 activated: true,
                 activated_at: Time.zone.now.to_datetime)

u = User.create!(name: 'YangSong',
             email: 'yangsongfwd@163.com',
             admin: true)

AuthInfo.create!(user: u,
                 password: 'yangsong',
                 password_confirmation: 'yangsong',
                 activated: true,
                 activated_at: Time.zone.now.to_datetime)

99.times do |n|
  u = User.create!(name: Faker::Name.name,
               email: "example-#{n+1}@inimei.org")

  AuthInfo.create!(user: u,
                   password: 'password',
                   password_confirmation: 'password',
                   activated: true,
                   activated_at: Time.zone.now.to_datetime)
end

users = User.order(:created_at).take(6)

50.times do
  content = Faker::Lorem.sentence(5)
  users.each do |user|
    user.microposts.create!(content: content)
  end
end

# Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

yangsong = User.find_by_email('yangsongfwd@163.com')
(0..20).each do |index|
  title = Faker::Lorem.words(2).join(' ')
  content = Faker::Lorem.sentence(8)

  yangsong.schedules.create!(title: title,
                             content: content,
                             planed_completed_at: (index % 5).days.ago.to_datetime)

end

ys = User.find_by_email 'yangsongfwd@163.com'
if ys
  if ys.blog_setting.nil?
    Blog::Setting.create!(user: yangsong,
                     blog_name: 'INiMei Blog',
                     blog_subtitle: 'Just enjoy every moment',
                     blogs_per_page: 10,
                     blog_preview_size: 1000,
                     linkedin_url: 'https://www.linkedin.com/in/%E6%9D%BE-%E6%9D%A8-1aa96aa2',
                     weibo_name: 'borrowedstory',
                     domain: 'yangsong')
  else
    ys.blog_setting.update_attributes!( user: yangsong,
                                    blog_name: 'INiMei Blog',
                                    blog_subtitle: 'Just enjoy every moment',
                                    blogs_per_page: 10,
                                    blog_preview_size: 1000,
                                    linkedin_url: 'https://www.linkedin.com/in/%E6%9D%BE-%E6%9D%A8-1aa96aa2',
                                    weibo_name: 'borrowedstory',
                                    domain: 'yangsong')
  end

end


#Blog::User.create!({name: 'yangsong', email: 'yangsongfwd@163.com', password: '123456', password_confirmation: '123456'})