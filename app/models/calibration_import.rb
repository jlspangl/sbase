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
      nil
    elsif load_imported_calibration
      @calibration.id
    else
      calibration.errors.full_messages.each do |message|
        errors.add :base, "Row #{index+2}: #{message}"
      end
      nil
    end
  end

  def load_imported_calibration

    Rails.logger.info ("maggie: in load_imported_calibration")
    spreadsheet = open_spreadsheet
    Rails.logger.info ("maggie: after open spreadsheet")

    sensor_row = 0
    sensor_col = 0
    range_col = 0
    std1_row = 0
    std1_col = 0
    std2_col = 0
    std2_row = 0
    cal_date_row = 0
    cal_date_col = 0
    exp_date_row = 0
    exp_date_col = 0

    #loop through  spreadsheet  cells
    (spreadsheet.first_row..spreadsheet.last_row).each do |i|
      (spreadsheet.first_column..spreadsheet.last_column).each do |j|

        if spreadsheet.celltype(i, j) == :string
          # cell containing "Xducer/Controller SN" label
          if sensor_row == 0 && spreadsheet.cell(i, j).upcase.include?("SN")
            sensor_row = i
            sensor_col = j

            # cell containing "Cal Range" label
          elsif range_col == 0 && spreadsheet.cell(i, j).upcase.include?("RANGE")
            range_col = j

            # cell containing "STD-1" label
          elsif std1_col == 0 && spreadsheet.cell(i, j).upcase.include?("STD")
            std1_row = i
            std1_col = j

            # cell containing "STD-2"
          elsif std1_col != 0 && std2_col == 0 && spreadsheet.cell(i, j).upcase.include?("STD")
            std2_row = i
            std2_col = j

            # cell containing "Cal Date"
          elsif cal_date_row == 0 && spreadsheet.cell(i, j).upcase.include?("DATE")
            cal_date_row = i
            cal_date_col = j

            # cell containing "Next Cal Due"
          elsif exp_date_row == 0 && spreadsheet.cell(i, j).upcase.include?("DUE")
            exp_date_row = i
            exp_date_col = j
          end
        end #if cell is string

      end #end columns
    end #end rows

    Rails.logger.info ("maggie: after spreadsheet parse")
    @calibration = Calibration.new
    @calibration.save!
    Rails.logger.info ("maggie: after save! #{@calibration.id}")

    #Get sensor associations
    sensor_ids = []
    (sensor_col+1...range_col).each do |j|
      if spreadsheet.celltype(sensor_row, j) == :string
        sensor_ids << spreadsheet.cell(sensor_row, j)
      elsif spreadsheet.celltype(sensor_row, j) == :float
        sensor_ids << spreadsheet.cell(sensor_row, j).to_i.to_s
      end
    end
    sensor_ids.each do |id|
      p = Sensor.first(:conditions => ['mcn = ? or ecn = ? or serial_no = ?', id, id, id])
      @calibration.sensors << p if p
    end

    true

=begin
#Get range
    range = 0
    unit = "undefined"
    (range_col+1..spreadsheet.last_column).each do |j|
      if spreadsheet.celltype(sensor_row, j) == :string
        str_value = spreadsheet.cell(sensor_row, j)
        range = str_value.to_f
        str_value = str_value.gsub(/[0-9\.\-\+\*]/, '')
        if str_value
          unit = case str_value.strip.upcase
                   when "IN", "INCH" then
                     "in"
                   when "FT", "FspreadsheetT", "FEET" then
                     "ft"
                   when "CM", "CENTIMETER", "CENTIMETERS" then
                     "cm"
                   when "MM", "MILLIIMETER", "MILLIMETERS" then
                     "mm"
                   when "M", "METER", "METERS" then
                     "m"
                   when "M", "MICROMETRE", "MICROMETER", "MICROMETRES", "MICROMETERS", "UM" then
                     "um"
                   else
                     "undefined"
                 end
        end
        break
      elsif spreadsheet.celltype(sensor_row, j) == :float
        range = spreadsheet.cell(sensor_row, j)
        units = "undefined"
        break
      end
    end
    puts "range = #{range}"
    puts unit

#get std min max
    std = []
    (std2_row+1..spreadsheet.last_row).each do |i|
      if spreadsheet.celltype(i, std2_col) == :float
        std << spreadsheet.cell(i, std2_col)
      end
    end
    puts std.max
    puts std.min

    cal_date = nil
    (cal_date_col+1...exp_date_col).each do |j|
      if spreadsheet.celltype(cal_date_row, j) == :date
        cal_date = spreadsheet.cell(cal_date_row, j)
        break;
      end
    end
    puts cal_date

    exp_date = nil
    (exp_date_col+1..spreadsheet.last_column).each do |j|
      if spreadsheet.celltype(exp_date_row, j) == :date
        exp_date = spreadsheet.cell(exp_date_row, j)
        break;
      end
    end
=end
  end

  #def load_imported_calibrations
  #  spreadsheet = open_spreadsheet
  #  header = spreadsheet.row(1)
  #  (2..spreadsheet.last_row).map do |i|
  #    row = Hash[[header, spreadsheet.row(i)].transpose]
  #    calibration = Calibration.find_by_id(row["id"]) || Calibration.new
  #    calibration.attributes = row.to_hash.slice(*Calibration.accessible_attributes)
  #    calibration
  #  end
  #end

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