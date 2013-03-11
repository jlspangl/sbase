class SensorImport

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

  def save
    if imported_sensors.map(&:valid?).all?
      imported_sensors.each(&:save!)
      true
    else
      imported_sensors.each_with_index do |sensor, index|
        sensor.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_sensors
    @imported_sensors ||= load_imported_sensors
  end

  def load_imported_sensors
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      sensor = Sensor.find_by_id(row["id"]) || Sensor.new
      sensor.attributes = row.to_hash.slice(*Sensor.accessible_attributes)
      sensor
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end
end