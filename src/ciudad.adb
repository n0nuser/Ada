with Ada.Text_IO;

package body Ciudad is
   protected body ConsumoCiudad is
      procedure leer (temp : out Integer) is
      begin
         temp := consumo;
      end leer;

      procedure abrirDispositivo is
      begin
         nextTime := periodoConsumo + Clock;
         Ada.Real_Time.Timing_Events.Set_Handler(jitterControl, nextTime, Timer'Access);
      end abrirDispositivo;

      procedure cerrarDispositivo is
      begin
         Ada.Real_Time.Timing_Events.Set_Handler(jitterControl, nextTime, null);
      end cerrarDispositivo;

      procedure Timer (event : in out Ada.Real_Time.Timing_Events.Timing_Event)
      is
      begin
         AleatorioCon.Reset(seed);
         tempCon := AleatorioCon.Random(seed); --Genera aleatoriamente un numero del -3 al 3
         consumo := consumo + tempCon; --Aumenta/disminuye el consumo un valor entre -3 y 3 cada 6 segundos
         nextTime   := periodoConsumo + Clock;
         Ada.Real_Time.Timing_Events.Set_Handler(jitterControl, nextTime, Timer'Access);
      end Timer;
   end ConsumoCiudad;
end Ciudad;
