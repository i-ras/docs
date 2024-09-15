require 'fileutils'

subjects_dir = '../_subjects'
docs_dir = '../docs'

Dir.foreach(subjects_dir) do |file|
  next if file == '.' || file == '..'

  if file.end_with?('.md')
    dir_name = File.basename(file, '.md')

    subject_path = File.join(docs_dir, dir_name)

    if Dir.exist?(subject_path)
      puts "Adresář #{subject_path} již existuje, přeskočeno."
      next
    end

    FileUtils.mkdir_p(subject_path)

    %w[presentation worksheet test].each do |sub_dir|
      FileUtils.mkdir_p(File.join(subject_path, sub_dir))
    end

    puts "Vytvořeno: #{subject_path} a podadresáře"
  end
end
