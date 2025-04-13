Code.require_file("util-java.ex")
Code.require_file("cliente.ex")

defmodule Estructuras do
  def main do
    "clientes.csv"
    |> Cliente.leer_csv()
    |> filtrar_datos_interes()
    |> Cliente.generar_mensaje_clientes(&generar_mensaje/1)
    |> IO.puts()
  end

  defp filtrar_datos_interes(datos) do
    datos
    |> Enum.filter(fn (cliente) -> cliente.edad < 21 end)
  end

  defp generar_mensaje(cliente) do
    altura = cliente.altura |> Float.round(2)
    "Hola #{cliente.nombre}, tu edad es de #{cliente.edad} años y " <>
    "tienes una altura de #{altura}"
  end
end

Estructuras.main()
