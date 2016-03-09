#encoding: utf-8

require 'fileutils'

module DB

  def self.prepare
    data_path = File.join(ENV['HOME'], '.shunkuntype','training_data.txt')

    create_file_if_not_exists data_path
  end

  def self.create_file_if_not_exists(path)
    create_file_path path

    return if File::exists?(path)
  end

  def self.create_file_path(path)
    FileUtils.mkdir_p File.dirname(path)
  end

  private_class_method :create_file_if_not_exists, :create_file_path
end

