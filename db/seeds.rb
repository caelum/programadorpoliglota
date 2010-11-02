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

java.tags << Tag.create(:name=>'#java')
java.tags << Tag.create(:name=>'#vraptor')
java.tags << Tag.create(:name=>'#jsf')
java.tags << Tag.create(:name=>'#wicket')
java.tags << Tag.create(:name=>'#struts')
java.tags << Tag.create(:name=>'#android')

ruby.tags << Tag.create(:name=>'#ruby')
ruby.tags << Tag.create(:name=>'#rails')
ruby.tags << Tag.create(:name=>'#sinatra')
ruby.tags << Tag.create(:name=>'#merb')

python.tags << Tag.create(:name=>'#python')
python.tags << Tag.create(:name=>'#django')
python.tags << Tag.create(:name=>'#web2py')

dotnet.tags << Tag.create(:name=>'#dotnet')
dotnet.tags << Tag.create(:name=>'#csharp')
dotnet.tags << Tag.create(:name=>'#linq')

php.tags << Tag.create(:name=>'#php')

agile.tags << Tag.create(:name=>'#agile')
agile.tags << Tag.create(:name=>'#scrum')
agile.tags << Tag.create(:name=>'#kanban')
agile.tags << Tag.create(:name=>'#lean')

javascript.tags << Tag.create(:name=>'#javascript')
javascript.tags << Tag.create(:name=>'#js')
javascript.tags << Tag.create(:name=>'#nodejs')
