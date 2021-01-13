-- Fichero: planta.adb
-- Participantes
-- Sergio Garcia Gonzalez - 70921911P
-- Pablo Jesus Gonzalez Rubio - 70894492M

with Ada.Text_IO;
package body Planta is
   protected body Generador is
      procedure leer (temp : out Integer) is
      begin
         temp := produccion; --Guarda en la varible temp la produccion que tenga ese momento el generador
      end leer;

      procedure incrementar (incremento : Integer) is
      begin
         produccion := produccion + incremento; --Incrementa produccion con la produccion que se le haya pasado
      end incrementar;

      procedure abrirDispositivo is
      begin
         nextTime := periodoProduccion + Clock;
         Ada.Real_Time.Timing_Events.Set_Handler(bajarJitterControl, nextTime, Timer'Access);
      end abrirDispositivo;

      procedure cerrarDispositivo is
      begin
         --Para cerrarla ponemos a null la funcion que iniciamos antes y dejara de ejecutarse
         Ada.Real_Time.Timing_Events.Set_Handler(bajarJitterControl, nextTime, null);
      end cerrarDispositivo;

      procedure Timer (event : in out Ada.Real_Time.Timing_Events.Timing_Event)
      is
      begin
         temp := Aleatorio.Random(seed);
         if temp = 1 then
            produccion := produccion - 1;
            --Ada.Text_IO.Put_Line("# Decrementando produccion de generador");
         elsif temp = 2 then
            produccion := produccion + 1;
            --Ada.Text_IO.Put_Line("# Incrementando produccion de generador");
         end if;
         nextTime   := periodoProduccion + Clock;
         Ada.Real_Time.Timing_Events.Set_Handler(bajarJitterControl, nextTime, Timer'Access);
      end Timer;

   end Generador;

end Planta;
