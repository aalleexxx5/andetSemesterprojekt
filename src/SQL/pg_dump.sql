--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: webshop_db; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE webshop_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';


ALTER DATABASE webshop_db OWNER TO postgres;

\connect webshop_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: account; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA account;


ALTER SCHEMA account OWNER TO postgres;

--
-- Name: catalog; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA catalog;


ALTER SCHEMA catalog OWNER TO postgres;

--
-- Name: world; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA world;


ALTER SCHEMA world OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = account, pg_catalog;

--
-- Name: lower_name(); Type: FUNCTION; Schema: account; Owner: postgres
--

CREATE FUNCTION lower_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  -- Insert new column
  IF( tg_op ='INSERT' ) THEN
    NEW.name = LOWER(NEW.name);
    RETURN NEW;
    
  -- Updating a column
  ELSEIF( tg_op = 'UPDATE' ) THEN
    NEW.name = LOWER(NEW.name);
    RETURN NEW;
  END IF;

END
  $$;


ALTER FUNCTION account.lower_name() OWNER TO postgres;

SET search_path = catalog, pg_catalog;

--
-- Name: product_list_assoc_getprice(); Type: FUNCTION; Schema: catalog; Owner: postgres
--

CREATE FUNCTION product_list_assoc_getprice() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  SELECT price INTO NEW.price FROM catalog.product WHERE catalog.product.identities = NEW.product;

  RETURN NEW;
END;
$$;


ALTER FUNCTION catalog.product_list_assoc_getprice() OWNER TO postgres;

SET search_path = account, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: orders; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE orders (
    identities integer NOT NULL,
    profile_info integer NOT NULL,
    order_status integer NOT NULL,
    "timestamp" date DEFAULT now() NOT NULL,
    product_list integer NOT NULL
);


ALTER TABLE orders OWNER TO postgres;

--
-- Name: orders_identities_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE orders_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders_identities_seq OWNER TO postgres;

--
-- Name: orders_identities_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE orders_identities_seq OWNED BY orders.identities;


--
-- Name: orders_status; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE orders_status (
    identities integer NOT NULL,
    status text NOT NULL
);


ALTER TABLE orders_status OWNER TO postgres;

--
-- Name: orders_status_identities_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE orders_status_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders_status_identities_seq OWNER TO postgres;

--
-- Name: orders_status_identities_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE orders_status_identities_seq OWNED BY orders_status.identities;


--
-- Name: person_firstnames; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE person_firstnames (
    identities integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE person_firstnames OWNER TO postgres;

--
-- Name: person_lastnames; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE person_lastnames (
    identities integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE person_lastnames OWNER TO postgres;

--
-- Name: person_names; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE person_names (
    identities integer NOT NULL,
    firstname integer,
    middlename text,
    lastname integer
);


ALTER TABLE person_names OWNER TO postgres;

--
-- Name: person_names_view; Type: VIEW; Schema: account; Owner: postgres
--

CREATE VIEW person_names_view AS
 SELECT person_name.identities AS identity,
    firstnames.name AS first_names,
    person_name.middlename AS middle_names,
    lastnames.name AS last_names
   FROM ((person_names person_name
     JOIN person_firstnames firstnames ON ((person_name.firstname = firstnames.identities)))
     JOIN person_lastnames lastnames ON ((person_name.lastname = lastnames.identities)));


ALTER TABLE person_names_view OWNER TO postgres;

--
-- Name: people_names_view; Type: VIEW; Schema: account; Owner: postgres
--

CREATE VIEW people_names_view AS
 SELECT v.identity AS identities,
    (((initcap(v.first_names) || concat((' '::text || initcap(v.middle_names)))) || ' '::text) || initcap(v.last_names)) AS person_names
   FROM person_names_view v;


ALTER TABLE people_names_view OWNER TO postgres;

--
-- Name: person_firstnames_identities_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE person_firstnames_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person_firstnames_identities_seq OWNER TO postgres;

--
-- Name: person_firstnames_identities_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE person_firstnames_identities_seq OWNED BY person_firstnames.identities;


--
-- Name: person_lastnames_identities_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE person_lastnames_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person_lastnames_identities_seq OWNER TO postgres;

--
-- Name: person_lastnames_identities_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE person_lastnames_identities_seq OWNED BY person_lastnames.identities;


--
-- Name: person_names_identity_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE person_names_identity_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person_names_identity_seq OWNER TO postgres;

--
-- Name: person_names_identity_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE person_names_identity_seq OWNED BY person_names.identities;


--
-- Name: profile_header; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE profile_header (
    identities bigint NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    salt text NOT NULL
);


ALTER TABLE profile_header OWNER TO postgres;

--
-- Name: profile_information; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE profile_information (
    identities bigint NOT NULL,
    ref_user bigint NOT NULL,
    ref_person_name integer NOT NULL,
    ref_address integer NOT NULL,
    ref_phone bigint NOT NULL
);


ALTER TABLE profile_information OWNER TO postgres;

SET search_path = world, pg_catalog;

--
-- Name: address; Type: TABLE; Schema: world; Owner: postgres
--

CREATE TABLE address (
    identities bigint NOT NULL,
    country smallint NOT NULL,
    post_address integer NOT NULL,
    city bigint NOT NULL,
    street bigint NOT NULL,
    address_number integer NOT NULL,
    apartment_place smallint,
    floor integer
);


ALTER TABLE address OWNER TO postgres;

--
-- Name: apartment; Type: TABLE; Schema: world; Owner: postgres
--

CREATE TABLE apartment (
    identities smallint NOT NULL,
    content text NOT NULL
);


ALTER TABLE apartment OWNER TO postgres;

--
-- Name: cities; Type: TABLE; Schema: world; Owner: postgres
--

CREATE TABLE cities (
    identities bigint NOT NULL,
    content text NOT NULL
);


ALTER TABLE cities OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: world; Owner: postgres
--

CREATE TABLE countries (
    identities smallint NOT NULL,
    name text NOT NULL,
    acronym text
);


ALTER TABLE countries OWNER TO postgres;

--
-- Name: postal_code; Type: TABLE; Schema: world; Owner: postgres
--

CREATE TABLE postal_code (
    identities integer NOT NULL,
    content text NOT NULL
);


ALTER TABLE postal_code OWNER TO postgres;

--
-- Name: street; Type: TABLE; Schema: world; Owner: postgres
--

CREATE TABLE street (
    identities bigint NOT NULL,
    content text NOT NULL
);


ALTER TABLE street OWNER TO postgres;

--
-- Name: world_address_view; Type: VIEW; Schema: world; Owner: postgres
--

CREATE VIEW world_address_view AS
 SELECT ad.identities,
    country.name AS countries,
    postcode.content AS postal_codes,
    city.content AS cities,
    street.content AS streets,
    ad.address_number AS address_numbers,
    ad.floor AS floors,
    place.content AS apartment
   FROM (((((address ad
     JOIN countries country ON ((ad.country = country.identities)))
     JOIN postal_code postcode ON ((ad.post_address = postcode.identities)))
     JOIN cities city ON ((ad.city = city.identities)))
     JOIN street street ON ((ad.street = street.identities)))
     LEFT JOIN apartment place ON ((ad.apartment_place = place.identities)));


ALTER TABLE world_address_view OWNER TO postgres;

--
-- Name: address_view; Type: VIEW; Schema: world; Owner: postgres
--

CREATE VIEW address_view AS
 SELECT address_view.identities,
    initcap(address_view.countries) AS countries,
    address_view.postal_codes,
    ((((initcap(address_view.streets) || ' '::text) || address_view.address_numbers) || ' '::text) || concat((address_view.floors || upper(address_view.apartment)))) AS address
   FROM world_address_view address_view;


ALTER TABLE address_view OWNER TO postgres;

--
-- Name: country_codes; Type: TABLE; Schema: world; Owner: postgres
--

CREATE TABLE country_codes (
    identities smallint NOT NULL,
    country smallint NOT NULL,
    code character varying(4) NOT NULL
);


ALTER TABLE country_codes OWNER TO postgres;

--
-- Name: phone_numbers; Type: TABLE; Schema: world; Owner: postgres
--

CREATE TABLE phone_numbers (
    identities bigint NOT NULL,
    country_code smallint NOT NULL,
    phone_number character varying(12) NOT NULL
);


ALTER TABLE phone_numbers OWNER TO postgres;

--
-- Name: phone_numbers_view; Type: VIEW; Schema: world; Owner: postgres
--

CREATE VIEW phone_numbers_view AS
 SELECT pn.identities,
    ((('+'::text || (cc.code)::text) || ' '::text) || (pn.phone_number)::text) AS numbers
   FROM (phone_numbers pn
     JOIN country_codes cc ON ((pn.country_code = cc.identities)));


ALTER TABLE phone_numbers_view OWNER TO postgres;

SET search_path = account, pg_catalog;

--
-- Name: profile; Type: VIEW; Schema: account; Owner: postgres
--

CREATE VIEW profile AS
 SELECT prof.identities,
    prof.username,
    pname.person_names,
    addr.address,
    addr.countries,
    addr.postal_codes,
    phone.numbers
   FROM ((((profile_header prof
     JOIN profile_information infor ON ((prof.identities = infor.ref_user)))
     JOIN people_names_view pname ON ((infor.ref_user = pname.identities)))
     JOIN world.address_view addr ON ((infor.ref_address = addr.identities)))
     JOIN world.phone_numbers_view phone ON ((infor.ref_phone = phone.identities)));


ALTER TABLE profile OWNER TO postgres;

--
-- Name: profile_informations_view; Type: VIEW; Schema: account; Owner: postgres
--

CREATE VIEW profile_informations_view AS
 SELECT prof_info.identities,
    peoples.person_names,
    prof_info.ref_user,
    av.postal_codes,
    av.countries,
    av.address,
    pn.numbers
   FROM (((profile_information prof_info
     JOIN people_names_view peoples ON ((peoples.identities = prof_info.ref_person_name)))
     JOIN world.phone_numbers_view pn ON ((prof_info.ref_phone = pn.identities)))
     JOIN world.address_view av ON ((prof_info.ref_address = av.identities)));


ALTER TABLE profile_informations_view OWNER TO postgres;

--
-- Name: user_identities_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE user_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_identities_seq OWNER TO postgres;

--
-- Name: user_identities_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE user_identities_seq OWNED BY profile_header.identities;


--
-- Name: user_information_identities_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE user_information_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_information_identities_seq OWNER TO postgres;

--
-- Name: user_information_identities_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE user_information_identities_seq OWNED BY profile_information.identities;


SET search_path = catalog, pg_catalog;

--
-- Name: product; Type: TABLE; Schema: catalog; Owner: postgres
--

CREATE TABLE product (
    name text DEFAULT 'Product'::text NOT NULL,
    price double precision NOT NULL,
    category integer NOT NULL,
    identities integer NOT NULL
);


ALTER TABLE product OWNER TO postgres;

--
-- Name: product_category; Type: TABLE; Schema: catalog; Owner: postgres
--

CREATE TABLE product_category (
    name text NOT NULL,
    identities integer NOT NULL
);


ALTER TABLE product_category OWNER TO postgres;

--
-- Name: product_category_identities_seq; Type: SEQUENCE; Schema: catalog; Owner: postgres
--

CREATE SEQUENCE product_category_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_category_identities_seq OWNER TO postgres;

--
-- Name: product_category_identities_seq; Type: SEQUENCE OWNED BY; Schema: catalog; Owner: postgres
--

ALTER SEQUENCE product_category_identities_seq OWNED BY product_category.identities;


--
-- Name: product_identities_seq; Type: SEQUENCE; Schema: catalog; Owner: postgres
--

CREATE SEQUENCE product_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_identities_seq OWNER TO postgres;

--
-- Name: product_identities_seq; Type: SEQUENCE OWNED BY; Schema: catalog; Owner: postgres
--

ALTER SEQUENCE product_identities_seq OWNED BY product.identities;


--
-- Name: product_list; Type: TABLE; Schema: catalog; Owner: postgres
--

CREATE TABLE product_list (
    identities integer NOT NULL
);


ALTER TABLE product_list OWNER TO postgres;

--
-- Name: product_list_associated; Type: TABLE; Schema: catalog; Owner: postgres
--

CREATE TABLE product_list_associated (
    amount integer DEFAULT 0 NOT NULL,
    price double precision DEFAULT 0.0 NOT NULL,
    product integer NOT NULL,
    list integer NOT NULL,
    identities integer NOT NULL
);


ALTER TABLE product_list_associated OWNER TO postgres;

--
-- Name: product_list_associated_identities_seq; Type: SEQUENCE; Schema: catalog; Owner: postgres
--

CREATE SEQUENCE product_list_associated_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_list_associated_identities_seq OWNER TO postgres;

--
-- Name: product_list_associated_identities_seq; Type: SEQUENCE OWNED BY; Schema: catalog; Owner: postgres
--

ALTER SEQUENCE product_list_associated_identities_seq OWNED BY product_list_associated.identities;


--
-- Name: product_list_identities_seq; Type: SEQUENCE; Schema: catalog; Owner: postgres
--

CREATE SEQUENCE product_list_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_list_identities_seq OWNER TO postgres;

--
-- Name: product_list_identities_seq; Type: SEQUENCE OWNED BY; Schema: catalog; Owner: postgres
--

ALTER SEQUENCE product_list_identities_seq OWNED BY product_list.identities;


SET search_path = public, pg_catalog;

--
-- Name: product_categories; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW product_categories AS
 SELECT product_category.identities,
    product_category.name AS categories
   FROM catalog.product_category;


ALTER TABLE product_categories OWNER TO postgres;

--
-- Name: products; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW products AS
 SELECT product.identities,
    product.name AS product_names,
    product.price,
    categories.name
   FROM (catalog.product
     JOIN catalog.product_category categories ON ((product.category = categories.identities)));


ALTER TABLE products OWNER TO postgres;

SET search_path = world, pg_catalog;

--
-- Name: address_country_seq; Type: SEQUENCE; Schema: world; Owner: postgres
--

CREATE SEQUENCE address_country_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE address_country_seq OWNER TO postgres;

--
-- Name: address_country_seq; Type: SEQUENCE OWNED BY; Schema: world; Owner: postgres
--

ALTER SEQUENCE address_country_seq OWNED BY address.country;


--
-- Name: address_identities_seq; Type: SEQUENCE; Schema: world; Owner: postgres
--

CREATE SEQUENCE address_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE address_identities_seq OWNER TO postgres;

--
-- Name: address_identities_seq; Type: SEQUENCE OWNED BY; Schema: world; Owner: postgres
--

ALTER SEQUENCE address_identities_seq OWNED BY address.identities;


--
-- Name: address_street_seq; Type: SEQUENCE; Schema: world; Owner: postgres
--

CREATE SEQUENCE address_street_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE address_street_seq OWNER TO postgres;

--
-- Name: address_street_seq; Type: SEQUENCE OWNED BY; Schema: world; Owner: postgres
--

ALTER SEQUENCE address_street_seq OWNED BY address.street;


--
-- Name: apartment_identities_seq; Type: SEQUENCE; Schema: world; Owner: postgres
--

CREATE SEQUENCE apartment_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE apartment_identities_seq OWNER TO postgres;

--
-- Name: apartment_identities_seq; Type: SEQUENCE OWNED BY; Schema: world; Owner: postgres
--

ALTER SEQUENCE apartment_identities_seq OWNED BY apartment.identities;


--
-- Name: cities_identities_seq; Type: SEQUENCE; Schema: world; Owner: postgres
--

CREATE SEQUENCE cities_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cities_identities_seq OWNER TO postgres;

--
-- Name: cities_identities_seq; Type: SEQUENCE OWNED BY; Schema: world; Owner: postgres
--

ALTER SEQUENCE cities_identities_seq OWNED BY cities.identities;


--
-- Name: countries_identities_seq; Type: SEQUENCE; Schema: world; Owner: postgres
--

CREATE SEQUENCE countries_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE countries_identities_seq OWNER TO postgres;

--
-- Name: countries_identities_seq; Type: SEQUENCE OWNED BY; Schema: world; Owner: postgres
--

ALTER SEQUENCE countries_identities_seq OWNED BY countries.identities;


--
-- Name: country_codes_identities_seq; Type: SEQUENCE; Schema: world; Owner: postgres
--

CREATE SEQUENCE country_codes_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE country_codes_identities_seq OWNER TO postgres;

--
-- Name: country_codes_identities_seq; Type: SEQUENCE OWNED BY; Schema: world; Owner: postgres
--

ALTER SEQUENCE country_codes_identities_seq OWNED BY country_codes.identities;


--
-- Name: phone_numbers_identities_seq; Type: SEQUENCE; Schema: world; Owner: postgres
--

CREATE SEQUENCE phone_numbers_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE phone_numbers_identities_seq OWNER TO postgres;

--
-- Name: phone_numbers_identities_seq; Type: SEQUENCE OWNED BY; Schema: world; Owner: postgres
--

ALTER SEQUENCE phone_numbers_identities_seq OWNED BY phone_numbers.identities;


--
-- Name: postal_code_identities_seq; Type: SEQUENCE; Schema: world; Owner: postgres
--

CREATE SEQUENCE postal_code_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE postal_code_identities_seq OWNER TO postgres;

--
-- Name: postal_code_identities_seq; Type: SEQUENCE OWNED BY; Schema: world; Owner: postgres
--

ALTER SEQUENCE postal_code_identities_seq OWNED BY postal_code.identities;


--
-- Name: street_identities_seq; Type: SEQUENCE; Schema: world; Owner: postgres
--

CREATE SEQUENCE street_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE street_identities_seq OWNER TO postgres;

--
-- Name: street_identities_seq; Type: SEQUENCE OWNED BY; Schema: world; Owner: postgres
--

ALTER SEQUENCE street_identities_seq OWNED BY street.identities;


SET search_path = account, pg_catalog;

--
-- Name: orders identities; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY orders ALTER COLUMN identities SET DEFAULT nextval('orders_identities_seq'::regclass);


--
-- Name: orders_status identities; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY orders_status ALTER COLUMN identities SET DEFAULT nextval('orders_status_identities_seq'::regclass);


--
-- Name: person_firstnames identities; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY person_firstnames ALTER COLUMN identities SET DEFAULT nextval('person_firstnames_identities_seq'::regclass);


--
-- Name: person_lastnames identities; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY person_lastnames ALTER COLUMN identities SET DEFAULT nextval('person_lastnames_identities_seq'::regclass);


--
-- Name: person_names identities; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY person_names ALTER COLUMN identities SET DEFAULT nextval('person_names_identity_seq'::regclass);


--
-- Name: profile_header identities; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_header ALTER COLUMN identities SET DEFAULT nextval('user_identities_seq'::regclass);


--
-- Name: profile_information identities; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_information ALTER COLUMN identities SET DEFAULT nextval('user_information_identities_seq'::regclass);


SET search_path = catalog, pg_catalog;

--
-- Name: product identities; Type: DEFAULT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product ALTER COLUMN identities SET DEFAULT nextval('product_identities_seq'::regclass);


--
-- Name: product_category identities; Type: DEFAULT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product_category ALTER COLUMN identities SET DEFAULT nextval('product_category_identities_seq'::regclass);


--
-- Name: product_list identities; Type: DEFAULT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product_list ALTER COLUMN identities SET DEFAULT nextval('product_list_identities_seq'::regclass);


--
-- Name: product_list_associated identities; Type: DEFAULT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product_list_associated ALTER COLUMN identities SET DEFAULT nextval('product_list_associated_identities_seq'::regclass);


SET search_path = world, pg_catalog;

--
-- Name: address identities; Type: DEFAULT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY address ALTER COLUMN identities SET DEFAULT nextval('address_identities_seq'::regclass);


--
-- Name: address country; Type: DEFAULT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY address ALTER COLUMN country SET DEFAULT nextval('address_country_seq'::regclass);


--
-- Name: address street; Type: DEFAULT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY address ALTER COLUMN street SET DEFAULT nextval('address_street_seq'::regclass);


--
-- Name: apartment identities; Type: DEFAULT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY apartment ALTER COLUMN identities SET DEFAULT nextval('apartment_identities_seq'::regclass);


--
-- Name: cities identities; Type: DEFAULT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY cities ALTER COLUMN identities SET DEFAULT nextval('cities_identities_seq'::regclass);


--
-- Name: countries identities; Type: DEFAULT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY countries ALTER COLUMN identities SET DEFAULT nextval('countries_identities_seq'::regclass);


--
-- Name: country_codes identities; Type: DEFAULT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY country_codes ALTER COLUMN identities SET DEFAULT nextval('country_codes_identities_seq'::regclass);


--
-- Name: phone_numbers identities; Type: DEFAULT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY phone_numbers ALTER COLUMN identities SET DEFAULT nextval('phone_numbers_identities_seq'::regclass);


--
-- Name: postal_code identities; Type: DEFAULT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY postal_code ALTER COLUMN identities SET DEFAULT nextval('postal_code_identities_seq'::regclass);


--
-- Name: street identities; Type: DEFAULT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY street ALTER COLUMN identities SET DEFAULT nextval('street_identities_seq'::regclass);


SET search_path = account, pg_catalog;

--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (identities);


--
-- Name: orders_status orders_status_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY orders_status
    ADD CONSTRAINT orders_status_pkey PRIMARY KEY (identities);


--
-- Name: person_firstnames person_firstnames_name_key; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY person_firstnames
    ADD CONSTRAINT person_firstnames_name_key UNIQUE (name);


--
-- Name: person_firstnames person_firstnames_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY person_firstnames
    ADD CONSTRAINT person_firstnames_pkey PRIMARY KEY (identities);


--
-- Name: person_lastnames person_lastnames_name_key; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY person_lastnames
    ADD CONSTRAINT person_lastnames_name_key UNIQUE (name);


--
-- Name: person_lastnames person_lastnames_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY person_lastnames
    ADD CONSTRAINT person_lastnames_pkey PRIMARY KEY (identities);


--
-- Name: person_names person_names_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY person_names
    ADD CONSTRAINT person_names_pkey PRIMARY KEY (identities);


--
-- Name: profile_information user_information_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_information
    ADD CONSTRAINT user_information_pkey PRIMARY KEY (identities);


--
-- Name: profile_information user_information_ref_user_key; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_information
    ADD CONSTRAINT user_information_ref_user_key UNIQUE (ref_user);


--
-- Name: profile_header user_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_header
    ADD CONSTRAINT user_pkey PRIMARY KEY (identities);


--
-- Name: profile_header user_username_key; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_header
    ADD CONSTRAINT user_username_key UNIQUE (username);


SET search_path = catalog, pg_catalog;

--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (identities);


--
-- Name: product_list_associated product_list_associated_pkey; Type: CONSTRAINT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product_list_associated
    ADD CONSTRAINT product_list_associated_pkey PRIMARY KEY (identities);


--
-- Name: product_list product_list_pkey; Type: CONSTRAINT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product_list
    ADD CONSTRAINT product_list_pkey PRIMARY KEY (identities);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (identities);


SET search_path = world, pg_catalog;

--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (identities);


--
-- Name: apartment apartment_content_key; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY apartment
    ADD CONSTRAINT apartment_content_key UNIQUE (content);


--
-- Name: apartment apartment_pkey; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY apartment
    ADD CONSTRAINT apartment_pkey PRIMARY KEY (identities);


--
-- Name: cities cities_content_key; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_content_key UNIQUE (content);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (identities);


--
-- Name: countries countries_name_key; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_name_key UNIQUE (name);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (identities);


--
-- Name: country_codes country_codes_code_key; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY country_codes
    ADD CONSTRAINT country_codes_code_key UNIQUE (code);


--
-- Name: country_codes country_codes_pkey; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY country_codes
    ADD CONSTRAINT country_codes_pkey PRIMARY KEY (identities);


--
-- Name: phone_numbers phone_numbers_pkey; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY phone_numbers
    ADD CONSTRAINT phone_numbers_pkey PRIMARY KEY (identities);


--
-- Name: postal_code postal_code_content_key; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY postal_code
    ADD CONSTRAINT postal_code_content_key UNIQUE (content);


--
-- Name: postal_code postal_code_pkey; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY postal_code
    ADD CONSTRAINT postal_code_pkey PRIMARY KEY (identities);


--
-- Name: street street_content_key; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY street
    ADD CONSTRAINT street_content_key UNIQUE (content);


--
-- Name: street street_pkey; Type: CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY street
    ADD CONSTRAINT street_pkey PRIMARY KEY (identities);


SET search_path = account, pg_catalog;

--
-- Name: firstnames_index; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX firstnames_index ON person_firstnames USING btree (identities, name);


--
-- Name: lastnames_index; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX lastnames_index ON person_lastnames USING btree (identities, name);


--
-- Name: person_names_index; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX person_names_index ON person_names USING btree (identities, firstname, middlename, lastname);


--
-- Name: users_indexed; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX users_indexed ON profile_header USING btree (identities, username, password, salt);


--
-- Name: users_profile_information_index; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX users_profile_information_index ON profile_information USING btree (identities, ref_user, ref_person_name, ref_address, ref_phone);


SET search_path = world, pg_catalog;

--
-- Name: world_address_apartment_indexed; Type: INDEX; Schema: world; Owner: postgres
--

CREATE INDEX world_address_apartment_indexed ON apartment USING btree (identities, content);


--
-- Name: world_address_cities_indexed; Type: INDEX; Schema: world; Owner: postgres
--

CREATE INDEX world_address_cities_indexed ON cities USING btree (identities, content);


--
-- Name: world_address_countries_indexed; Type: INDEX; Schema: world; Owner: postgres
--

CREATE INDEX world_address_countries_indexed ON countries USING btree (identities, name, acronym);


--
-- Name: world_address_country_codes_indexed; Type: INDEX; Schema: world; Owner: postgres
--

CREATE INDEX world_address_country_codes_indexed ON country_codes USING btree (identities, country, code);


--
-- Name: world_countries_indexed; Type: INDEX; Schema: world; Owner: postgres
--

CREATE INDEX world_countries_indexed ON countries USING btree (identities, name, acronym);


--
-- Name: world_phone_numbers_index; Type: INDEX; Schema: world; Owner: postgres
--

CREATE INDEX world_phone_numbers_index ON phone_numbers USING btree (identities, country_code, phone_number);


--
-- Name: world_street_indexed; Type: INDEX; Schema: world; Owner: postgres
--

CREATE INDEX world_street_indexed ON street USING btree (identities, content);


SET search_path = account, pg_catalog;

--
-- Name: person_firstnames firstname_lowername; Type: TRIGGER; Schema: account; Owner: postgres
--

CREATE TRIGGER firstname_lowername BEFORE INSERT OR UPDATE ON person_firstnames FOR EACH ROW EXECUTE PROCEDURE lower_name();


--
-- Name: person_lastnames lastname_lowername; Type: TRIGGER; Schema: account; Owner: postgres
--

CREATE TRIGGER lastname_lowername BEFORE INSERT OR UPDATE ON person_lastnames FOR EACH ROW EXECUTE PROCEDURE lower_name();


SET search_path = catalog, pg_catalog;

--
-- Name: product_list_associated product_list_assoc_trigger; Type: TRIGGER; Schema: catalog; Owner: postgres
--

CREATE TRIGGER product_list_assoc_trigger BEFORE INSERT OR UPDATE ON product_list_associated FOR EACH ROW EXECUTE PROCEDURE product_list_assoc_getprice();


SET search_path = account, pg_catalog;

--
-- Name: orders orders_order_status_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_order_status_fkey FOREIGN KEY (order_status) REFERENCES orders_status(identities);


--
-- Name: orders orders_product_list_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_product_list_fkey FOREIGN KEY (product_list) REFERENCES catalog.product_list(identities);


--
-- Name: orders orders_profile_info_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_profile_info_fkey FOREIGN KEY (profile_info) REFERENCES profile_information(identities);


--
-- Name: person_names person_names_firstname_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY person_names
    ADD CONSTRAINT person_names_firstname_fkey FOREIGN KEY (firstname) REFERENCES person_firstnames(identities);


--
-- Name: person_names person_names_lastname_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY person_names
    ADD CONSTRAINT person_names_lastname_fkey FOREIGN KEY (lastname) REFERENCES person_lastnames(identities);


--
-- Name: profile_information user_information_ref_address_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_information
    ADD CONSTRAINT user_information_ref_address_fkey FOREIGN KEY (ref_address) REFERENCES world.address(identities);


--
-- Name: profile_information user_information_ref_person_name_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_information
    ADD CONSTRAINT user_information_ref_person_name_fkey FOREIGN KEY (ref_person_name) REFERENCES person_names(identities);


--
-- Name: profile_information user_information_ref_phone_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_information
    ADD CONSTRAINT user_information_ref_phone_fkey FOREIGN KEY (ref_phone) REFERENCES world.phone_numbers(identities);


--
-- Name: profile_information user_information_ref_user_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_information
    ADD CONSTRAINT user_information_ref_user_fkey FOREIGN KEY (ref_user) REFERENCES profile_header(identities);


SET search_path = catalog, pg_catalog;

--
-- Name: product product_catagory_fkey; Type: FK CONSTRAINT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_catagory_fkey FOREIGN KEY (category) REFERENCES product_category(identities);


--
-- Name: product_list_associated product_list_associated_list_fkey; Type: FK CONSTRAINT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product_list_associated
    ADD CONSTRAINT product_list_associated_list_fkey FOREIGN KEY (list) REFERENCES product_list(identities);


--
-- Name: product_list_associated product_list_associated_product_fkey; Type: FK CONSTRAINT; Schema: catalog; Owner: postgres
--

ALTER TABLE ONLY product_list_associated
    ADD CONSTRAINT product_list_associated_product_fkey FOREIGN KEY (product) REFERENCES product(identities);


SET search_path = world, pg_catalog;

--
-- Name: address address_apartment_place_fkey; Type: FK CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_apartment_place_fkey FOREIGN KEY (apartment_place) REFERENCES apartment(identities);


--
-- Name: address address_city_fkey; Type: FK CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_city_fkey FOREIGN KEY (city) REFERENCES cities(identities);


--
-- Name: address address_country_fkey; Type: FK CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_country_fkey FOREIGN KEY (country) REFERENCES countries(identities);


--
-- Name: address address_post_address_fkey; Type: FK CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_post_address_fkey FOREIGN KEY (post_address) REFERENCES postal_code(identities);


--
-- Name: address address_street_fkey; Type: FK CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_street_fkey FOREIGN KEY (street) REFERENCES street(identities);


--
-- Name: country_codes country_codes_country_fkey; Type: FK CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY country_codes
    ADD CONSTRAINT country_codes_country_fkey FOREIGN KEY (country) REFERENCES countries(identities);


--
-- Name: phone_numbers phone_numbers_country_code_fkey; Type: FK CONSTRAINT; Schema: world; Owner: postgres
--

ALTER TABLE ONLY phone_numbers
    ADD CONSTRAINT phone_numbers_country_code_fkey FOREIGN KEY (country_code) REFERENCES country_codes(identities);


--
-- PostgreSQL database dump complete
--

