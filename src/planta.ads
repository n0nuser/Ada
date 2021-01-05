with Ada.Real_Time;
with Ada.Real_Time.Timing_Events; use Ada.Real_Time;
package Planta is
   protected type Generador is
      procedure leer (temp : out Integer);
      procedure incrementar (incremento : Integer);
      procedure abrirDispositivo;
      procedure cerrarDispositivo;
      procedure Timer(event : in out Ada.Real_Time.Timing_Events.Timing_Event);
   private
      produccion         : Integer := 15; --produccion inicial del generador
      bajarJitterControl : Ada.Real_Time.Timing_Events.Timing_Event;
      periodoProduccion       : Ada.Real_Time.Time_Span := Ada.Real_Time.Seconds(3); -- Cada 3 segundos aumenta/disminuye en 1 Mw la produccion
      nextTime : Ada.Real_Time.Time;
   end Generador;
end Planta;
