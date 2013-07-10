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

  def upload
    File.open(Rails.root.join('public', 'uploads', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end
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
      #calibration.errors.full_messages.each do |message|
      #  errors.add :base, "Row #{index+2}: #{message}"
      #end
      nil
    end
  end

  def load_imported_calibration

    #Rails.logger.info ("maggie: in load_imported_calibration")
    spreadsheet = open_spreadsheet
    loc = Hash.new #locations in spreadsheet
    parse_spreadsheet(spreadsheet, loc)
    @calibration = Calibration.new

    @calibration.orig_filename = file.original_filename

    set_range(spreadsheet, loc[:range_label][0], loc[:range_label][1]) if loc.key?(:range_label)

    set_minmax(spreadsheet, loc[:std1_label][0], loc[:std1_label][1]) if loc.key?(:std1_label)

    set_dates(spreadsheet, loc[:cal_date_label][0], loc[:cal_date_label][1],
              loc[:exp_date_label][0], loc[:exp_date_label][1])

    #Get sensor associations
    sensors = get_sensors(spreadsheet, loc)

    if errors.any?
      false
    else
      @calibration.save!
      sensors.each { |p| @calibration.sensors << p }
      true
    end


=begin
#get std min max

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


  def parse_spreadsheet(spreadsheet, cell_locations)
    #loop through  spreadsheet  cells
    (spreadsheet.first_row..spreadsheet.last_row).each do |i|
      (spreadsheet.first_column..spreadsheet.last_column).each do |j|

        if spreadsheet.celltype(i, j) == :string
          # cell containing "Xducer/Controller SN" label
          if !cell_locations.key?(:sensor_label) && spreadsheet.cell(i, j).upcase.include?("SN")
            cell_locations[:sensor_label] = [i, j]

            # cell containing "Cal Range" label
          elsif !cell_locations.key?(:range_label) && spreadsheet.cell(i, j).upcase.include?("RANGE")
            cell_locations[:range_label] = [i, j]

            # cell containing "STD-1" label
          elsif !cell_locations.key?(:std1_label) && spreadsheet.cell(i, j).upcase.include?("STD")
            cell_locations[:std1_label] = [i, j]

            # cell containing "STD-2"
          elsif cell_locations.key?(:std1_label) && !cell_locations.key?(:std2_label) && spreadsheet.cell(i, j).upcase.include?("STD")
            cell_locations[:std1_label] = [i, j]

            # cell containing "Cal Date"
          elsif !cell_locations.key?(:cal_date_label) && spreadsheet.cell(i, j).upcase.include?("DATE")
            cell_locations[:cal_date_label] = [i, j]

            # cell containing "Next Cal Due"
          elsif !cell_locations.key?(:exp_date_label) && spreadsheet.cell(i, j).upcase.include?("DUE")
            cell_locations[:exp_date_label] = [i, j]
          end
        end #if cell is string

      end #end columns
    end #end rows
  end

  #end  parse_spreadsheet

  def get_sensors(spreadsheet, cell_locations)
    sensors = []
    if cell_locations.key?(:sensor_label)
      (cell_locations[:sensor_label][1]+1...cell_locations[:range_label][1]).each do |j|
        sensor_num = nil
        if spreadsheet.celltype(cell_locations[:sensor_label][0], j) == :string
          sensor_num = spreadsheet.cell(cell_locations[:sensor_label][0], j)
        elsif spreadsheet.celltype(cell_locations[:sensor_label][0], j) == :float
          sensor_num = spreadsheet.cell(cell_locations[:sensor_label][0], j).to_i.to_s
        end
        if sensor_num
          p = Sensor.first(:conditions => ['mcn = ? or ecn = ? or serial = ?', sensor_num, sensor_num, sensor_num])
          if p
             sensors << p
          else
            errors.add :base, "The calibration was not uploaded because no sensor with control number #{sensor_num} was found in the database."
          end
        end
      end
      sensors
    end
  end

  def set_range(spreadsheet, row, col)
    @calibration.range = 0
    @calibration.measurement_unit = "undefined"
    (col+1..spreadsheet.last_column).each do |j|
      if spreadsheet.celltype(row, j) == :float
        @calibration.range = spreadsheet.cell(row, j)
        break;
      elsif spreadsheet.celltype(row, j) == :string
        str = spreadsheet.cell(row, j)
        @calibration.range = str.to_f
        str = str.gsub(/[0-9\.\-\+\*]/, '')
        @calibration.measurement_unit = unit_type(str) if str
        break;
      end
    end
  end

  #set_range


  def set_minmax(spreadsheet, row, col)
    std = []
    (row+1..spreadsheet.last_row).each do |i|
      if spreadsheet.celltype(i, col) == :float
        std << spreadsheet.cell(i, col)
      end
    end
    @calibration.calibration_max = std.max
    @calibration.calibration_min = std.min
    @calibration.set_mode
  end

  #set_minmax

  def unit_type(str)
    case str.strip.upcase
      when "IN", "INCH" then
        "in"
      when "FT", "FOOT", "FEET" then
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


  #set date looks for calibration date and then assumes next date found is expiration date
  #assumption: calibration and expiration dates are in same row and
  #            calibration date precedes expiration date

  def set_dates(spreadsheet, cal_date_row, cal_date_col, exp_date_row, exp_date_col)

    k = 0
    (cal_date_col+1...exp_date_col).each do |j|
      if spreadsheet.celltype(cal_date_row, j) == :date
        @calibration.caldate = spreadsheet.cell(cal_date_row, j)
        k = j + 1
        break
      end
    end

    #look for expiration date
    if (k != 0)

      (k..spreadsheet.last_column).each do |j|
        if spreadsheet.celltype(cal_date_row, j) == :date
          @calibration.expdate = spreadsheet.cell(cal_date_row, j)
          break
        end
      end
    end

  end #set_dates


end