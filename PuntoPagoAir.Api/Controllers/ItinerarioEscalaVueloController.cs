using Microsoft.AspNetCore.Mvc;
using PuntoPagoAir.Api.Responses;
using PuntoPagoAir.Core.DTOs;
using PuntoPagoAir.Core.Interfaces;

namespace PuntoPagoAir.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ItinerarioEscalaVueloController : ControllerBase
    {
        private readonly IItinerarioEscalaVueloRepository _itinerarioEscalaVueloRepository;

        public ItinerarioEscalaVueloController(IItinerarioEscalaVueloRepository itinerarioEscalaVueloRepository)
        {
            _itinerarioEscalaVueloRepository = itinerarioEscalaVueloRepository;
        }

        // Método para obtener detalle escalas para un itinerario de vuelo especifico
        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerItinerarioEscalasPorIdVuelo(int id)
        {
            var itinerarios = await _itinerarioEscalaVueloRepository.ObtenerItinerarioEscalasPorIdVuelo(id);
            var response = new ApiResponse<List<ItinerarioEscalaVueloDto>>(itinerarios);
            return Ok(response);
        }
    }
}
