--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4 (Ubuntu 13.4-1.pgdg20.10+1)
-- Dumped by pg_dump version 13.4 (Ubuntu 13.4-1.pgdg20.10+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: DemoTable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DemoTable" (
    id integer NOT NULL,
    name text NOT NULL,
    blood_group text NOT NULL
);


ALTER TABLE public."DemoTable" OWNER TO postgres;

--
-- Name: DemoTable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."DemoTable_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."DemoTable_id_seq" OWNER TO postgres;

--
-- Name: DemoTable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."DemoTable_id_seq" OWNED BY public."DemoTable".id;


--
-- Name: animal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal (
    name text,
    genus text,
    species text
);


ALTER TABLE public.animal OWNER TO postgres;

--
-- Name: DemoTable id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DemoTable" ALTER COLUMN id SET DEFAULT nextval('public."DemoTable_id_seq"'::regclass);


--
-- Data for Name: DemoTable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DemoTable" (id, name, blood_group) FROM stdin;
1	Hakim	B+
2	Vodro	A+
3	Mashiat	B+
\.


--
-- Data for Name: animal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animal (name, genus, species) FROM stdin;
\.


--
-- Name: DemoTable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."DemoTable_id_seq"', 3, true);


--
-- Name: DemoTable demotable_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DemoTable"
    ADD CONSTRAINT demotable_pk PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

