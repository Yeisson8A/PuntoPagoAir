using PuntoPagoAir.Core.DTOs;

namespace PuntoPagoAir.Core.Interfaces
{
    public interface IItinerarioVueloRepository
    {
        // Método para obtener itinerario de vuelos de acuerdo a aeropuertos de origen y destino, fecha de viaje
        Task<List<ItinerarioVueloDto>> ObtenerItinerariosVuelos(string codAeropuertoOrigen, string codAeropuertoDestino, DateTime fechaViaje);

        // Método para obtener todos los itinerario de vuelos
        Task<List<ItinerarioVueloDto>> ObtenerTodosItinerariosVuelos();
    }
}
