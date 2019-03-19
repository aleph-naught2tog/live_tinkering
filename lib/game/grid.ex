defmodule Game.Grid do
  alias Game.Cell

  def clamp(value, top, bottom \\ 0), do: max(bottom, min(value, top))

  def update_location({x, y}, {old_x, old_y}, {rows, columns}) do
    updated = {clamp(old_x + x, columns), clamp(old_y + y, rows)}
    %{location: updated, last_location: {old_x, old_y}}
  end

  def build_grid({row_count, column_count}) do
    Enum.map(0..row_count, fn y_value ->
      Enum.map(0..column_count, &%Cell{x: &1, y: y_value})
    end)
  end

  def update_grid(grid, %{location: {x, y}, last_location: {old_x, old_y}}) do
    grid
    |> List.update_at(
      old_y,
      &List.update_at(&1, old_x, fn cell ->
        Cell.deactivate(cell)
      end)
    )
    |> List.update_at(
      y,
      &List.update_at(&1, x, fn cell ->
        Cell.activate(cell)
      end)
    )
  end
end
