with Text_IO;
with Ada.Text_IO;
with Ada.Real_Time;
with Ada.Real_Time.Timing_Events;
with System;
with SensorLectorP;     use SensorLectorP;
with ActuadorEscritorP; use ActuadorEscritorP;
with Planta;            use Planta;
with Ciudad;            use Ciudad;
with Ada.Calendar;      use Ada.Calendar;
with Ada.Calendar.Formatting;
with Ada.Real_Time; use Ada.Real_Time;

procedure Main is
   Produccion1 : Integer := 15;
   Produccion2 : Integer := 15;
   Produccion3 : Integer := 15;
   ConsumoGlobal : Integer := 35;

   type Generadores is array(1 .. 3) of aliased Generador; -- Array con objecto generador(esta en Planta). Contiene la produccion

   procedure PrintRT is
      The_Clock : Ada.Real_Time.Time := Ada.Real_Time.Clock;

      -- Convert to Time_Span
      As_Time_Span : Ada.Real_Time.Time_Span := The_Clock - Time_Of(0, Time_Span_Zero);

      -- Epoch ?
      Epoch : constant Ada.Calendar.Time := Ada.Calendar.Time_Of(1970, 01, 01);

      Dur : Duration := Ada.Real_Time.To_Duration(As_Time_Span);
   begin
      Ada.Text_IO.Put_Line(Ada.Calendar.Formatting.Image(Ada.Calendar."+"(Epoch, Dur)));
   end PrintRT;


   task type tareaGenerador (g : access Generador; id : Integer)
   is
      entry avisarme;
   end tareaGenerador;
   task body tareaGenerador is
      act : aliased ActuadorEscritorGen;
   begin
      act.mantenerEstable(g, id);
      loop
         select
            accept avisarme do
               begin
                  --Text_IO.Put_Line("ME HA LLEGADO EL AVISARME GENERADOR " & id'Img);
                  --act.mantenerEstable(g, id);
                  null;
               end;
            end avisarme;
         or
            delay 5.0;
            Text_IO.Put_Line("ALERTA MONITORIZACION ENERGIA GENERADOR " & id'Img);
         end select;
      end loop;
   end tareaGenerador;

   --Tarea coordinadora. Los generadores le avisaran
   task type tareaCoordinadora (g : access Generadores; c : access ConsumoCiudad)
   is
      private
   end tareaCoordinadora;
   task body tareaCoordinadora is
      delayInicio : Duration := 0.3; -- Esperamos 0.3 segundos antes de empezar la tarea coordinadora
      delayNormal : Duration := 1.0; -- Esperamos 0.3 segundos antes de empezar la tarea coordinadora
      act : aliased ActuadorEscritorGen;
      sen : aliased SensorLectorGen; --Punteros a sensorLector y actuadorEscritor para usar sus funciones
      diferencia : Integer;
      porcentajeProduccion : Float;
      porcentajeConsumo : Float;
      porcentajeDiferencia : Float;
      ProduccionGlobal : Integer := 0;
      timer : Ada.Calendar.Time;
      aviso1 : tareaGenerador(g(1)'Access, 1);
      aviso2 : tareaGenerador(g(2)'Access, 2);
      aviso3 : tareaGenerador(g(3)'Access, 3);
   begin
      delay until (delayInicio + Clock);
      timer := delayNormal + Clock;
      loop
         -- CONSULTA
         sen.leer(g(1)'Access, Produccion1);
         aviso1.avisarme;
         sen.leer(g(2)'Access, Produccion2);
         aviso2.avisarme;
         sen.leer(g(3)'Access, Produccion3);
         aviso3.avisarme;

         c.leer(consumoGlobal);

         ProduccionGlobal := Produccion1 + Produccion2 + Produccion3;
         diferencia := ProduccionGlobal - consumoGlobal;
         porcentajeProduccion := (100.0 * Float(ProduccionGlobal)) / 90.0;
         porcentajeConsumo := (100.0 * Float(ConsumoGlobal)) / 90.0;
         porcentajeDiferencia := porcentajeProduccion - porcentajeConsumo;

         -- GESTION AUMENTO, DECREMENTO, ESTABILIZACION
         Text_IO.Put_Line("");
         if porcentajeDiferencia > 5.0 then
            PrintRT;
            Text_IO.Put_Line("PELIGRO SOBRECARGA consumo:" & ConsumoGlobal'Img & " produccion:" & ProduccionGlobal'Img);
         elsif porcentajeDiferencia < -5.0 then
            PrintRT;
            Text_IO.Put_Line("PELIGRO BAJADA consumo:" & ConsumoGlobal'Img & " produccion:" & ProduccionGlobal'Img);
         else
            PrintRT;
            Text_IO.Put_Line("Estable consumo:" & ConsumoGlobal'Img & " produccion:" & ProduccionGlobal'Img);
         end if;
         Text_IO.Put_Line("");

         if diferencia >= 3 then
            PrintRT;
            Text_IO.Put_Line("### DIFERENCIA MAYOR QUE 3 # Diferencia: " & diferencia'Img);
            act.decrementar(g(1)'Access, 1);
            aviso1.avisarme;
            act.decrementar(g(2)'Access, 2);
            aviso2.avisarme;
            act.decrementar(g(3)'Access, 3);
            aviso3.avisarme;
         elsif diferencia >= 2 then
            PrintRT;
            Text_IO.Put_Line("### DIFERENCIA MAYOR QUE 2 # Diferencia: " & diferencia'Img);
            act.decrementar(g(1)'Access, 1);
            aviso1.avisarme;
            act.decrementar(g(2)'Access, 2);
            aviso2.avisarme;
         elsif diferencia >= 1 then
            PrintRT;
            Text_IO.Put_Line("### DIFERENCIA MAYOR QUE 1 # Diferencia: " & diferencia'Img);
            act.decrementar(g(1)'Access, 1);
            aviso1.avisarme;
         elsif diferencia <= -3 then
            PrintRT;
            Text_IO.Put_Line("### DIFERENCIA MENOR QUE -3 # Diferencia: " & diferencia'Img);
            act.incrementar(g(1)'Access, 1);
            aviso1.avisarme;
            act.incrementar(g(2)'Access, 2);
            aviso2.avisarme;
            act.incrementar(g(3)'Access, 3);
            aviso3.avisarme;
         elsif diferencia <= -2 then
            PrintRT;
            Text_IO.Put_Line("### DIFERENCIA MENOR QUE -2 # Diferencia: " & diferencia'Img);
            act.incrementar(g(1)'Access, 1);
            aviso1.avisarme;
            act.incrementar(g(2)'Access, 2);
            aviso2.avisarme;
         elsif diferencia <= -1 then
            PrintRT;
            Text_IO.Put_Line("### DIFERENCIA MENOR QUE -1 # Diferencia: " & diferencia'Img);
            act.incrementar(g(1)'Access, 1);
            aviso1.avisarme;
         else
            act.mantenerEstable(g(1)'Access, 1);
            aviso1.avisarme;
            act.mantenerEstable(g(2)'Access, 2);
            aviso2.avisarme;
            act.mantenerEstable(g(3)'Access, 3);
            aviso3.avisarme;
         end if;
         delay until (timer);
         timer := delayNormal + Clock;
      end loop;
   end tareaCoordinadora;

   --Tarea de la ciudad. Incrementa a razon de 6 segundos un consumo entre -3 y 3 en el actuador
   task type tareaCiudad (c : access ConsumoCiudad)
   is
      private
   end tareaCiudad;
   task body tareaCiudad is
   begin
      c.abrirDispositivo;
      if ConsumoGlobal < 15 or ConsumoGlobal > 90 then
         c.cerrarDispositivo;
      end if;
   end tareaCiudad;

   procedure inicio is
      gs : aliased Generadores; --Iniciamos el array de generadores
      ciu : aliased ConsumoCiudad;
      mon : tareaCoordinadora(gs'Access, ciu'Access);
      g1 : tareaGenerador(gs(1)'Access, 1); --Para cada generador iniciamos su correspondiente tarea
      g2 : tareaGenerador(gs(2)'Access, 2);
      g3 : tareaGenerador(gs(3)'Access, 3);
      c  : tareaCiudad(ciu'Access); --Iniciamos la tarea que sube la produccion
   begin
      null;
   end inicio;

begin
   inicio;
   null;
end Main;
