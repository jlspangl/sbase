module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "SensorBase"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end


  def sensor_label(sensor)
    a = []
    a << sensor.mcn unless sensor.mcn.blank?
    a << sensor.ecn unless sensor.ecn.blank?
    a << sensor.serial unless sensor.serial.blank?
    s = ""
    a.each { |x| s << "#{x} #{'/ ' unless a.last==x}" }
    s
  end

  #def sortable(column, title = nil)
  #  title ||= column.titleize
  #  css_class = column == sort_column ? "current #{sort_direction}" : nil
  #  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  #  if  column == sort_column   &&    sort_direction == "asc"
  #    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:style => "padding-right: 12px;background-repeat: no-repeat;background-position: right center;background-image: url(up_arrow.gif);"}
  #  elsif  column == sort_column   &&    sort_direction == "desc"
  #    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:style => "padding-right: 12px;background-repeat: no-repeat;background-position: right center;background-image: url(down_arrow.gif);"}
  #  else
  #     link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  #  end
  #end
end
