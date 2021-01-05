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
   Produccion1 : Integer := 0;
   Produccion2 : Integer := 0;
   Produccion3 : Integer := 0;
   ProduccionGlobal : Integer := 0;
   ConsumoGlobal : Integer := 0;

   type Generadores is array(1 .. 3) of aliased Generador; -- Array con objecto generador(esta en Planta). Contiene la produccion

   subtype aleatorioGenerador is Integer range 1 .. 3; --Esto es para generar el generador aleatorio que aumenta la produccion
   package AleatorioGen is new Ada.Numerics.Discrete_Random(aleatorioGenerador);

   subtype aleatorioProduccion is Integer range 1 .. 2;
   package AleatorioProd is new Ada.Numerics.Discrete_Random(aleatorioProduccion);

   subtype aleatorioConsumo is Integer range -3 .. 3; --Esto es para generar el generador aleatorio que aumenta la produccion
   package AleatorioCon is new Ada.Numerics.Discrete_Random(aleatorioConsumo);

   --Tarea aumento produccion
   task type produccion (g : access Generadores);
   task body produccion is
      intervalo : Duration := 2.0; --El tiempo en el que debe subir la produccion de un generador aleatorio
      nextTime : Time;
      seedGen     : AleatorioGen.Generator;
      seedProd     : AleatorioProd.Generator;
      tempGen     : aleatorioGenerador;
      tempProd     : aleatorioProduccion;
   begin
      AleatorioGen.Reset(seedGen);
      AleatorioProd.Reset(seedProd);
      nextTime := Clock + intervalo;
      loop
         -- Subir produccion aleatoriamente
         tempGen := AleatorioGen.Random(seedGen); --Genera aleatoriamente un numero del 1 al 3 que representa a un generador
         tempProd := AleatorioProd.Random(seedProd);
         if tempProd = 1 then
            g(tempGen).incrementar(-1); --Llama a la funcion incrementar del correspondiente generador, y le incrementa 150 grados
         elsif tempProd = 2 then
            g(tempGen).incrementar(1);
         end if;
         Text_IO.Put_Line("Incrementando produccion de " & tempGen'Img & " en " & tempProd'Img);
         delay until nextTime; --Espera esos dos segundos. Como esto es un bucle infinito, volvera a ejecturarse lo de antes
         nextTime := Clock + intervalo;
      end loop;
   end produccion;

   --Tarea aumento produccion
   task type consumo (c : access ConsumoCiudad);
   task body consumo is
      intervalo : Duration := 2.0; --El tiempo en el que debe subir la produccion de un generador aleatorio
      nextTime : Time;
      seed     : AleatorioCon.Generator;
      tempGen : aleatorioConsumo;
   begin
      AleatorioCon.Reset(seed);
      nextTime := Clock + intervalo;
      loop
         --Subir produccion aleatoriamente
         tempGen := AleatorioCon.Random(seed); --Genera aleatoriamente un numero del -3 al 3 que representa el valor de incremento de carga electrica
         c.incrementar(tempGen); --Llama a la funcion incrementar del correspondiente generador, y le incrementa 150 grados
         Text_IO.Put_Line("Incrementando consumo de ciudad en " & tempGen'Img);
         delay until nextTime; --Espera esos dos segundos. Como esto es un bucle infinito, volvera a ejecturarse lo de antes
         nextTime := Clock + intervalo;
      end loop;
   end consumo;

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
            Text_IO.Put_Line ("����Alarma!!!!");
         end select;
      end loop;
   end tareaCoordinadora;

   --Tarea de los generadores. Cada generador ejecutara estas tareas
   task type tareaGenerador (g : access Generador; id : Integer)
   is --Parametros: Puntero al generador y el id del generador(1,2,3)

      private
   end tareaGenerador;
   task body tareaGenerador is
      sen : aliased SensorLectorGen; --Punteros a sensorLector y actuadorEscritor para usar sus funciones
      act       : aliased ActuadorEscritorGen;
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
         sen.leer(g, produccion); --Ejecutamos la funcion leer de SensorLectorGen, pasandole el generador. produccion almacenara la produccion leida
         if id = 1 then Produccion1 := produccion; end if;
         if id = 2 then Produccion2 := produccion; end if;
         if id = 3 then Produccion3 := produccion; end if;
         Text_IO.Put_Line("Produccion: " & produccion'Img & " Generador: " & id'Img);
         if produccion >= 0
         then --Si es igual o superior que 0 abrimos las compuertas
            act.abrir (g, id); --Llama a la funcion abrir del actuadorEscritor
            if produccion > 30
            then --Si es mayor que 30 imprimimos mensaje de alarma
               Text_IO.Put_Line("¡¡¡Alarma Sobreproduccion!!! " & produccion'Img & " Generador: " & id'Img);
            end if;
         elsif produccion < 0
         then --Si es inferior a 0 cerramos la compuerta si se ha abierto antes
            act.cerrar(g, id); --Llama a la funcion cerrar del actuadorEscritor
         end if;
         co.avisarme; --Una vez leimos avisamos a la coordinadora
         delay until nextTimer; --Esperamos los 2 segundos para muestrear de nuevo. Bucle infinito, hara lo de antes siempre cada 2 segundos
         nextTimer := intervalo + Clock;
      end loop;
   end tareaGenerador;

   --Tarea de los generadores. Cada generador ejecutara estas tareas
   task type tareaCiudad (c : access ConsumoCiudad; id : Integer)
   is --Parametros: Puntero al generador y el id del generador(1,2,3)

      private
   end tareaCiudad;
   task body tareaCiudad is
      sen : aliased SensorLectorCiu; --Punteros a sensorLector y actuadorEscritor para usar sus funciones
      act       : aliased ActuadorEscritorCiu;
      co        : tareaCoordinadora; --La tarea coordinadora declarada antes
      intervalo : Duration := 2.0; -- Estos dos segundos son los que tarda en volver a muestrear la consumo del generador
      nextTimer       : Time;
      inicioIntervalo : Duration := 0.5; --Tiempo que tarda en empezar el bucle para muestrear.
      inicio     : Time;
      consumo : Integer;
   begin
      inicio := inicioIntervalo + Clock;
      delay until inicio;
      nextTimer := intervalo + Clock;
      loop
         sen.leer(c, consumo); --Ejecutamos la funcion leer de SensorLectorCiu, pasandole el generador. consumo almacenara la consumo leida
         Text_IO.Put_Line("Consumo: " & consumo'Img & " Ciudad: " & id'Img);
         if consumo >= 0
         then --Si es igual o superior que 0 abrimos las compuertas
            act.abrir (c, id); --Llama a la funcion abrir del actuadorEscritor
            if consumo > 90
            then --Si es mayor que 30 imprimimos mensaje de alarmaa
               Text_IO.Put_Line("¡¡¡Alarma Sobreconsumo!!! " & consumo'Img & " Ciudad: " & id'Img);
            end if;
         elsif consumo < 0
         then --Si es inferior a 0 cerramos la compuerta si se ha abierto antes
            act.cerrar(c, id); --Llama a la funcion cerrar del actuadorEscritor
         end if;
         co.avisarme; --Una vez leimos avisamos a la coordinadora
         delay until nextTimer; --Esperamos los 2 segundos para muestrear de nuevo. Bucle infinito, hara lo de antes siempre cada 2 segundos
         nextTimer := intervalo + Clock;
      end loop;
   end tareaCiudad;

   procedure inicio is
      gs : aliased Generadores; --Iniciamos el array de generadores
      ciu : aliased ConsumoCiudad;
      t  : produccion (gs'Access); --Iniciamos la tarea que sube la produccion
      t1  : consumo (ciu'Access); --Iniciamos la tarea que sube la produccion
      g1 : tareaGenerador(gs (1)'Access, 1); --Para cada generador iniciamos su correspondiente tarea
      g2 : tareaGenerador (gs (2)'Access, 2);
      g3 : tareaGenerador (gs (3)'Access, 3);
      c  : tareaCiudad (ciu'Access, 1); --Iniciamos la tarea que sube la produccion
   begin
      null;
   end inicio;

begin
   inicio;
   null;
end Main;
