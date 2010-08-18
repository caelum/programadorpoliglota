job_type :runner,  'cd :path && rails runner -e :environment ":task"'
env "GEM_HOME", ENV["GEM_HOME"]

every 1.minute do
  
  runner "Tweet.add_new_tweets"
  
end
