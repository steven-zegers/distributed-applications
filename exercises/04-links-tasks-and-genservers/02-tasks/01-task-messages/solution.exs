# <!-- Hoe is dit een oplossing voor de opgave? -->
# <!-- Hier wordt aangetoond dat elke "response" v.e. task niet meer dan een message is. 
# m.a.w. er kan d.m.v. patternmatching in je receive blok je resultaat opgehaald worden,
#  en je zou theoretisch gezien Task.await of Task.yield niet nodig hebben 
# Het is eerder de bedoeling om ze te laten snappen wat er op de achtergrond gebeurd dan gewoon de Task API te gebruiken -->

# Basic syntax
Task.async(fn -> :ok1 end)
Task.async(fn -> :ok2 end)
Task.async(fn -> :ok3 end)

# De module is misschien wat overkill, maar zo haal je alle messages eruit

defmodule Receive do
  def message() do
    receive do
      {ref, val} ->
        IO.puts("I've received #{inspect(val)} form #{inspect(ref)}")

      {:DOWN, ref, :process, pid, :normal} ->
        IO.puts("Normal process exit form #{inspect(pid)} with ref #{inspect(ref)}")
    end

    message()
  end
end

# Either spawn a process that prints to the screen or block your iex shell... it's up to you
Receive.message()

############################
# FUN version             ##
############################
tasks = Enum.map(1..100, fn n -> Task.async(fn -> {:ok, n} end) end)

myreceive = fn f ->
  receive do
    {ref, val} ->
      IO.puts("I've received #{inspect(val)} form #{inspect(ref)}")

    {:DOWN, ref, :process, pid, :normal} ->
      IO.puts("Normal process exit form #{inspect(pid)} with ref #{inspect(ref)}")
  end

  f.(f)
end

myreceive.(myreceive)

# After looking at this code, you should be able to understand what is happening.
# NOTE: There is no guarantee in which order the results arrive!
