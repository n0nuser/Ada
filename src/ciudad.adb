with Ada.Text_IO;

package body Ciudad is
   protected body ConsumoCiudad is
      procedure leer (temp : out Integer) is
      begin
         temp := consumo; --Guarda en la varible temp la consumo que tenga ese momento el generador
      end leer;

      procedure abrirDispositivo is
      begin
         nextTime := periodoConsumo + Clock;
         --Para abrir la compuerta lo que hace la funcion de abajo es llamar a Timer cada vez que pasa un segundo
         Ada.Real_Time.Timing_Events.Set_Handler(jitterControl, nextTime, Timer'Access);
      end abrirDispositivo;

      procedure Timer (event : in out Ada.Real_Time.Timing_Events.Timing_Event)
      is
      begin
         AleatorioCon.Reset(seed);
         tempCon := AleatorioCon.Random(seed); --Genera aleatoriamente un numero del -3 al 3
         consumo := consumo + tempCon; --Aumenta/disminuye el consumo un valor entre -3 y 3 cada 6 segundos
         nextTime   := periodoConsumo + Clock;
         --Eliminar comprobacion
         Ada.Text_IO.Put_Line ("Consumo actual de la ciudad: " & consumo'Img);
         Ada.Real_Time.Timing_Events.Set_Handler(jitterControl, nextTime, Timer'Access);
      end Timer;

   end ConsumoCiudad;
end Ciudad;
