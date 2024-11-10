# Instrucciones:

# Base de datos:
- Se debe tener instalado el motor de base de datos SQL Server, adicionalmente para la ejecución del script se puede instalar la herramienta "Microsoft SQL Server Management Studio".
- Se debe ejecutar el script "Script Prueba Técnica Punto Pago.sql" en el servidor respectivo para crear la base de datos, las tablas "Aeropuerto", "Vuelo" y "EscalaVuelo", y sus respectivos procedimientos.

# Nota:
Este script igualmente contiene datos de prueba en las tablas "Aeropuerto", "Vuelo" y "EscalaVuelo".

# Proyecto
- Se debe tener instalada la versión .NET 8.0 para la ejecución de la solución.
- Se debe cambiar el nombre del servidor a utilizar en el archivo "appsettings.json", en la clave "ConfiguracionConexion" y "CadenaSQL", en el apartado "Data Source". En caso de utilizar un servidor con conexión de usuario y clave sql se debe realizar el respectivo cambio y especificar estos datos en la cadena de conexión.
- Se debe establecer como proyecto de inicio "PuntoPagoAir.Api", seleccionando el proyecto, clic derecho y seleccionar "Establecer como proyecto de inicio"
