with Ada.Text_IO;
package body Ciudad is
   protected body ConsumoCiudad is
      procedure leer (temp : out Integer) is
      begin
         temp := consumo; --Guarda en la varible temp la consumo que tenga ese momento el generador
      end leer;

      procedure incrementar (incremento : Integer) is
      begin
         consumo := consumo + incremento; --Incrementa consumo con la consumo que se le haya pasado
      end incrementar;

      procedure abrirDispositivo is
      begin
         nextTime := periodoConsumo + Clock;
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
         consumo := consumo - 50; --Baja la consumo 50 cada segundo
         nextTime   := periodoConsumo + Clock;
         --Eliminar comprobacion
         Ada.Text_IO.Put_Line ("consumo bajada: " & consumo'Img);
         Ada.Real_Time.Timing_Events.Set_Handler(bajarJitterControl, nextTime, Timer'Access);
      end Timer;

   end ConsumoCiudad;

end Ciudad;
