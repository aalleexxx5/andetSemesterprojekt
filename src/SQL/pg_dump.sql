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


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = account, pg_catalog;

--
-- Name: encrypt_password(); Type: FUNCTION; Schema: account; Owner: postgres
--

CREATE FUNCTION encrypt_password() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF ( tg_op = 'INSERT' )
    THEN
    -- Generate SALT
      NEW.salt = gen_salt('bf');

      -- Generate Password
      NEW.password = crypt(NEW.password, NEW.salt);
    RETURN NEW;
    ELSEIF ( tg_op = 'UPDATE' ) THEN

      -- If not Empty, then
      IF ( NEW.password != old.password )
        THEN
        -- Generate SALT
        NEW.salt = gen_salt('bf');

        -- Generate Password
        NEW.password = crypt(NEW.password, NEW.salt);

        RETURN NEW;

      END IF;

  END IF;
  
  RETURN New;

END;
$$;


ALTER FUNCTION account.encrypt_password() OWNER TO postgres;

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
    order_status integer NOT NULL,
    "timestamp" date DEFAULT now() NOT NULL,
    product_list integer NOT NULL,
    profile integer NOT NULL
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
-- Name: person_lastnames; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE person_lastnames (
    identities integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE person_lastnames OWNER TO postgres;

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
    salt text NOT NULL,
    privileges integer DEFAULT 1 NOT NULL
);


ALTER TABLE profile_header OWNER TO postgres;

--
-- Name: profile_privileges; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE profile_privileges (
    identities integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE profile_privileges OWNER TO postgres;

--
-- Name: profile_header_table; Type: VIEW; Schema: account; Owner: postgres
--

CREATE VIEW profile_header_table AS
 SELECT header.identities,
    header.username,
    header.password,
    header.salt,
    privilege.name
   FROM (profile_header header
     JOIN profile_privileges privilege ON ((header.privileges = privilege.identities)));


ALTER TABLE profile_header_table OWNER TO postgres;

--
-- Name: profile_information; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE profile_information (
    identities bigint NOT NULL,
    ref_user bigint NOT NULL,
    ref_person_name integer DEFAULT 33 NOT NULL,
    ref_address integer DEFAULT 4 NOT NULL,
    ref_phone bigint DEFAULT 4 NOT NULL,
    email text
);


ALTER TABLE profile_information OWNER TO postgres;

--
-- Name: vpeople_names_columns; Type: VIEW; Schema: account; Owner: postgres
--

CREATE VIEW vpeople_names_columns AS
 SELECT person_name.identities AS identity,
    firstnames.name AS first_names,
    person_name.middlename AS middle_names,
    lastnames.name AS last_names
   FROM ((person_names person_name
     JOIN person_firstnames firstnames ON ((person_name.firstname = firstnames.identities)))
     JOIN person_lastnames lastnames ON ((person_name.lastname = lastnames.identities)));


ALTER TABLE vpeople_names_columns OWNER TO postgres;

--
-- Name: vpeople_names_trunc; Type: VIEW; Schema: account; Owner: postgres
--

CREATE VIEW vpeople_names_trunc AS
 SELECT v.identity AS identities,
    (((initcap(v.first_names) || concat((' '::text || initcap(v.middle_names)))) || ' '::text) || initcap(v.last_names)) AS person_names
   FROM vpeople_names_columns v;


ALTER TABLE vpeople_names_trunc OWNER TO postgres;

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
-- Name: profile_information_table; Type: VIEW; Schema: account; Owner: postgres
--

CREATE VIEW profile_information_table AS
 SELECT info.identities,
    info.ref_user,
    names.person_names,
    info.email,
    addr.address,
    addr.postal_codes,
    phones.numbers
   FROM (((profile_information info
     JOIN vpeople_names_trunc names ON ((info.ref_person_name = names.identities)))
     JOIN world.address_view addr ON ((info.ref_address = addr.identities)))
     JOIN world.phone_numbers_view phones ON ((info.ref_phone = phones.identities)));


ALTER TABLE profile_information_table OWNER TO postgres;

--
-- Name: profile_privileges_identities_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE profile_privileges_identities_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE profile_privileges_identities_seq OWNER TO postgres;

--
-- Name: profile_privileges_identities_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE profile_privileges_identities_seq OWNED BY profile_privileges.identities;


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
-- Name: catalog; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW catalog AS
 SELECT product_category.name
   FROM catalog.product_category;


ALTER TABLE catalog OWNER TO postgres;

--
-- Name: products_table; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW products_table AS
 SELECT products.identities,
    products.name AS product_names,
    products.price,
    categories.name AS category_names
   FROM (catalog.product products
     JOIN catalog.product_category categories ON ((products.category = categories.identities)))
  ORDER BY products.name;


ALTER TABLE products_table OWNER TO postgres;

--
-- Name: profiles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW profiles AS
 SELECT head.identities,
    head.username AS usernames,
    head.password AS passwords,
    head.salt AS salts,
    head.name AS account_types,
    info.person_names,
    info.email AS emails,
    info.address,
    info.numbers
   FROM (account.profile_header_table head
     JOIN account.profile_information_table info ON ((head.identities = info.ref_user)));


ALTER TABLE profiles OWNER TO postgres;

--
-- Name: profile_names; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW profile_names AS
 SELECT profiles.usernames
   FROM profiles;


ALTER TABLE profile_names OWNER TO postgres;

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


--
-- Name: profile_privileges identities; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_privileges ALTER COLUMN identities SET DEFAULT nextval('profile_privileges_identities_seq'::regclass);


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
-- Data for Name: orders; Type: TABLE DATA; Schema: account; Owner: postgres
--

COPY orders (identities, order_status, "timestamp", product_list, profile) FROM stdin;
1	2	2017-05-28	1	1
\.


--
-- Name: orders_identities_seq; Type: SEQUENCE SET; Schema: account; Owner: postgres
--

SELECT pg_catalog.setval('orders_identities_seq', 1, true);


--
-- Data for Name: orders_status; Type: TABLE DATA; Schema: account; Owner: postgres
--

COPY orders_status (identities, status) FROM stdin;
1	packaging
2	delivered
3	freight
\.


--
-- Name: orders_status_identities_seq; Type: SEQUENCE SET; Schema: account; Owner: postgres
--

SELECT pg_catalog.setval('orders_status_identities_seq', 3, true);


--
-- Data for Name: person_firstnames; Type: TABLE DATA; Schema: account; Owner: postgres
--

COPY person_firstnames (identities, name) FROM stdin;
1	kent
2	musse
3	alex
4	mattias
5	sam
6	kevin
7	camilla
8	mads
9	mikkel
10	christian
13	dzenita
14	emil
15	jonas
16	simon
17	ditte
18	martin
19	thananya
20	mathias
21	jens
22	daniel
23	troels
27	niklas
28	malthe
29	glenn
30	marc
31	omar
32	thomas
33	asger
34	amalie
35	victor
37	persha
38	niels
48	kasper
49	andreas
50	rasmus
51	laura
52	matias
53	marie
54	maria
55	johan
60	alexander
61	nicolai
62	morten
63	jørgen
64	tobias
65	sebastian
66	rune
67	nicholas
68	malte
69	anders
70	jacob
71	jesper
78	kristian
79	mohammad
80	cecilie
81	hjalte
82	lasse
88	michael
89	kian
90	frederik
92	nha
93	hamzat
97	markus
98	cao
99	jonathan
100	niclas
101	alexandros
102	tuseef
103	sean
104	peter
105	peder
107	nerma
109	antonio
112	jakob
116	ditlev
117	steffen
118	stephen
119	phillip
122	per
123	sofie
124	chris
125	jungne
132	henrik
133	caroline
134	lilja
135	jeffery
136	stefan
137	eirikur
138	samuel
139	samoon
140	søren
142	sylvester
143	morena
144	ryan
145	jessica
146	wade
147	vanessa
148	mark
149	gideon
150	erica
151	karen
152	tory
153	isobel
154	allison
155	anna
156	rose
157	lynn
158	adria
159	alice
160	sara
161	chloe
162	maya
163	inara
164	maggie
165	rebecca
166	monica
167	hoyt
169	ed
170	edd
171	eddy
172	style
173	naika
174	taylor
175	kyle
176	randal
177	todd
178	isaac
179	ted
180	cindy
181	paul
182	walker
183	jason
186	stan
187	karsten
188	carsten
189	rachel
190	al
191	leslie
192	darcey
197	ben
198	rob
199	freddy
200	brad
201	victoria
202	john
203	jon
204	rick
205	tony
206	greg
209	david
210	anthony
211	jared
212	jensen
213	erik
214	kim
215	hanne
216	hanna
217	birgitte
218	james
220	patrik
221	dennis
11	heinrik
12	margrethe
207	vincent
222	nikolai
208	benedikte
223	danny
193	lauras
194	ulla
195	brittany
196	ghita
224	hillary
168	gavin
225	adolph
226	ada
227	adal
228	albert
229	adolf
230	aili
231	ailis
232	ald
233	aliz
234	alrick
36	samantha
235	jim
236	jimmy
237	lone
238	donald
239	bill
240	unknown
\.


--
-- Name: person_firstnames_identities_seq; Type: SEQUENCE SET; Schema: account; Owner: postgres
--

SELECT pg_catalog.setval('person_firstnames_identities_seq', 240, true);


--
-- Data for Name: person_lastnames; Type: TABLE DATA; Schema: account; Owner: postgres
--

COPY person_lastnames (identities, name) FROM stdin;
1	madsen
2	holberg
3	damsgaard
4	bahadori
5	al-ali
6	kennedy
7	kristiansen
8	thy
9	bytoft
10	arentsen
11	hallas
12	dreymann
13	koustrup
14	phromwongsa
15	rasmussen
16	hansen
17	johansen
18	hasic
19	navne
20	jørgensen
21	nielsen
22	bruun
23	harder
24	drescher
25	hawwash
26	dahl
27	steenfeldt
28	schmidt
29	stokholm
30	mølsted
31	jakobsen
32	boserup
33	dreier
34	truong
35	pedersen
36	sørensen
37	vinge
38	henriksen
332	iranii
40	rindom
41	hyrup
42	vejrum
43	matthiesen
44	sinding
45	klevang
46	søgaard
47	schou
48	javidan
49	huu
50	lagoni
51	ralskov
52	huynh
54	egebjerg
55	peter
56	clausen
57	skafte
58	beck
59	lunde
60	mosumgaard
61	lund
62	karambelas
63	langkilde
64	ahmad
65	schultz
66	davidsen
67	jacobsen
342	blyth
343	jensen
344	smith
345	tapdrup
72	alkhanov
73	holm
74	shanmugalingam
348	gates
77	tang
78	marquardt
82	koch
84	agger
85	langelund 
86	christensen
87	adilović
88	starup
89	lundin
90	struntze
317	losang
328	kumar
333	norby
334	jepsen
335	elner
336	hoff
337	lauritsen
338	thorup
340	englund
298	byskov
299	gluud
300	lascari
301	wulff
302	bisander
303	schneider
304	mohr
306	tøndering
307	selz
308	stoltenberg
309	stjerne
310	olsen
311	villefrance
312	skjold
313	toft
314	lykke
315	bach
316	bundgaard
318	munksbo
319	hansson
320	azizi
321	lindberg
322	larsen
323	vest
324	brøgger
325	thomassen
326	hauptmann
327	van dam
329	sif
330	sveinsdóttir
331	ingwersen
341	hoffmann
346	rowling
347	trump
349	unknown
\.


--
-- Name: person_lastnames_identities_seq; Type: SEQUENCE SET; Schema: account; Owner: postgres
--

SELECT pg_catalog.setval('person_lastnames_identities_seq', 349, true);


--
-- Data for Name: person_names; Type: TABLE DATA; Schema: account; Owner: postgres
--

COPY person_names (identities, firstname, middlename, lastname) FROM stdin;
1	1	vejrup	1
2	2	\N	5
3	5	emamverdikhan hoffmann	4
4	4	\N	3
5	3	\N	2
6	8	heimdal	8
7	6	\N	6
8	7	voigt	7
9	13	\N	18
10	9	\N	9
11	14	højgaard	17
12	15	alslev	15
13	8	christoffer	333
14	23	skovgaard	334
15	22	anton	20
16	27	lundemann	22
17	20	ingemann 	21
18	31	n.	25
19	33	storm	335
20	34	krøldrup	336
21	38	michaeli	337
22	50	hjelmberg duemose	16
23	53	mølsted	20
24	60	roed	338
25	16	krüger 	35
26	67	r.	17
27	66	huan yu	340
28	48	malmsiø	341
29	15	mohr	35
30	135	m.	16
31	239	\N	348
33	240	\N	349
\.


--
-- Name: person_names_identity_seq; Type: SEQUENCE SET; Schema: account; Owner: postgres
--

SELECT pg_catalog.setval('person_names_identity_seq', 33, true);


--
-- Data for Name: profile_header; Type: TABLE DATA; Schema: account; Owner: postgres
--

COPY profile_header (identities, username, password, salt, privileges) FROM stdin;
3	thejokerd3	$2a$06$urVpPom9vF9BcX3vSWBk1eaRTFDWOaE9TU4rU9eNaNFt7GtuGrDMG	$2a$06$urVpPom9vF9BcX3vSWBk1e	2
4	samemam	$2a$06$Si8aCcK1xtwtuK2WQIMyI.eVNsiroPVV1w44R6qQaLoWqq9HfQX0C	$2a$06$Si8aCcK1xtwtuK2WQIMyI.	2
5	mdamsgaard1	$2a$06$iG2p2qE1s2zKlBKdiSAxseXugHP.bsplCtD6VVUsmedAHJ.ceFYB6	$2a$06$iG2p2qE1s2zKlBKdiSAxse	2
6	ximias	$2a$06$H4GaMzYrR00WhnEcyFSR..3Kp5YcyW1XVDB9RSE.rtb9H70tl52sS	$2a$06$H4GaMzYrR00WhnEcyFSR..	2
2	test	$2a$06$z4bqvXsiV.2C90sUtk4roOqsfHGXwhhE8DdWfmUkKEjyXhOeq1RdK	$2a$06$z4bqvXsiV.2C90sUtk4roO	2
1	gambithollow	$2a$06$kcC8T3YJ9dTLrMSaG33Xl.nGL9ruoy4sY.l.PE5XvRRxmNim/jvoK	$2a$06$kcC8T3YJ9dTLrMSaG33Xl.	3
7	testa	$2a$06$SZ.feqpTJibku01JiuWk9urME6ENaaykp1PuTKmoNt5qZklgvguhG	$2a$06$SZ.feqpTJibku01JiuWk9u	1
8	madsen	$2a$06$rUH9kYFFrTHXlOLsge6qpuz/ug6jhBjXGNu/25aSL8D9x7AdEFT5G	$2a$06$rUH9kYFFrTHXlOLsge6qpu	1
9	test32	$2a$06$htBInUr0QKfjP.skAv7GnuyC7Lh130hgZ.aQ1qsXyW8KW/ya/9E/G	$2a$06$htBInUr0QKfjP.skAv7Gnu	1
10	test1234	$2a$06$iuL4NJkWZfpsHKLvPpxxEeeG3uGVhIwbSmey220q64e0WXRmWSWuC	$2a$06$iuL4NJkWZfpsHKLvPpxxEe	1
11	test123	$2a$06$sVocwtsnbxSF.69B.z0fnuDC2ctxsgqdgi9C6hefzRvgU0XVUTL5G	$2a$06$sVocwtsnbxSF.69B.z0fnu	1
12	testAB	$2a$06$FFVIE6nk0XkS2aBfRQJ8ee6YIpBBxV3Xb8AdM9xFFTWPJB9BCkofq	$2a$06$FFVIE6nk0XkS2aBfRQJ8ee	1
\.


--
-- Data for Name: profile_information; Type: TABLE DATA; Schema: account; Owner: postgres
--

COPY profile_information (identities, ref_user, ref_person_name, ref_address, ref_phone, email) FROM stdin;
1	1	1	1	1	kemad16@Student.sdu.dk
4	3	2	4	3	sabah15@student.sdu.dk
6	6	5	4	2	aholb16@student.sdu.dk
2	4	3	3	4	sabah15@student.sdu.dk
5	5	4	4	6	mdams16@student.sdu.dk
7	12	33	4	4	fract@asd.com
\.


--
-- Data for Name: profile_privileges; Type: TABLE DATA; Schema: account; Owner: postgres
--

COPY profile_privileges (identities, name) FROM stdin;
2	employee
3	admin
1	client
\.


--
-- Name: profile_privileges_identities_seq; Type: SEQUENCE SET; Schema: account; Owner: postgres
--

SELECT pg_catalog.setval('profile_privileges_identities_seq', 3, true);


--
-- Name: user_identities_seq; Type: SEQUENCE SET; Schema: account; Owner: postgres
--

SELECT pg_catalog.setval('user_identities_seq', 12, true);


--
-- Name: user_information_identities_seq; Type: SEQUENCE SET; Schema: account; Owner: postgres
--

SELECT pg_catalog.setval('user_information_identities_seq', 7, true);


SET search_path = catalog, pg_catalog;

--
-- Data for Name: product; Type: TABLE DATA; Schema: catalog; Owner: postgres
--

COPY product (name, price, category, identities) FROM stdin;
Banana Pi 1 GB	299	13	1
Cubieboard V3 Cubietruck 	799	13	2
Cubieboard Kølesæt	39	14	3
Allnet Banana Pi Pro	359	13	4
Raspberry Pi 3	349	13	5
Raspberry Pi 2 model B 1	349	13	6
Raspberry Pi Model A+	219	13	7
Raspberry Pi WLAN stik	69	8	8
AEROCOOL DS Fan - 120 MM	119.95	16	9
Akasa Viper PWM - 120MM	119.95	16	10
Cooler Master Sickleflow 120B	79	16	11
name	200	17	12
Test	120	16	13
LCD Screen - Samsung	2000	19	14
LCD Screen v2 - Samsung	2500	19	15
razer m250	400	6	16
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: catalog; Owner: postgres
--

COPY product_category (name, identities) FROM stdin;
computer	1
graphics cards	2
processers	3
power supply	4
motherboards	5
mouse	6
keyboards	7
wifi	8
router	9
cooking appliances	10
monitors	11
hardware	12
singleboard computer	13
heatsinks	14
cabinet	15
fan	16
test	17
services	18
screen	19
\.


--
-- Name: product_category_identities_seq; Type: SEQUENCE SET; Schema: catalog; Owner: postgres
--

SELECT pg_catalog.setval('product_category_identities_seq', 19, true);


--
-- Name: product_identities_seq; Type: SEQUENCE SET; Schema: catalog; Owner: postgres
--

SELECT pg_catalog.setval('product_identities_seq', 16, true);


--
-- Data for Name: product_list; Type: TABLE DATA; Schema: catalog; Owner: postgres
--

COPY product_list (identities) FROM stdin;
1
\.


--
-- Data for Name: product_list_associated; Type: TABLE DATA; Schema: catalog; Owner: postgres
--

COPY product_list_associated (amount, price, product, list, identities) FROM stdin;
2	799	2	1	3
4	299	1	1	4
\.


--
-- Name: product_list_associated_identities_seq; Type: SEQUENCE SET; Schema: catalog; Owner: postgres
--

SELECT pg_catalog.setval('product_list_associated_identities_seq', 4, true);


--
-- Name: product_list_identities_seq; Type: SEQUENCE SET; Schema: catalog; Owner: postgres
--

SELECT pg_catalog.setval('product_list_identities_seq', 1, true);


SET search_path = world, pg_catalog;

--
-- Data for Name: address; Type: TABLE DATA; Schema: world; Owner: postgres
--

COPY address (identities, country, post_address, city, street, address_number, apartment_place, floor) FROM stdin;
1	1	1	1	1	13	2	2
2	1	2	4	2	39	\N	\N
3	1	3	1	3	17	\N	\N
4	2	4	5	4	0	\N	\N
\.


--
-- Name: address_country_seq; Type: SEQUENCE SET; Schema: world; Owner: postgres
--

SELECT pg_catalog.setval('address_country_seq', 1, false);


--
-- Name: address_identities_seq; Type: SEQUENCE SET; Schema: world; Owner: postgres
--

SELECT pg_catalog.setval('address_identities_seq', 4, true);


--
-- Name: address_street_seq; Type: SEQUENCE SET; Schema: world; Owner: postgres
--

SELECT pg_catalog.setval('address_street_seq', 1, false);


--
-- Data for Name: apartment; Type: TABLE DATA; Schema: world; Owner: postgres
--

COPY apartment (identities, content) FROM stdin;
2	.mf
3	.th
4	.tv
\.


--
-- Name: apartment_identities_seq; Type: SEQUENCE SET; Schema: world; Owner: postgres
--

SELECT pg_catalog.setval('apartment_identities_seq', 4, true);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: world; Owner: postgres
--

COPY cities (identities, content) FROM stdin;
1	odense
2	ålborg
3	københavn
4	esbjerg
5	unknown
\.


--
-- Name: cities_identities_seq; Type: SEQUENCE SET; Schema: world; Owner: postgres
--

SELECT pg_catalog.setval('cities_identities_seq', 5, true);


--
-- Data for Name: countries; Type: TABLE DATA; Schema: world; Owner: postgres
--

COPY countries (identities, name, acronym) FROM stdin;
1	danmark	dk
2	unknown	unknown
\.


--
-- Name: countries_identities_seq; Type: SEQUENCE SET; Schema: world; Owner: postgres
--

SELECT pg_catalog.setval('countries_identities_seq', 2, true);


--
-- Data for Name: country_codes; Type: TABLE DATA; Schema: world; Owner: postgres
--

COPY country_codes (identities, country, code) FROM stdin;
1	1	45
2	2	xx
\.


--
-- Name: country_codes_identities_seq; Type: SEQUENCE SET; Schema: world; Owner: postgres
--

SELECT pg_catalog.setval('country_codes_identities_seq', 2, true);


--
-- Data for Name: phone_numbers; Type: TABLE DATA; Schema: world; Owner: postgres
--

COPY phone_numbers (identities, country_code, phone_number) FROM stdin;
1	1	51902914
2	1	28633398
3	1	42763205
4	1	22588025
6	2	unknown
\.


--
-- Name: phone_numbers_identities_seq; Type: SEQUENCE SET; Schema: world; Owner: postgres
--

SELECT pg_catalog.setval('phone_numbers_identities_seq', 6, true);


--
-- Data for Name: postal_code; Type: TABLE DATA; Schema: world; Owner: postgres
--

COPY postal_code (identities, content) FROM stdin;
1	5250
2	6705
3	5220
4	unknown
\.


--
-- Name: postal_code_identities_seq; Type: SEQUENCE SET; Schema: world; Owner: postgres
--

SELECT pg_catalog.setval('postal_code_identities_seq', 4, true);


--
-- Data for Name: street; Type: TABLE DATA; Schema: world; Owner: postgres
--

COPY street (identities, content) FROM stdin;
1	floravænget
2	kirkebakken
3	niels bjerres vænge
4	unknown
\.


--
-- Name: street_identities_seq; Type: SEQUENCE SET; Schema: world; Owner: postgres
--

SELECT pg_catalog.setval('street_identities_seq', 4, true);


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
-- Name: profile_privileges profile_privileges_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_privileges
    ADD CONSTRAINT profile_privileges_pkey PRIMARY KEY (identities);


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


SET search_path = catalog, pg_catalog;

--
-- Name: product_category_name_uindex; Type: INDEX; Schema: catalog; Owner: postgres
--

CREATE UNIQUE INDEX product_category_name_uindex ON product_category USING btree (name);


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
-- Name: profile_header insert_or_update_password_trigger; Type: TRIGGER; Schema: account; Owner: postgres
--

CREATE TRIGGER insert_or_update_password_trigger BEFORE INSERT OR UPDATE ON profile_header FOR EACH ROW EXECUTE PROCEDURE encrypt_password();


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
-- Name: orders orders_profile_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_profile_fkey FOREIGN KEY (profile) REFERENCES profile_header(identities);


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
-- Name: profile_header profile_header_privileges_fkey; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY profile_header
    ADD CONSTRAINT profile_header_privileges_fkey FOREIGN KEY (privileges) REFERENCES profile_privileges(identities);


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

