# The S3ResultTree class represents a tree-shaped directory of files in S3.
class S3ResultTree
  def initialize(name = nil, path = '')
    @name = name
    @path = path
    @folders = {}
    @files = []
  end

  attr_reader :name, :path, :folders, :files

  def add_file(obj)
    return unless obj.size > 0
    file = extract_data(obj)
    folder_for(file[:path]).files << file
  end

  def to_hash
    if @name
      {
        name: @name,
        isDir: true,
        path: @path,
        children: children
      }
    else
      children
    end
  end

  private

  def children
    @folders.values.map(&:to_hash) + @files
  end

  def extract_data(obj)
    {
      name: File.basename(obj[:key]),
      isFile: true,
      path: obj[:key],
      meta:
        {
          last_modified: obj[:last_modified].utc.strftime('%Y-%m-%dT%H:%M:%S+00:00'),
          content_type: nil, # must call #head_object to get this or guess it
          content_length: obj[:size].to_i
        }
    }
  end

  def folder_for(path)
    File.dirname(path).split('/').inject(self) do |tree, folder_name|
      tree.folders[folder_name] ||= S3ResultTree.new(folder_name, tree.path + folder_name + '/')
    end
  end
end
