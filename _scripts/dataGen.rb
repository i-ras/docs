require 'fileutils'
require 'yaml'

subjects_dir = '../_subjects'
docs_root_dir = 'docs'
data_dir = '../_data'

FileUtils.mkdir_p(data_dir)

Dir.foreach(subjects_dir) do |file|
  next if file == '.' || file == '..'

  if file.end_with?('.md')
    subject_name = File.basename(file, '.md')
    subject_docs_path = File.join(docs_root_dir, subject_name, 'docs')

    unless Dir.exist?(subject_docs_path)
      puts "Adresář #{subject_docs_path} neexistuje, přeskočeno."
      next
    end

    data = {}

    %w[presentation worksheet test].each do |sub_dir|
      sub_path = File.join(subject_docs_path, sub_dir)

      if Dir.exist?(sub_path)
        documents = []
        Dir.foreach(sub_path) do |sub_file|
          next if sub_file == '.' || sub_file == '..'

          documents << {
            'name' => File.basename(sub_file, File.extname(sub_file)),
            'path' => File.join('/', docs_root_dir, subject_name, 'docs', sub_dir, sub_file)
          }
        end

        data[sub_dir] = documents.empty? ? nil : documents
      else
        data[sub_dir] = nil
      end
    end

    yaml_file_path = File.join(data_dir, "#{subject_name}.yml")

    File.open(yaml_file_path, 'w') do |yaml_file|
      yaml_file.write(data.to_yaml)
    end
    puts "Vytvořen YAML soubor pro #{subject_name}: #{yaml_file_path}"
  end
end
