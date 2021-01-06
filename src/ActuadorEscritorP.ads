with System;
with Ada.Real_Time;
use Ada.Real_Time;
with Ada.Real_Time.Timing_Events;
use Ada.Real_Time;
with Text_IO;
with Planta; use Planta;

package ActuadorEscritorP is
   type ActuadorDato is new Integer;
   protected type ActuadorEscritorGen is
      pragma Interrupt_Priority(System.Interrupt_Priority'Last);
      procedure abrir(g: access Generador; id: Integer);
      procedure cerrar(g: access Generador; id: Integer);
      procedure Timer(event: in out Ada.Real_Time.Timing_Events.Timing_Event);
   private
      nextTime:Ada.Real_Time.Time;
      cerrado: Boolean := true; --Esta variable indicara si la puerta del generador esta cerrada
      escribiendo:ActuadorDato;
      salidaJitterControl:Ada.Real_Time.Timing_Events.Timing_Event;
      salidaPeriodo:Ada.Real_Time.Time_Span:=Ada.Real_Time.Milliseconds(600); --Simula el tiempo que tarda en actuar el Actuador

   end ActuadorEscritorGen;
end ActuadorEscritorP;

