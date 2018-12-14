CREATE TABLE `agency` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    agency_id VARCHAR(100) NOT NULL,
    agency_name VARCHAR(255) NOT NULL,
    agency_url VARCHAR(255) NOT NULL,
    agency_timezone VARCHAR(100) NOT NULL,
    agency_lang VARCHAR(100) NOT NULL DEFAULT 'en',
    agency_phone VARCHAR(100),
    agency_fare_url VARCHAR(100),
    
    KEY `transit_system` (transit_system),
    KEY `agency_id` (agency_id)
);

CREATE TABLE `calendar_dates` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    service_id VARCHAR(255) NOT NULL,
    `date` VARCHAR(8) NOT NULL,
    exception_type TINYINT(2) NOT NULL COMMENT '1: service added for spec. date, 2: service removed for spec. date',
    
    KEY `transit_system` (transit_system),
    KEY `service_id` (service_id),
    KEY `date` (date),
    KEY `exception_type` (exception_type) 
);

CREATE TABLE `calendar` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    service_id VARCHAR(255) NOT NULL,
    monday TINYINT(1) NOT NULL,
    tuesday TINYINT(1) NOT NULL,
    wednesday TINYINT(1) NOT NULL,
    thursday TINYINT(1) NOT NULL,
    friday TINYINT(1) NOT NULL,
    saturday TINYINT(1) NOT NULL,
    sunday TINYINT(1) NOT NULL,
    start_date VARCHAR(8) NOT NULL,	
    end_date VARCHAR(8) NOT NULL,
    
    KEY `transit_system` (transit_system),
    KEY `service_id` (service_id),
    KEY `start_date` (service_id),
    KEY `end_date` (service_id)
);

CREATE TABLE `fare_attributes` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    fare_id VARCHAR(100),
    price VARCHAR(50) NOT NULL,
    currency_type VARCHAR(50) NOT NULL DEFAULT 'EUR' COMMENT 'Ref to http://en.wikipedia.org/wiki/ISO_4217',
    payment_method TINYINT(1) NOT NULL DEFAULT '1' COMMENT '0: fare is paid on board, 1: fare must be paid before boarding',
    transfers TINYINT(1) NULL DEFAULT '0' COMMENT '0: no transfers permitted on this fare, 1: passenger may transfer once, 2: assenger may transfer twice, (empty): unlimited transfers are permitted',
    transfer_duration VARCHAR(10),
-- ???    exception_type TINYINT(2) NOT NULL,
    agency_id INT(100),
    
    KEY `transit_system` (transit_system),
    KEY `fare_id` (fare_id),
    KEY `agency_id` (agency_id)
);

CREATE TABLE `fare_rules` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    fare_id VARCHAR(100),
    route_id VARCHAR(100),
    origin_id VARCHAR(100),
    destination_id VARCHAR(100),
    contains_id VARCHAR(100),
    
    KEY `transit_system` (transit_system),
    KEY `fare_id` (fare_id),
    KEY `route_id` (route_id),
    KEY `origin_id` (origin_id),
    KEY `destination_id` (destination_id),
    KEY `contains_id` (contains_id)
);

CREATE TABLE `feed_info` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    feed_publisher_name VARCHAR(100),
    feed_publisher_url VARCHAR(255) NOT NULL,
    feed_lang VARCHAR(255) NOT NULL,
    feed_start_date VARCHAR(8),
    feed_end_date VARCHAR(8),
    feed_version VARCHAR(100),
    
    KEY `transit_system` (transit_system),
    KEY `feed_start_date` (feed_start_date),
    KEY `feed_end_date` (feed_end_date)
);

CREATE TABLE `frequencies` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    trip_id VARCHAR(100) NOT NULL,
    start_time VARCHAR(8) NOT NULL,
    end_time VARCHAR(8) NOT NULL,
    headway_secs VARCHAR(100) NOT NULL,
    exact_times TINYINT(1),
    
    KEY `transit_system` (transit_system),
    KEY `trip_id` (trip_id),
    KEY `start_time` (start_time),
    KEY `end_time` (end_time)
);

CREATE TABLE `routes` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    route_id VARCHAR(100),
    agency_id VARCHAR(50),
    route_short_name VARCHAR(50) NOT NULL,
    route_long_name VARCHAR(255) NOT NULL,
    route_type INT(3) NOT NULL DEFAULT '3' COMMENT '0: tram, Streetcar, Light rail, 1: Subway, Metro, 2: Rail, 3 - Bus, 4: Ferry, 5: Cable car, 6 Gondola, Suspended cable car, 7: Funicular',
    route_text_color VARCHAR(255),
    route_color VARCHAR(255),
    route_url VARCHAR(255),
    route_desc VARCHAR(255),
    
    KEY `transit_system` (transit_system),
    KEY `route_id` (route_id),
    KEY `route_short_name` (route_short_name),
    KEY `agency_id` (agency_id),
    KEY `route_type` (route_type)
);

CREATE TABLE `shapes` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    shape_id VARCHAR(100) NOT NULL,
    shape_pt_lat DECIMAL(8,6) NOT NULL,
    shape_pt_lon DECIMAL(8,6) NOT NULL,
    shape_pt_sequence SMALLINT(5) NOT NULL,
    shape_dist_traveled VARCHAR(50),
    
    KEY `transit_system` (transit_system),
    KEY `shape_id` (shape_id),
    KEY `shape_pt` (shape_pt_lat, shape_pt_lon),
    KEY `shape_pt_sequence` (shape_pt_sequence)
);

CREATE TABLE `stop_times` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    trip_id VARCHAR(100) NOT NULL,
    arrival_time VARCHAR(8) NOT NULL DEFAULT '00:00:00'   COMMENT 'Format: HH:MM:SS local time - Trips that span multiple dates will have stop times greater than 24:00:00',
    arrival_time_seconds INT(10) NOT NULL DEFAULT '0'     COMMENT '(Auto generated by trigger)',
    departure_time VARCHAR(8) NOT NULL DEFAULT '00:00:00' COMMENT 'Format: HH:MM:SS local time - Trips that span multiple dates will have stop times greater than 24:00:00',
    departure_time_seconds INT(10) NOT NULL DEFAULT '0'   COMMENT '(Auto generated by trigger)',
    stop_id VARCHAR(100) NOT NULL,
    stop_sequence SMALLINT(5) NOT NULL,
    stop_headsign VARCHAR(50),
    pickup_type VARCHAR(2),
    drop_off_type VARCHAR(2),
    shape_dist_traveled VARCHAR(50),
    
    KEY `transit_system` (transit_system),
    KEY `trip_id` (trip_id),
    KEY `arrival_time_seconds` (arrival_time_seconds),
    KEY `departure_time_seconds` (departure_time_seconds),
    KEY `stop_id` (stop_id),
    KEY `stop_sequence` (stop_sequence),
    KEY `pickup_type` (pickup_type),
    KEY `drop_off_type` (drop_off_type)
);

CREATE TABLE `stops` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    stop_id VARCHAR(100) NOT NULL,
    stop_code VARCHAR(50),
    stop_name VARCHAR(255) NOT NULL,
    stop_desc VARCHAR(255),
    stop_lat DECIMAL(10,6) NOT NULL,
    stop_lon DECIMAL(10,6) NOT NULL,
    zone_id VARCHAR(255),
    stop_url VARCHAR(255),
    location_type TINYINT(1) DEFAULT '0' COMMENT '0 or blank: Stop, 1: Station, 2: Station Entrance/Exit',
    parent_station VARCHAR(100) COMMENT 'For stops that are physically located inside stations, this field identifies the station associated with the stop (with a location_type=1)',
    stop_timezone VARCHAR(50),
    wheelchair_boarding TINYINT(1),
    
    KEY `transit_system` (transit_system),
    KEY `stop_id` (stop_id),
	KEY `stop_code` (stop_code),
    KEY `zone_id` (zone_id),
    KEY `stop_lat` (stop_lat),
    KEY `stop_lon` (stop_lon),
    KEY `location_type` (location_type),
    KEY `parent_station` (parent_station)
);

CREATE TABLE `transfers` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    from_stop_id INT(100) NOT NULL,
    to_stop_id VARCHAR(100) NOT NULL,
    transfer_type TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Ref to https://developers.google.com/transit/gtfs/reference/#transferstxt',
    min_transfer_time VARCHAR(100),
    
    KEY `transit_system` (transit_system),
    KEY `from_stop_id` (from_stop_id),
    KEY `to_stop_id` (to_stop_id)
);

CREATE TABLE `trips` (
    id INT(12) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    transit_system VARCHAR(50) NOT NULL DEFAULT '0',
    route_id VARCHAR(100) NOT NULL,
    service_id VARCHAR(100) NOT NULL,
    trip_id VARCHAR(100) NOT NULL,
    trip_headsign VARCHAR(255),
    trip_short_name VARCHAR(255),
    direction_id TINYINT(1) NOT NULL DEFAULT '0' COMMENT '0: one direction, 1: another',
    block_id VARCHAR(11),
    shape_id VARCHAR(11),
    wheelchair_accessible TINYINT(1) NOT NULL DEFAULT '0' COMMENT '0: no information, 1: at least one rider accommodated on wheel chair, 2: no riders accommodated',
    bikes_allowed TINYINT(1) NOT NULL DEFAULT '0' COMMENT '0: no information, 1: at least one bicycle accommodated, 2: no bicycles accommodated',
    
    KEY `transit_system` (transit_system),
    KEY `route_id` (route_id),
    KEY `service_id` (service_id),
    KEY `trip_id` (trip_id),
    KEY `direction_id` (direction_id),
    KEY `block_id` (block_id),
    KEY `shape_id` (shape_id)
);


-- -----------------------------------------------------------------------------
-- TRIGGERS --------------------------------------------------------------------
-- -----------------------------------------------------------------------------


DELIMITER $$

-- Convert time to seconds (if non set):
--     stop_times.arrival_time --> stop_times.arrival_time_seconds
--     stop_times.departure_time --> stop_times.departure_time_seconds

CREATE DEFINER=CURRENT_USER TRIGGER `stop_times_BEFORE_INSERT` BEFORE INSERT ON `stop_times` FOR EACH ROW
BEGIN
    IF LENGTH(NEW.arrival_time) = 0 THEN
        SET NEW.arrival_time = '00:00:00';
    ELSEIF LENGTH(NEW.arrival_time) = 5 THEN
        SET NEW.arrival_time = CONCACT(NEW.arrival_time, ':00');
    END IF;
    
    SET NEW.arrival_time_seconds = 0;
        
    IF LENGTH(NEW.arrival_time) = 8 THEN BEGIN
        -- Format: HH:MM:SS
        SET @HH = CONVERT(SUBSTRING(NEW.arrival_time, 1, 2), UNSIGNED INTEGER);
        SET @MM = CONVERT(SUBSTRING(NEW.arrival_time, 4, 2), UNSIGNED INTEGER);
        SET @SS = CONVERT(SUBSTRING(NEW.arrival_time, 7, 2), UNSIGNED INTEGER);
        
        SET NEW.arrival_time_seconds = @SS + (@MM * 60) + (@HH * 3600);
    END; END IF;
    
    
    IF LENGTH(NEW.departure_time) = 0 THEN
        SET NEW.departure_time = '00:00:00';
    ELSEIF LENGTH(NEW.departure_time) = 5 THEN
        SET NEW.departure_time = CONCACT(NEW.departure_time, ':00');
    END IF;
    
    SET NEW.departure_time_seconds = 0;
    
    IF LENGTH(NEW.departure_time) = 8 THEN BEGIN
        -- Format: HH:MM:SS
        SET @HH = CONVERT(SUBSTRING(NEW.departure_time, 1, 2), UNSIGNED INTEGER);
        SET @MM = CONVERT(SUBSTRING(NEW.departure_time, 4, 2), UNSIGNED INTEGER);
        SET @SS = CONVERT(SUBSTRING(NEW.departure_time, 7, 2), UNSIGNED INTEGER);
        
        SET NEW.departure_time_seconds = @SS + (@MM * 60) + (@HH * 3600);
    END; END IF;
END$$

CREATE DEFINER=CURRENT_USER TRIGGER `stop_times_BEFORE_UPDATE` BEFORE UPDATE ON `stop_times` FOR EACH ROW
BEGIN
    IF LENGTH(NEW.arrival_time) = 0 THEN
        SET NEW.arrival_time = '00:00:00';
    ELSEIF LENGTH(NEW.arrival_time) = 5 THEN
        SET NEW.arrival_time = CONCACT(NEW.arrival_time, ':00');
    END IF;

    SET NEW.arrival_time_seconds = 0;
        
    IF LENGTH(NEW.arrival_time) = 8 THEN BEGIN
        -- Format: HH:MM:SS
        SET @HH = CONVERT(SUBSTRING(NEW.arrival_time, 1, 2), UNSIGNED INTEGER);
        SET @MM = CONVERT(SUBSTRING(NEW.arrival_time, 4, 2), UNSIGNED INTEGER);
        SET @SS = CONVERT(SUBSTRING(NEW.arrival_time, 7, 2), UNSIGNED INTEGER);
        
        SET NEW.arrival_time_seconds = @SS + (@MM * 60) + (@HH * 3600);
    END; END IF;


    IF LENGTH(NEW.departure_time) = 0 THEN
        SET NEW.departure_time = '00:00:00';
    ELSEIF LENGTH(NEW.departure_time) = 5 THEN
        SET NEW.departure_time = CONCACT(NEW.departure_time, ':00');
    END IF;

    SET NEW.departure_time_seconds = 0;

    IF LENGTH(NEW.departure_time) = 8 THEN BEGIN
        -- Format: HH:MM:SS
        SET @HH = CONVERT(SUBSTRING(NEW.departure_time, 1, 2), UNSIGNED INTEGER);
        SET @MM = CONVERT(SUBSTRING(NEW.departure_time, 4, 2), UNSIGNED INTEGER);
        SET @SS = CONVERT(SUBSTRING(NEW.departure_time, 7, 2), UNSIGNED INTEGER);
        
        SET NEW.departure_time_seconds = @SS + (@MM * 60) + (@HH * 3600);
    END; END IF;
END$$
DELIMITER ;
