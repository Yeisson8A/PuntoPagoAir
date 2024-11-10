namespace PuntoPagoAir.Api.Requests
{
    public class ItinerarioVueloRequest
    {
        public string CodAeropuertoOrigen { get; set; }

        public string CodAeropuertoDestino { get; set; }

        public DateTime FechaViaje { get; set; }
    }
}
