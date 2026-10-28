USE Ventas_Tech_DB;
-- CONSULTA 1: Resumen ejecutivo mensual --
SELECT 
       MONTH(fecha_venta) AS mes,
       SUM(cantidad * precio_unitario) AS total_facturado,
       COUNT(*) AS cantidad_pedidos,
       AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

-- CONSULTA 2: Ranking de productos por facturación --
SELECT TOP 5 id_producto,
       SUM(cantidad) AS unidades_vendidas,
       SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY SUM(cantidad * precio_unitario) DESC;

-- CONSULTA 3: Clientes recurrentes --
SELECT id_cliente, 
       COUNT(*) AS cantidad_pedidos,  
       SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- CONSULTA 4: Facturación mensual comparada con el promedio --
;WITH ventas_por_mes AS (
-- Parte 1: calcular el total facturado de cada mes
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_mes
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

-- Parte 2: comparar cada mes con el promedio mensual
SELECT
    mes,
    total_mes,
    CASE
        WHEN total_mes > (SELECT AVG(total_mes) FROM ventas_por_mes)
            THEN 'Por encima'
        WHEN total_mes < (SELECT AVG(total_mes) FROM ventas_por_mes)
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM ventas_por_mes
ORDER BY mes;


-- Hallazgos principales
-- 1. Las ventas registradas corresponden a marzo y suman 6.444,00
-- 2. El producto 1 generó la mayor facturación, con 3.600,00
-- 3. Los cinco clientes realizaron dos pedidos cada uno
