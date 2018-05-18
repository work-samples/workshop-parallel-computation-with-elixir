defmodule Lab1 do
  def print_first_message() do
    spawn(fn ->
      receive do
        message -> IO.write(:stderr, message)
      end
    end)
  end

  def loop() do
    receive do
      message ->
        IO.write(:stderr, message)
        loop()
    end
  end

  def print_all_messages() do
    spawn(&loop/0)
  end

  def sum() do
    spawn(fn ->
      receive do
        {:sum, pid, list} ->
          send(pid, Enum.sum(list))
      end
    end)
  end

  def sum_with_pid() do
    spawn(fn ->
      receive do
        {:sum, pid, list} ->
          send(pid, {self(), Enum.sum(list)})
      end
    end)
  end

  def sum_all(list_of_lists) do
    me = self()

    list_of_lists
    |> Enum.map(fn list ->
      ref = make_ref()

      spawn(fn ->
        send(me, {ref, Enum.sum(list)})
      end)

      ref
    end)
    |> Enum.map(fn ref ->
      receive do
        {^ref, sum} -> sum
      end
    end)
  end
end
