-- Fichero: ActuadorEscritorP.adb
-- Participantes
-- Sergio Garcia Gonzalez - 70921911P
-- Pablo Jesus Gonzalez Rubio - 70894492M

package body ActuadorEscritorP is
   protected body ActuadorEscritorGen is

      -- El actuador solo llama a las funciones de planta pero metiendole el retardo de 0.6

      procedure incrementar(g: access Generador;  id: Integer) is
      begin
         nextTime := Clock + salidaPeriodo;
         Ada.Real_Time.Timing_Events.Set_Handler(salidaJitterControl, nextTime, Timer'Access); --Le mete un retardo de 0.6 segundos
         --g.cerrarDispositivo; --Si se comenta se activa para siempre el consumo aleatorio cada 3 segundos
         g.incrementar(1);
      end incrementar;

      procedure decrementar(g: access Generador;  id: Integer) is
      begin
         nextTime := Clock + salidaPeriodo;
         Ada.Real_Time.Timing_Events.Set_Handler(salidaJitterControl, nextTime, Timer'Access); --Le mete un retardo de 0.6 segundos

         --g.cerrarDispositivo; --Si se comenta se activa para siempre el consumo aleatorio cada 3 segundos
         g.incrementar(-1);
      end decrementar;

      procedure mantenerEstable(g: access Generador; id: Integer) is
      begin
         nextTime := Clock + salidaPeriodo;
         Ada.Real_Time.Timing_Events.Set_Handler(salidaJitterControl, nextTime, Timer'Access); --Le mete un retardo de 0.6 segundos

         g.abrirDispositivo;
      end mantenerEstable;

      procedure cerrarDispositivo(g: access Generador; id: Integer) is
      begin
         nextTime := Clock + salidaPeriodo;
         Ada.Real_Time.Timing_Events.Set_Handler(salidaJitterControl, nextTime, Timer'Access); --Le mete un retardo de 0.6 segundos

         g.cerrarDispositivo;
      end cerrarDispositivo;

      procedure Timer(event:in out Ada.Real_Time.Timing_Events.Timing_Event) is
      begin
         nextTime := nextTime+salidaPeriodo;
         Ada.Real_Time.Timing_Events.Set_Handler(salidaJitterControl, nextTime, Timer'Access);
      end Timer;
   end ActuadorEscritorGen;

end ActuadorEscritorP;

