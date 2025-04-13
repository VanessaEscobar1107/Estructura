Code.require_file("docente.ex")
Code.require_file("util-java.ex")

defmodule Estructuras do
  def main do
    "Docentes_Uniquindio_20240817.csv"
    |> Docente.leer_csv()
    |> filtrar_datos_interes()
    |> Docente.generar_mensaje_docente(&generar_mensaje/1)
    |> IO.puts()

  end

  defp filtrar_datos_interes(datos) do
    datos
    |> Enum.filter(fn docente ->
      docente.formacion == "MAESTRIA" and docente.vinculacion == "PLANTA"
    end)
  end

  defp generar_mensaje(docente) do
    "#{docente.periodo}, #{docente.formacion}, #{docente.vinculacion}"
  end
end

Estructuras.main()
