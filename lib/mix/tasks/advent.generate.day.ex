defmodule Mix.Tasks.Advent.Generate.Day do
  use Igniter.Mix.Task

  @example "mix advent.generate.day 1 2024"

  @shortdoc "A short description of your task"
  @moduledoc """
  #{@shortdoc}

  Longer explanation of your task

  ## Example

  ```bash
  #{@example}
  ```

  ## Options

  * `--example-option` or `-e` - Docs for your option
  """

  @impl Igniter.Mix.Task
  def info(_argv, _composing_task) do
    %Igniter.Mix.Task.Info{
      # Groups allow for overlapping arguments for tasks by the same author
      # See the generators guide for more.
      group: :advent,
      # dependencies to add
      adds_deps: [],
      # dependencies to add and call their associated installers, if they exist
      installs: [],
      # An example invocation
      example: @example,
      # a list of positional arguments, i.e `[:file]`
      positional: [{:day, opional: true}, {:year, optional: true}],
      # Other tasks your task composes using `Igniter.compose_task`, passing in the CLI argv
      # This ensures your option schema includes options from nested tasks
      composes: [],
      # `OptionParser` schema
      schema: [],
      # Default values for the options in the `schema`
      defaults: [],
      # CLI aliases
      aliases: [],
      # A list of options in the schema that are required
      required: []
    }
  end

  @impl Igniter.Mix.Task
  def igniter(igniter, argv) do
    {arguments, _argv} = positional_args!(argv)

    day = advent_day(Map.get(arguments, :day))
    year = advent_year(Map.get(arguments, :year))

    full_day_number = String.pad_leading(Integer.to_string(day), 2, "0")

    day_module_name =
      Igniter.Project.Module.parse("Advent.Year#{year}.Day#{full_day_number}")

    test_module_name =
      Igniter.Project.Module.parse("Advent.Year#{year}.Day#{full_day_number}Test")

    igniter
    |> Igniter.Project.Module.create_module(
      day_module_name,
      """
        def part1(input) do
          input
        end

        def part2(input) do
          input
        end
      """
    )
    |> Igniter.Project.Module.create_module(
      test_module_name,
      """
      defmodule #{test_module_name}Test do
        use ExUnit.Case

        import#{day_module_name}

        @tag :skip
        test "part1" do
          input = nil
          result = part1(input)

          assert result
        end

        @tag :skip
        test "part2" do
          input = nil
          result = part1(input)

          assert result
        end
      """,
      path: Igniter.Code.Module.proper_test_location(test_module_name)
    )
  end

  defp advent_day(nil) do
    {:ok, now} = DateTime.now("Europe/Berlin")
    now.day
  end

  defp advent_day(day) when is_binary(day) do
    case Integer.parse(day) do
      {day, _} when day in 1..25 ->
        day

      _ ->
        raise ArgumentError, "provide a valid day from 1-25"
    end
  end

  defp advent_year(nil) do
    {:ok, now} = DateTime.now("America/New_York")
    now.year
  end

  defp advent_year(year) when is_binary(year) do
    String.to_integer(year)
  end
end
