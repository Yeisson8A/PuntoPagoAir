-- Crear la base de datos
CREATE DATABASE PuntoPagoAir;
GO

-- Usar la base de datos
USE PuntoPagoAir;
GO

/*** Creación de tablas ***/
CREATE TABLE [dbo].[Aeropuerto](
	[CodigoAeropuerto] [nvarchar](3) NOT NULL,
	[NombreAeropuerto] [varchar](200) NOT NULL,
 CONSTRAINT [PK_Aeropuerto] PRIMARY KEY CLUSTERED 
(
	[CodigoAeropuerto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EscalaVuelo](
	[IdEscala] [int] IDENTITY(1,1) NOT NULL,
	[IdVuelo] [int] NULL,
	[CodigoAeropuertoOrigen] [nvarchar](3) NULL,
	[CodigoAeropuertoDestino] [nvarchar](3) NULL,
	[FechaSalida] [datetime] NULL,
	[FechaLlegada] [datetime] NULL,
 CONSTRAINT [PK_EscalaVuelo] PRIMARY KEY CLUSTERED 
(
	[IdEscala] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Vuelo](
	[IdVuelo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoAeropuertoOrigen] [nvarchar](3) NULL,
	[CodigoAeropuertoDestino] [nvarchar](3) NULL,
	[FechaSalida] [datetime] NULL,
	[FechaLlegada] [datetime] NULL,
 CONSTRAINT [PK_Vuelo] PRIMARY KEY CLUSTERED 
(
	[IdVuelo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*** Creación de claves foráneas ***/
ALTER TABLE [dbo].[EscalaVuelo]  WITH CHECK ADD  CONSTRAINT [FK_EscalaVuelo_AeropuertoDestino] FOREIGN KEY([CodigoAeropuertoDestino])
REFERENCES [dbo].[Aeropuerto] ([CodigoAeropuerto])
GO
ALTER TABLE [dbo].[EscalaVuelo] CHECK CONSTRAINT [FK_EscalaVuelo_AeropuertoDestino]
GO
ALTER TABLE [dbo].[EscalaVuelo]  WITH CHECK ADD  CONSTRAINT [FK_EscalaVuelo_AeropuertoOrigen] FOREIGN KEY([CodigoAeropuertoOrigen])
REFERENCES [dbo].[Aeropuerto] ([CodigoAeropuerto])
GO
ALTER TABLE [dbo].[EscalaVuelo] CHECK CONSTRAINT [FK_EscalaVuelo_AeropuertoOrigen]
GO
ALTER TABLE [dbo].[EscalaVuelo]  WITH CHECK ADD  CONSTRAINT [FK_EscalaVuelo_Vuelo] FOREIGN KEY([IdVuelo])
REFERENCES [dbo].[Vuelo] ([IdVuelo])
GO
ALTER TABLE [dbo].[EscalaVuelo] CHECK CONSTRAINT [FK_EscalaVuelo_Vuelo]
GO
ALTER TABLE [dbo].[Vuelo]  WITH CHECK ADD  CONSTRAINT [FK_Vuelo_AeropuertoDestino] FOREIGN KEY([CodigoAeropuertoDestino])
REFERENCES [dbo].[Aeropuerto] ([CodigoAeropuerto])
GO
ALTER TABLE [dbo].[Vuelo] CHECK CONSTRAINT [FK_Vuelo_AeropuertoDestino]
GO
ALTER TABLE [dbo].[Vuelo]  WITH CHECK ADD  CONSTRAINT [FK_Vuelo_AeropuertoOrigen] FOREIGN KEY([CodigoAeropuertoOrigen])
REFERENCES [dbo].[Aeropuerto] ([CodigoAeropuerto])
GO
ALTER TABLE [dbo].[Vuelo] CHECK CONSTRAINT [FK_Vuelo_AeropuertoOrigen]
GO

/*** Creación de procedimientos ***/

-- =============================================
-- Author:		Yeisson Alexander Ochoa Villa
-- Create date: <09/11/2024>
-- Description:	Obtener listado de aeropuertos disponibles
-- =============================================
CREATE PROCEDURE [dbo].[SP_ObtenerAeropuertos] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT CodigoAeropuerto, NombreAeropuerto
	FROM Aeropuerto
	ORDER BY CodigoAeropuerto
END
GO

-- =============================================
-- Author:		Yeisson Alexander Ochoa Villa
-- Create date: <09/11/2024>
-- Description:	Obtener detalle escalas para un itinerario de vuelo especifico
-- =============================================
CREATE PROCEDURE [dbo].[SP_ObtenerItinerarioEscalasPorIdVuelo] 
	-- Add the parameters for the stored procedure here
	@IdVuelo INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    WITH tt1 (IdEscala, AeropuertoOrigen, AeropuertoDestino, FechaSalida, FechaLlegada, TiempoTotal)
	AS
	(
		SELECT e.IdEscala, e.CodigoAeropuertoOrigen + ' - ' + a1.NombreAeropuerto as AeropuertoOrigen, 
		       e.CodigoAeropuertoDestino + ' - ' + a2.NombreAeropuerto as AeropuertoDestino, e.FechaSalida, e.FechaLlegada, 
			   DATEDIFF(MINUTE, e.FechaSalida, e.FechaLlegada) as TiempoTotal
		FROM EscalaVuelo e
		INNER JOIN Aeropuerto a1 ON e.CodigoAeropuertoOrigen = a1.CodigoAeropuerto
		INNER JOIN Aeropuerto a2 ON e.CodigoAeropuertoDestino = a2.CodigoAeropuerto
		WHERE e.IdVuelo = @IdVuelo
		GROUP BY e.IdEscala, e.CodigoAeropuertoOrigen, a1.NombreAeropuerto, e.CodigoAeropuertoDestino, a2.NombreAeropuerto, e.FechaSalida, e.FechaLlegada
	)
	SELECT IdEscala, AeropuertoOrigen, AeropuertoDestino, FechaSalida, FechaLlegada, TiempoTotal/60 as Horas, TiempoTotal%60 as Minutos
	FROM tt1
END
GO

-- =============================================
-- Author:		Yeisson Alexander Ochoa Villa
-- Create date: <09/11/2024>
-- Description:	Obtener itinerario de vuelos de acuerdo a aeropuertos de origen y destino, fecha de viaje
-- =============================================
CREATE PROCEDURE [dbo].[SP_ObtenerItinerariosVuelos] 
	@CodAeropuertoOrigen VARCHAR(3),
	@CodAeropuertoDestino VARCHAR(3),
	@FechaViaje DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	WITH tt1 (IdVuelo, AeropuertoOrigen, AeropuertoDestino, FechaSalida, FechaLlegada, TiempoTotal, TieneEscala)
	AS
	(
		SELECT v.IdVuelo, v.CodigoAeropuertoOrigen + ' - ' + a1.NombreAeropuerto as AeropuertoOrigen, 
		       v.CodigoAeropuertoDestino + ' - ' + a2.NombreAeropuerto as AeropuertoDestino, v.FechaSalida, v.FechaLlegada, 
			   DATEDIFF(MINUTE, v.FechaSalida, v.FechaLlegada) as TiempoTotal, CASE WHEN e.IdVuelo IS NULL THEN 0 ELSE 1 END as TieneEscala
		FROM Vuelo v
		INNER JOIN Aeropuerto a1 ON v.CodigoAeropuertoOrigen = a1.CodigoAeropuerto
		INNER JOIN Aeropuerto a2 ON v.CodigoAeropuertoDestino = a2.CodigoAeropuerto
		LEFT OUTER JOIN EscalaVuelo e ON v.IdVuelo = e.IdVuelo
		WHERE (v.CodigoAeropuertoOrigen = @CodAeropuertoOrigen AND v.CodigoAeropuertoDestino = @CodAeropuertoDestino) 
		OR (e.CodigoAeropuertoOrigen = @CodAeropuertoOrigen AND e.CodigoAeropuertoDestino = @CodAeropuertoDestino) 
		AND @FechaViaje BETWEEN CONVERT(DATE, v.FechaSalida) AND CONVERT(DATE, v.FechaLlegada)
		GROUP BY v.IdVuelo, v.CodigoAeropuertoOrigen, a1.NombreAeropuerto, v.CodigoAeropuertoDestino, a2.NombreAeropuerto, v.FechaSalida, v.FechaLlegada, e.IdVuelo
	)
	SELECT IdVuelo, AeropuertoOrigen, AeropuertoDestino, FechaSalida, FechaLlegada, TiempoTotal/60 as Horas, TiempoTotal%60 as Minutos, TieneEscala
	FROM tt1
	ORDER BY TiempoTotal ASC
END
GO

-- =============================================
-- Author:		Yeisson Alexander Ochoa Villa
-- Create date: <09/11/2024>
-- Description:	Obtener todos los itinerario de vuelos
-- =============================================
CREATE PROCEDURE [dbo].[SP_ObtenerTodosItinerariosVuelos] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    WITH tt1 (IdVuelo, AeropuertoOrigen, AeropuertoDestino, FechaSalida, FechaLlegada, TiempoTotal, TieneEscala)
	AS
	(
		SELECT v.IdVuelo, v.CodigoAeropuertoOrigen + ' - ' + a1.NombreAeropuerto as AeropuertoOrigen, 
		       v.CodigoAeropuertoDestino + ' - ' + a2.NombreAeropuerto as AeropuertoDestino, v.FechaSalida, v.FechaLlegada, 
			   DATEDIFF(MINUTE, v.FechaSalida, v.FechaLlegada) as TiempoTotal, CASE WHEN e.IdVuelo IS NULL THEN 0 ELSE 1 END as TieneEscala
		FROM Vuelo v
		INNER JOIN Aeropuerto a1 ON v.CodigoAeropuertoOrigen = a1.CodigoAeropuerto
		INNER JOIN Aeropuerto a2 ON v.CodigoAeropuertoDestino = a2.CodigoAeropuerto
		LEFT OUTER JOIN EscalaVuelo e ON v.IdVuelo = e.IdVuelo
		GROUP BY v.IdVuelo, v.CodigoAeropuertoOrigen, a1.NombreAeropuerto, v.CodigoAeropuertoDestino, a2.NombreAeropuerto, v.FechaSalida, v.FechaLlegada, e.IdVuelo
	)
	SELECT IdVuelo, AeropuertoOrigen, AeropuertoDestino, FechaSalida, FechaLlegada, TiempoTotal/60 as Horas, TiempoTotal%60 as Minutos, TieneEscala
	FROM tt1
	ORDER BY TiempoTotal ASC
END
GO

/*** Datos de prueba tabla Aeropuerto ***/
INSERT [dbo].[Aeropuerto] ([CodigoAeropuerto], [NombreAeropuerto]) VALUES (N'BAQ', N'Barranquilla')
GO
INSERT [dbo].[Aeropuerto] ([CodigoAeropuerto], [NombreAeropuerto]) VALUES (N'BGA', N'Bucaramanga')
GO
INSERT [dbo].[Aeropuerto] ([CodigoAeropuerto], [NombreAeropuerto]) VALUES (N'BOG', N'Bogotá')
GO
INSERT [dbo].[Aeropuerto] ([CodigoAeropuerto], [NombreAeropuerto]) VALUES (N'CLO', N'Cali')
GO
INSERT [dbo].[Aeropuerto] ([CodigoAeropuerto], [NombreAeropuerto]) VALUES (N'CTG', N'Cartagena')
GO
INSERT [dbo].[Aeropuerto] ([CodigoAeropuerto], [NombreAeropuerto]) VALUES (N'EOH', N'Medellín / Enrique Olaya Herrera')
GO
INSERT [dbo].[Aeropuerto] ([CodigoAeropuerto], [NombreAeropuerto]) VALUES (N'MDE', N'Medellín / Rionegro')
GO
INSERT [dbo].[Aeropuerto] ([CodigoAeropuerto], [NombreAeropuerto]) VALUES (N'SMR', N'Santa Marta')
GO

/*** Datos de prueba tabla Vuelo ***/
SET IDENTITY_INSERT [dbo].[Vuelo] ON 
GO
INSERT [dbo].[Vuelo] ([IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (1, N'MDE', N'CLO', CAST(N'2024-11-12T05:00:00.000' AS DateTime), CAST(N'2024-11-12T06:05:00.000' AS DateTime))
GO
INSERT [dbo].[Vuelo] ([IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (2, N'MDE', N'CLO', CAST(N'2024-11-12T07:02:00.000' AS DateTime), CAST(N'2024-11-12T10:08:00.000' AS DateTime))
GO
INSERT [dbo].[Vuelo] ([IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (3, N'MDE', N'CLO', CAST(N'2024-11-12T17:19:00.000' AS DateTime), CAST(N'2024-11-12T20:18:00.000' AS DateTime))
GO
INSERT [dbo].[Vuelo] ([IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (4, N'MDE', N'BAQ', CAST(N'2024-12-11T05:39:00.000' AS DateTime), CAST(N'2024-12-11T06:57:00.000' AS DateTime))
GO
INSERT [dbo].[Vuelo] ([IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (5, N'BOG', N'SMR', CAST(N'2024-12-11T11:15:00.000' AS DateTime), CAST(N'2024-12-11T12:49:00.000' AS DateTime))
GO
INSERT [dbo].[Vuelo] ([IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (6, N'BOG', N'SMR', CAST(N'2024-12-11T13:18:00.000' AS DateTime), CAST(N'2024-12-11T17:48:00.000' AS DateTime))
GO
INSERT [dbo].[Vuelo] ([IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (7, N'MDE', N'BGA', CAST(N'2024-12-11T17:32:00.000' AS DateTime), CAST(N'2024-12-12T10:49:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Vuelo] OFF
GO

/*** Datos de prueba tabla EscalaVuelo ***/
SET IDENTITY_INSERT [dbo].[EscalaVuelo] ON 
GO
INSERT [dbo].[EscalaVuelo] ([IdEscala], [IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (1, 2, N'MDE', N'BOG', CAST(N'2024-11-12T07:02:00.000' AS DateTime), CAST(N'2024-11-12T08:00:00.000' AS DateTime))
GO
INSERT [dbo].[EscalaVuelo] ([IdEscala], [IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (2, 2, N'BOG', N'CLO', CAST(N'2024-11-12T09:03:00.000' AS DateTime), CAST(N'2024-11-12T10:08:00.000' AS DateTime))
GO
INSERT [dbo].[EscalaVuelo] ([IdEscala], [IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (3, 3, N'MDE', N'BOG', CAST(N'2024-11-12T17:19:00.000' AS DateTime), CAST(N'2024-11-12T18:15:00.000' AS DateTime))
GO
INSERT [dbo].[EscalaVuelo] ([IdEscala], [IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (4, 3, N'BOG', N'CLO', CAST(N'2024-11-12T19:15:00.000' AS DateTime), CAST(N'2024-11-12T20:18:00.000' AS DateTime))
GO
INSERT [dbo].[EscalaVuelo] ([IdEscala], [IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (5, 6, N'BOG', N'CLO', CAST(N'2024-12-11T13:18:00.000' AS DateTime), CAST(N'2024-12-11T14:19:00.000' AS DateTime))
GO
INSERT [dbo].[EscalaVuelo] ([IdEscala], [IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (6, 6, N'CLO', N'SMR', CAST(N'2024-12-11T16:13:00.000' AS DateTime), CAST(N'2024-12-11T17:48:00.000' AS DateTime))
GO
INSERT [dbo].[EscalaVuelo] ([IdEscala], [IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (7, 7, N'MDE', N'CLO', CAST(N'2024-12-11T17:32:00.000' AS DateTime), CAST(N'2024-12-11T18:36:00.000' AS DateTime))
GO
INSERT [dbo].[EscalaVuelo] ([IdEscala], [IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (8, 7, N'CLO', N'BOG', CAST(N'2024-12-12T04:23:00.000' AS DateTime), CAST(N'2024-12-12T05:30:00.000' AS DateTime))
GO
INSERT [dbo].[EscalaVuelo] ([IdEscala], [IdVuelo], [CodigoAeropuertoOrigen], [CodigoAeropuertoDestino], [FechaSalida], [FechaLlegada]) VALUES (9, 7, N'BOG', N'BGA', CAST(N'2024-12-12T09:40:00.000' AS DateTime), CAST(N'2024-12-12T10:49:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[EscalaVuelo] OFF
GO