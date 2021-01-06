package body SensorLectorC is
   protected body SensorLectorCiu is

      entry leer (c : access ConsumoCiudad; result : out Integer) when datoDisponible is
      begin
         c.leer(result); --Llama a la funcion del generador, leer. Result contendra la produccion del generador.
         --datoDisponible:=False;
      end leer;

      procedure Timer (event : in out Ada.Real_Time.Timing_Events.Timing_Event)
      is
      begin
         --obtener el dato y cargarlo en leyendo
         datoDisponible := True;
         nextTime       := nextTime + entradaPeriodo;
         Ada.Real_Time.Timing_Events.Set_Handler(entradaJitterControl, nextTime, Timer'Access);
      end Timer;

   end SensorLectorCiu;
end SensorLectorC;
