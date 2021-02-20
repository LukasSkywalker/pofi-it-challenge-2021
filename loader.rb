require 'json'

class Loader
  def initialize(coordinates_path, connections_path)
    @coordinates_path = coordinates_path
    @connections_path = connections_path
  end

  def nodes
    coordinates.map do |segment|
      segment.keys
    end
  end

  def coordinates
    @coordinates ||= JSON.parse(File.read('coordinates.json'))
  end

  def connections
    data = JSON.parse(File.read('connections.json'))
    data.each_with_index.map do |segment, segment_idx|
      segment.map do |edge|
        from_name = edge['from']
        to_name = edge['to']
        {
          'from' => {
            'name' => from_name,
            'x' => coordinates[segment_idx][from_name]['x'],
            'y' => coordinates[segment_idx][from_name]['y']
          },
          'to' => {
            'name' => to_name,
            'x' => coordinates[segment_idx][to_name]['x'],
            'y' => coordinates[segment_idx][to_name]['y']
          }
        }
      end
    end
  end
end
