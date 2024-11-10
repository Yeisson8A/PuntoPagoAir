using PuntoPagoAir.Core.Interfaces;
using PuntoPagoAir.Infrastructure.Data;
using PuntoPagoAir.Infrastructure.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Agregar referencia a la cadena de conexión de la base de datos
builder.Services.Configure<ConfiguracionConexion>(builder.Configuration.GetSection("ConfiguracionConexion"));
// Agregar dependencia de repositorio
builder.Services.AddScoped<IItinerarioVueloRepository, ItinerarioVueloRepository>();
builder.Services.AddScoped<IAeropuertoRepository, AeropuertoRepository>();
builder.Services.AddScoped<IItinerarioEscalaVueloRepository, ItinerarioEscalaVueloRepository>();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Habilitar CORS para acceso externo
builder.Services.AddCors(opt =>
{
    opt.AddPolicy("CorsRule", rule =>
    {
        rule.AllowAnyHeader().AllowAnyMethod().WithOrigins("*");
    });
});

var app = builder.Build();
app.UseCors("CorsRule");

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();

app.MapControllers();

app.Run();
