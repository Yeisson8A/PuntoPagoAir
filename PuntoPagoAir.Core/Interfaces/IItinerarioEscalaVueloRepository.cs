using PuntoPagoAir.Core.DTOs;

namespace PuntoPagoAir.Core.Interfaces
{
    public interface IItinerarioEscalaVueloRepository
    {
        // Método para obtener detalle escalas para un itinerario de vuelo especifico
        Task<List<ItinerarioEscalaVueloDto>> ObtenerItinerarioEscalasPorIdVuelo(int idVuelo);
    }
}
