namespace PuntoPagoAir.Core.DTOs
{
    public class ItinerarioEscalaVueloDto
    {
        public int IdEscala { get; set; }

        public string AeropuertoOrigen { get; set; }

        public string AeropuertoDestino { get; set; }

        public DateTime FechaSalida { get; set; }

        public DateTime FechaLlegada { get; set; }

        public int Horas { get; set; }

        public int Minutos { get; set; }
    }
}
