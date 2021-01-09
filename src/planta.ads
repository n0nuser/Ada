with Ada.Real_Time;
with Ada.Real_Time.Timing_Events; use Ada.Real_Time;
with Ada.Numerics.Discrete_Random;

package Planta is
   subtype aleatorioProduccion is Integer range 1 .. 2;
   package Aleatorio is new Ada.Numerics.Discrete_Random(aleatorioProduccion);

   protected type Generador is
      procedure leer (temp : out Integer);
      procedure incrementar (incremento : Integer);
      procedure abrirDispositivo;
      procedure cerrarDispositivo;
      procedure Timer(event : in out Ada.Real_Time.Timing_Events.Timing_Event);
   private
      seed     : Aleatorio.Generator;
      temp     : aleatorioProduccion;
      produccion         : Integer := 15; --produccion inicial del generador
      bajarJitterControl : Ada.Real_Time.Timing_Events.Timing_Event;
      periodoProduccion       : Ada.Real_Time.Time_Span := Ada.Real_Time.Seconds(3); -- Cada 3 segundos aumenta/disminuye en 1 Mw la produccion
      nextTime : Ada.Real_Time.Time;
   end Generador;
end Planta;
