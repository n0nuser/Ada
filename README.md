# Enunciado Práctica ADA - Plantas de Energía y Consumo Ciudad

# Nota Final : 

## Parcipantes:

<table>
  <tr>
    <td align="center"><a href="https://github.com/AnOrdinaryUsser"><img width="100px;" src="https://avatars2.githubusercontent.com/u/61872281?s=460&u=e276002ebcb7a49338dac7ffb561cf968d6c0ee4&v=4"></td>
    <td align="center"><a href="https://github.com/n0nuser"><img width="100px;" src="https://avatars3.githubusercontent.com/u/32982175?s=460&u=ce93410c9c5e0f3ffa17321e16ee2f2b8879ca6f&v=4"></td>
  </tr>
</table>

# Requisitos

## Planta

3 Plantas. Producen `0-30` Mw/h. El valor de inicio de producción es de `15` Mw para cada central. Las plantas cada tres segundos producen `+-1` Mw. Si es decimal no se incrementa/decrementa.

En caso de que la diferencia de la producción/consumo sea superior a `3` Mw hay que actuar en las tres centrales a la vez, en caso de que sea `2` Mw sobre dos y en caso de que sea `1` Mw sobre una.

Cada tarea planta quedará a la espera de recibir un mensaje de consultar, aumentar, disminuir o mantener la producción. En caso de no recibir ningún mensaje durante `5` segundos desde la última recepción de uno se imprime `ALERTA MONITORIZACIÓN ENERGÍA`. 

## Ciudad

Ciudad consumo `15-90` Mw/h. Consumo cada `6` segundos valor aleatorio entre `-3` y `3`. El consumo de inicio de la ciudad es de `35` Mw (se deben de producir alertas y alcanzar una situación más o menos estable pasado un tiempo). El acceso/modificación a la energía consumida en la ciudad es instantáneo y se puede acceder directamente a un objeto protegido.

## Consumo

Si diferencia entre consumo y producción + de `5%` -> ALARMA: por la pantalla `PELIGRO SOBRECARGA consumo:VALOR producción:VALOR` en caso de sobreproducción o `PELIGRO BAJADA consumo:VALOR producción:VALOR` en caso de que el consumo sea superior, en otro caso se imprimirá `Estable consumo:VALOR producción:VALOR`.

Una tarea (que se lanza a los `0.3` segundos)  monitorizará cada segundo el valor de la energía producida y la consumida y en función de dichos valores mandará un mensaje a cada planta para que aumente, disminuya o mantenga la producción.

## Retardos

El actuador que permite alterar la producción de la energía de cada central tarda `0.6` segundos en abrir el dispositivo o cerrarlo para aumentar o disminuir la producción, por lo que: Si recibe una orden de aumentar tarda `0.6` segundos en volver (simular el retardo). Si recibe una nueva orden de aumentar antes de que se haya modificado realmente la producción (a los tres segundos) entonces vuelve de inmediato ya que no tiene que modificar el dispositivo.

En caso de recibir un mensaje de consultar hay que tener en cuenta que cada vez que se va a leer del sensor que proporciona la energía producida se tiene un retardo de `0.15` segundos (input jitter) hasta que se obtiene el dato, hay que simular este retardo.

## Notas

- Importante. Ejecutar el programa desde línea de órdenes. El ejecutable está en el directorio `obj` del proyecto.
- Se recomienda implementar un `sensorLector` y un actuador que permitan acceder y modificar la producción de cada una de las centrales.
- Si se dice que una acción ocurre cada determinado período, ocurre cada ese determinado período con independencia de lo que se tarde en procesar los datos que hay antes o después
- El número de tareas creado debe de estar en función del enunciado, no se puede hacer por ejemplo una única tarea para las tres plantas y que se queda a la espera de la recepción de los mensajes por parte de la tarea monitorizadora. Cada planta funciona de forma independiente.
- Se puede leer secuencialmente desde la tarea de control la producción de cada una de las centrales no es obligatorio poner a cada sensor en un hilo diferente. No penalizará si no se hace aunque se valorará positivamente.
