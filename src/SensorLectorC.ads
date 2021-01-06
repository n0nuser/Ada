with System;
with Ada.Real_Time;               use Ada.Real_Time;
with Ada.Real_Time.Timing_Events; use Ada.Real_Time;
with Text_IO;
with Ciudad; use Ciudad;

package SensorLectorC is
   type SensorDato is new Integer;
   protected type SensorLectorCiu is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);
      entry leer (c : access ConsumoCiudad; result : out Integer);
      procedure Timer(event : in out Ada.Real_Time.Timing_Events.Timing_Event);
   private
      nextTime             : Ada.Real_Time.Time;
      datoDisponible       : Boolean := True;
      entradaJitterControl : Ada.Real_Time.Timing_Events.Timing_Event;
      entradaPeriodo : Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(0); --Simula el tiempo que tarda en actuar el Actuador, como Ciudad no tiene retraso pues 0.
   end SensorLectorCiu;
end SensorLectorC;
