defmodule Cliente do
  defstruct nombre: "", edad: 0, altura: 0.0

  def crear(nombre, edad, altura) do
    %Cliente{nombre: nombre, edad: edad, altura: altura}
  end

  def ingresar(mensaje) do
    mensaje |> Util.mostrar_mensaje()

    nombre = "Ingrese nombre:" |> Util.ingresar(:texto)
    edad = "Ingresar edad:" |> Util.ingresar(:entero)
    altura = "Ingrese la altura:" |> Util.ingresar(:real)

    crear(nombre, edad, altura)
  end

  def ingresar(mensaje, :clientes) do
    mensaje
    |> ingresar([], :clientes)
  end

  defp ingresar(mensaje, lista, :clientes) do
    cliente = mensaje |> ingresar()
    nueva_lista = lista ++ [cliente]

    mas_clientes =
      "\nIngresar más clientes (s/n): "
      |> Util.ingresar(:boolean)

    case mas_clientes do
      true -> mensaje |> ingresar(nueva_lista, :clientes)
      false -> nueva_lista
    end
  end

  def generar_mensaje_clientes(lista_clientes, parser) do
    lista_clientes
    |> Enum.map(parser)
    |> Enum.join("\n")
  end

  def escribir_csv(clientes, nombre) do
    clientes
    |> generar_mensaje_clientes(&convertir_cliente_linea_csv/1)
    |> (&("nombre, edad, altura\n" <> &1)).()
    |> (&File.write(nombre, &1)).()
  end

  def convertir_cliente_linea_csv(cliente) do
    "#{cliente.nombre}, #{cliente.edad} , #{cliente.altura}\n"
  end

  def leer_csv(nombre) do
    nombre
    |> File.stream!()
    |> Stream.drop(1) # ignora encabezados
    |> Enum.map(&convertir_cadena_cliente/1)
  end

  # función modificada para soportar comillas
  def convertir_cadena_cliente(cadena) do
    [nombre, edad, altura] =
      cadena
      |> obtener_campos_ignorando_comillas()
      |> Enum.map(&String.trim/1)

    edad = String.to_integer(edad)
    altura = String.to_float(altura)

    # Quita las comillas si el nombre las tiene
    nombre = String.replace(nombre, ~s("), "")
    crear(nombre, edad, altura)
  end

  # Función para dividir correctamente ignorando comas dentro de comillas
  defp obtener_campos_ignorando_comillas(cadena) do
    expresion_regular = ~r/,(?=(?:[^"]*"[^"]*")*[^"]*$)/
    Regex.split(expresion_regular, cadena)
  end
end
