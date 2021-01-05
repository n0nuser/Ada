with System;
with Ada.Real_Time;               use Ada.Real_Time;
with Ada.Real_Time.Timing_Events; use Ada.Real_Time;
with Text_IO;
with Planta;                      use Planta;

package SensorLectorP is
   type SensorDato is new Integer;
   protected type SensorLectorCiu is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);
      entry leer (g : access Generador; result : out Integer);
      procedure Timer(event : in out Ada.Real_Time.Timing_Events.Timing_Event);
   private
      nextTime             : Ada.Real_Time.Time;
      datoDisponible       : Boolean := True;
      entradaJitterControl : Ada.Real_Time.Timing_Events.Timing_Event;
      --400ms -20ms del input jitter
      entradaPeriodo : Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(150); --Simula el tiempo que tarda en leer la produccion
   end SensorLectorCiu;
end SensorLectorP;
