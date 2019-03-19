defmodule LiveTinkeringWeb.BearGameView do
  use LiveTinkeringWeb, :view
  alias Game.Cell

  def grid(values) do
    [
      ~E{<table class="grid">},
      for row <- Enum.reverse(values) do
        [
          ~E{<tr>},
          for cell <- row do
            game_cell(cell)
          end,
          ~E{</tr>}
        ]
      end,
      ~E{</table>}
    ]
  end

  def game_cell(%Cell{} = cell) do
    ~E{
      <td>
        <%= cell %>
      </td>
    }
  end
end
