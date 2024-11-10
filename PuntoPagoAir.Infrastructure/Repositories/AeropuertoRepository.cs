using Microsoft.Extensions.Options;
using PuntoPagoAir.Core.Entities;
using PuntoPagoAir.Core.Interfaces;
using PuntoPagoAir.Infrastructure.Data;
using System.Data;
using System.Data.SqlClient;

namespace PuntoPagoAir.Infrastructure.Repositories
{
    public class AeropuertoRepository : IAeropuertoRepository
    {
        // Inyectar depedencia con cadena de conexión a la base de datos
        private readonly ConfiguracionConexion _conexion;

        public AeropuertoRepository(IOptions<ConfiguracionConexion> conexion)
        {
            _conexion = conexion.Value;
        }

        // Método para obtener listado de aeropuertos disponibles
        public async Task<List<Aeropuerto>> GetAeropuertos()
        {
            List<Aeropuerto> _aeropuertos = new List<Aeropuerto>();

            using (var conexion = new SqlConnection(_conexion.CadenaSQL))
            {
                // Abrir conexión a la base de datos
                conexion.Open();
                // Indicar consulta a ejecutar
                SqlCommand cmd = new SqlCommand("SP_ObtenerAeropuertos", conexion);
                // Indicar el tipo de consulta como procedimiento almacenado
                cmd.CommandType = CommandType.StoredProcedure;

                // Ejecutar consulta
                using (var dr = await cmd.ExecuteReaderAsync())
                {
                    // Leer resultados
                    while (await dr.ReadAsync())
                    {
                        _aeropuertos.Add(new Aeropuerto
                        {
                            CodigoAeropuerto = dr["CodigoAeropuerto"].ToString(),
                            NombreAeropuerto = dr["NombreAeropuerto"].ToString()
                        });
                    }
                }
            }
            return _aeropuertos;
        }
    }
}
