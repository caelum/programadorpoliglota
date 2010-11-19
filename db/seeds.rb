# -*- coding: utf-8 -*-
#Precisa dar truncate antes senão não limpa as tabelas
ActiveRecord::Base.connection.execute("TRUNCATE #{Tag.table_name}")
ActiveRecord::Base.connection.execute("TRUNCATE #{TagGroup.table_name}")

java   = TagGroup.create(:name=>'Java')
ruby   = TagGroup.create(:name=>'Ruby')
python = TagGroup.create(:name=>'Python')
dotnet = TagGroup.create(:name=>'.NET')
php    = TagGroup.create(:name=>'PHP')
agile  = TagGroup.create(:name=>'Agile')
javascript  = TagGroup.create(:name=>'Javascript')

java.tags << Tag.create(:name=>'#java', :query=>'#java')
java.tags << Tag.create(:name=>'#vraptor', :query=>'#vraptor')
java.tags << Tag.create(:name=>'#jsf', :query=>'#jsf')
java.tags << Tag.create(:name=>'#wicket', :query=>'#wicket')
java.tags << Tag.create(:name=>'#struts', :query=>'#struts')
java.tags << Tag.create(:name=>'#android', :query=>'#android')

ruby.tags << Tag.create(:name=>'#ruby', :query=>'#ruby')
ruby.tags << Tag.create(:name=>'#rails', :query=>'#rails')
ruby.tags << Tag.create(:name=>'#sinatra', :query=>'#sinatra')
ruby.tags << Tag.create(:name=>'#merb', :query=>'#merb')

python.tags << Tag.create(:name=>'#python', :query=>'#python')
python.tags << Tag.create(:name=>'#django', :query=>'#django')
python.tags << Tag.create(:name=>'#web2py', :query=>'#web2py')

dotnet.tags << Tag.create(:name=>'#dotnet', :query=>'#dotnet')
dotnet.tags << Tag.create(:name=>'#csharp', :query=>'#csharp')
dotnet.tags << Tag.create(:name=>'#linq', :query=>'#linq')

php.tags << Tag.create(:name=>'#php', :query=>'#php')
php.tags << Tag.create(:name=>'#cakephp', :query=>'#cakephp')

agile.tags << Tag.create(:name=>'#agile', :query=>'#agile')
agile.tags << Tag.create(:name=>'#scrum', :query=>'#scrum')
agile.tags << Tag.create(:name=>'#kanban', :query=>'#kanban')
agile.tags << Tag.create(:name=>'#lean', :query=>'#lean')

javascript.tags << Tag.create(:name=>'#javascript', :query=>'#javascript')
javascript.tags << Tag.create(:name=>'#js', :query=>'#js')
javascript.tags << Tag.create(:name=>'#nodejs', :query=>'#nodejs')
