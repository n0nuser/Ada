with Ada.Real_Time;
with Ada.Real_Time.Timing_Events; use Ada.Real_Time;
package Planta is
   protected type Generador is
      procedure leer (temp : out Integer);
      procedure incrementar (incremento : Integer);
      procedure decrementar (decremento : Integer);
      procedure abrirDispositivo;
      procedure cerrarDispositivo;
      procedure Timer(event : in out Ada.Real_Time.Timing_Events.Timing_Event);
   private
      produccion         : Integer := 15; --produccion inicial del generador
      bajarJitterControl : Ada.Real_Time.Timing_Events.Timing_Event;
      bajarPeriodo       : Ada.Real_Time.Time_Span := Ada.Real_Time.Seconds(3); -- Este segundo es el tiempo que esperara para volver a bajar la produccion en 50 grados cuando se abra la compuerta
      nextTime : Ada.Real_Time.Time;
   end Generador;
end Planta;
