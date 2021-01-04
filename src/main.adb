with Text_IO;
with Ada.Real_Time;
with Ada.Real_Time.Timing_Events;
with System;
with SensorLectorP;     use SensorLectorP;
with ActuadorEscritorP; use ActuadorEscritorP;
with Ada.Numerics.Discrete_Random;
with Planta;            use Planta;
with Ciudad;            use Ciudad;
with Ada.Calendar;      use Ada.Calendar;

procedure Main is
   type Generadores is array(1 .. 3) of aliased Generador; -- Array con objecto generador(esta en Planta). Contiene la produccion

   subtype aleatorioGenerador is Integer range 1 .. 3; --Esto es para generar el generador aleatorio que aumenta la produccion
   package AleatorioGen is new Ada.Numerics.Discrete_Random(aleatorioGenerador);
   
   subtype aleatorioValor is Integer range -3 .. 3; --Esto es para generar el generador aleatorio que aumenta la produccion
   package AleatorioVal is new Ada.Numerics.Discrete_Random (aleatorioValor);

   --Tarea aumento produccion
   task type produccion (c : access Generadores);
   task body produccion is
      intervalo : Duration := 2.0; --El tiempo en el que debe subir la produccion de un generador aleatorio
      nextTime : Time;
      seed     : Aleatorio.Generator;
      temp     : aleatorioGenerador;
   begin
      Aleatorio.Reset (seed);
      nextTime := Clock + intervalo;
      loop
         -- Subir produccion aleatoriamente
         temp := AleatorioGen.Random(seed); --Genera aleatoriamente un numero del 1 al 3 que representa a un generador
         temp2 := AleatorioVal.Random(seed); --Genera aleatoriamente un numero del -3 al 3 que representa el valor de incremento de carga electrica
         c (temp).incrementar(temp2); --Llama a la funcion incrementar del correspondiente generador, y le incrementa 150 grados
         Text_IO.Put_Line("Incrementando produccion de " & temp'Img & " en " & temp2'Img);
         delay until nextTime; --Espera esos dos segundos. Como esto es un bucle infinito, volvera a ejecturarse lo de antes
         nextTime := Clock + intervalo;
      end loop;
   end produccion;

   --Tarea coordinadora. Los generadores le avisaran
   task type tareaCoordinadora is
      entry avisarme;
   end tareaCoordinadora;
   task body tareaCoordinadora is
   begin
      loop
         select
            accept avisarme do
               begin
                  null; --Si le avisan en menos de 3 segundos no hace nada
               end;
            end avisarme;
         or
            delay 3.0; --Si despues de 3 segundos no le llega el aviso, imprime el mensaje de alarma
            Text_IO.Put_Line ("!!!!Alarma!!!!");
         end select;
      end loop;
   end tareaCoordinadora;

   --Tarea de los generadores. Cada generador ejecutara estas tareas
   task type tareaGenerador (c : access Generador; id : Integer)
   is --Parametros: Puntero al generador y el id del generador(1,2,3)

      private
   end tareaGenerador;
   task body tareaGenerador is
      sen : aliased SensorLector; --Punteros a sensorLector y actuadorEscritor para usar sus funciones
      act       : aliased ActuadorEscritor;
      co        : tareaCoordinadora; --La tarea coordinadora declarada antes
      intervalo : Duration := 2.0; -- Estos dos segundos son los que tarda en volver a muestrear la produccion del generador
      nextTimer       : Time;
      inicioIntervalo : Duration := 0.5; --Tiempo que tarda en empezar el bucle para muestrear.
      inicio     : Time;
      produccion : Integer;
   begin
      inicio := inicioIntervalo + Clock;
      delay until inicio;
      nextTimer := intervalo + Clock;
      loop
         sen.leer(c, produccion); --Ejecutamos la funcion leer de SensorLector, pasandole el generador. produccion almacenara la produccion leida
         Text_IO.Put_Line("produccion: " & produccion'Img & " Generador: " & id'Img);
         if produccion >= 0
         then --Si es igual o superior que 0 abrimos las compuertas
            act.abrir (c, id); --Llama a la funcion abrir del actuadorEscritor
            if produccion > 30
            then --Si es mayor que 30 imprimimos mensaje de alarmaa
               Text_IO.Put_Line("¡¡¡Alarma produccion!!! " & produccion'Img & " Generador: " & id'Img);
            end if;
         elsif produccion < 0
         then --Si es inferior a 0 cerramos la compuerta si se ha abierto antes
            act.cerrar(c, id); --Llama a la funcion cerrar del actuadorEscritor
         end if;
         co.avisarme; --Una vez leimos avisamos a la coordinadora
         delay until nextTimer; --Esperamos los 2 segundos para muestrear de nuevo. Bucle infinito, hara lo de antes siempre cada 2 segundos
         nextTimer := intervalo + Clock;
      end loop;
   end tareaGenerador;

   --Tarea de los generadores. Cada generador ejecutara estas tareas
   task type tareaCiudad (c : access Generador; id : Integer)
   is --Parametros: Puntero al generador y el id del generador(1,2,3)

      private
   end tareaCiudad;
   task body tareaCiudad is
      sen : aliased SensorLector; --Punteros a sensorLector y actuadorEscritor para usar sus funciones
      act       : aliased ActuadorEscritor;
      co        : tareaCoordinadora; --La tarea coordinadora declarada antes
      intervalo : Duration := 2.0; -- Estos dos segundos son los que tarda en volver a muestrear la produccion del generador
      nextTimer       : Time;
      inicioIntervalo : Duration := 0.5; --Tiempo que tarda en empezar el bucle para muestrear.
      inicio     : Time;
      produccion : Integer;
   begin
      inicio := inicioIntervalo + Clock;
      delay until inicio;
      nextTimer := intervalo + Clock;
      loop
         sen.leer(c, produccion); --Ejecutamos la funcion leer de SensorLector, pasandole el generador. produccion almacenara la produccion leida
         Text_IO.Put_Line("produccion: " & produccion'Img & " Ciudad: " & id'Img);
         if produccion >= 0
         then --Si es igual o superior que 0 abrimos las compuertas
            act.abrir (c, id); --Llama a la funcion abrir del actuadorEscritor
            if produccion > 30
            then --Si es mayor que 30 imprimimos mensaje de alarmaa
               Text_IO.Put_Line("¡¡¡Alarma produccion!!! " & produccion'Img & " Ciudad: " & id'Img);
            end if;
         elsif produccion < 0
         then --Si es inferior a 0 cerramos la compuerta si se ha abierto antes
            act.cerrar(c, id); --Llama a la funcion cerrar del actuadorEscritor
         end if;
         co.avisarme; --Una vez leimos avisamos a la coordinadora
         delay until nextTimer; --Esperamos los 2 segundos para muestrear de nuevo. Bucle infinito, hara lo de antes siempre cada 2 segundos
         nextTimer := intervalo + Clock;
      end loop;
   end tareaCiudad;

   procedure inicio is
      rs : aliased Generadores; --Iniciamos el array de generadores
      t  : produccion (rs'Access); --Iniciamos la tarea que sube la produccion
      r1 : tareaGenerador(rs (1)'Access, 1); --Para cada generador iniciamos su correspondiente tarea
      r2 : tareaGenerador (rs (2)'Access, 2);
      r3 : tareaGenerador (rs (3)'Access, 3);
   begin
      null;
   end inicio;

begin
   inicio;
   null;
end Main;
