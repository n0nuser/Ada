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

      procedure decrementar (decremento : Integer) is
      begin
         produccion := produccion - decremento;
      end decrementar;

      procedure abrirDispositivo is
      begin
         nextTime := bajarPeriodo + Clock;
         --Para abrir la compuerta lo que hace la funcion de abajo es llamar a Timer cada vez que pasa un segundo
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
         produccion := produccion - 50; --Baja la produccion 50 cada segundo
         nextTime   := bajarPeriodo + Clock;
         --Eliminar comprobacion
         Ada.Text_IO.Put_Line ("produccion bajada: " & produccion'Img);
         Ada.Real_Time.Timing_Events.Set_Handler(bajarJitterControl, nextTime, Timer'Access);
      end Timer;

   end Generador;

end Planta;
