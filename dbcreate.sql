CREATE DATABASE cth CHARACTER SET utf8 COLLATE utf8_general_ci;

create table `font` (
	`id` integer unsigned not null auto_increment,
	`version` integer unsigned not null default 1,
	`font_name` varchar(64) not null,
	`font_desc` text not null,
	`weight` integer not null,
	`file` varchar(128) not null,
	`status` varchar(10) not null default 'A',
	primary key (`id`),
	unique (`font_name`),
	index using btree (`weight`)
); 

create table `dictionary` (
	`id` varchar(128) not null,
	`word` varchar(128) not null,
	`tags` text,
	`category` varchar(64) not null default 'general',
	`simpl_ch` varchar(20),
	`trad_ch` varchar(20) not null,
	`safe_status` int not null default 0,
	`audit` int not null default 0, 
	`warning` text,
	primary key (`id`),
	index using hash (`tags`(100)),
	index using hash(`category`)
);

create table `download_history` (
	`id` bigint(10) unsigned not null auto_increment,
	`word` varchar(128) not null,
	`font_id` integer unsigned not null,
	`source_id` integer unsigned not null,
	`device_id` integer unsigned not null,
	`dl_date` timestamp default CURRENT_TIMESTAMP,
	primary key(`id`),
	index using hash(`word`),
	index using hash(`font_id`)
);
