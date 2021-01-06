with Ada.Real_Time;
with Ada.Real_Time.Timing_Events; use Ada.Real_Time;
with Ada.Numerics.Discrete_Random;

package Ciudad is
   subtype aleatorioConsumo is Integer range -3 .. 3; --Esto es para generar el generador aleatorio que aumenta la produccion
   package AleatorioCon is new Ada.Numerics.Discrete_Random(aleatorioConsumo);

   protected type ConsumoCiudad is
      procedure leer (temp : out Integer);
      procedure abrirDispositivo;
      procedure Timer(event : in out Ada.Real_Time.Timing_Events.Timing_Event);
   private
      seed     : AleatorioCon.Generator;
      tempCon     : aleatorioConsumo;
      consumo         : Integer := 35; --consumo inicial de la ciudad
      jitterControl : Ada.Real_Time.Timing_Events.Timing_Event;
      periodoConsumo       : Ada.Real_Time.Time_Span := Ada.Real_Time.Seconds(6); -- Cada 6 segundos aumenta/disminuye en un rango entre -3 y 3 Mw la produccion
      nextTime : Ada.Real_Time.Time;
   end ConsumoCiudad;
end Ciudad;
