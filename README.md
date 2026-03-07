# Mejia Examen - Arquitectura de Microservicios

Este proyecto es una implementación de una arquitectura de microservicios robusta y escalable utilizando Spring Boot, diseñada para gestionar un flujo completo de productos, órdenes y pagos.

## Infraestructura y Tecnologías
- **Java 21**: Lenguaje de programación principal.
- **Spring Boot 3.2.5**: Framework para el desarrollo de los microservicios.
- **Spring Cloud Netflix Eureka**: Registro y descubrimiento de servicios.
- **Spring Cloud Gateway**: API Gateway para el enrutamiento centralizado.
- **MongoDB**: Base de datos NoSQL para persistencia de datos (Productos, Órdenes, Pagos).
- **LocalStack (AWS CloudWatch)**: Simulación de servicios de AWS para el almacenamiento y visualización de logs centralizados.
- **Docker & Docker Compose**: Orquestación de contenedores para el despliegue local.

## Puertos de los Servicios
| Servicio | Puerto | Descripción |
| :--- | :--- | :--- |
| **Eureka Server** | 8761 | Dashboard de descubrimiento de servicios. |
| **API Gateway** | 8080 | Punto de entrada único para todos los microservicios. |
| **Product Service** | 8081 | Gestión del catálogo de productos. |
| **Order Service** | 8082 | Gestión de órdenes de compra. |
| **Payment Service** | 8083 | Procesamiento de pagos y reembolsos. |
| **MongoDB** | 27017 | Base de datos principal. |
| **LocalStack** | 4566 | CloudWatch Logs (Mock). |

## Cómo Iniciar el Proyecto
1. Asegúrate de tener instalado **Docker Desktop**.
2. Compila los microservicios (opcional, docker-compose lo hace):
   ```powershell
   ./mvnw clean package -DskipTests
   ```
3. Levanta la infraestructura completa:
   ```powershell
   docker-compose up -d --build
   ```
4. Importa el archivo `Postman_Collection.json` en Postman para probar los endpoints.

## Logs Centralizados
Cada microservicio envía sus logs a **CloudWatch (LocalStack)**. Puedes consultarlos vía Postman o mediante la CLI de AWS apuntando al endpoint de LocalStack:
```powershell
aws --endpoint-url=http://localhost:4566 logs describe-log-groups
```
