defmodule LiveTinkeringWeb.WhiteboardView do
  use LiveTinkeringWeb, :view

  def keys do
    ~w{` 1 2 3 4 5 6 7 8 9 0 - = ~ ! @ # $ % ^ & * ( ) _ + q w e r t y u i o p [ ] ' ; l k j h g f d s a z x c v b n m , . / ? > < M N B V C X Z A S D F G H J K L : \" | \} \{ P O I U Y T R E W Q Shift Enter Tab Meta Ctrl Alt Backspace}
  end
end