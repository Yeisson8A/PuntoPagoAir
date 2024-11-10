using Microsoft.Extensions.Options;
using PuntoPagoAir.Core.DTOs;
using PuntoPagoAir.Core.Interfaces;
using PuntoPagoAir.Infrastructure.Data;
using System.Data;
using System.Data.SqlClient;

namespace PuntoPagoAir.Infrastructure.Repositories
{
    public class ItinerarioVueloRepository : IItinerarioVueloRepository
    {
        // Inyectar depedencia con cadena de conexión a la base de datos
        private readonly ConfiguracionConexion _conexion;

        public ItinerarioVueloRepository(IOptions<ConfiguracionConexion> conexion)
        {
            _conexion = conexion.Value;
        }

        // Método para obtener itinerario de vuelos de acuerdo a aeropuertos de origen y destino, fecha de viaje
        public async Task<List<ItinerarioVueloDto>> ObtenerItinerariosVuelos(string codAeropuertoOrigen, string codAeropuertoDestino, DateTime fechaViaje)
        {
            List<ItinerarioVueloDto> _itinerario = new List<ItinerarioVueloDto>();

            using (var conexion = new SqlConnection(_conexion.CadenaSQL))
            {
                // Abrir conexión a la base de datos
                conexion.Open();
                // Indicar consulta a ejecutar
                SqlCommand cmd = new SqlCommand("SP_ObtenerItinerariosVuelos", conexion);
                // Asignar parámetros del procedimiento
                cmd.Parameters.AddWithValue("CodAeropuertoOrigen", codAeropuertoOrigen);
                cmd.Parameters.AddWithValue("CodAeropuertoDestino", codAeropuertoDestino);
                cmd.Parameters.AddWithValue("FechaViaje", fechaViaje);
                // Indicar el tipo de consulta como procedimiento almacenado
                cmd.CommandType = CommandType.StoredProcedure;

                // Ejecutar consulta
                using (var dr = await cmd.ExecuteReaderAsync())
                {
                    // Leer resultados
                    while (await dr.ReadAsync())
                    {
                        _itinerario.Add(new ItinerarioVueloDto
                        {
                            IdVuelo = Convert.ToInt32(dr["IdVuelo"]),
                            AeropuertoOrigen = dr["AeropuertoOrigen"].ToString(),
                            AeropuertoDestino = dr["AeropuertoDestino"].ToString(),
                            FechaSalida = Convert.ToDateTime(dr["FechaSalida"]),
                            FechaLlegada = Convert.ToDateTime(dr["FechaLlegada"]),
                            Horas = Convert.ToInt32(dr["Horas"]),
                            Minutos = Convert.ToInt32(dr["Minutos"]),
                            TieneEscala = Convert.ToInt32(dr["TieneEscala"])
                        });
                    }
                }
            }
            return _itinerario;
        }

        // Método para obtener todos los itinerario de vuelos
        public async Task<List<ItinerarioVueloDto>> ObtenerTodosItinerariosVuelos()
        {
            List<ItinerarioVueloDto> _itinerario = new List<ItinerarioVueloDto>();

            using (var conexion = new SqlConnection(_conexion.CadenaSQL))
            {
                // Abrir conexión a la base de datos
                conexion.Open();
                // Indicar consulta a ejecutar
                SqlCommand cmd = new SqlCommand("SP_ObtenerTodosItinerariosVuelos", conexion);
                // Indicar el tipo de consulta como procedimiento almacenado
                cmd.CommandType = CommandType.StoredProcedure;

                // Ejecutar consulta
                using (var dr = await cmd.ExecuteReaderAsync())
                {
                    // Leer resultados
                    while (await dr.ReadAsync())
                    {
                        _itinerario.Add(new ItinerarioVueloDto
                        {
                            IdVuelo = Convert.ToInt32(dr["IdVuelo"]),
                            AeropuertoOrigen = dr["AeropuertoOrigen"].ToString(),
                            AeropuertoDestino = dr["AeropuertoDestino"].ToString(),
                            FechaSalida = Convert.ToDateTime(dr["FechaSalida"]),
                            FechaLlegada = Convert.ToDateTime(dr["FechaLlegada"]),
                            Horas = Convert.ToInt32(dr["Horas"]),
                            Minutos = Convert.ToInt32(dr["Minutos"]),
                            TieneEscala = Convert.ToInt32(dr["TieneEscala"])
                        });
                    }
                }
            }
            return _itinerario;
        }
    }
}
