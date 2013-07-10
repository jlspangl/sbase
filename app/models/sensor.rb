# == Schema Information
#
# Table name: sensors
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  category   :string(255)
#  ecn        :string(255)
#  mcn        :string(255)
#  model      :string(255)
#  serial     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag        :string(255)
#

class Sensor < ActiveRecord::Base

  CATEGORIES = ['LVDT',
                'Test Stand',
                'Clip gauge / Extensometer',
                'Linear stage',
                'Signal conditioning amplifier',
                'Data acquisition system' ,
                'Caliper/Micrometer',
                'Microscope stage',
                'Other']

  attr_accessible :ecn, :mcn, :model, :serial, :name, :category

  has_many :measurements
  has_many  :calibrations, :through => :measurements

  validates_uniqueness_of :ecn, :mcn,  :allow_blank => true
  validate :either_mcn_or_ecn_present?
  validates_inclusion_of :category, in: CATEGORIES,  :allow_blank => true
  validates_acceptance_of :confirmation, :on => :create

  before_save :set_tag


  def set_tag
    self.tag = [mcn, ecn, serial].reject(&:blank?).join(" ")
  end


  def control_number
    if !mcn.blank?
      mcn
    elsif !ecn.blank?
      ecn
    elsif !serial.blank?
      serial.to_s
    else
      "undefined"
    end
  end

  #
  #def self.import(file)
  #  spreadsheet = open_spreadsheet(file)
  #  header = spreadsheet.row(1)
  #  (2..spreadsheet.last_row).each do |i|
  #    row = Hash[[header, spreadsheet.row(i)].transpose]
  #    sensor = find_by_id(row["id"]) || new
  #    sensor.attributes = row.to_hash.slice(*accessible_attributes)
  #    sensor.save!
  #  end
  #end
  #
  #def self.open_spreadsheet(file)
  #  case File.extname(file.original_filename)
  #    when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
  #    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
  #    when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
  #    else raise "Unknown file type: #{file.original_filename}"
  #  end
  #end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |sensor|
        csv << sensor.attributes.values_at(*column_names)
      end
    end
  end

  private

  def either_mcn_or_ecn_present?
    if %w(ecn mcn).all?{|attr| self[attr].blank?}
      errors[:base] << ("Please enter ECN or MCN -- either control number will do.")
    end
  end
end
