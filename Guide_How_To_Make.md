# Guía: Creación de Microservicios de Cero a Cien

Esta guía detalla los pasos seguidos para construir la infraestructura de microservicios para este examen.

## 1. Planificación de la Arquitectura
El sistema consta de:
- **Service Discovery**: Eureka Server para el registro de servicios.
- **API Gateway**: Punto de entrada único.
- **Microservicios de Negocio**: Productos, Órdenes y Pagos (cada uno con su propia DB en MongoDB).
- **Logs Centralizados**: Envío de logs a CloudWatch vía LocalStack.

## 2. Creación de Eureka Server
1. Generar proyecto en [Spring Initializr](https://start.spring.io/):
   - Dependencias: `Eureka Server`.
2. Habilitar el servidor en la clase principal con `@EnableEurekaServer`.
3. Configurar `application.yml` para que no se registre a sí mismo:
   ```yaml
   eureka:
     client:
       register-with-eureka: false
       fetch-registry: false
   ```

## 3. Creación del API Gateway
1. Generar proyecto con dependencias: `Gateway`, `Eureka Discovery Client`.
2. Configurar rutas en `application.yml`:
   ```yaml
   spring:
     cloud:
       gateway:
         routes:
           - id: product-service
             uri: lb://PRODUCT-SERVICE
             predicates:
               - Path=/productos/**
   ```

## 4. Desarrollo de los Microservicios (Productos, Órdenes, Pagos)
Para cada microservicio:
1. Generar proyecto con: `Spring Web`, `Spring Data MongoDB`, `Eureka Discovery Client`, `Lombok`, `Actuator`.
2. **Modelo**: Crear clases `@Document` para MongoDB.
3. **Repositorio**: Interfaz que extiende de `MongoRepository`.
4. **Controlador**: Implementar los endpoints CRUD y de negocio (procesar pago, reembolsar, etc.).
5. **Logs**: Configurar `logback-spring.xml` para usar `AwsLogsAppender`.

### Solución al Problema de Logs (LocalStack)
El error común es usar la propiedad `<endpoint>`, pero la librería `logback-awslogs-appender` requiere específicamente la propiedad **`<cloudWatchEndpoint>`** para redirigir el tráfico a LocalStack (`http://localstack:4566`).

## 5. Dockerización
1. Crear un `Dockerfile` por cada servicio basado en `eclipse-temurin:21-jre-jammy`.
2. Crear el `docker-compose.yml` integrando:
   - Contenedores de aplicaciones.
   - Contenedor de `mongo:latest`.
   - Contenedor de `localstack/localstack:latest` con servicios `logs,cloudwatch`.

## 6. Pruebas y Validación
1. Levantar todo con `docker-compose up -d --build`.
2. Verificar en Eureka Dashboard (`localhost:8761`) que todos los servicios estén `UP`.
3. Probar el flujo completo con Postman:
   - Crear producto -> Crear orden -> Procesar pago.
4. Validar logs en LocalStack:
   - Usar el endpoint de describeLogGroups para confirmar que los grupos como `producto-log-group` se crearon automáticamente.

## 7. Mantenimiento
- Para actualizar cambios: `./mvnw clean package` seguido de `docker-compose up -d --build`.
