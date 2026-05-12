-- ============================================================
-- EXAMEN 4 - TÉCNICAS DE PROGRAMACIÓN
-- Programación Declarativa - PostgreSQL
-- Autores: Andres Ferney Buitrago Suarez - Jhakayra Cardona Montiel
-- Fecha : 11 Mayo de 2026
-- Descripción:
--   Script declarativo e idempotente que:
--   1. Asegura que las 4 monedas existen (INSERT si no existen).
--   2. Alimenta los cambios diarios de los 2 últimos meses
--      (11 de marzo de 2026 al 10 de mayo de 2026) para 4 monedas.
--   3. Si un cambio ya existe, actualiza el valor (UPSERT).
--   4. Incluye una moneda nueva: Sol Peruano (PEN), que NO
--      estaba originalmente en la base de datos.
--
-- MONEDAS USADAS:
--   - Dólar estadounidense  (USD) - Id 155 en el DML original
--   - Euro                  (EUR) - Id  49 en el DML original
--   - Libra esterlina       (GBP) - Id  52 en el DML original
--   - Sol peruano           (PEN) - NUEVA (no existía en el DML)
--

-- ============================================================


-- ============================================================
-- SECCIÓN 1: INSERTAR MONEDAS
--   ON CONFLICT (Moneda) DO NOTHING  → si ya existe, no falla.
--   ON CONFLICT (Moneda) DO UPDATE   → para el Sol Peruano,
--   actualiza Sigla/Simbolo/Emisor en caso de re-ejecución.
-- ============================================================

-- Dólar estadounidense (ya debe existir con Id 155)
INSERT INTO Moneda (Id, Moneda, Sigla, Simbolo, Emisor)
VALUES (155, 'Dólar estadounidense', 'USD', '$', 'Reserva Federal de EE. UU.')
ON CONFLICT (Id) DO NOTHING;

-- Euro (ya debe existir con Id 49)
INSERT INTO Moneda (Id, Moneda, Sigla, Simbolo, Emisor)
VALUES (49, 'Euro', 'EUR', '€', 'Banco Central Europeo')
ON CONFLICT (Id) DO NOTHING;

-- Libra esterlina (ya debe existir con Id 52)
INSERT INTO Moneda (Id, Moneda, Sigla, Simbolo, Emisor)
VALUES (52, 'Libra esterlina', 'GBP', '£', 'Banco de Inglaterra')
ON CONFLICT (Id) DO NOTHING;

-- Sol peruano (NUEVA — no estaba en el DML original)
-- Se usa ON CONFLICT DO UPDATE para que sea idempotente:
-- si se ejecuta de nuevo, actualiza los datos descriptivos.
INSERT INTO Moneda (Moneda, Sigla, Simbolo, Emisor)
VALUES ('Sol peruano', 'PEN', 'S/', 'Banco Central de Reserva del Perú')
ON CONFLICT (Moneda) DO UPDATE
    SET Sigla  = EXCLUDED.Sigla,
        Simbolo = EXCLUDED.Simbolo,
        Emisor  = EXCLUDED.Emisor;


-- ============================================================
-- SECCIÓN 2: CAMBIOS DIARIOS — DÓLAR ESTADOUNIDENSE (USD)
--   Período: 11 de marzo de 2026 al 10 de mayo de 2026
--   Tasa de referencia: COP/USD (pesos colombianos por dólar)
--   ON CONFLICT (IdMoneda, Fecha) DO UPDATE → idempotente
-- ============================================================

INSERT INTO CambioMoneda (IdMoneda, Fecha, Cambio)
SELECT m.Id, fechas.Fecha, fechas.Cambio
FROM Moneda m,
(VALUES
    ('2026-03-11'::DATE, 4185.50),
    ('2026-03-12'::DATE, 4192.30),
    ('2026-03-13'::DATE, 4201.75),
    ('2026-03-14'::DATE, 4198.40),
    ('2026-03-15'::DATE, 4195.80),
    ('2026-03-16'::DATE, 4190.20),
    ('2026-03-17'::DATE, 4188.60),
    ('2026-03-18'::DATE, 4182.10),
    ('2026-03-19'::DATE, 4178.90),
    ('2026-03-20'::DATE, 4175.30),
    ('2026-03-21'::DATE, 4180.55),
    ('2026-03-22'::DATE, 4176.80),
    ('2026-03-23'::DATE, 4172.40),
    ('2026-03-24'::DATE, 4168.90),
    ('2026-03-25'::DATE, 4165.20),
    ('2026-03-26'::DATE, 4162.70),
    ('2026-03-27'::DATE, 4170.15),
    ('2026-03-28'::DATE, 4175.60),
    ('2026-03-29'::DATE, 4180.30),
    ('2026-03-30'::DATE, 4185.90),
    ('2026-03-31'::DATE, 4190.45),
    ('2026-04-01'::DATE, 4195.10),
    ('2026-04-02'::DATE, 4200.80),
    ('2026-04-03'::DATE, 4205.35),
    ('2026-04-04'::DATE, 4210.60),
    ('2026-04-05'::DATE, 4208.25),
    ('2026-04-06'::DATE, 4215.70),
    ('2026-04-07'::DATE, 4220.15),
    ('2026-04-08'::DATE, 4225.40),
    ('2026-04-09'::DATE, 4230.85),
    ('2026-04-10'::DATE, 4228.30),
    ('2026-04-11'::DATE, 4235.60),
    ('2026-04-12'::DATE, 4240.25),
    ('2026-04-13'::DATE, 4238.90),
    ('2026-04-14'::DATE, 4232.45),
    ('2026-04-15'::DATE, 4228.70),
    ('2026-04-16'::DATE, 4225.10),
    ('2026-04-17'::DATE, 4222.80),
    ('2026-04-18'::DATE, 4218.35),
    ('2026-04-19'::DATE, 4215.60),
    ('2026-04-20'::DATE, 4212.90),
    ('2026-04-21'::DATE, 4209.75),
    ('2026-04-22'::DATE, 4206.40),
    ('2026-04-23'::DATE, 4203.85),
    ('2026-04-24'::DATE, 4200.20),
    ('2026-04-25'::DATE, 4197.55),
    ('2026-04-26'::DATE, 4194.80),
    ('2026-04-27'::DATE, 4191.35),
    ('2026-04-28'::DATE, 4188.60),
    ('2026-04-29'::DATE, 4185.90),
    ('2026-04-30'::DATE, 4183.25),
    ('2026-05-01'::DATE, 4180.50),
    ('2026-05-02'::DATE, 4177.85),
    ('2026-05-03'::DATE, 4175.10),
    ('2026-05-04'::DATE, 4172.40),
    ('2026-05-05'::DATE, 4169.75),
    ('2026-05-06'::DATE, 4167.00),
    ('2026-05-07'::DATE, 4164.30),
    ('2026-05-08'::DATE, 4161.60),
    ('2026-05-09'::DATE, 4158.90),
    ('2026-05-10'::DATE, 4156.25)
) AS fechas(Fecha, Cambio)
WHERE m.Sigla = 'USD'
ON CONFLICT (IdMoneda, Fecha) DO UPDATE
    SET Cambio = EXCLUDED.Cambio;


-- ============================================================
-- SECCIÓN 3: CAMBIOS DIARIOS — EURO (EUR)
--   Período: 11 de marzo de 2026 al 10 de mayo de 2026
--   Tasa de referencia: COP/EUR
-- ============================================================

INSERT INTO CambioMoneda (IdMoneda, Fecha, Cambio)
SELECT m.Id, fechas.Fecha, fechas.Cambio
FROM Moneda m,
(VALUES
    ('2026-03-11'::DATE, 4580.20),
    ('2026-03-12'::DATE, 4590.75),
    ('2026-03-13'::DATE, 4601.30),
    ('2026-03-14'::DATE, 4595.80),
    ('2026-03-15'::DATE, 4588.45),
    ('2026-03-16'::DATE, 4582.10),
    ('2026-03-17'::DATE, 4578.60),
    ('2026-03-18'::DATE, 4572.90),
    ('2026-03-19'::DATE, 4565.35),
    ('2026-03-20'::DATE, 4558.80),
    ('2026-03-21'::DATE, 4562.45),
    ('2026-03-22'::DATE, 4555.70),
    ('2026-03-23'::DATE, 4549.25),
    ('2026-03-24'::DATE, 4543.80),
    ('2026-03-25'::DATE, 4538.30),
    ('2026-03-26'::DATE, 4534.75),
    ('2026-03-27'::DATE, 4541.20),
    ('2026-03-28'::DATE, 4548.65),
    ('2026-03-29'::DATE, 4555.10),
    ('2026-03-30'::DATE, 4562.55),
    ('2026-03-31'::DATE, 4570.00),
    ('2026-04-01'::DATE, 4577.45),
    ('2026-04-02'::DATE, 4584.90),
    ('2026-04-03'::DATE, 4592.35),
    ('2026-04-04'::DATE, 4600.80),
    ('2026-04-05'::DATE, 4597.25),
    ('2026-04-06'::DATE, 4605.70),
    ('2026-04-07'::DATE, 4613.15),
    ('2026-04-08'::DATE, 4620.60),
    ('2026-04-09'::DATE, 4628.05),
    ('2026-04-10'::DATE, 4624.50),
    ('2026-04-11'::DATE, 4632.95),
    ('2026-04-12'::DATE, 4640.40),
    ('2026-04-13'::DATE, 4637.85),
    ('2026-04-14'::DATE, 4630.30),
    ('2026-04-15'::DATE, 4625.75),
    ('2026-04-16'::DATE, 4620.20),
    ('2026-04-17'::DATE, 4615.65),
    ('2026-04-18'::DATE, 4610.10),
    ('2026-04-19'::DATE, 4605.55),
    ('2026-04-20'::DATE, 4601.00),
    ('2026-04-21'::DATE, 4596.45),
    ('2026-04-22'::DATE, 4591.90),
    ('2026-04-23'::DATE, 4587.35),
    ('2026-04-24'::DATE, 4582.80),
    ('2026-04-25'::DATE, 4578.25),
    ('2026-04-26'::DATE, 4573.70),
    ('2026-04-27'::DATE, 4569.15),
    ('2026-04-28'::DATE, 4564.60),
    ('2026-04-29'::DATE, 4560.05),
    ('2026-04-30'::DATE, 4555.50),
    ('2026-05-01'::DATE, 4550.95),
    ('2026-05-02'::DATE, 4546.40),
    ('2026-05-03'::DATE, 4541.85),
    ('2026-05-04'::DATE, 4537.30),
    ('2026-05-05'::DATE, 4532.75),
    ('2026-05-06'::DATE, 4528.20),
    ('2026-05-07'::DATE, 4523.65),
    ('2026-05-08'::DATE, 4519.10),
    ('2026-05-09'::DATE, 4514.55),
    ('2026-05-10'::DATE, 4510.00)
) AS fechas(Fecha, Cambio)
WHERE m.Sigla = 'EUR'
ON CONFLICT (IdMoneda, Fecha) DO UPDATE
    SET Cambio = EXCLUDED.Cambio;


-- ============================================================
-- SECCIÓN 4: CAMBIOS DIARIOS — LIBRA ESTERLINA (GBP)
--   Período: 11 de marzo de 2026 al 10 de mayo de 2026
--   Tasa de referencia: COP/GBP
-- ============================================================

INSERT INTO CambioMoneda (IdMoneda, Fecha, Cambio)
SELECT m.Id, fechas.Fecha, fechas.Cambio
FROM Moneda m,
(VALUES
    ('2026-03-11'::DATE, 5310.40),
    ('2026-03-12'::DATE, 5322.85),
    ('2026-03-13'::DATE, 5335.30),
    ('2026-03-14'::DATE, 5328.75),
    ('2026-03-15'::DATE, 5320.20),
    ('2026-03-16'::DATE, 5312.65),
    ('2026-03-17'::DATE, 5305.10),
    ('2026-03-18'::DATE, 5298.55),
    ('2026-03-19'::DATE, 5291.00),
    ('2026-03-20'::DATE, 5283.45),
    ('2026-03-21'::DATE, 5288.90),
    ('2026-03-22'::DATE, 5281.35),
    ('2026-03-23'::DATE, 5273.80),
    ('2026-03-24'::DATE, 5266.25),
    ('2026-03-25'::DATE, 5258.70),
    ('2026-03-26'::DATE, 5253.15),
    ('2026-03-27'::DATE, 5260.60),
    ('2026-03-28'::DATE, 5268.05),
    ('2026-03-29'::DATE, 5275.50),
    ('2026-03-30'::DATE, 5282.95),
    ('2026-03-31'::DATE, 5290.40),
    ('2026-04-01'::DATE, 5298.85),
    ('2026-04-02'::DATE, 5307.30),
    ('2026-04-03'::DATE, 5315.75),
    ('2026-04-04'::DATE, 5324.20),
    ('2026-04-05'::DATE, 5320.65),
    ('2026-04-06'::DATE, 5329.10),
    ('2026-04-07'::DATE, 5337.55),
    ('2026-04-08'::DATE, 5346.00),
    ('2026-04-09'::DATE, 5354.45),
    ('2026-04-10'::DATE, 5350.90),
    ('2026-04-11'::DATE, 5359.35),
    ('2026-04-12'::DATE, 5367.80),
    ('2026-04-13'::DATE, 5364.25),
    ('2026-04-14'::DATE, 5357.70),
    ('2026-04-15'::DATE, 5351.15),
    ('2026-04-16'::DATE, 5344.60),
    ('2026-04-17'::DATE, 5338.05),
    ('2026-04-18'::DATE, 5331.50),
    ('2026-04-19'::DATE, 5324.95),
    ('2026-04-20'::DATE, 5318.40),
    ('2026-04-21'::DATE, 5311.85),
    ('2026-04-22'::DATE, 5305.30),
    ('2026-04-23'::DATE, 5298.75),
    ('2026-04-24'::DATE, 5292.20),
    ('2026-04-25'::DATE, 5285.65),
    ('2026-04-26'::DATE, 5279.10),
    ('2026-04-27'::DATE, 5272.55),
    ('2026-04-28'::DATE, 5266.00),
    ('2026-04-29'::DATE, 5259.45),
    ('2026-04-30'::DATE, 5252.90),
    ('2026-05-01'::DATE, 5246.35),
    ('2026-05-02'::DATE, 5239.80),
    ('2026-05-03'::DATE, 5233.25),
    ('2026-05-04'::DATE, 5226.70),
    ('2026-05-05'::DATE, 5220.15),
    ('2026-05-06'::DATE, 5213.60),
    ('2026-05-07'::DATE, 5207.05),
    ('2026-05-08'::DATE, 5200.50),
    ('2026-05-09'::DATE, 5193.95),
    ('2026-05-10'::DATE, 5187.40)
) AS fechas(Fecha, Cambio)
WHERE m.Sigla = 'GBP'
ON CONFLICT (IdMoneda, Fecha) DO UPDATE
    SET Cambio = EXCLUDED.Cambio;


-- ============================================================
-- SECCIÓN 5: CAMBIOS DIARIOS — SOL PERUANO (PEN) ← MONEDA NUEVA
--   Período: 11 de marzo de 2026 al 10 de mayo de 2026
--   Tasa de referencia: COP/PEN
--   Esta moneda no existía en el DML original.
--   Se referencia por Sigla para que el Id generado (SERIAL)
--   sea resuelto automáticamente con el subquery del FROM.
-- ============================================================

INSERT INTO CambioMoneda (IdMoneda, Fecha, Cambio)
SELECT m.Id, fechas.Fecha, fechas.Cambio
FROM Moneda m,
(VALUES
    ('2026-03-11'::DATE, 1118.30),
    ('2026-03-12'::DATE, 1121.45),
    ('2026-03-13'::DATE, 1124.60),
    ('2026-03-14'::DATE, 1122.85),
    ('2026-03-15'::DATE, 1120.10),
    ('2026-03-16'::DATE, 1117.35),
    ('2026-03-17'::DATE, 1114.60),
    ('2026-03-18'::DATE, 1111.85),
    ('2026-03-19'::DATE, 1109.10),
    ('2026-03-20'::DATE, 1106.35),
    ('2026-03-21'::DATE, 1108.60),
    ('2026-03-22'::DATE, 1105.85),
    ('2026-03-23'::DATE, 1103.10),
    ('2026-03-24'::DATE, 1100.35),
    ('2026-03-25'::DATE, 1097.60),
    ('2026-03-26'::DATE, 1095.85),
    ('2026-03-27'::DATE, 1098.10),
    ('2026-03-28'::DATE, 1100.35),
    ('2026-03-29'::DATE, 1102.60),
    ('2026-03-30'::DATE, 1104.85),
    ('2026-03-31'::DATE, 1107.10),
    ('2026-04-01'::DATE, 1109.35),
    ('2026-04-02'::DATE, 1111.60),
    ('2026-04-03'::DATE, 1113.85),
    ('2026-04-04'::DATE, 1116.10),
    ('2026-04-05'::DATE, 1114.35),
    ('2026-04-06'::DATE, 1116.60),
    ('2026-04-07'::DATE, 1118.85),
    ('2026-04-08'::DATE, 1121.10),
    ('2026-04-09'::DATE, 1123.35),
    ('2026-04-10'::DATE, 1121.60),
    ('2026-04-11'::DATE, 1123.85),
    ('2026-04-12'::DATE, 1126.10),
    ('2026-04-13'::DATE, 1124.35),
    ('2026-04-14'::DATE, 1122.60),
    ('2026-04-15'::DATE, 1120.85),
    ('2026-04-16'::DATE, 1119.10),
    ('2026-04-17'::DATE, 1117.35),
    ('2026-04-18'::DATE, 1115.60),
    ('2026-04-19'::DATE, 1113.85),
    ('2026-04-20'::DATE, 1112.10),
    ('2026-04-21'::DATE, 1110.35),
    ('2026-04-22'::DATE, 1108.60),
    ('2026-04-23'::DATE, 1106.85),
    ('2026-04-24'::DATE, 1105.10),
    ('2026-04-25'::DATE, 1103.35),
    ('2026-04-26'::DATE, 1101.60),
    ('2026-04-27'::DATE, 1099.85),
    ('2026-04-28'::DATE, 1098.10),
    ('2026-04-29'::DATE, 1096.35),
    ('2026-04-30'::DATE, 1094.60),
    ('2026-05-01'::DATE, 1092.85),
    ('2026-05-02'::DATE, 1091.10),
    ('2026-05-03'::DATE, 1089.35),
    ('2026-05-04'::DATE, 1087.60),
    ('2026-05-05'::DATE, 1085.85),
    ('2026-05-06'::DATE, 1084.10),
    ('2026-05-07'::DATE, 1082.35),
    ('2026-05-08'::DATE, 1080.60),
    ('2026-05-09'::DATE, 1078.85),
    ('2026-05-10'::DATE, 1077.10)
) AS fechas(Fecha, Cambio)
WHERE m.Sigla = 'PEN'
ON CONFLICT (IdMoneda, Fecha) DO UPDATE
    SET Cambio = EXCLUDED.Cambio;



-- ============================================================
-- Contar registros por moneda:
--
-- SELECT m.Sigla, m.Moneda, COUNT(c.Id) AS TotalCambios
-- FROM Moneda m
-- LEFT JOIN CambioMoneda c ON c.IdMoneda = m.Id
-- WHERE m.Sigla IN ('USD','EUR','GBP','PEN')
-- GROUP BY m.Sigla, m.Moneda
-- ORDER BY m.Sigla;
--
-- Resultado esperado: 61 cambios por cada moneda (11 mar → 10 may 2026)
-- ============================================================
