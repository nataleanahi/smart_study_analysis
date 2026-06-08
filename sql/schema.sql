SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `smart_study_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `break_type`
--

DROP TABLE IF EXISTS `break_type`;
CREATE TABLE IF NOT EXISTS `break_type` (
  `break_type_id` int NOT NULL AUTO_INCREMENT,
  `break_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`break_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `break_type`
--

INSERT INTO `break_type` (`break_type_id`, `break_type`) VALUES
(1, 'not_applicable'),
(2, 'phone_usage'),
(3, 'walking_moving'),
(4, 'eating_drinking'),
(5, 'breathing_meditation'),
(6, 'other');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `career`
--

DROP TABLE IF EXISTS `career`;
CREATE TABLE IF NOT EXISTS `career` (
  `career_id` int NOT NULL AUTO_INCREMENT,
  `career_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`career_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `career`
--

INSERT INTO `career` (`career_id`, `career_name`) VALUES
(1, 'Computer Science'),
(2, 'Software Engineering'),
(3, 'Data Science'),
(4, 'Psychology'),
(5, 'Industrial Engineering'),
(6, 'Medicine'),
(7, 'Law'),
(8, 'Graphic Design'),
(9, 'Business Administration'),
(10, 'English Teaching Degree'),
(11, 'Mathematics');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `course_type`
--

DROP TABLE IF EXISTS `course_type`;
CREATE TABLE IF NOT EXISTS `course_type` (
  `course_type_id` int NOT NULL AUTO_INCREMENT,
  `course_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`course_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `course_type`
--

INSERT INTO `course_type` (`course_type_id`, `course_type`) VALUES
(1, 'math_logic'),
(2, 'hard_sciences'),
(3, 'social_sciences'),
(4, 'languages'),
(5, 'programming_tech'),
(6, 'other');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `duration_minutes`
--

DROP TABLE IF EXISTS `duration_minutes`;
CREATE TABLE IF NOT EXISTS `duration_minutes` (
  `duration_minutes_id` int NOT NULL AUTO_INCREMENT,
  `range_in_minutes` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`duration_minutes_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `duration_minutes`
--

INSERT INTO `duration_minutes` (`duration_minutes_id`, `range_in_minutes`) VALUES
(1, '15_30'),
(2, '30_60'),
(3, '60_120'),
(4, 'more_than_120');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hours_slept`
--

DROP TABLE IF EXISTS `hours_slept`;
CREATE TABLE IF NOT EXISTS `hours_slept` (
  `hours_slept_id` int NOT NULL AUTO_INCREMENT,
  `hours_slept` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`hours_slept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `hours_slept`
--

INSERT INTO `hours_slept` (`hours_slept_id`, `hours_slept`) VALUES
(1, '0_3'),
(2, '4_5'),
(3, '6_7'),
(4, '8_or_more');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `session`
--

DROP TABLE IF EXISTS `session`;
CREATE TABLE IF NOT EXISTS `session` (
  `session_id` int NOT NULL AUTO_INCREMENT,
  `topic_difficulty` int DEFAULT NULL,
  `breaks` int DEFAULT NULL,
  `anxiety_level` int DEFAULT NULL,
  `concentration_level` int DEFAULT NULL,
  `comprehension_level` int DEFAULT NULL,
  `course_type_id` int NOT NULL,
  `duration_minutes_id` int NOT NULL,
  `time_of_day_id` int NOT NULL,
  `break_type_id` int NOT NULL,
  `technique_id` int NOT NULL,
  `hours_slept_id` int NOT NULL,
  `record_hash` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `timestamp_form` datetime DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `record_hash` (`record_hash`),
  KEY `fk_course_type_real` (`course_type_id`),
  KEY `fk_hours_slept_real` (`hours_slept_id`),
  KEY `fk_technique_real` (`technique_id`),
  KEY `fk_duration_minutes_real` (`duration_minutes_id`),
  KEY `fk_break_type_real` (`break_type_id`),
  KEY `fk_time_of_day_real` (`time_of_day_id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `technique`
--

DROP TABLE IF EXISTS `technique`;
CREATE TABLE IF NOT EXISTS `technique` (
  `technique_id` int NOT NULL AUTO_INCREMENT,
  `technique_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`technique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `technique`
--

INSERT INTO `technique` (`technique_id`, `technique_type`) VALUES
(1, 'reading'),
(2, 'summarizing_writing'),
(3, 'exercises_practice'),
(4, 'memorization'),
(5, 'video_recorded_class'),
(6, 'concept_maps'),
(7, 'other');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `time_of_day`
--

DROP TABLE IF EXISTS `time_of_day`;
CREATE TABLE IF NOT EXISTS `time_of_day` (
  `time_of_day_id` int NOT NULL AUTO_INCREMENT,
  `time_of_day` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`time_of_day_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `time_of_day`
--

INSERT INTO `time_of_day` (`time_of_day_id`, `time_of_day`) VALUES
(1, 'early_morning'),
(2, 'morning'),
(3, 'afternoon'),
(4, 'night'),
(5, 'not_specified');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `session`
--
ALTER TABLE `session`
  ADD CONSTRAINT `fk_break_type_real` FOREIGN KEY (`break_type_id`) REFERENCES `break_type` (`break_type_id`),
  ADD CONSTRAINT `fk_course_type_real` FOREIGN KEY (`course_type_id`) REFERENCES `course_type` (`course_type_id`),
  ADD CONSTRAINT `fk_duration_minutes_real` FOREIGN KEY (`duration_minutes_id`) REFERENCES `duration_minutes` (`duration_minutes_id`),
  ADD CONSTRAINT `fk_hours_slept_real` FOREIGN KEY (`hours_slept_id`) REFERENCES `hours_slept` (`hours_slept_id`),
  ADD CONSTRAINT `fk_technique_real` FOREIGN KEY (`technique_id`) REFERENCES `technique` (`technique_id`),
  ADD CONSTRAINT `fk_time_of_day_real` FOREIGN KEY (`time_of_day_id`) REFERENCES `time_of_day` (`time_of_day_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
