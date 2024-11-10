using Microsoft.AspNetCore.Mvc;
using PuntoPagoAir.Api.Responses;
using PuntoPagoAir.Core.Entities;
using PuntoPagoAir.Core.Interfaces;

namespace PuntoPagoAir.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AeropuertoController : ControllerBase
    {
        private readonly IAeropuertoRepository _aeropuertoRepository;

        public AeropuertoController(IAeropuertoRepository aeropuertoRepository)
        {
            _aeropuertoRepository = aeropuertoRepository;
        }

        // Método para obtener listado de aeropuertos disponibles
        [HttpGet()]
        public async Task<IActionResult> GetAeropuertos()
        {
            var aeropuertos = await _aeropuertoRepository.GetAeropuertos();
            var response = new ApiResponse<List<Aeropuerto>>(aeropuertos);
            return Ok(response);
        }
    }
}
