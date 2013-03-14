class CalibrationImport

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def is_spreadsheet
    %w(.xls .xlsx).include? File.extname(file.original_filename)
  end

  def save
    if !is_spreadsheet
      errors.add :base, "File cannot be read. Please choose a spreadsheet file ending in .xls or .xlsx."
      false
    elsif imported_calibrations.map(&:valid?).all?
      imported_calibrations.each(&:save!)
      true
    else
      imported_calibrations.each_with_index do |calibration, index|
        calibration.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_calibrations
    @imported_calibrations ||= load_imported_calibrations
  end

  def load_imported_calibrations
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      calibration = Calibration.find_by_id(row["id"]) || Calibration.new
      calibration.attributes = row.to_hash.slice(*Calibration.accessible_attributes)
      calibration
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
      when ".csv" then
        Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then
        Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then
        Roo::Excelx.new(file.path, nil, :ignore)
      else
        raise "Unknown file type: #{file.original_filename}"
    end
  end

end