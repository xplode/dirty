require 'open3'

module Generate
  APP_DIR = '/home/ubuntu/dirty'
  OUTPUT_IMAGE_DIR = File.join(APP_DIR, 'public', 'images')
  INPUT_IMAGE_DIR =  File.join(APP_DIR, 'images')

  def self.get_html(rand, path=nil)
    generated_file = File.join(APP_DIR, 'generated', "#{rand.random_number}.html")
    return File.read(generated_file) if File.exists?(generated_file)

    result = create_html(rand, path)
    File.open(generated_file, 'w') do |file|
      file.write(result)
    end

    return result
  end

  def self.create_html(rand, path=nil)
    images = ''
    numbers = ''
    height = 20 

    case rand.seed
    when 1
      height = 800
    when (2..4)
      height = 600
    when (5..10)
      height = 300
    when (11..25)
      height = 200
    when (26..60)
      height = 150
    when (61..99)
      height = 100
    when (100..500)
      height = 50 
    end

    (0...rand.seed).each do
      image_file = create_image(rand)
      images += "<img src='/images/#{image_file}' height='#{height}'>"
      numbers += "#{rand.random_number}<br>"
    end
    return images + numbers 
  end

  def self.create_image(rand)
    # choose input file
    image_files = Dir.glob(File.join(INPUT_IMAGE_DIR, '*'))
    input_file = image_files[ (rand.random_number*1000).to_i % image_files.length]
    output_file = File.join(OUTPUT_IMAGE_DIR, "#{rand.random_number}_#{input_file.split('/').last}")
    fill_color = "srgb(#{(rand.random_number*1000).to_i % 256},#{(rand.random_number*1000).to_i % 256},#{(rand.random_number*1000).to_i % 256})"
    font = FONTS[(rand.random_number*1000).to_i % FONTS.length]
    pointsize = (rand.random_number*1000).to_i % 100
    text = rand.random_number.to_s
    cmd = "convert #{input_file} -fill \"#{fill_color}\" -font #{font} -pointsize #{pointsize} -gravity center -annotate 0 '#{text}' #{output_file}"
    Open3.popen2e(cmd) {|stdin, stdout_and_stderr, wait_thr|
      exit_status = wait_thr.value # Process::Status object returned.
      msg = "#{stdout_and_stderr.read}: #{exit_status}"
      raise "Failed to generate image" if exit_status != 0
    }

    return output_file.split('/').last
  end

  FONTS = [
    'AvantGarde-Book',
    'AvantGarde-BookOblique',
    'AvantGarde-Demi',
    'AvantGarde-DemiOblique',
    'Bookman-Demi',
    'Bookman-DemiItalic',
    'Bookman-Light',
    'Bookman-LightItalic',
    'Courier',
    'Courier-Bold',
    'Courier-BoldOblique',
    'Courier-Oblique',
    'fixed',
    'Helvetica',
    'Helvetica-Bold',
    'Helvetica-BoldOblique',
    'Helvetica-Narrow',
    'Helvetica-Narrow-Bold',
    'Helvetica-Narrow-BoldOblique',
    'Helvetica-Narrow-Oblique',
    'Helvetica-Oblique',
    'NewCenturySchlbk-Bold',
    'NewCenturySchlbk-BoldItalic',
    'NewCenturySchlbk-Italic',
    'NewCenturySchlbk-Roman',
    'Palatino-Bold',
    'Palatino-BoldItalic',
    'Palatino-Italic',
    'Palatino-Roman',
    'Symbol',
    'Times-Bold',
    'Times-BoldItalic',
    'Times-Italic',
    'Times-Roman',
    'Century-Schoolbook-L-Bold',
    'Century-Schoolbook-L-Bold-Italic',
    'Century-Schoolbook-L-Italic',
    'Century-Schoolbook-L-Roman',
    'DejaVu-Sans',
    'DejaVu-Sans-Bold',
    'DejaVu-Sans-Mono',
    'DejaVu-Sans-Mono-Bold',
    'DejaVu-Serif',
    'DejaVu-Serif-Bold',
    'Dingbats',
    'Lato-Black',
    'Lato-Black-Italic',
    'Lato-Bold',
    'Lato-Bold-Italic',
    'Lato-Hairline',
    'Lato-Hairline-Italic',
    'Lato-Heavy',
    'Lato-Heavy-Italic',
    'Lato-Italic',
    'Lato-Light',
    'Lato-Light-Italic',
    'Lato-Medium',
    'Lato-Medium-Italic',
    'Lato-Regular',
    'Lato-Semibold',
    'Lato-Semibold-Italic',
    'Lato-Thin',
    'Lato-Thin-Italic',
    'Nimbus-Mono-L',
    'Nimbus-Mono-L-Bold',
    'Nimbus-Mono-L-Bold-Oblique',
    'Nimbus-Mono-L-Regular-Oblique',
    'Nimbus-Roman-No9-L',
    'Nimbus-Roman-No9-L-Medium',
    'Nimbus-Roman-No9-L-Medium-Italic',
    'Nimbus-Roman-No9-L-Regular-Italic',
    'Nimbus-Sans-L',
    'Nimbus-Sans-L-Bold',
    'Nimbus-Sans-L-Bold-Condensed',
    'Nimbus-Sans-L-Bold-Condensed-Italic',
    'Nimbus-Sans-L-Regular-Condensed',
    'Nimbus-Sans-L-Bold-Condensed-Italic',
    'Nimbus-Sans-L-Bold-Italic',
    'Nimbus-Sans-L-Regular-Condensed',
    'Nimbus-Sans-L-Regular-Condensed-Italic',
    'Nimbus-Sans-L-Regular-Italic',
    'Standard-Symbols-L',
    'URW-Bookman-L-Demi-Bold',
    'URW-Bookman-L-Demi-Bold-Italic',
    'URW-Bookman-L-Light',
    'URW-Bookman-L-Light-Italic',
    'URW-Chancery-L-Medium-Italic',
    'URW-Gothic-L-Book',
    'URW-Gothic-L-Book-Oblique',
    'URW-Gothic-L-Demi',
    'URW-Gothic-L-Demi-Oblique',
    'URW-Palladio-L-Bold',
    'URW-Palladio-L-Bold-Italic',
    'URW-Palladio-L-Italic',
    'URW-Palladio-L-Roman',
  ]
end
