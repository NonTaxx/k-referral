CREATE TABLE `referral` (
  `identifier` varchar(46) NOT NULL,
  `used_code` varchar(16) DEFAULT NULL,
  `own_code` varchar(16) DEFAULT NULL,
  `uses` int(3) NOT NULL DEFAULT 0,
  `unclaimed_uses` int(3) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `referral`
  ADD PRIMARY KEY (`identifier`);
COMMIT;