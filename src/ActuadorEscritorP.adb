package body ActuadorEscritorP is
   protected body ActuadorEscritorGen is
      procedure abrir(g: access Generador;  id: Integer) is
      begin
         if cerrado = true then --Si es llamado cuando la compuerta esta abierta no hace nada
            Text_IO.Put_Line("Abriendo compuerta del generador: " & id'Img);
            nextTime := Clock + salidaPeriodo;
            Ada.Real_Time.Timing_Events.Set_Handler(salidaJitterControl, nextTime, Timer'Access); --Llama a timer para simular el tiempo que tarda en actuar (decima segundo)
            g.abrirDispositivo; --Llama a la funcion abrir del generador que le hemos pasado como parametro
            Text_IO.Put_Line("Abierta compuerta del generador " & id'Img);
            cerrado := false; --Indica que se ha abierto la compuerta
         end if;
      end abrir;

      procedure cerrar(g: access Generador; id: Integer)  is
      begin
         if cerrado = false then --Si es llamado cuando la compuerta esta cerrada no hace nada
            Text_IO.Put_Line("Cerrando compuerta generador: " & id'Img);
            nextTime := Clock + salidaPeriodo;
            Ada.Real_Time.Timing_Events.Set_Handler(salidaJitterControl, nextTime, Timer'Access); --Simula el tiempo que tarda el actuador en actuar
            g.cerrarDispositivo; --Llama a la funcion cerrar del generador que le hemos pasado como parametro
            Text_IO.Put_Line("Compuerta cerrada del generador: " & id'Img);
            cerrado := true; --Indica que se ha cerrado
         end if;
      end cerrar;

      procedure Timer(event:in out Ada.Real_Time.Timing_Events.Timing_Event) is
      begin
         --escribir dato escribiendo
         nextTime := nextTime+salidaPeriodo;
         Ada.Real_Time.Timing_Events.Set_Handler(salidaJitterControl, nextTime, Timer'Access);
      end Timer;
   end ActuadorEscritorGen;

end ActuadorEscritorP;

