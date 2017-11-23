#chromedriverexeが存在しなければ導入するよう促し終了する
if (ENV.key?("OCRA_EXECUTABLE"))
exe_path=ENV['OCRA_EXECUTABLE']
exe_path=exe_path.gsub("CPPlus.exe","")
chromedriver_path=exe_path.dup.to_s.gsub("CPPlus.exe","chromedriver.exe")
file_inside_current_dir=[]
     Dir.glob("#{File.expand_path(exe_path)}/*").each do |file|
     file_inside_current_dir<<File.basename("#{file}")
     end
  if file_inside_current_dir.include?("chromedriver.exe")
    puts("Confirm chromedriver.exe......")
  else
    puts"It seems you have not introduce chrome-driver yet. Please download it from https://sites.google.com/a/chromium.org/chromedriver/downloads and restart this program. You should put chromedriver.exe at #{chromedriver_path} . This window will be closed in 50 seconds."
    sleep(50)
    exit!
  end

else
file=File.expand_path(File.dirname(__FILE__)).to_s
chromedriver_path="#{file}/chromedriver.exe"
file_inside_current_dir=[]
     Dir.glob("#{File.expand_path(file)}/*").each do |file|
     file_inside_current_dir<<File.basename("#{file}")
     end
   if file_inside_current_dir.include?("chromedriver.exe")
     puts("Confirm chromedriver.exe.....")
   else
     puts"It seems you have not introduce chrome-driver yet. Please download it from https://sites.google.com/a/chromium.org/chromedriver/downloads . You should put chromedriver.exe at #{chromedriver_path} "
     sleep(50)
     exit!
   end
end
#chromedriverexeが存在しなければ導入するよう促し終了する


#envファイルの存在を確認し、なければ新設する。

if (ENV.key?("OCRA_EXECUTABLE"))
exe_path=ENV['OCRA_EXECUTABLE']
exe_path=exe_path.gsub("CPPlus.exe","")
file_inside_current_dir=[]
     Dir.glob("#{File.expand_path(exe_path)}/*").each do |file|
     file_inside_current_dir<<File.basename("#{file}")
     end
  if file_inside_current_dir.include?("settings.env")
    puts("Confirm configuration file.......")
  else
    puts"Welcome to CoursePowerPlus!"
    puts"At first, put your USER_ID and PASSWORD which you usually use to login to CousePower.\n You do not have to input it again because these data will be recorded."
    puts"USER_ID:"
    user_id=gets.to_s.chomp
    puts"PASSWORD:"
    password=gets.to_s.chomp
    puts"Specify the directory to download new doucuments. If you are using Windows10, you can designat the path like this. \nExample: C:\\Users\\your_account_name\\Desktop"
    puts"PATH:"
    path_for_download=gets.chomp
    path_for_download=path_for_download.gsub("\\","\\\\\\")
#環境設定ファイルの新規作成と書き込み
    File.open("settings.env","w") do |file|
    file.puts("USER_ID=\"#{user_id}\"")
    file.puts("PASSWORD=\"#{password}\"")
    file.puts("PATH_FOR_DOWNLOAD=\"#{path_for_download}\"")
    end
  end

else
file=File.expand_path(File.dirname(__FILE__)).to_s
file_inside_current_dir=[]
     Dir.glob("#{File.expand_path(file)}/*").each do |file|
     file_inside_current_dir<<File.basename("#{file}")
     end
   if file_inside_current_dir.include?("settings.env")
     puts("Confirm configuration file......")
   else
     puts"Welcome to CoursePowerPlus!"
     puts"At first, put your USER_ID and PASSWORD which you usually use to login to CousePower.\n You do not have to input it again because these data will be recorded. Push Enter key after you put each datum."
    puts"USER_ID:"
    user_id=gets.to_s.chomp
    puts"PASSWORD:"
    password=gets.to_s.chomp
    puts"Specify the directory to download new doucuments. If you are using Windows OS, you can designat the path like this. \nExample: C:\\Users\\your_account_name\\Desktop"
    path_for_download=gets.to_s.chomp
    path_for_download=path_for_download.gsub("\\","\\\\\\")

    File.open("settings.env","w") do |file|
    file.puts("USER_ID=\"#{user_id}\"")
    file.puts("PASSWORD=\"#{password}\"")
    file.puts("PATH_FOR_DOWNLOAD=\"#{path_for_download}\"")
    end
   end
end

#envファイルの存在を確認し、なければ新設する。終わり

require 'dotenv'
Dotenv.load "settings.env"
#設定ファイル読み込み
path_dir= ENV['PATH_FOR_DOWNLOAD']
user_id=ENV["USER_ID"]
password=ENV["PASSWORD"]

names_of_files_downloaded=[]

if (ENV.key?("OCRA_EXECUTABLE"))
exe_path=ENV['OCRA_EXECUTABLE']
chromedriver_path=exe_path.dup.to_s.gsub("CPPlus.exe","chromedriver.exe")
else
file=File.expand_path(File.dirname(__FILE__)).to_s
chromedriver_path="#{file}/chromedriver.exe"
end

require 'bundler/setup'
require 'selenium-webdriver'
Bundler.require
Selenium::WebDriver::Chrome.driver_path = chromedriver_path
prefs = {
  prompt_for_download: false,
  automatic_downloads: 1,
  directory_upgrade: true,
  #default_directory: "#{File.expand_path(path_dir)}/",
}
path_dir_download_now="#{path_dir}\\download_now"
puts ("Files will be downloaded in #{path_dir_download_now} tempolary, but it will be move to #{path_dir} soon...")
options = Selenium::WebDriver::Chrome::Options.new
options.add_preference(:download, prefs)
options.add_argument('--headless')
puts "Now Starting Google Chrome..."
driver = Selenium::WebDriver.for :chrome, options: options,:switches => %w[--disable-application-cache]

     bridge = driver.send(:bridge)
     path = '/session/:session_id/chromium/send_command'
     path[':session_id'] = bridge.session_id
     bridge.http.call(:post, path, {
       "cmd" => "Page.setDownloadBehavior",
       "params" => {
         "behavior" => "allow",
         "downloadPath" => "#{path_dir_download_now}"
       }
    })
Dir.rmdir("#{path_dir_download_now}") if FileTest.exist?("#{path_dir_download_now}")
driver.get "https://cp.aim.aoyama.ac.jp/lms/lginLgir/"
puts 'Connect to Course Power Sucsessful...'

driver.find_element(:name, 'userId').send_keys "#{user_id}"
driver.find_element(:name, 'password').send_keys "#{password}"
driver.find_element(:name,'loginButton').click
puts"Loged in sucsessful..."

#ログインに失敗したらenvファイルの内容を書き直させる
    #未実装
#ログインに失敗したらenvファイルの内容を書き直させる。end

number_of_subjects=driver.find_elements(:class, 'courseCardName').length.to_i
n=0
subject_numburs=[]
number_of_subjects.times{
subject_numburs<<n
n=n+1
}

subject_numburs.each do |subject_number|

subject_number=subject_number.to_i
subject_name=driver.find_elements(:class, 'courseCardName')[subject_number].text()

puts ("Finding new documents from #{subject_name}.....")

tags=[]
target_tags=[]
tags_raw=driver.page_source.to_s
tags_raw.each_line {|line| tags<<line }
target_tags=tags.select{|item| item.include? ("#{subject_name}")}

unless target_tags.join.include?("onclick")
  puts("Skip this subject because the link is not available...")
  next
end

driver.find_element(:xpath,("//a[.='#{subject_name}']")).click
driver.find_element(:xpath,("//a[.='状況別に表示する']")).click
#driver.find_element(:xpath,("//a[.='完了']")).click#For only developper
tags=[]
target_tags=[]
delete_tags=[]
tags_raw=driver.page_source.to_s
tags_raw.each_line {|line| tags<<line }
target_tags=tags.select{|item| item.include? ('kyozaiTitleLink'&&'SRY')}

delete_tags=target_tags.select{|item| item.include? ('Cell')}#採ってきたタグから余計なタグを選ぶ。

delete_tags.each do|delete_tag|                          #余計なタグを消す。
target_tags.reject!{|item| item.include?(delete_tag)}
end

links_to_next=[]
target_tags.each do |target_tag|
  target_tag=target_tag.match(/\>(.*?)\</).to_s
  links_to_next<<target_tag.gsub(">","").gsub("<","")
end

if links_to_next.empty?
  puts ("All documents are already downloaded. Move on to next subject...")
  driver.navigate.back
  driver.navigate.back
  next#状況別表示のリンクが空であればsubject_numbersの数字を一つ進めたい。
else

 links_to_next.each do |link_to_next|
 driver.find_element(:xpath,("//a[.='#{link_to_next}']")).click
#ダウンロード画面
 tags=[]
 target_tags=[]
 delete_tags=[]
 tags_raw=driver.page_source.to_s
 tags_raw.each_line {|line| tags<<line }
 target_tags=tags.select{|item| item.include? ('onclick'&&'downloadFile')} #余計なタグを複数選んでしまう。

 target_tags=target_tags.select!{|item| item.include? ('onclick')}#採ってきたタグから余計なタグのみに絞る。

   target_tags.each do |target_tag|
     link_to_download=target_tag.match(/;\"\>(.*?)\<\/a\>/).to_s
     link_to_download=link_to_download.match(/\>(.*?)\</).to_s
     link_to_download=link_to_download.gsub(";\">","").gsub("<","")
     link_to_download.gsub!(">","")
     puts "Starting download this document ....#{link_to_download}"

#ダウンロード前のディレクトリのファイルの個数
     path_dir_download_now="#{path_dir}\\download_now"
     FileUtils.mkdir("#{path_dir_download_now}")unless FileTest.exist?("#{path_dir_download_now}")

     file_number_before=[]
     Dir.glob("#{File.expand_path(path_dir_download_now)}/*").each do |file|
     file_number_before<<file
     end
     file_number_before_int=file_number_before.length
     #ダウンロード先ファイルの作成
     path_dir_download_now="#{path_dir}/download_now"
     #ダウンロードボタンクリック
     driver.find_element(:xpath,("//a[.='#{link_to_download}']")).click

#名前重複回避プロセス
require 'fileutils'
#ファイルが一つ増えていることを確認
     file_number_after=[]
     Dir.glob("#{File.expand_path(path_dir_download_now)}/*").each do |file|
     file_number_after<<file
     end
     file_number_after_int=file_number_after.length

     until file_number_after_int==file_number_before_int+1
     sleep(1)
     puts"Now Downloading....#{link_to_download}"
     file_number_after=[]
     Dir.glob("#{File.expand_path(path_dir_download_now)}/*").each do |file|
     file=file.to_s.encode("UTF-8")
     file_number_after<<file
     end#end for each
     file_number_after_int=file_number_after.length
     end
#crdownloadではないことも確認
     file_arry=[]
     Dir.glob("#{File.expand_path(path_dir_download_now)}/*").each do |file|
     file=file.to_s.encode("UTF-8")
     file_arry<<file
     end

     while file_arry.join().include?("crdownload")
     sleep(1)
     file_arry=[]
     Dir.glob("#{File.expand_path(path_dir_download_now)}/*").each do |file|
     file=file.to_s.encode("UTF-8")
     file_arry<<file
     puts"Saving the file to #{File.expand_path(path_dir_download_now)}"
     end#end for each
     end#end for while

#ディレクトリの中のファイル名を取得する
     file_inside_download_now=[]
     Dir.glob("#{File.expand_path(path_dir_download_now)}/*").each do |file|
     file_inside_download_now<<File.basename("#{file}")
     end
     file_inside_download_now=file_inside_download_now.join.to_s#一つしかファイルは存在しないはずなのでjoin使用
#デスクトップの中のファイル名をすべて取得する
     dir_designated=[]
Dir.glob("#{File.expand_path(path_dir)}/*").each do |file|
     dir_designated<<File.basename("#{file}")
     end

#ディレクトリの中のファイルとデスクトップのファイルの内容が同じものがあるか確認する
   if dir_designated.include?(file_inside_download_now)
     #もしあればディレクトリの中のファイル名を変更する
     #拡張子を取得して
     extname=File.extname("#{file_inside_download_now}").to_s
     #変更後の名前の生成
     extname=extname.encode("Windows-31J")
     file_changed_name=file_inside_download_now.gsub("#{extname}","new#{extname}")
     #名前の変更
     FileUtils.mv("#{path_dir_download_now}/#{file_inside_download_now}", "#{path_dir_download_now}/#{file_changed_name}")
     #ファイルの移動
     File.rename("#{path_dir_download_now}/#{file_changed_name}","#{path_dir}/#{file_changed_name}")
     file_inside_download_now=file_changed_name
   else
      puts"No same name files was found"
      #単にファイルの移動だけ
      File.rename("#{path_dir_download_now}/#{file_inside_download_now}","#{path_dir}/#{file_inside_download_now}")
   end
#フォルダを削除する
     Dir.rmdir("#{path_dir_download_now}")
#名前重複回避プロセス終了

     name_of_file_download="#{link_to_download}--#{subject_name}\n"
     name_of_file_download=name_of_file_download.encode("UTF-8")
     names_of_files_downloaded<<name_of_file_download
    end
    driver.navigate.back#ダウンロードをすべて終えたら一つ前に戻る（状況別表示へ）
 end
 puts ("All documents are downloaded from #{subject_name}.")
 driver.navigate.back
 #driver.navigate.back#devolopper only
 driver.navigate.back
 #状況別表示がすべて参照済みになったら講義一覧に戻る。
end

end#if文のend。

if names_of_files_downloaded.empty?
puts"No new documents was found..."
else
puts"This is the list of new documents downloaded."
names_of_files_downloaded.each do |name_of_file_to_show_list|
puts name_of_file_to_show_list
end
end

print("The process completed. \n The window will be closed automatically in 10 seconds....")
sleep(10)