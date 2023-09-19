# Manual de Usuario del Proyecto Q-Learning con MindStorm EV3

![Robot](Result/robot.png)

Este repositorio contiene un proyecto que utiliza el algoritmo de DQN con buffer experience replay para entrenar y controlar un robot utilizando el Kit MindStorm EV3 de Lego, con el fin de que aprenda a desplazarse hacia delante. El proyecto también hace uso de la Toolbox MindstormsEV3 para interactuar con el hardware. Este manual de usuario proporciona instrucciones detalladas sobre cómo configurar, entrenar y probar el robot con este proyecto.

## Requisitos Previos

Para el correcto funcionamiento es ncesario los siguientes requisitos previos configurados en tu sistema:

- Kit MindStorm EV3 de Lego.
- MATLAB instalado en tu computadora.
- Toolbox MindstormsEV3, se puede obtener desde el link: https://github.com/Markay12/mindstormsEV3/tree/master

## Construcción de robot

Los detalles para construir el robot para este proyecto esta disponible dentro [construction](./Construction/robotproximationdistance.pdf), además se incluye un archivo de diseño realizado en la plataforma EV3 Classroom App de Lego®.

## Información de Sensores

Puerto Sensor 1: Sensor Ultrasónico
Puerto Sensor 2: Sensor Táctil
Puerto Sensor 3: N/A
Puerto Sensor 4: N/A
Motores conectados en los puertos A y B

## Estado inicial

Para poder empezar el entrenamiento y testo es necesario establecer un estado 0 en ambos motores, para nuestro caso como se puede ver a continuación.
![stateInitial](Result/stateInitial.png)

## Entrenamiento

Sigue estos pasos para configurar el proyecto en tu entorno:
1. Encender el Kit MindStorm EV3.
2. Establecer comunicación entre el Kit MindStorm EV3 de Lego y el software Matlab, en este caso se hizo uso de conexión USB .
3. Para empezar el entrenamiento es necesario correr el archivo QNN_train.m.
   1. options = configurar los hiperparámetros que el usuario vea conveniente: número de neuronas por capas, funciones de transferencia, número de épocas, número de épocas para actualizar el momentum, gamma, epsilon, thao, tamaño máximo de buffer, número de batches, número de actualizaciones por batch, 
   2. agent = son parámetros relacionados a los motores: limites, velocidad y ángulos 
   3. trainQNN.m = archivo ubicado dentro de la carpeta QNN Toolbox, se utiliza para entrenar una red neuronal para controlar un robot en un entorno. En cada época de entrenamiento, el agente interactúa con el entorno, actualiza una memoria de experiencia, y utiliza esta experiencia para actualizar los pesos de la red neuronal. El proceso se repite durante múltiples épocas, con la disminución gradual de la exploración (epsilon) y la visualización de métricas de entrenamiento. La función devuelve los pesos entrenados de la red neuronal al final del entrenamiento, lo que permite al agente tomar decisiones más informadas en el entorno.

### Simulación

Para ejecutar una simulación de entrenamiento y testeo, se hace uso de los archivos dentro de la carpeta Simulator Toolbox QNN_train_s y QNN_test_s respectivamente.

## Testeo

Para probar el robot entrenado, sigue estos pasos:
1. Ejecutar el script de testo QNN_test.m
   1. net = variable usada para realizar la carga del modelo entrenado.
   2. testQNN_robot.m = archivo ubicado dentro de la carpeta QNN Toolbox, se utiliza para llevar a cabo la fase de prueba, donde el agente utiliza la red neuronal entrenada para tomar decisiones en un entorno específico (en este caso, un robot). La función comienza con la configuración inicial del agente y el entorno, y luego entra en un bucle en el que el agente toma decisiones basadas en los valores Q calculados por la red neuronal. El agente interactúa con el entorno, selecciona acciones y registra las transiciones de estado hasta que se cumplan ciertas condiciones de finalización, como alcanzar un estado terminal o un número máximo de pasos. Durante el proceso, se imprime información relevante, como los estados actuales y nuevos y la distancia recorrida.