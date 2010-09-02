Feature: Tweets Listings
  As a new polyglot programmer
  I want to view the tweets listing separated by tags
  In order to follow the programming languages news
  
  Scenario: Show all the created tags
    Given I am on the root page
    Then I should see a link called "Sugira sua comunidade" pointing to "http://twitter.com/?status=@progpoliglota"
