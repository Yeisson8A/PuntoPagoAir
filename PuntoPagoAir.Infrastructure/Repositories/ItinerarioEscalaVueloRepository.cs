using Microsoft.Extensions.Options;
using PuntoPagoAir.Core.DTOs;
using PuntoPagoAir.Core.Interfaces;
using PuntoPagoAir.Infrastructure.Data;
using System.Data;
using System.Data.SqlClient;

namespace PuntoPagoAir.Infrastructure.Repositories
{
    public class ItinerarioEscalaVueloRepository : IItinerarioEscalaVueloRepository
    {
        // Inyectar depedencia con cadena de conexión a la base de datos
        private readonly ConfiguracionConexion _conexion;

        public ItinerarioEscalaVueloRepository(IOptions<ConfiguracionConexion> conexion)
        {
            _conexion = conexion.Value;
        }

        // Método para obtener detalle escalas para un itinerario de vuelo especifico
        public async Task<List<ItinerarioEscalaVueloDto>> ObtenerItinerarioEscalasPorIdVuelo(int idVuelo)
        {
            List<ItinerarioEscalaVueloDto> _itinerario = new List<ItinerarioEscalaVueloDto>();

            using (var conexion = new SqlConnection(_conexion.CadenaSQL))
            {
                // Abrir conexión a la base de datos
                conexion.Open();
                // Indicar consulta a ejecutar
                SqlCommand cmd = new SqlCommand("SP_ObtenerItinerarioEscalasPorIdVuelo", conexion);
                // Asignar parámetros del procedimiento
                cmd.Parameters.AddWithValue("IdVuelo", idVuelo);
                // Indicar el tipo de consulta como procedimiento almacenado
                cmd.CommandType = CommandType.StoredProcedure;

                // Ejecutar consulta
                using (var dr = await cmd.ExecuteReaderAsync())
                {
                    // Leer resultados
                    while (await dr.ReadAsync())
                    {
                        _itinerario.Add(new ItinerarioEscalaVueloDto
                        {
                            IdEscala = Convert.ToInt32(dr["IdEscala"]),
                            AeropuertoOrigen = dr["AeropuertoOrigen"].ToString(),
                            AeropuertoDestino = dr["AeropuertoDestino"].ToString(),
                            FechaSalida = Convert.ToDateTime(dr["FechaSalida"]),
                            FechaLlegada = Convert.ToDateTime(dr["FechaLlegada"]),
                            Horas = Convert.ToInt32(dr["Horas"]),
                            Minutos = Convert.ToInt32(dr["Minutos"])
                        });
                    }
                }
            }
            return _itinerario;
        }
    }
}
