using Microsoft.AspNetCore.Mvc;
using PuntoPagoAir.Api.Requests;
using PuntoPagoAir.Api.Responses;
using PuntoPagoAir.Core.DTOs;
using PuntoPagoAir.Core.Interfaces;

namespace PuntoPagoAir.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ItinerarioVueloController : ControllerBase
    {
        private readonly IItinerarioVueloRepository _itinerarioVueloRepository;

        public ItinerarioVueloController(IItinerarioVueloRepository itinerarioVueloRepository)
        {
            _itinerarioVueloRepository = itinerarioVueloRepository;
        }

        // Método para obtener itinerario de vuelos de acuerdo a aeropuertos de origen y destino, fecha de viaje
        [HttpPost()]
        public async Task<IActionResult> ObtenerItinerariosVuelos(ItinerarioVueloRequest parametros)
        {
            var itinerarios = await _itinerarioVueloRepository.ObtenerItinerariosVuelos(parametros.CodAeropuertoOrigen, parametros.CodAeropuertoDestino, parametros.FechaViaje);
            var response = new ApiResponse<List<ItinerarioVueloDto>>(itinerarios);
            return Ok(response);
        }

        // Método para obtener todos los itinerario de vuelos
        [HttpGet()]
        public async Task<IActionResult> ObtenerTodosItinerariosVuelos()
        {
            var itinerarios = await _itinerarioVueloRepository.ObtenerTodosItinerariosVuelos();
            var response = new ApiResponse<List<ItinerarioVueloDto>>(itinerarios);
            return Ok(response);
        }
    }
}
