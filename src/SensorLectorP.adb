package body SensorLectorP is
   protected body SensorLectorGen is

      entry leer (g : access Generador; result : out Integer) when True is
      begin
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
