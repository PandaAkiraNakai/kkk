-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 09-07-2025 a las 19:29:01
-- Versión del servidor: 9.1.0
-- Versión de PHP: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `penka`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comunas`
--

DROP TABLE IF EXISTS `comunas`;
CREATE TABLE IF NOT EXISTS `comunas` (
  `idcomunas` int NOT NULL AUTO_INCREMENT,
  `nombre_comuna` varchar(50) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `estado` int NOT NULL,
  `idprovincias` int NOT NULL,
  PRIMARY KEY (`idcomunas`)
) ENGINE=MyISAM AUTO_INCREMENT=338 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `comunas`
--

INSERT INTO `comunas` (`idcomunas`, `nombre_comuna`, `estado`, `idprovincias`) VALUES
(1, 'La Serena', 1, 1),
(2, 'Coquimbo', 1, 1),
(3, 'Andacollo', 1, 1),
(4, 'La Higuera', 1, 1),
(5, 'Paiguano', 1, 1),
(6, 'Vicuña', 1, 1),
(7, 'Ovalle', 1, 2),
(8, 'Combarbalá', 1, 2),
(9, 'Monte Patria', 1, 2),
(10, 'Punitaqui', 1, 2),
(11, 'Río Hurtado', 1, 2),
(12, 'Illapel', 1, 3),
(13, 'Canela', 1, 3),
(14, 'Los Vilos', 1, 3),
(15, 'Salamanca', 1, 3),
(16, 'Arica', 1, 101),
(17, 'Camarones', 1, 101),
(18, 'Putre', 1, 102),
(19, 'General Lagos', 1, 102),
(20, 'Iquique', 1, 103),
(21, 'Alto Hospicio', 1, 103),
(22, 'Pozo Almonte', 1, 104),
(23, 'Camiña', 1, 104),
(24, 'Colchane', 1, 104),
(25, 'Huara', 1, 104),
(26, 'Pica', 1, 104),
(27, 'Copiapó', 1, 105),
(28, 'Caldera', 1, 105),
(29, 'Tierra Amarilla', 1, 105),
(30, 'Chañaral', 1, 106),
(31, 'Diego de Almagro', 1, 106),
(32, 'Vallenar', 1, 107),
(33, 'Alto del Carmen', 1, 107),
(34, 'Freirina', 1, 107),
(35, 'Huasco', 1, 107),
(36, 'Valparaíso', 1, 108),
(37, 'Viña del Mar', 1, 108),
(38, 'Concón', 1, 108),
(39, 'Quintero', 1, 108),
(40, 'Puchuncaví', 1, 108),
(41, 'Casablanca', 1, 108),
(42, 'Juan Fernández', 1, 108),
(43, 'Laguna Verde', 1, 108),
(44, 'San Antonio', 1, 109),
(45, 'Cartagena', 1, 109),
(46, 'El Tabo', 1, 109),
(47, 'El Quisco', 1, 109),
(48, 'Algarrobo', 1, 109),
(49, 'Santo Domingo', 1, 109),
(50, 'Quillota', 1, 110),
(51, 'La Cruz', 1, 110),
(52, 'La Calera', 1, 110),
(53, 'Hijuelas', 1, 110),
(54, 'Nogales', 1, 110),
(55, 'San Felipe', 1, 111),
(56, 'Llay-Llay', 1, 111),
(57, 'Catemu', 1, 111),
(58, 'Putaendo', 1, 111),
(59, 'Santa María', 1, 111),
(60, 'Panquehue', 1, 111),
(61, 'Los Andes', 1, 112),
(62, 'Calle Larga', 1, 112),
(63, 'Rinconada', 1, 112),
(64, 'San Esteban', 1, 112),
(65, 'La Ligua', 1, 113),
(66, 'Cabildo', 1, 113),
(67, 'Papudo', 1, 113),
(68, 'Zapallar', 1, 113),
(69, 'Petorca', 1, 113),
(70, 'Isla de Pascua', 1, 114),
(71, 'Quilpué', 1, 115),
(72, 'Villa Alemana', 1, 115),
(73, 'Limache', 1, 115),
(74, 'Olmué', 1, 115),
(75, 'Santiago', 1, 116),
(76, 'Cerrillos', 1, 116),
(77, 'Cerro Navia', 1, 116),
(78, 'Conchalí', 1, 116),
(79, 'El Bosque', 1, 116),
(80, 'Estación Central', 1, 116),
(81, 'Huechuraba', 1, 116),
(82, 'Independencia', 1, 116),
(83, 'La Cisterna', 1, 116),
(84, 'La Florida', 1, 116),
(85, 'La Granja', 1, 116),
(86, 'La Pintana', 1, 116),
(87, 'La Reina', 1, 116),
(88, 'Las Condes', 1, 116),
(89, 'Lo Barnechea', 1, 116),
(90, 'Lo Espejo', 1, 116),
(91, 'Lo Prado', 1, 116),
(92, 'Macul', 1, 116),
(93, 'Maipú', 1, 116),
(94, 'Ñuñoa', 1, 116),
(95, 'Pedro Aguirre Cerda', 1, 116),
(96, 'Peñalolén', 1, 116),
(97, 'Providencia', 1, 116),
(98, 'Pudahuel', 1, 116),
(99, 'Quilicura', 1, 116),
(100, 'Quinta Normal', 1, 116),
(101, 'Recoleta', 1, 116),
(102, 'Renca', 1, 116),
(103, 'San Joaquín', 1, 116),
(104, 'San Miguel', 1, 116),
(105, 'San Ramón', 1, 116),
(106, 'Vitacura', 1, 116),
(107, 'Puente Alto', 1, 117),
(108, 'Pirque', 1, 117),
(109, 'San José de Maipo', 1, 117),
(110, 'San Bernardo', 1, 118),
(111, 'Buin', 1, 118),
(112, 'Calera de Tango', 1, 118),
(113, 'Paine', 1, 118),
(114, 'Melipilla', 1, 119),
(115, 'Alhué', 1, 119),
(116, 'Curacaví', 1, 119),
(117, 'María Pinto', 1, 119),
(118, 'San Pedro', 1, 119),
(119, 'Talagante', 1, 120),
(120, 'El Monte', 1, 120),
(121, 'Isla de Maipo', 1, 120),
(122, 'Padre Hurtado', 1, 120),
(123, 'Peñaflor', 1, 120),
(124, 'Colina', 1, 121),
(125, 'Lampa', 1, 121),
(126, 'Tiltil', 1, 121),
(127, 'Rancagua', 1, 122),
(128, 'Codegua', 1, 122),
(129, 'Coinco', 1, 122),
(130, 'Coltauco', 1, 122),
(131, 'Doñihue', 1, 122),
(132, 'Graneros', 1, 122),
(133, 'Las Cabras', 1, 122),
(134, 'Machalí', 1, 122),
(135, 'Malloa', 1, 122),
(136, 'Mostazal', 1, 122),
(137, 'Olivar', 1, 122),
(138, 'Peumo', 1, 122),
(139, 'Pichidegua', 1, 122),
(140, 'Quinta de Tilcoco', 1, 122),
(141, 'Rengo', 1, 122),
(142, 'Requínoa', 1, 122),
(143, 'San Vicente de Tagua Tagua', 1, 122),
(144, 'San Fernando', 1, 123),
(145, 'Chépica', 1, 123),
(146, 'Chimbarongo', 1, 123),
(147, 'La Estrella', 1, 123),
(148, 'Litueche', 1, 123),
(149, 'Lolol', 1, 123),
(150, 'Nancagua', 1, 123),
(151, 'Palmilla', 1, 123),
(152, 'Peralillo', 1, 123),
(153, 'Placilla', 1, 123),
(154, 'Pumanque', 1, 123),
(155, 'Santa Cruz', 1, 123),
(156, 'Pichilemu', 1, 124),
(157, 'La Estrella', 1, 124),
(158, 'Litueche', 1, 124),
(159, 'Marchigüe', 1, 124),
(160, 'Navidad', 1, 124),
(161, 'Paredones', 1, 124),
(162, 'Talca', 1, 125),
(163, 'Constitución', 1, 125),
(164, 'Curepto', 1, 125),
(165, 'Empedrado', 1, 125),
(166, 'Maule', 1, 125),
(167, 'Pelarco', 1, 125),
(168, 'Pencahue', 1, 125),
(169, 'Río Claro', 1, 125),
(170, 'San Clemente', 1, 125),
(171, 'San Rafael', 1, 125),
(172, 'Curicó', 1, 126),
(173, 'Hualañé', 1, 126),
(174, 'Licantén', 1, 126),
(175, 'Molina', 1, 126),
(176, 'Romeral', 1, 126),
(177, 'Sagrada Familia', 1, 126),
(178, 'Teno', 1, 126),
(179, 'Vichuquén', 1, 126),
(180, 'Linares', 1, 127),
(181, 'Colbún', 1, 127),
(182, 'Longaví', 1, 127),
(183, 'Parral', 1, 127),
(184, 'Retiro', 1, 127),
(185, 'San Javier', 1, 127),
(186, 'Villa Alegre', 1, 127),
(187, 'Yerbas Buenas', 1, 127),
(188, 'Cauquenes', 1, 128),
(189, 'Chanco', 1, 128),
(190, 'Pelluhue', 1, 128),
(191, 'Chillán', 1, 129),
(192, 'Chillán Viejo', 1, 129),
(193, 'Bulnes', 1, 129),
(194, 'El Carmen', 1, 129),
(195, 'Pemuco', 1, 129),
(196, 'Pinto', 1, 129),
(197, 'Quillón', 1, 129),
(198, 'San Ignacio', 1, 129),
(199, 'Yungay', 1, 129),
(200, 'San Carlos', 1, 130),
(201, 'Coihueco', 1, 130),
(202, 'Ñiquén', 1, 130),
(203, 'San Fabián', 1, 130),
(204, 'San Nicolás', 1, 130),
(205, 'Cobquecura', 1, 131),
(206, 'Coelemu', 1, 131),
(207, 'Portezuelo', 1, 131),
(208, 'Quirihue', 1, 131),
(209, 'Ránquil', 1, 131),
(210, 'Treguaco', 1, 131),
(211, 'Concepción', 1, 132),
(212, 'Coronel', 1, 132),
(213, 'Chiguayante', 1, 132),
(214, 'Florida', 1, 132),
(215, 'Hualqui', 1, 132),
(216, 'Lota', 1, 132),
(217, 'Penco', 1, 132),
(218, 'San Pedro de la Paz', 1, 132),
(219, 'Santa Juana', 1, 132),
(220, 'Talcahuano', 1, 132),
(221, 'Tomé', 1, 132),
(222, 'Hualpén', 1, 132),
(223, 'Lebu', 1, 133),
(224, 'Arauco', 1, 133),
(225, 'Cañete', 1, 133),
(226, 'Contulmo', 1, 133),
(227, 'Curanilahue', 1, 133),
(228, 'Los Álamos', 1, 133),
(229, 'Tirúa', 1, 133),
(230, 'Los Ángeles', 1, 134),
(231, 'Antuco', 1, 134),
(232, 'Cabrero', 1, 134),
(233, 'Laja', 1, 134),
(234, 'Mulchén', 1, 134),
(235, 'Nacimiento', 1, 134),
(236, 'Negrete', 1, 134),
(237, 'Quilaco', 1, 134),
(238, 'Quilleco', 1, 134),
(239, 'San Rosendo', 1, 134),
(240, 'Santa Bárbara', 1, 134),
(241, 'Tucapel', 1, 134),
(242, 'Yumbel', 1, 134),
(243, 'Temuco', 1, 135),
(244, 'Carahue', 1, 135),
(245, 'Cholchol', 1, 135),
(246, 'Cunco', 1, 135),
(247, 'Curarrehue', 1, 135),
(248, 'Freire', 1, 135),
(249, 'Galvarino', 1, 135),
(250, 'Gorbea', 1, 135),
(251, 'Lautaro', 1, 135),
(252, 'Loncoche', 1, 135),
(253, 'Melipeuco', 1, 135),
(254, 'Nueva Imperial', 1, 135),
(255, 'Padre Las Casas', 1, 135),
(256, 'Perquenco', 1, 135),
(257, 'Pitrufquén', 1, 135),
(258, 'Pucón', 1, 135),
(259, 'Saavedra', 1, 135),
(260, 'Teodoro Schmidt', 1, 135),
(261, 'Toltén', 1, 135),
(262, 'Vilcún', 1, 135),
(263, 'Villarrica', 1, 135),
(264, 'Angol', 1, 136),
(265, 'Collipulli', 1, 136),
(266, 'Curacautín', 1, 136),
(267, 'Ercilla', 1, 136),
(268, 'Lonquimay', 1, 136),
(269, 'Los Sauces', 1, 136),
(270, 'Lumaco', 1, 136),
(271, 'Purén', 1, 136),
(272, 'Renaico', 1, 136),
(273, 'Traiguén', 1, 136),
(274, 'Victoria', 1, 136),
(275, 'Valdivia', 1, 137),
(276, 'Corral', 1, 137),
(277, 'Lanco', 1, 137),
(278, 'Los Lagos', 1, 137),
(279, 'Máfil', 1, 137),
(280, 'Mariquina', 1, 137),
(281, 'Paillaco', 1, 137),
(282, 'Panguipulli', 1, 137),
(283, 'La Unión', 1, 138),
(284, 'Futrono', 1, 138),
(285, 'Lago Ranco', 1, 138),
(286, 'Río Bueno', 1, 138),
(287, 'Puerto Montt', 1, 139),
(288, 'Calbuco', 1, 139),
(289, 'Cochamó', 1, 139),
(290, 'Fresia', 1, 139),
(291, 'Frutillar', 1, 139),
(292, 'Los Muermos', 1, 139),
(293, 'Llanquihue', 1, 139),
(294, 'Maullín', 1, 139),
(295, 'Puerto Varas', 1, 139),
(296, 'Castro', 1, 140),
(297, 'Ancud', 1, 140),
(298, 'Chonchi', 1, 140),
(299, 'Curaco de Vélez', 1, 140),
(300, 'Dalcahue', 1, 140),
(301, 'Puqueldón', 1, 140),
(302, 'Queilén', 1, 140),
(303, 'Quellón', 1, 140),
(304, 'Quemchi', 1, 140),
(305, 'Quinchao', 1, 140),
(306, 'Osorno', 1, 141),
(307, 'Puerto Octay', 1, 141),
(308, 'Purranque', 1, 141),
(309, 'Puyehue', 1, 141),
(310, 'Río Negro', 1, 141),
(311, 'San Juan de la Costa', 1, 141),
(312, 'San Pablo', 1, 141),
(313, 'Chaitén', 1, 142),
(314, 'Futaleufú', 1, 142),
(315, 'Hualaihué', 1, 142),
(316, 'Palena', 1, 142),
(317, 'Coyhaique', 1, 143),
(318, 'Lago Verde', 1, 143),
(319, 'Aysén', 1, 144),
(320, 'Cisnes', 1, 144),
(321, 'Guaitecas', 1, 144),
(322, 'Chile Chico', 1, 145),
(323, 'Río Ibáñez', 1, 145),
(324, 'Cochrane', 1, 146),
(325, 'O’Higgins', 1, 146),
(326, 'Tortel', 1, 146),
(327, 'Punta Arenas', 1, 147),
(328, 'Laguna Blanca', 1, 147),
(329, 'Río Verde', 1, 147),
(330, 'San Gregorio', 1, 147),
(331, 'Natales', 1, 148),
(332, 'Torres del Paine', 1, 148),
(333, 'Porvenir', 1, 149),
(334, 'Primavera', 1, 149),
(335, 'Timaukel', 1, 149),
(336, 'Cabo de Hornos', 1, 150),
(337, 'Antártica', 1, 150);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `galeria`
--

DROP TABLE IF EXISTS `galeria`;
CREATE TABLE IF NOT EXISTS `galeria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `foto` varchar(255) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `estado` int NOT NULL DEFAULT '1',
  `principal` tinyint(1) NOT NULL DEFAULT '0',
  `idpropiedades` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idpropiedades` (`idpropiedades`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `galeria`
--

INSERT INTO `galeria` (`id`, `foto`, `estado`, `principal`, `idpropiedades`) VALUES
(1, 'img/propiedades/1750032630_38bc0b2c-e6f5-4780-a817-f081bd9c7734.webp', 1, 1, 3),
(2, 'img/propiedades/1750032665_a1b29771-0590-450b-a0a5-493873b9ff40.webp', 1, 1, 4),
(3, 'img/propiedades/1750032667_a1b29771-0590-450b-a0a5-493873b9ff40.webp', 1, 1, 5),
(4, 'img/propiedades/1750032856_a1b29771-0590-450b-a0a5-493873b9ff40.webp', 1, 1, 6),
(5, 'img/propiedades/1750033332_38bc0b2c-e6f5-4780-a817-f081bd9c7734.webp', 1, 1, 7),
(6, 'img/propiedades/1750034677_4cf4f171-bd37-4164-988a-d9f8b98e1838 (2).jpg', 1, 1, 8),
(9, 'img/propiedades/1750048922_TheLastOfUs1.jpg', 1, 1, 11),
(10, 'img/propiedades/1750049324_Snorlax Chill.jpg', 1, 1, 12),
(12, 'img/propiedades/1750055000_Captura de pantalla (14).png', 1, 0, 13),
(13, 'img/propiedades/1750056238_Captura de pantalla (15).png', 1, 1, 13),
(14, 'img/propiedades/1752088470381_588428974.jpg', 1, 1, 14);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gestores`
--

DROP TABLE IF EXISTS `gestores`;
CREATE TABLE IF NOT EXISTS `gestores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rut` varchar(12) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `nombre_completo` varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `correo` varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `password` varchar(50) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `sexo` char(1) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `telefono` varchar(12) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `certificado_path` varchar(255) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `estado` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rut` (`rut`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `gestores`
--

INSERT INTO `gestores` (`id`, `rut`, `nombre_completo`, `fecha_nacimiento`, `correo`, `password`, `sexo`, `telefono`, `certificado_path`, `estado`) VALUES
(1, '15575629-2', 'susana', '2025-05-08', 'susana@hotmail.es', 'aac7d3276fbe433467c3e4dcc6acb76c', 'F', '+56968712289', 'certificados/68266b665e836.pdf', 0),
(3, '19271399-4', 'Victor Manzano penka', '2025-05-09', 'victor@pnk.cl', 'edceaffe9972e6304832f692cf05245d', 'M', '+56966683463', 'certificados/68275c72c3983.png', 1),
(5, '20965953-0', 'Sergio Cubelli', '2025-06-03', 'sergio1@pnk.cl', '68b6c1eded499f85fb38876ff3b2df28', 'M', '+56966683463', 'certificados/684f55118983b.png', 0),
(6, '7964344-0', 'Manuel Manzano', '2025-06-04', 'manuel@pnk.cl', '$2y$10$l2GAHW7o1PirDoLyIfRoAOcYvn2T7ZRBmH27dZ5dt07', 'M', '+56988847362', 'certificados/684fc02637856.png', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `propiedades`
--

DROP TABLE IF EXISTS `propiedades`;
CREATE TABLE IF NOT EXISTS `propiedades` (
  `num_propiedad` int NOT NULL AUTO_INCREMENT,
  `rut_propietario` varchar(12) CHARACTER SET latin1 COLLATE latin1_spanish_ci DEFAULT NULL,
  `titulopropiedad` varchar(50) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `descripcion` text CHARACTER SET latin1 COLLATE latin1_spanish_ci,
  `cant_banos` int DEFAULT NULL,
  `cant_domitorios` int DEFAULT NULL,
  `area_total` int DEFAULT NULL,
  `area_construida` int DEFAULT NULL,
  `precio_pesos` int DEFAULT NULL,
  `precio_uf` int DEFAULT NULL,
  `fecha_publicacion` date DEFAULT NULL,
  `estado` int DEFAULT NULL,
  `idtipo_propiedad` int NOT NULL,
  `bodega` int DEFAULT NULL,
  `estacionamiento` int DEFAULT NULL,
  `logia` int DEFAULT NULL,
  `cocinaamoblada` int DEFAULT NULL,
  `antejardin` int DEFAULT NULL,
  `patiotrasero` int DEFAULT NULL,
  `piscina` int DEFAULT NULL,
  `idsectores` int NOT NULL,
  PRIMARY KEY (`num_propiedad`),
  KEY `fk_propiedades_tipo_propiedad1_idx` (`idtipo_propiedad`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `propiedades`
--

INSERT INTO `propiedades` (`num_propiedad`, `rut_propietario`, `titulopropiedad`, `descripcion`, `cant_banos`, `cant_domitorios`, `area_total`, `area_construida`, `precio_pesos`, `precio_uf`, `fecha_publicacion`, `estado`, `idtipo_propiedad`, `bodega`, `estacionamiento`, `logia`, `cocinaamoblada`, `antejardin`, `patiotrasero`, `piscina`, `idsectores`) VALUES
(14, '11111111-9', 'Casa Pe', 'sss', 1, 2, 20, NULL, 350000, 3000, '2025-07-09', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `propietarios`
--

DROP TABLE IF EXISTS `propietarios`;
CREATE TABLE IF NOT EXISTS `propietarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rut` varchar(12) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `nombre_completo` varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `correo` varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `password` varchar(255) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `sexo` char(1) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `telefono` varchar(12) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rut` (`rut`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `propietarios`
--

INSERT INTO `propietarios` (`id`, `rut`, `nombre_completo`, `fecha_nacimiento`, `correo`, `password`, `sexo`, `telefono`) VALUES
(9, '20965953-0', 'Sergio Cubelli', '2025-06-13', 'sergio@pnk.cl', '$2y$10$a0kCfEXCRvmJhR/aUSZWDefJI5vVrbo7gx99zmKBfYyFDXy3GGXcW', 'M', '+56966683463'),
(10, '19271399-4', 'Victor Manzano', '2025-06-16', 'victor@pnk.cl', '$2y$10$o8HPAjaynyiO1hVhBQvG4uXu8mC5LjPLdG2j91ipJfYdSEmgQBgU6', 'M', '+56944493723'),
(11, '7964344-0', 'Manuel Manzano', '2025-06-06', 'manuel@pnk.cl', '$2y$10$p9J3uZOH9l4AlomzEtWVSu3C4b76EHWUusu0imet0hBvTithbcf9e', 'M', '+56933374654');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provincias`
--

DROP TABLE IF EXISTS `provincias`;
CREATE TABLE IF NOT EXISTS `provincias` (
  `idprovincias` int NOT NULL AUTO_INCREMENT,
  `nombre_provincia` varchar(50) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `estado` int NOT NULL,
  `idregion` int NOT NULL,
  PRIMARY KEY (`idprovincias`)
) ENGINE=MyISAM AUTO_INCREMENT=151 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `provincias`
--

INSERT INTO `provincias` (`idprovincias`, `nombre_provincia`, `estado`, `idregion`) VALUES
(1, 'Elqui', 1, 4),
(2, 'Limari', 1, 4),
(3, 'Choapa', 1, 4),
(101, 'Arica', 1, 1),
(102, 'Parinacota', 1, 1),
(103, 'Iquique', 1, 2),
(104, 'Tamarugal', 1, 2),
(105, 'Copiapó', 1, 3),
(106, 'Chañaral', 1, 3),
(107, 'Huasco', 1, 3),
(108, 'Valparaíso', 1, 5),
(109, 'San Antonio', 1, 5),
(110, 'Quillota', 1, 5),
(111, 'San Felipe de Aconcagua', 1, 5),
(112, 'Los Andes', 1, 5),
(113, 'Petorca', 1, 5),
(114, 'Isla de Pascua', 1, 5),
(115, 'Marga Marga', 1, 5),
(116, 'Santiago', 1, 6),
(117, 'Cordillera', 1, 6),
(118, 'Maipo', 1, 6),
(119, 'Melipilla', 1, 6),
(120, 'Talagante', 1, 6),
(121, 'Chacabuco', 1, 6),
(122, 'Cachapoal', 1, 7),
(123, 'Colchagua', 1, 7),
(124, 'Cardenal Caro', 1, 7),
(125, 'Talca', 1, 8),
(126, 'Curicó', 1, 8),
(127, 'Linares', 1, 8),
(128, 'Cauquenes', 1, 8),
(129, 'Diguillín', 1, 9),
(130, 'Punilla', 1, 9),
(131, 'Itata', 1, 9),
(132, 'Concepción', 1, 10),
(133, 'Arauco', 1, 10),
(134, 'Biobío', 1, 10),
(135, 'Cautín', 1, 11),
(136, 'Malleco', 1, 11),
(137, 'Valdivia', 1, 12),
(138, 'Ranco', 1, 12),
(139, 'Llanquihue', 1, 13),
(140, 'Chiloé', 1, 13),
(141, 'Osorno', 1, 13),
(142, 'Palena', 1, 13),
(143, 'Coyhaique', 1, 14),
(144, 'Aysén', 1, 14),
(145, 'General Carrera', 1, 14),
(146, 'Capitán Prat', 1, 14),
(147, 'Magallanes', 1, 15),
(148, 'Última Esperanza', 1, 15),
(149, 'Tierra del Fuego', 1, 15),
(150, 'Antártica Chilena', 1, 15);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `regiones`
--

DROP TABLE IF EXISTS `regiones`;
CREATE TABLE IF NOT EXISTS `regiones` (
  `idregion` int NOT NULL AUTO_INCREMENT,
  `nombre_region` varchar(30) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `estado` int NOT NULL,
  PRIMARY KEY (`idregion`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `regiones`
--

INSERT INTO `regiones` (`idregion`, `nombre_region`, `estado`) VALUES
(4, 'Región de Coquimbo', 1),
(3, 'Region de Atacama', 1),
(1, 'Región de Arica y Parinacota', 1),
(2, 'Región de Tarapacá', 1),
(5, 'Región de Valparaíso', 1),
(6, 'Región Metropolitana de Santia', 1),
(7, 'Región del Libertador Gral. Be', 1),
(8, 'Región del Maule', 1),
(9, 'Región de Ñuble', 1),
(10, 'Región del Biobío', 1),
(11, 'Región de La Araucanía', 1),
(12, 'Región de Los Ríos', 1),
(13, 'Región de Los Lagos', 1),
(14, 'Región de Aysén del Gral. Carl', 1),
(15, 'Región de Magallanes y la Antá', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sectores`
--

DROP TABLE IF EXISTS `sectores`;
CREATE TABLE IF NOT EXISTS `sectores` (
  `idsectores` int NOT NULL AUTO_INCREMENT,
  `nombre_sector` varchar(50) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `estado` int NOT NULL,
  `idcomunas` int NOT NULL,
  PRIMARY KEY (`idsectores`)
) ENGINE=MyISAM AUTO_INCREMENT=68 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `sectores`
--

INSERT INTO `sectores` (`idsectores`, `nombre_sector`, `estado`, `idcomunas`) VALUES
(1, 'Bosque San Carlos', 1, 2),
(2, 'Tierras Blancas', 1, 2),
(3, 'Sindempart', 1, 2),
(4, 'La Cantera', 1, 2),
(5, 'La Florida', 1, 1),
(6, 'Las Compañias', 1, 1),
(7, 'Centro de La Serena', 1, 1),
(8, 'La Pampa', 1, 1),
(9, 'Centro de Ovalle', 1, 7),
(10, 'Media Hacienda', 1, 7),
(11, 'El Molino', 1, 7),
(12, 'Centro de Combarbalá', 1, 8),
(13, 'La Isla', 1, 8),
(14, 'Monte Patria Centro', 1, 9),
(15, 'El Palqui', 1, 9),
(16, 'Punitaqui Centro', 1, 10),
(17, 'El Tome Alto', 1, 10),
(18, 'Población Hurtado', 1, 11),
(19, 'Centro de Illapel', 1, 12),
(20, 'Villa San Rafael', 1, 12),
(21, 'Canela Alta', 1, 13),
(22, 'Canela Baja', 1, 13),
(23, 'Centro de Los Vilos', 1, 14),
(24, 'Pichidangui', 1, 14),
(25, 'Salamanca Centro', 1, 15),
(26, 'Chalinga', 1, 15),
(27, 'Centro de Arica', 1, 16),
(28, 'El Morro', 1, 16),
(29, 'Valle de Azapa', 1, 16),
(30, 'Cavancha', 1, 20),
(31, 'Playa Brava', 1, 20),
(32, 'Zofri', 1, 20),
(33, 'Centro de Copiapó', 1, 27),
(34, 'Paipote', 1, 27),
(35, 'Cerro Alegre', 1, 36),
(36, 'Cerro Concepción', 1, 36),
(37, 'Playa Ancha', 1, 36),
(38, 'Reñaca', 1, 37),
(39, 'Concón (parte de Viña del Mar)', 1, 37),
(40, 'Forestal', 1, 37),
(41, 'Barrio Lastarria', 1, 75),
(42, 'Barrio Cívico', 1, 75),
(43, 'Bellavista', 1, 75),
(44, 'El Golf', 1, 88),
(45, 'Manquehue', 1, 88),
(46, 'Ciudad Satélite', 1, 93),
(47, 'El Abrazo', 1, 93),
(48, 'Parque O\'Higgins (Puente Alto)', 1, 107),
(49, 'Bajará', 1, 107),
(50, 'Centro de Rancagua', 1, 127),
(51, 'Barrio O\'Higgins', 1, 127),
(52, 'Centro de Talca', 1, 162),
(53, 'Las Rastras', 1, 162),
(54, 'Centro de Chillán', 1, 191),
(55, 'Los Volcanes', 1, 191),
(56, 'Centro de Concepción', 1, 211),
(57, 'San Pedro de la Paz', 1, 211),
(58, 'Centro de Temuco', 1, 243),
(59, 'Barrio Inglés', 1, 243),
(60, 'Isla Teja', 1, 275),
(61, 'Collico', 1, 275),
(62, 'Angelmó', 1, 287),
(63, 'Pelluco', 1, 287),
(64, 'Centro de Coyhaique', 1, 317),
(65, 'Ribera Sur', 1, 317),
(66, 'Centro de Punta Arenas', 1, 327),
(67, 'Barrio Croata', 1, 327);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_propiedad`
--

DROP TABLE IF EXISTS `tipo_propiedad`;
CREATE TABLE IF NOT EXISTS `tipo_propiedad` (
  `idtipo_propiedad` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(45) CHARACTER SET latin1 COLLATE latin1_spanish_ci DEFAULT NULL,
  `estado` int DEFAULT NULL,
  PRIMARY KEY (`idtipo_propiedad`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tipo_propiedad`
--

INSERT INTO `tipo_propiedad` (`idtipo_propiedad`, `tipo`, `estado`) VALUES
(1, 'Casas', 1),
(2, 'Departamentos', 1),
(3, 'Terrenos', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rut` varchar(12) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `nombres` varchar(50) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `ap_paterno` varchar(50) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `ap_materno` varchar(50) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `usuario` varchar(50) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `clave` varchar(250) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `estado` int NOT NULL DEFAULT '1',
  `tipo_usuario` varchar(20) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL DEFAULT 'usuario',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rut` (`rut`),
  UNIQUE KEY `usuario` (`usuario`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `rut`, `nombres`, `ap_paterno`, `ap_materno`, `usuario`, `clave`, `estado`, `tipo_usuario`) VALUES
(12, '11111111-9', 'Admin', 'Admin', 'Admin', 'admin@pnk.cl', '$2a$12$G4nbFZGk0XBGRDbvuVY53u1zSdNkz76XCexOsU0hMkJFIwDb33b5W', 1, 'admin'),
(13, '209659530', 'Sergio', 'Cubelli', 'Nazer', 'sergio@pnk.cl', '$2b$12$mh.1psGxhFBmA7cicFCs/uF.2vqrZt26AjMfjKbU2h7tKPpjh5iEG', 0, 'usuario');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `propiedades`
--
ALTER TABLE `propiedades`
  ADD CONSTRAINT `fk_propiedades_tipo_propiedad1` FOREIGN KEY (`idtipo_propiedad`) REFERENCES `tipo_propiedad` (`idtipo_propiedad`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
