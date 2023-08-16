CREATE TABLE IF NOT EXISTS `ricky_admin` (
  `identifier` varchar(46) NOT NULL,
  `warn` longtext DEFAULT NULL,
  `kick` longtext DEFAULT NULL,
  `ban` longtext DEFAULT NULL,
  `jail` longtext DEFAULT NULL,
  `inJail` int(11) DEFAULT 0,
  `jailCoords` longtext DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

