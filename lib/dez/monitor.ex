defmodule Monitor do
  use ExFSWatch, dirs: ["../.."]

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, events) do
    R.reload!
    IO.inspect {file_path, events}
  end
end
