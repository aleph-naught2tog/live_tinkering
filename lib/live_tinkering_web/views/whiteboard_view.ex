defmodule LiveTinkeringWeb.WhiteboardView do
  use LiveTinkeringWeb, :view

  def keys do
    ~w{
        <<open>>
        ~ ! @ # $ % ^ & * ( ) _ +  <<shift>>
        ` 1 2 3 4 5 6 7 8 9 0 - = Backspace
        <<close>>

        <<open>>
        Q W E R T Y U I O P \{ \} | <<shift>>
        Tab q w e r t y u i o p [ ] \\
        <<close>>

        <<open>>
        A S D F G H J K L : "       <<shift>>
        a s d f g h j k l ; ' Enter
        <<close>>

        <<open>>
        Z X C V B N M < > ?         <<shift>>
        Shift z x c v b n m , . / Shift
        <<close>>

        <<open>>
        Space
        <<close>>

        Meta Ctrl Alt}
  end

  def print_key("<<open>>"), do: ~E{<div>}
  def print_key("<<close>>"), do: ~E{</div>}
  def print_key("<<shift>>"), do: ~E{<br />}

  @key_class "key"
  def print_key(key) do
    keypress_id = "#{key}_keypress_id"
    keyup_id = "#{key}_keyup_id"
    keydown_id = "#{key}_keydown_id"
    ~E{
      <button
        class="key"
        value="<%= key %>"
        id="<%= keypress_id %>"
        phx-click="keypress"
      >
        <%= key %>
      </button>
      <button
        class="key hidden"
        value="<%= key %>"
        id="<%= keyup_id %>"
        phx-click="keyup"
      >
        <%= key %> up
      </button>
      <button
        class="key hidden"
        value="<%= key %>"
        id="<%= keydown_id %>"
        phx-click="keydown"
      >
        <%= key %> down
      </button>
    }
  end
end