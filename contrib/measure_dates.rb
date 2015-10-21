require 'rubygems'
require 'zip/zip'

class ZipFileGenerator
  # Initialize with the directory to zip and the location of the output archive.
  def initialize(inputDir, outputFile)
    @inputDir = inputDir
    @outputFile = outputFile
  end

  def unzip_file()
    Zip::ZipFile.open(@outputFile) { |zip_file|
     zip_file.each { |f|
       f_path=File.join(@inputDir, f.name)
       FileUtils.mkdir_p(File.dirname(f_path))
       zip_file.extract(f, f_path) unless File.exist?(f_path)
     }
    }
  end
  # Zip the input directory.
  def write()
    entries = Dir.entries(@inputDir); entries.delete("."); entries.delete("..")
    io = Zip::ZipFile.open(@outputFile, Zip::ZipFile::CREATE);
    writeEntries(entries, "", io)
    io.close();
  end
  # A helper method to make the recursion work.
  private
  def writeEntries(entries, path, io)
    entries.each { |e|
      zipFilePath = path == "" ? e : File.join(path, e)
      diskFilePath = File.join(@inputDir, zipFilePath)
      puts "Deflating " + diskFilePath
      if File.directory?(diskFilePath)
        io.mkdir(zipFilePath)
        subdir =Dir.entries(diskFilePath); subdir.delete("."); subdir.delete("..")
        writeEntries(subdir, zipFilePath, io)
      else
        io.get_output_stream(zipFilePath) { |f| f.print(File.open(diskFilePath, "rb").read())}
      end
    }
  end
end

def modify_bundle_dates(bundle_name)
  zf = ZipFileGenerator.new("./bundle_tmp", bundle_name)
  zf.unzip_file()
  FileUtils.rm(bundle_name)

  Dir.glob('./bundle_tmp/measures/**/*').select{ |measure|
  	next unless File.file? measure
  	IO.write(measure, File.open(measure) do |f|
  		f.read.gsub("var effective_date = <%= effective_date %>;", "var effective_date = <%= effective_date %>;\\nvar start_date = <%= start_date %>;")
  	    .gsub("MeasurePeriod.low.date.setFullYear(MeasurePeriod.low.date.getFullYear()-1);", "MeasurePeriod.low.date.setFullYear(MeasurePeriod.low.date.getFullYear()-1);\\nif(start_date)\\nMeasurePeriod.low.date = new Date(1000 * start_date);")
  	  end
  	)
  }

  zf.write()

  FileUtils.rm_rf('./bundle_tmp')
end