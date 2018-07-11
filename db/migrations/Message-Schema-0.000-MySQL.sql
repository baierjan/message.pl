-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Mon Jul  9 14:42:19 2018
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS author;

--
-- Table: author
--
CREATE TABLE author (
  id integer NOT NULL auto_increment,
  nick varchar(64) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS label;

--
-- Table: label
--
CREATE TABLE label (
  id integer NOT NULL auto_increment,
  name text NOT NULL,
  parent_id integer NOT NULL,
  INDEX label_idx_parent_id (parent_id),
  PRIMARY KEY (id),
  CONSTRAINT label_fk_parent_id FOREIGN KEY (parent_id) REFERENCES label (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS message;

--
-- Table: message
--
CREATE TABLE message (
  id integer NOT NULL auto_increment,
  label_id integer NOT NULL,
  author_id integer NOT NULL,
  text text NOT NULL,
  datetime datetime NOT NULL DEFAULT now(),
  useragent text NOT NULL,
  client_ip varchar(64) NOT NULL,
  INDEX message_idx_author_id (author_id),
  INDEX message_idx_label_id (label_id),
  PRIMARY KEY (id),
  CONSTRAINT message_fk_author_id FOREIGN KEY (author_id) REFERENCES author (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT message_fk_label_id FOREIGN KEY (label_id) REFERENCES label (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks=1;

