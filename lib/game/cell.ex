defmodule Game.Cell do
  alias Game.Cell

  @active "🐻"
  @inactive "🌸"
  @default "🍀"

  defstruct x: 0, y: 0, data: @default, active?: false

  def activate(%Cell{} = cell) do
    %{cell | data: @active, active?: true}
  end

  def deactivate(%Cell{} = cell) do
    %{cell | data: @inactive, active?: false}
  end
end

defimpl String.Chars, for: Game.Cell do
  def to_string(cell), do: cell.data
end

defimpl Phoenix.HTML.Safe, for: Game.Cell do
  def to_iodata(cell), do: cell.data
end
