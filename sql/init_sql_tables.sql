CREATE DATABASE IF NOT EXISTS weather_formatted_sample;
USE weather_formatted_sample;

CREATE TABLE IF NOT EXISTS weather_stage (stationId CHAR(12), date DATE, tmin SMALLINT, tmax SMALLINT, snow SMALLINT, snwd SMALLINT, prcp SMALLINT);
CREATE TABLE IF NOT EXISTS weather (stationId CHAR(12), date DATE, tmin SMALLINT, tmax SMALLINT, snow SMALLINT, snwd SMALLINT, prcp SMALLINT, PRIMARY KEY(stationId, date));


