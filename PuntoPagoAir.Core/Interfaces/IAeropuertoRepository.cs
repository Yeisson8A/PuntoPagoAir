using PuntoPagoAir.Core.Entities;

namespace PuntoPagoAir.Core.Interfaces
{
    public interface IAeropuertoRepository
    {
        // Método para obtener listado de aeropuertos disponibles
        Task<List<Aeropuerto>> GetAeropuertos();
    }
}
