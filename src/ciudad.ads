with Ada.Real_Time;
with Ada.Real_Time.Timing_Events; use Ada.Real_Time;
package Ciudad is
   protected type ConsumoCiudad is
      procedure leer (temp : out Integer);
      procedure incrementar (incremento : Integer);
      procedure decrementar (decremento : Integer);
      procedure abrirDispositivo;
      procedure cerrarDispositivo;
      procedure Timer(event : in out Ada.Real_Time.Timing_Events.Timing_Event);
   private
      consumo         : Integer := 35; --consumo inicial de la ciudad
      bajarJitterControl : Ada.Real_Time.Timing_Events.Timing_Event;
      bajarPeriodo       : Ada.Real_Time.Time_Span := Ada.Real_Time.Seconds(1); -- Este segundo es el tiempo que esperara para volver a bajar la consumo en 50 grados cuando se abra la compuerta
      nextTime : Ada.Real_Time.Time;
   end ConsumoCiudad;
end Ciudad;
