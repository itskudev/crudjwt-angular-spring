-- =====================================================
-- BASE DE DATOS: SISTEMA DE GESTIÓN DE PRODUCTOS
-- MOTOR: PostgreSQL
-- =====================================================

-- =====================================================
-- 1. ELIMINAR TABLAS (SI EXISTEN)
-- =====================================================

DROP TABLE IF EXISTS producto CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS rol CASCADE;


-- =====================================================
-- 2. TABLA: ROL
-- =====================================================

CREATE TABLE rol (
    id_rol BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP
);


-- =====================================================
-- 3. TABLA: USUARIO
-- =====================================================

CREATE TABLE usuario (
    id_usuario BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    id_rol BIGINT NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP,

    CONSTRAINT fk_usuario_rol
        FOREIGN KEY (id_rol)
        REFERENCES rol(id_rol)
);


-- =====================================================
-- 4. TABLA: CATEGORIA
-- =====================================================

CREATE TABLE categoria (
    id_categoria BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP
);


-- =====================================================
-- 5. TABLA: PRODUCTO
-- =====================================================

CREATE TABLE producto (
    id_producto BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    id_categoria BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP,

    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria),

    CONSTRAINT fk_producto_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario),

    CONSTRAINT chk_producto_precio
        CHECK (precio >= 0),

    CONSTRAINT chk_producto_stock
        CHECK (stock >= 0)
);


-- =====================================================
-- 6. CREACIÓN DE ÍNDICES
-- =====================================================

CREATE INDEX idx_usuario_rol
ON usuario(id_rol);

CREATE INDEX idx_producto_categoria
ON producto(id_categoria);

CREATE INDEX idx_producto_usuario
ON producto(id_usuario);

CREATE INDEX idx_producto_nombre
ON producto(nombre);


-- =====================================================
-- 7. INSERTAR ROLES
-- =====================================================

INSERT INTO rol (nombre, descripcion)
VALUES
('ROLE_ADMIN', 'Administrador del sistema'),
('ROLE_VENDEDOR', 'Usuario encargado de gestionar productos'),
('ROLE_CLIENTE', 'Usuario con acceso básico');


-- =====================================================
-- 8. INSERTAR USUARIOS
-- =====================================================

-- NOTA: Todas las contraseñas son 123456

INSERT INTO usuario (
    nombre,
    apellido,
    email,
    password,
    id_rol
)
VALUES
(
    'Juan',
    'Perez',
    'admin@gmail.com',
    '$2a$10$yt3uXC8EVrHR4A0MQZAu/e6iVWYUixYb9uUam8lhnwKa6.qdj/7pO',
    (SELECT id_rol FROM rol WHERE nombre = 'ROLE_ADMIN')
),
(
    'Maria',
    'Lopez',
    'vendedor@gmail.com',
    '$2a$10$yt3uXC8EVrHR4A0MQZAu/e6iVWYUixYb9uUam8lhnwKa6.qdj/7pO',
    (SELECT id_rol FROM rol WHERE nombre = 'ROLE_VENDEDOR')
),
(
    'Carlos',
    'Ramirez',
    'cliente@gmail.com',
    '$2a$10$yt3uXC8EVrHR4A0MQZAu/e6iVWYUixYb9uUam8lhnwKa6.qdj/7pO',
    (SELECT id_rol FROM rol WHERE nombre = 'ROLE_CLIENTE')
);


-- =====================================================
-- 9. INSERTAR CATEGORÍAS
-- =====================================================

INSERT INTO categoria (nombre, descripcion)
VALUES
('Electrónica', 'Productos electrónicos'),
('Ropa', 'Prendas de vestir'),
('Hogar', 'Artículos para el hogar'),
('Deportes', 'Productos deportivos');


-- =====================================================
-- 10. INSERTAR PRODUCTOS
-- =====================================================

INSERT INTO producto (
    nombre,
    descripcion,
    precio,
    stock,
    id_categoria,
    id_usuario
)
VALUES
(
    'Laptop Lenovo',
    'Laptop Core i7',
    3500.00,
    10,
    (SELECT id_categoria FROM categoria WHERE nombre = 'Electrónica'),
    (SELECT id_usuario FROM usuario WHERE email = 'admin@gmail.com')
),
(
    'Mouse Logitech',
    'Mouse inalámbrico',
    85.50,
    30,
    (SELECT id_categoria FROM categoria WHERE nombre = 'Electrónica'),
    (SELECT id_usuario FROM usuario WHERE email = 'vendedor@gmail.com')
),
(
    'Polo Nike',
    'Polo deportivo',
    120.00,
    20,
    (SELECT id_categoria FROM categoria WHERE nombre = 'Ropa'),
    (SELECT id_usuario FROM usuario WHERE email = 'vendedor@gmail.com')
),
(
    'Silla de oficina',
    'Silla ergonómica',
    450.00,
    5,
    (SELECT id_categoria FROM categoria WHERE nombre = 'Hogar'),
    (SELECT id_usuario FROM usuario WHERE email = 'admin@gmail.com')
);


-- =====================================================
-- 11. CONSULTAR USUARIOS CON ROLES
-- =====================================================

SELECT
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.email,
	u.password,
    r.nombre AS rol,
    u.estado
FROM usuario u
INNER JOIN rol r
    ON u.id_rol = r.id_rol;


-- =====================================================
-- 12. CONSULTAR PRODUCTOS CON CATEGORÍA Y USUARIO
-- =====================================================

SELECT
    p.id_producto,
    p.nombre AS producto,
    p.descripcion,
    p.precio,
    p.stock,
    c.nombre AS categoria,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario,
    r.nombre AS rol_usuario,
    p.estado,
    p.fecha_creacion
FROM producto p
INNER JOIN categoria c
    ON p.id_categoria = c.id_categoria
INNER JOIN usuario u
    ON p.id_usuario = u.id_usuario
INNER JOIN rol r
    ON u.id_rol = r.id_rol
ORDER BY p.id_producto;