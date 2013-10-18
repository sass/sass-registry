module ExtensionsHelper
  def short_description(description)
    first_line = description.split("\n\n").first
    sanitize(markdown(truncate(first_line, :length => 200))) unless first_line.blank?
  end
  
  def repository_types_for_select
    [
      'Git',
      'Subversion'
    ]
  end
  
  def download_types_for_select
    [
      'Gem',
      ['Tar (.tar)', 'Tarball'],
      ['GZip (.tar.gz, .tgz)', 'Gzip'],
      ['BZip2 (.tar.bz2)', 'Bzip2'],
      ['Zip (.zip)', 'Zip']
    ]
  end
  
  def view_orders(current)
    o = []
    ExtensionsController::ORDER_BY.keys.each {|order|
      if current == order
        o << "<strong>#{order}</strong>"
      else
        o << link_to(order, order: order)
      end
    }
    raw(o.join(' | '))
  end
end
