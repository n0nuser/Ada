-- Fichero: SensorLectorP.adb
-- Participantes
-- Sergio Garcia Gonzalez - 70921911P
-- Pablo Jesus Gonzalez Rubio - 70894492M

package body SensorLectorP is
   protected body SensorLectorGen is

      -- El sensor solo llama a las funciones de planta pero metiendole el retardo de 0.15

      entry leer (g : access Generador; result : out Integer) when True is
      begin
         nextTime := Clock + entradaPeriodo;
         Ada.Real_Time.Timing_Events.Set_Handler(entradaJitterControl, nextTime, Timer'Access); --Le mete un retardo de 0.15 segundos
         g.leer(result); --Llama a la funcion del generador, leer. Result contendra la produccion del generador.
      end leer;

      procedure Timer (event : in out Ada.Real_Time.Timing_Events.Timing_Event)
      is
      begin
         --obtener el dato y cargarlo en leyendo
         nextTime       := nextTime + entradaPeriodo;
         Ada.Real_Time.Timing_Events.Set_Handler(entradaJitterControl, nextTime, Timer'Access);
      end Timer;

   end SensorLectorGen;
end SensorLectorP;
