with Ada.Real_Time;
with Ada.Real_Time.Timing_Events; use Ada.Real_Time;
package Ciudad is
   protected type ConsumoCiudad is
      procedure leer (temp : out Integer);
      procedure incrementar (incremento : Integer);
      procedure abrirDispositivo;
      procedure cerrarDispositivo;
      procedure Timer(event : in out Ada.Real_Time.Timing_Events.Timing_Event);
   private
      consumo         : Integer := 35; --consumo inicial de la ciudad
      bajarJitterControl : Ada.Real_Time.Timing_Events.Timing_Event;
      periodoConsumo       : Ada.Real_Time.Time_Span := Ada.Real_Time.Seconds(6); -- Cada 6 segundos aumenta/disminuye en un rango entre -3 y 3 Mw la produccion
      nextTime : Ada.Real_Time.Time;
   end ConsumoCiudad;
end Ciudad;
