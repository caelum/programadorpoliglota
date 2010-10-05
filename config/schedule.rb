job_type :runner,  'cd :path && rails runner -e :environment ":task"'
env "GEM_HOME", ENV["GEM_HOME"]

every 5.minute do
  runner "TweetsRetrievalJob.new.import_all_groups_tweets"
end
