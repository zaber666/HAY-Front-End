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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: person_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.person_role AS ENUM (
    'PATIENT',
    'PSYCHIATRIST',
    'BOARD MEMBER'
);


ALTER TYPE public.person_role OWNER TO postgres;

--
-- Name: employee_insert_trigger_fnc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.employee_insert_trigger_fnc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
        arg INT;
BEGIN
    FOREACH arg IN ARRAY TG_ARGV LOOP
    NEW.score = (SELECT sum(o.score)
        FROM test_results INNER JOIN answer a on test_results.test_result_id = a.test_result_id
        INNER JOIN options o on a.option_id = o.option_id
        WHERE a.test_result_id = NEW.test_result_id
        GROUP BY test_results.test_result_id);
    UPDATE test_results
        SET score = NEW.score
        WHERE test_result_id = NEW.test_result_id;
    END LOOP;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.employee_insert_trigger_fnc() OWNER TO postgres;

--
-- Name: myrule(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.myrule() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   BEGIN
    NEW.score := (SELECT sum(o.score)
        FROM test_results INNER JOIN answer a on test_results.test_result_id = a.test_result_id
        INNER JOIN options o on a.option_id = o.option_id
        WHERE a.test_result_id = OLD.test_result_id);
    RETURN NEW;
  END;
$$;


ALTER FUNCTION public.myrule() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answer (
    test_result_id integer NOT NULL,
    option_id integer NOT NULL
);


ALTER TABLE public.answer OWNER TO postgres;

--
-- Name: counselling_suggestion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.counselling_suggestion (
    test_result_id integer NOT NULL,
    psychiatrist_id integer NOT NULL
);


ALTER TABLE public.counselling_suggestion OWNER TO postgres;

--
-- Name: options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.options (
    option_id integer NOT NULL,
    option_text character varying(256),
    score integer,
    question_id integer
);


ALTER TABLE public.options OWNER TO postgres;

--
-- Name: options_option_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.options_option_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.options_option_id_seq OWNER TO postgres;

--
-- Name: options_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.options_option_id_seq OWNED BY public.options.option_id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patients (
    height_inches integer,
    weight_kgs integer,
    location character varying,
    patient_id integer NOT NULL
);


ALTER TABLE public.patients OWNER TO postgres;

--
-- Name: persons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persons (
    person_id integer NOT NULL,
    name character varying(64),
    email character varying(64),
    password_hash character varying(256),
    date_of_birth timestamp without time zone,
    gender character varying(1),
    photo_path character varying(128),
    cellphone character varying(12)
);


ALTER TABLE public.persons OWNER TO postgres;

--
-- Name: persons_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.persons_person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.persons_person_id_seq OWNER TO postgres;

--
-- Name: persons_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.persons_person_id_seq OWNED BY public.persons.person_id;


--
-- Name: psychiatrists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.psychiatrists (
    psychiatrist_id integer NOT NULL,
    is_verified boolean,
    available_times character varying(256),
    certificate_id character varying(32)
);


ALTER TABLE public.psychiatrists OWNER TO postgres;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    question_id integer NOT NULL,
    question_text character varying(256),
    created_at timestamp without time zone,
    is_approved boolean
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: questions_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questions_question_id_seq OWNER TO postgres;

--
-- Name: questions_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_question_id_seq OWNED BY public.questions.question_id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(64)
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: test_question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_question (
    test_id integer NOT NULL,
    question_id integer NOT NULL,
    is_approved boolean
);


ALTER TABLE public.test_question OWNER TO postgres;

--
-- Name: test_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_results (
    test_result_id integer NOT NULL,
    test_id integer NOT NULL,
    patient_id integer NOT NULL,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    verifier_id integer,
    verified_at timestamp without time zone,
    machine_report character varying(256),
    manual_report character varying(256),
    score integer DEFAULT 0
);


ALTER TABLE public.test_results OWNER TO postgres;

--
-- Name: test_results_test_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_results_test_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_results_test_result_id_seq OWNER TO postgres;

--
-- Name: test_results_test_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_results_test_result_id_seq OWNED BY public.test_results.test_result_id;


--
-- Name: tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tests (
    test_id integer NOT NULL,
    name character varying(64) NOT NULL,
    description character varying(256),
    created_at timestamp without time zone NOT NULL,
    is_approved boolean,
    psychiatrist_id_of_added_by integer
);


ALTER TABLE public.tests OWNER TO postgres;

--
-- Name: tests_test_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tests_test_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tests_test_id_seq OWNER TO postgres;

--
-- Name: tests_test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tests_test_id_seq OWNED BY public.tests.test_id;


--
-- Name: options option_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options ALTER COLUMN option_id SET DEFAULT nextval('public.options_option_id_seq'::regclass);


--
-- Name: persons person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons ALTER COLUMN person_id SET DEFAULT nextval('public.persons_person_id_seq'::regclass);


--
-- Name: questions question_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions ALTER COLUMN question_id SET DEFAULT nextval('public.questions_question_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: test_results test_result_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results ALTER COLUMN test_result_id SET DEFAULT nextval('public.test_results_test_result_id_seq'::regclass);


--
-- Name: tests test_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests ALTER COLUMN test_id SET DEFAULT nextval('public.tests_test_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
d53109438b4d
\.


--
-- Data for Name: answer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answer (test_result_id, option_id) FROM stdin;
1	76
1	71
1	86
1	91
1	96
1	81
1	66
1	101
5	101
5	81
5	91
5	86
5	96
5	76
5	68
5	72
6	101
6	81
6	92
6	86
6	96
6	76
6	68
6	72
7	101
7	81
7	92
7	86
7	96
7	76
7	68
7	72
16	101
16	81
16	92
16	86
16	96
16	76
16	68
16	72
17	101
17	81
17	92
17	86
17	96
17	76
17	68
17	72
18	101
18	81
18	92
18	86
18	96
18	76
18	68
18	72
19	101
19	81
19	92
19	86
19	96
19	76
19	68
19	72
20	101
20	81
20	92
20	86
20	96
20	76
20	68
20	72
21	101
21	81
21	92
21	86
21	96
21	76
21	68
21	72
22	101
22	81
22	92
22	86
22	96
22	76
22	68
22	72
36	66
36	73
36	77
36	84
36	86
36	94
36	97
36	102
37	66
37	73
37	77
37	84
37	86
37	94
37	96
37	103
38	66
38	73
38	77
38	84
38	86
38	94
38	97
38	102
54	66
54	73
54	77
54	84
54	86
54	94
54	97
54	102
71	66
71	73
71	77
71	84
71	86
71	94
71	97
71	102
72	66
72	73
72	77
72	84
72	86
72	94
72	97
72	102
73	66
73	73
73	77
73	84
73	86
73	94
73	97
73	102
74	66
74	73
74	77
74	84
74	86
74	94
74	97
74	102
75	66
75	73
75	77
75	84
75	86
75	94
75	97
75	102
76	69
76	74
76	79
76	84
76	89
76	95
76	99
76	104
78	66
78	72
78	77
78	82
78	87
78	92
78	97
78	102
79	107
79	111
79	116
79	122
79	127
80	66
80	73
80	77
80	82
\.


--
-- Data for Name: counselling_suggestion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.counselling_suggestion (test_result_id, psychiatrist_id) FROM stdin;
\.


--
-- Data for Name: options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.options (option_id, option_text, score, question_id) FROM stdin;
111	Never	1	23
112	Rarely	2	23
113	Sometimes	3	23
114	Often	4	23
115	Always	5	23
116	Never	1	24
117	Rarely	2	24
118	Sometimes	3	24
119	Often	4	24
120	Always	5	24
121	Never	1	25
122	Rarely	2	25
123	Sometimes	3	25
124	Often	4	25
125	Always	5	25
126	Never	1	26
127	Rarely	2	26
128	Sometimes	3	26
129	Often	4	26
130	Always	5	26
106	Never	1	22
107	Rarely	2	22
108	Sometimes	3	22
109	Often	4	22
110	Always	5	22
89	Often	4	18
105	Always	5	21
98	Sometimes	3	20
69	Often	4	14
101	Never	1	21
100	Always	5	20
55	Nearly every day	5	11
24	More than half the days	4	5
18	Several days	3	4
104	Often	4	21
81	Never	1	17
82	Rarely	2	17
12	Rare, less than a day or two	2	3
67	Rarely	2	14
84	Often	4	17
91	Never	1	19
23	Several days	3	5
86	Never	1	18
2	Rare, less than a day or two	2	1
60	Nearly every day	5	12
33	Several days	3	7
63	Several days	3	13
96	Never	1	20
27	Rare, less than a day or two	2	6
43	Several days	3	9
99	Often	4	20
7	Rare, less than a day or two	2	2
38	Several days	3	8
14	More than half the days	4	3
17	Rare, less than a day or two	2	4
15	Nearly every day	5	3
47	Rare, less than a day or two	2	10
9	More than half the days	4	2
25	Nearly every day	5	5
57	Rare, less than a day or two	2	12
10	Nearly every day	5	2
88	Sometimes	3	18
58	Several days	3	12
20	Nearly every day	5	4
52	Rare, less than a day or two	2	11
22	Rare, less than a day or two	2	5
53	Several days	3	11
29	More than half the days	4	6
32	Rare, less than a day or two	2	7
30	Nearly every day	5	6
62	Rare, less than a day or two	2	13
40	Nearly every day	5	8
72	Rarely	2	15
42	Rare, less than a day or two	2	9
4	More than half the days	4	1
73	Sometimes	3	15
35	Nearly every day	5	7
5	Nearly every day	5	1
37	Rare, less than a day or two	2	8
68	Sometimes	3	14
21	Not at all	1	5
44	More than half the days	4	9
75	Always	5	15
103	Sometimes	3	21
16	Not at all	1	4
46	Not at all	1	10
87	Rarely	2	18
19	More than half the days	4	4
26	Not at all	1	6
50	Nearly every day	5	10
65	Nearly every day	5	13
97	Rarely	2	20
95	Always	5	19
92	Rarely	2	19
36	Not at all	1	8
59	More than half the days	4	12
90	Always	5	18
39	More than half the days	4	8
1	Not at all	1	1
70	Always	5	14
31	Not at all	1	7
85	Always	5	17
34	More than half the days	4	7
41	Not at all	1	9
11	Not at all	1	3
51	Not at all	1	11
80	Always	5	16
13	Several days	3	3
76	Never	1	16
61	Not at all	1	13
93	Sometimes	3	19
56	Not at all	1	12
78	Sometimes	3	16
3	Several days	3	1
77	Rarely	2	16
45	Nearly every day	5	9
48	Several days	3	10
28	Several days	3	6
66	None	1	14
8	Several days	3	2
83	Sometimes	3	17
71	Never	1	15
79	Often	4	16
74	Often	4	15
54	More than half the days	4	11
6	Not at all	1	2
102	Rarely	2	21
49	More than half the days	4	10
64	More than half the days	4	13
94	Often	4	19
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients (height_inches, weight_kgs, location, patient_id) FROM stdin;
65	85	Demra	1705002
68	75	Chef's Table	1705008
68	65	Xu Lab	1705015
65	\N	\N	3
66	\N	\N	4
67	\N	Left Wing	1705016
65	\N	Khulna	1705017
408	515	dffrgeb	5
\.


--
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persons (person_id, name, email, password_hash, date_of_birth, gender, photo_path, cellphone) FROM stdin;
1	Goodman	goodman@mail.com	pbkdf2:sha256:260000$K2sfLqByvR0UFkwX$189d1029f0e340154e1ebe2b43dd31a9a5845f391f9f49687d53aa65cf888b6d	\N	\N	\N	\N
2	Sipser	sipser@mit.edu	pbkdf2:sha256:260000$iqEK4azzRfOEl3co$4630cc072e2c33a3102250e62e41a55448d2d5b8bd1d16d828fd491c6cbdd273	\N	\N	\N	\N
3	\N	\N	\N	\N	\N	\N	\N
5	ewfrghrebe	s@eb.e	pbkdf2:sha256:260000$sQQYoF7IRpqIzWyv$c4e7867bf1fb44b7a69b6586d6d4e827782014604eee1810297891b08fcae416	1000-10-10 00:00:00	f	https://picsum.photos/200	\N
4	Sipser2	sipser2@mit.edu	pbkdf2:sha256:260000$XWi5d6w9t08E3hU5$f5aed2082786f273a3a06bd4fff8ca89834b0712feb52f4b4b6110fa61f9e45e	\N	\N	\N	\N
1705001	Kowshic Roy	vdrkowshic@gmail.com	pbkdf2:sha256:260000$gCrYpvHhyqzeNwRo$a317e8ae3c4350ef83f8eb6788b36e1867f7732c42b59189c5f209dc240c13d9	\N	M	picsum.photos/200	\N
1705002	Sheikh Azizul Hakim	1705002@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$2KVoasWGhJoxocm8$a8811a419ac30caa3d89e1971831981cb75f9dc35e00f4216e1e47a6684af8f0	\N	M	picsum.photos/200	\N
1705003	Mahdi Hasnat Siyam	mahdibuet3@gmail.com	pbkdf2:sha256:260000$BeGE3cJBmunSYhPO$c08ffbd2b5361269c84afbec806aad85d3ce631888b86684f0a3f8705bfb3b39	\N	M	picsum.photos/200	\N
1705004	Ramisa Alam	ramisa2108@gmail.com	pbkdf2:sha256:260000$qaWkYmoDLMsLL4nz$5b5c6009099a4897d20441cd415639661b63e2d1be0a0950efd81136cb83d527	\N	F	picsum.photos/200	\N
1705005	Mashiat Mustaq	mashiatmustaq98@gmail.com	pbkdf2:sha256:260000$ZWilIi2y0RyghzLT$13e0c882fc3683cc4d7bbff09c0c3d54c02f7f5cb4e0d76dc833055f91f27e58	\N	F	picsum.photos/200	\N
1705006	Saiful Islam	saifulislambuet11@gmail.com	pbkdf2:sha256:260000$lIjzNJVJW9l7icp2$124e497999845b0a2e4aa7564fc8bf1f0c05d877fcf0aabc75a775d1237ce8b8	\N	M	picsum.photos/200	\N
1705007	Md. Tawsif Shahriar Dipto	tawsifshahriar7@gmail.com	pbkdf2:sha256:260000$3eGhzLwnuggH6slw$79343cd5ce99d36c218098de7456482653aaf39e7770ab9904c2dd153b5c8e4a	\N	M	picsum.photos/200	\N
1705008	Sheikh Saifur Rahman Jony	srj.buet17@gmail.com	pbkdf2:sha256:260000$HBmsjjRuCXER06XA$c47838a6e5ffd0e6974d949d42c819b6295623919e5d2f6c09d029744fc75cff	\N	M	picsum.photos/200	\N
1705009	Shayekh Bin Islam	shayekh.bin.islam@gmail.com	pbkdf2:sha256:260000$2Rqo77uvkBqdI1wZ$43f42e2503f2fd305ea7b67f00b30916acc012946d0b47ddbef7a68888d7eb98	\N	M	picsum.photos/200	\N
1705010	Md. Zarif-Ul-Alam	zarif98sjs@gmail.com	pbkdf2:sha256:260000$YwrNaOlNUdrS19Mq$2ab52d93e6b15a2022c2b0a6d2902a6e0f1962fbde0308f3dfea83519d0c1964	\N	M	picsum.photos/200	\N
1705011	Md. Salman Farsi	salman201103@gmail.com	pbkdf2:sha256:260000$xMEwJ2Vu1cISEoYF$77b1fb128d0d34103e71a75c8bb85aea5a402d18c96b67f111412f41113c9e98	\N	M	picsum.photos/200	\N
1705012	Jamilus Sheium	sheium1998@gmail.com	pbkdf2:sha256:260000$194xE4UAdBcncV1F$3eef4b6e7f4eabca721c4d0757e465cca9cf1a4933d51f603b4337f913c2062f	\N	M	picsum.photos/200	\N
1705013	Md. Olid Hasan Bhuiyan	1705013@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$L2okFmZO0qwMwuYs$5cdb8615769c307f3a09bbbc967b1a48da31ac9b3fd29cf87971f23b3e5973ac	\N	M	picsum.photos/200	\N
1705014	Naeem Ahmed	naeemtanveer1024@gmail.com	pbkdf2:sha256:260000$YZtM3Zb06Z2PvIxw$cf123db056e85c679f84801e50cceb13d513e4779f0163855ea677c6a083b688	\N	M	picsum.photos/200	\N
1705015	Zaber Ibn Abdul Hakim	ak5236638@gmail.com	pbkdf2:sha256:260000$H6RPr1VDWGbUBdWB$6d6bef379a15571cc35b812cc1e21ebf8ca5bf85e9c66d2e49db9fb445bbc511	\N	M	picsum.photos/200	\N
1705016	Ridwanul Hasan Tanvir	1705016@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$mSZJmhAcvK0wmIFS$5eeb2fccb27090efdbdba29bafe992d36c883a78d1e32a2d68f06f76c68705fe	\N	M	picsum.photos/200	\N
1705017	Towhidul Islam	towhidpqrst@gmail.com	pbkdf2:sha256:260000$J5QieJM8s4ncamCd$5f60cb1c97dd706720d790b73db9932cc3500d24d4020c1d05d522173721c473	\N	M	picsum.photos/200	\N
1705018	Shakil Ahmed	shakilahmedndc@gmail.com	pbkdf2:sha256:260000$yNh1f5p6F5zniBSK$9c480721023c9c29e588755ae1727e9d7c70d1055c0555692f3fb3e6472a0b4f	\N	M	picsum.photos/200	\N
1705045	Iftekhar Hakim Kaowsar	iftekharhakimkaowsar88@gmail.com	pbkdf2:sha256:260000$OE1qSI3a5Vt2SVYs$075d1f5b1f6996388ce6e9675c74d348081d66a7d11af52d557d915fc8d7f3be	\N	M	picsum.photos/200	\N
1705047	Jayanta Sadhu	jayantasadhu4557@gmail.com	pbkdf2:sha256:260000$bIrQq1498gusSAGl$f1a7318a54d003ace1f4098d4099b8d52dc4f5e6b6d191138d120c3c53900623	\N	M	picsum.photos/200	\N
1705049	Taufiqun Nur Farid	1705049@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$t5XRJLDWyRpsqHrh$0cac1ba9edf2a6e2c6d2474d19ca0b47d56f19869e3c8d47851f572c74ca69c5	\N	M	picsum.photos/200	\N
1705052	Pushpita Joardar	pushpitajoardar21@gmail.com	pbkdf2:sha256:260000$I60pLO6QG5TVlmQ5$c67a6bf8ef6aea02751169ca55090cfb913f75ff7784bfab5ea580e5768335c3	\N	F	picsum.photos/200	\N
1705054	Monirul Haq Imon	worstemon8@gmail.com	pbkdf2:sha256:260000$UKCGveoj2jg1awF8$a7fe375e4693ccfdb803fc4f969b464c4bf96962bad0724813b71a06aef42870	\N	M	picsum.photos/200	\N
1705056	Apurba Saha	diponsaha007@gmail.com	pbkdf2:sha256:260000$LsxgGPRO52Cnjk60$e13af4bb238ceaadafc3401667939ce8d0a6f4f862f597252b60d065b4271e3a	\N	M	picsum.photos/200	\N
1705058	Fattah-zul-ikram	galib05058@gmail.com	pbkdf2:sha256:260000$DjdpHGgnrxMrq7B0$76c9517a89a6fd9bf400422b6d5dc9bfc02c14c7de8a5ea97d7dedb1dabfc17f	\N	M	picsum.photos/200	\N
1705061	Maksudur Rahaman Rana	mksdrrana@gmail.com	pbkdf2:sha256:260000$rKHjSm1PK6vIEmb7$9c53e383c44b31de6fb1aee2b0bb11989e7229715fe242dbe439588996534bbf	\N	M	picsum.photos/200	\N
1705063	Mahfuzur Rahman Rifat	mahfuzrifat7@gmail.com	pbkdf2:sha256:260000$tJzDhjunK9QIscUy$466d2a5a17e6588fa68518b4f0fb224e150f97a71e670642bfb387e90fc91e8d	\N	M	picsum.photos/200	\N
1705066	Ataf Fazledin Ahamed	rabidahamed@gmail.com	pbkdf2:sha256:260000$HIfRD7fAQ7uIlLiD$bf4b81854b66b5028af96a9b6deca6f1627ba335ae70c3723607cc94811420d6	\N	M	picsum.photos/200	\N
1705068	Saadman Ahmed	1705068@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$duMkRFXotqCtcB1G$77a30761f9a8e277c6c45aecddf9cabdfb4d8191dd3c5714747f654f41a51a5c	\N	M	picsum.photos/200	\N
1705070	Al Arafat Tanin	1705070@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$8094iypQv2HF3Cq3$8db434043b3d4f09abaa4bed6cff9faf67d49a80d12b928c72e9503a160f2f94	\N	M	picsum.photos/200	\N
1705073	Istiak Bin Mahmod	1705073@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$30uEm8R4X20n4Xul$54d9c77fd4b4f11c31303dd2ef5c1bdfa38e916fee7f07316192f6bf45398f03	\N	M	picsum.photos/200	\N
1705075	Ovi Poddar	ovi.poddar2@gmail.com	pbkdf2:sha256:260000$8Vl3kfIzya2geAiO$7aa87b4b32bd675524ee90af5c3f17d268e22174015714da68de15f49ff13e15	\N	M	picsum.photos/200	\N
1705077	Fahim Faysal	ffalsoy@gmail.com	pbkdf2:sha256:260000$2igbD8DXSHVfzeZo$016f983c41d43412900d371ac9defc710e38d94329d3c7d982496333276bb76b	\N	M	picsum.photos/200	\N
1705079	Kazi Wasif Shammya	kaziwasifamin@hotmail.com	pbkdf2:sha256:260000$mcMUHw1wTVwh2ITb$125138a43ddd91d8e9ba492d74a85b7bad3c1066c94e4023cf819ae3ec2b38a4	\N	M	picsum.photos/200	\N
1705082	Md. Mehedi Hasan	1705082@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$pns4J7aX9k3htgVH$c6ff7937a3e6cba4f070cce5ee19e770a6e3cbdcef1aeab55395370f2093795c	\N	M	picsum.photos/200	\N
1705084	Asif Ahmed Utsa	1705084@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$mhYKftyItWjHy4Zs$941932925eb16c887b89f203191b778b8094b8ff93d6501bcfd63c82a573f2ee	\N	M	picsum.photos/200	\N
1705087	Fahmid Al Rifat	alrifatfahmid@gmail.com	pbkdf2:sha256:260000$qmnzkEgEfFODpB37$9ca7cb4e2fab620ac9f3c2f3ee5032caa4b6df0c6ce6f182f91c8bb5b4c00fa1	\N	M	picsum.photos/200	\N
1705089	Noshin Ulfat	1705089@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$FQVS8uyr5CZSkQ2B$6a404c82419b21d2e554d221a51631248d5e790b559345e83bbfff718b47ec1f	\N	F	picsum.photos/200	\N
1705091	Nahian Salsabil	cse_salsabil@yahoo.com	pbkdf2:sha256:260000$xIgeqZHa2NCKtkAI$d5b655d8c2dd2d2f5e44ee27c1886fac3f0ffcd1908739cba39c150ec29b0eda	\N	F	picsum.photos/200	\N
1705093	Fatima Nawmi	fatimanawmi@gmail.com	pbkdf2:sha256:260000$eSIzJXepataPRcIE$ecd4c117d1750b2d89cb6c69d97aa2e156735c7eb447fe678ebe3846ab8d7656	\N	F	picsum.photos/200	\N
1705096	Kazim Abrar Mahi	kazimabrarmahi135@gmail.com	pbkdf2:sha256:260000$ifaviP5AExFTD6D3$fec35203372f87f43833413adfd26bd4aeac871a651dbb1ae9f9d749cdc37ee9	\N	M	picsum.photos/200	\N
1705098	Sihat Afnan	sihatafnan15.9.1997@gmail.com	pbkdf2:sha256:260000$bY8zy6qVaQWLRC2b$2d1fa831a3aa6aa895048278a31bc9f0b702cb78abf47bd3e12f64c5c7102746	\N	M	picsum.photos/200	\N
1705100	Farhana Khan	farhanakhanhp@gmail.com	pbkdf2:sha256:260000$7fxYFfzpHEJZIZAJ$401e356d9ef66ae21981da1c283569fcacdc492638b4ef1e52f2842c16e94b2c	\N	F	picsum.photos/200	\N
1705103	Nazmul Takbir	nazmultakbir98@gmail.com	pbkdf2:sha256:260000$AhefXIEBzxRXOUmG$c7ac0160b6387fecf30ca554a086d742afbbb9a701efcdf39776c5fce4c3a96c	\N	M	picsum.photos/200	\N
1705105	Rittik Basak Utsha	rittik.basak@gmail.com	pbkdf2:sha256:260000$WxOXMZZDXQsZ96Vh$95fc1fa583506bc7dd5906516144a0b5a1898f8e782517b73b0f273d7f5a34f6	\N	M	picsum.photos/200	\N
1705107	Abu Nowshed Sakib	ansakib04@gmail.com	pbkdf2:sha256:260000$Nmdji672PIeNRNXC$b4aa7c5c4e9e20ca080938f1092aae7a838a28556963b9928c988c2c586df04b	\N	M	picsum.photos/200	\N
1705019	Adrita Hossain Nakshi	1705019@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$9AHNYSKJEILLFq6D$f3081e89d0e3bf626e164cec090dbd8c8b36818fbc3f26b3b368817a0e2f4ebc	\N	F	picsum.photos/200	\N
1705020	Md. Arafat Hossain	araf.reputation1999@gmail.com	pbkdf2:sha256:260000$yoPMopfsx57vzpcP$526aea2a983ffd580046ff067656da8eb848a0d58b0981e49e4517adef51b7ee	\N	M	picsum.photos/200	\N
1705021	Md. Shadmim Hasan Sifat	sifathshadmim@gmail.com	pbkdf2:sha256:260000$bBO5Vw8zSQz1jOA0$6153e243d4a32f0b4a2fcd898d687837f1d472cc8affe046ba822aa2df57a7fd	\N	M	picsum.photos/200	\N
1705022	Solaiman Ahmed	solaimanahmed112@gmail.com	pbkdf2:sha256:260000$jqY901Hd5xUd4Rsw$d7ca20121bc5f4a8a187e8400f8b88332c1393dc08c1ca26a74a7d14ac228141	\N	M	picsum.photos/200	\N
1705023	S. M. Zuhair Jawhar Zaki	zuhairzaki500@gmail.com	pbkdf2:sha256:260000$G9CwI2ZCcNgDIpj4$efd91741d1b609f1d04a1be93f76c95037c2bffa934b1bd37687db1539af93d1	\N	M	picsum.photos/200	\N
1705024	Khandokar Md. Rahat Hossain	rahat2975134@gmail.com	pbkdf2:sha256:260000$y20DfBPV4bi107Yn$a75703855b1ecf0b92c2009ee2cdad091cca98458df6e04cc9b797d9a11d5e07	\N	M	picsum.photos/200	\N
1705025	Swapnil Dey	swapnildey1999@gmail.com	pbkdf2:sha256:260000$sYqZTq31gv5uRCBw$31186c851b3071b349d95cd51c239062dc37dd3eb6dc0dca7942b1877964205f	\N	M	picsum.photos/200	\N
1705026	Shafqat Rakin	shafqatrakin@gmail.com	pbkdf2:sha256:260000$O8p0SRerPuVhvJkq$393fe092ff074be82ffa788f31880e38e4c95437c35c2f851d49fb78c232aa82	\N	M	picsum.photos/200	\N
1705027	Saem Hasan	sayim.hasan30@gmail.com	pbkdf2:sha256:260000$KcjDBkstxpuxXpKD$a1f9940585c0ace0e56c94c9acbc4dadd48cad1529525657a5e90c67e2332880	\N	M	picsum.photos/200	\N
1705028	Samira Islam	samiraakhter8657@gmail.com	pbkdf2:sha256:260000$9WyVaUPXQl79ftXU$c38d6d96b54f385041b96fb75b066f32049973f0d0f430b4bf1ca82a9e20b6fd	\N	F	picsum.photos/200	\N
1705029	Simantika Dristi	queendristi27@gmail.com	pbkdf2:sha256:260000$6fpCjLJBOzo7UKBg$2d387af3988f1ab441f0b81ab077ddb47576319e5ecbb9a21751cc9627a2d7c2	\N	F	picsum.photos/200	\N
1705030	Joy Saha	iamjoysaha1.0@gmail.com	pbkdf2:sha256:260000$Uds0vaMhoK9XjhZ6$e696af1d14ded4e212e8294c196b3c56929c10f0492e8a8801ef17556c78f514	\N	M	picsum.photos/200	\N
1705031	Md. Mahedi Hasan Rigan	mahedihasanrigan82@gmail.com	pbkdf2:sha256:260000$StVH9wxtergfVEDm$bfd81d7a51382d6824719b850159c4d1796ee39b0423507ae29083232c9cea5c	\N	M	picsum.photos/200	\N
1705032	Tanjim Ahmed Khan	tanjim.ak49@gmail.com	pbkdf2:sha256:260000$7lhiy09ceI2i6Lpw$c7d636ed6bbc11a75a46cc82c837ca8868b1984de5d48797eaadfabf2f82bab7	\N	M	picsum.photos/200	\N
1705033	Tanberul Islam Ruhan	tanberulislam98@gmail.com	pbkdf2:sha256:260000$gsdDphX4lKkn2evG$fbc0c6c83297cbb4520f9702a20fc8b45e64d56b06b142bffacd16a4a6b83867	\N	M	picsum.photos/200	\N
1705034	Souvik Das	souvik.piyal@gmail.com	pbkdf2:sha256:260000$3XsypgYIIzXvSknP$fea2b63c3c9201a67d3f519d61b994355fcb313a5dbdbf318b7cb67e21edacad	\N	M	picsum.photos/200	\N
1705035	A. Z. M Mehedi Hasan	mehedihm2015@gmail.com	pbkdf2:sha256:260000$QFwWgU5hKkXDBi1T$6f5dee841045ebaa9734f8bb421c4ef0316c4412c38c93ab8e19a251bf2016ab	\N	M	picsum.photos/200	\N
1705036	Ayan Antik Khan	ayanantikkhan@gmail.com	pbkdf2:sha256:260000$ffRMNxdQ0kxZBnIM$ccc11b36193c09c478a5612674e640767a280f9f0630f7edcc53e9cbc0c280f8	\N	M	picsum.photos/200	\N
1705037	Mushtari Sadia	mushtarisadia98@gmail.com	pbkdf2:sha256:260000$mpyF72dVb2yVjGib$1884b41f7291ad6c98d3b55fce1e0936d5b9d0f7c79f1608405ca0eba89cd364	\N	F	picsum.photos/200	\N
1705038	Fardin Hossain	fardinoyon123@gmail.com	pbkdf2:sha256:260000$NE64KCOtQfCFLJY3$84831bda7911bb0b3ead83d699a755c510a02c4602cdbbdb4118a7d2d9966c68	\N	M	picsum.photos/200	\N
1705039	Tahmeed Tarek	tahmeedtarek@gmail.com	pbkdf2:sha256:260000$L8kpwrBVLblBFR7O$30acb3af5c7e9de627baf7a5f4132072f8f17ca2fcff105a3bfc3703e0beb05e	\N	M	picsum.photos/200	\N
1705040	Umama Rahman	umamarahman5177@gmail.com	pbkdf2:sha256:260000$6X8TrokH6IE21ydW$5f3904e1a86ce1f5041c117bdd44af075a20948a18b4f6b86525c0883f848967	\N	F	picsum.photos/200	\N
1705041	Asif Mustafa Hassan	asifmustafahassan@gmail.com	pbkdf2:sha256:260000$NFbUXaiVAPCfcWVk$3bb0a0685829d4f7803f25c23f1c72c337870f8615a159107250c63b18819131	\N	M	picsum.photos/200	\N
1705042	Sadat Shahriyar	shahriyarsadat@gmail.com	pbkdf2:sha256:260000$oKbALO8cNSVIK1mL$f2c81606254f44ef5836c423ae0ef331608a7aa8c2f9a3cee111ecde7f0fdf42	\N	M	picsum.photos/200	\N
1705043	Kawshik Kumar Paul	kawshik.kumar.paul@gmail.com	pbkdf2:sha256:260000$OQqPg4BFXH6k21EH$a2bf1e16d18b3829ad8d5c7adef8db8e98bded6854b415da04e263c053dd5ff4	\N	M	picsum.photos/200	\N
1705044	Najibul Haque Sarker	najibhaq98@gmail.com	pbkdf2:sha256:260000$9bQ3mn4PZVrR2oVS$22af52a427f2e4b766515f8fab237e1aaf42a5078a72a405534be805fd419421	\N	M	picsum.photos/200	\N
1705048	Sumaiya Azad	azadsumaiya00@gmail.com	pbkdf2:sha256:260000$7IAV8wMfCpr0hVPX$06c5c726955e3387b16e3dba01007c1b33f616dcb1147710725c31fde2aed7f8	\N	F	picsum.photos/200	\N
1705050	Musharaf Hossain	mdmusharaf8071@gmail.com	pbkdf2:sha256:260000$wUU1AorOJMIGybEU$7186d9513a8ffedf404dc95244e1df7713b5c6398ce8756d6cf2164e272a414f	\N	M	picsum.photos/200	\N
1705051	Rasman Mubtasim Swargo	rmswargo98@gmail.com	pbkdf2:sha256:260000$dTDPxIiwCDq6Ruv7$38d9fd6345bdb5c318e43fab28dc4f068f5ed9ac38097c304abb3b4e2be5c8a1	\N	M	picsum.photos/200	\N
1705053	Tousif Tanjim Anan	anantousif@gmail.com	pbkdf2:sha256:260000$KokNYSDbQpAM9BCW$c063e27faea43f5cee28a4135e31192c4935163158428c9b3159a6c7ac37ac72	\N	M	picsum.photos/200	\N
1705055	Md. Anwarul Karim	1705055@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$wjhDNL1uKXssGgFl$f0d5efcc882d26f6a285070bfe7d07c5d629aee9d3a4c754331f847c309737ae	\N	M	picsum.photos/200	\N
1705057	Tanveer Hossain Munim	munim987654321@gmail.com	pbkdf2:sha256:260000$4hUYuw3IbaOXNd8W$d0a98f20a25fb97326cfbc136a6016a69707d40c2255cf9d80466c683fec3f9c	\N	M	picsum.photos/200	\N
1705059	Shahriar-al-mohaiminul	mohaiminultanmoy@gmail.com	pbkdf2:sha256:260000$rIVXdWCGxPAMEGmn$67c1c35dad66c8ce13c523e76c1cd7677645204f882c900de92a92985106659c	\N	M	picsum.photos/200	\N
1705060	Maisha Rahman Mim	maisharahman494@gmail.com	pbkdf2:sha256:260000$595olEpwGXhC73px$f18fdf8c562b39f9a11c333723aad9e9fc08502277f39174f9550861275764c2	\N	F	picsum.photos/200	\N
1705062	Jawad Ul Kabir	jawaduk15@gmail.com	pbkdf2:sha256:260000$pIUgb3K1mDvcHf4V$108cd7c6375aeda4214113352e53117316cbe05846365834efc7d2b8322e0246	\N	M	picsum.photos/200	\N
1705064	Tanvir Raihan	traihan3130@gmail.com	pbkdf2:sha256:260000$NEh1QB0YYbc3TdSH$8aebda613af84090827fc84a8651d2a3ad76e3b7e2c61550255ff8b5f9178b0f	\N	M	picsum.photos/200	\N
1705065	Tashin Mubassira	taseen123buet@gmail.com	pbkdf2:sha256:260000$LIvbWHqfzFQcVIMs$0c4d8091d784981495fb8a4ff8ebacb1faf5ab093adfaa1b973f5d696bc01f87	\N	F	picsum.photos/200	\N
1705067	Purbasha Nishat	purbashafarhana@gmail.com	pbkdf2:sha256:260000$eLYDrTnHSJ4XgTc0$9f4ed47f2d3023d3c02478a9250b56c1d2458676afc95c3f623f3e625dd3f47f	\N	F	picsum.photos/200	\N
1705069	Tanzim Hossain Romel	1705069@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$qzCNaCWoaflQyrVM$12d709c992f97fce981b20e79798d2f0a151fb7a4f5ccf15e33e006ba0843c6a	\N	M	picsum.photos/200	\N
1705071	Prantik Paul	prantik0299@outlook.com	pbkdf2:sha256:260000$mng0JqazkG6eQO2f$8a042b653b538e0a936434a2092b4d04c8dcd74de734dae8dd1a125875b171f9	\N	M	picsum.photos/200	\N
1705072	Sourov Jajodia	sourov.jph@gmail.com	pbkdf2:sha256:260000$SudMVjXPIisflQjF$cca87dc8cc70ea92a1af5e9d96086b163af1cbc761e6a2aecf8fd6000e65c9fa	\N	M	picsum.photos/200	\N
1705074	Md. Tanzim Azad	nishan.tan.2015@gmail.com	pbkdf2:sha256:260000$fIDBoxuJsDaHKBXg$e555ffbb30ab43ea87d965dbbb4266c55352050e36407906de484b89099f0550	\N	M	picsum.photos/200	\N
1705076	Md Sabbir Rahman	red.abiir@gmail.com	pbkdf2:sha256:260000$bAw02GfdjNJbaNu0$e429a1da87e66dc7acf9fd6ca351dc06b642bf4c12ca36db5b2104bf15e62709	\N	M	picsum.photos/200	\N
1705078	Emamul Haque Pranta	mehpranta2015@gmail.com	pbkdf2:sha256:260000$V7DeGgvhzMqUP11K$9e36b81b158561f8515fa606662e19a5884556cfa44e183809ff4fef0e3e9372	\N	M	picsum.photos/200	\N
1705080	Shafayat Hossain Majumder	monsieurmajumder@gmail.com	pbkdf2:sha256:260000$lg1sRdCsDtfdEe82$63723afa2d68b61e31eec870b955e3d85a5a6303d00a379bae60e1b74b17e255	\N	M	picsum.photos/200	\N
1705081	Md.kamrujjaman Kamrul	1705081@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$je1Ug931ZB2dhs3n$b3f9c8e4d69a9fdf4eda20eced7d17d2b71615e78ad32103881932d6b916f84c	\N	M	picsum.photos/200	\N
1705083	Hozifa Rahman Hamim	hozifahamim150@gmail.com	pbkdf2:sha256:260000$2deRj2yKJSZW1hZ1$332cfd46d8ebc58cb0852474dc2f5fd845cf6a09dd2a26cfc56dc760de642379	\N	M	picsum.photos/200	\N
1705085	Mehedi Hasan (moidda)	mhasan912@gmail.com	pbkdf2:sha256:260000$lt1n8kRIj16U7Mba$99c31ec6daaf0ea979f11f2098d6267325a99d48c966a983fecd2f69a90ef69a	\N	M	picsum.photos/200	\N
1705086	Shafaet Zaman	shafaetzaman937@gmail.com	pbkdf2:sha256:260000$NgAyKYwGsdmbeyRw$a22397cde17b338c08dd0df6c28db147fc8b90bd267891c44f219b0aae3051ba	\N	M	picsum.photos/200	\N
1705088	Abdullah Al Noman	nomana589@gmail.com	pbkdf2:sha256:260000$Inudvylvb6QNy7XM$8bbbeb08b3be766a7f529ff783dd8feb88bb081e2b984ad4f8cfeda0802cb294	\N	M	picsum.photos/200	\N
1705090	Ashrafi Zannat Ankon	1705090@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$Mx78o3aH6WWRrszM$abb0dd51e9fbe715038665442830d96d457a8efd668fdfe5b1154f6492f1bfe1	\N	F	picsum.photos/200	\N
1705092	Asif Ajrof	asifajrof@gmail.com	pbkdf2:sha256:260000$Nd79BrYKaifGGJ6h$7bf125f556597ed13e27dafd49942a76cb5d5069328a90585b52a8d1bea62754	\N	M	picsum.photos/200	\N
1705094	Kazi Md.irshad	1705094@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$A3XQlORjB40ozuXb$99169573de5651f94e68c2bf5bef8983577d82a4c8d9d679f9dbde8363726550	\N	M	picsum.photos/200	\N
1705095	Arif Shariar Rahman	1705095@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$cBuLcrxhd1sWzgXk$45782aeaacd5b070c4f7e4595aaf1930a6ff01633dae2ed3bc0c2eac03156677	\N	M	picsum.photos/200	\N
1705097	Mohammad Shamim Ahsan	shamim19119@gmail.com	pbkdf2:sha256:260000$gD62DpS4F7SpJAgS$285e1eabbd07890742a631be41b4d50caee85f8c104678444b5dec9c3026fa55	\N	M	picsum.photos/200	\N
1705099	Abrar Shariare	abrar.cse17.buet@gmail.com	pbkdf2:sha256:260000$SsC7LSuA9sOlbokN$1fc097e331e70b7d71f5a171cf4ea62399682d158db61fa0a8f836a96b198998	\N	M	picsum.photos/200	\N
1705101	Abdur Rahman Shibly	shibly.ar@gmail.com	pbkdf2:sha256:260000$UU7MgZLkrLDIymGQ$4337d4acdb0f00a0bab46026cd789e266652bd48c03a3c490ec0a54575b9618b	\N	M	picsum.photos/200	\N
1705102	Sadia Saman	1705102@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$JkclffLguFHqiF3I$4e7c40765bd30d3d90da926eafa3a2e11e26e5603218e9533636eabfd845d273	\N	M	picsum.photos/200	\N
1705104	Anik Islam Pantha	1705104@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$wpvNt2Ki4HXtSU5i$d2213df96837c218454bddccb0cb7860fae533cb4b5291b7a94a15713d0778f1	\N	M	picsum.photos/200	\N
1705106	Sakibur Reza	sakiburrezajony@gmail.com	pbkdf2:sha256:260000$LuwnncpjWxgKjGX4$8ec52c43d98375bf43d231dc85fd950ca7190c26e7fb48de6db58b927d997ea4	\N	M	picsum.photos/200	\N
1705108	Muhtasim Noor Alif	muhtasimnoor@gmail.com	pbkdf2:sha256:260000$9H5BJVZo5cQkXuwR$a08b96a9cd2f2e8ebfdab94ff0c16a1dd92908fc10f51e4b7dd116c204e40815	\N	M	picsum.photos/200	\N
1705109	Muhammad Nasif Imtiaz	nasif.imtiaz1997@gmail.com	pbkdf2:sha256:260000$gWhMPBl3IFxrhmay$8013a13e6f3fccb31ad9b1f56d95e77ea05634525f7b5b65f5c202e90028d929	\N	M	picsum.photos/200	\N
1705110	Saif A. Khan	ksaifahmed4@gmail.com	pbkdf2:sha256:260000$wQxleQqDYhpnCAIx$818291a635037046fb64c98abbf6e187a88df003c1eae346958ae324341a5234	\N	M	picsum.photos/200	\N
1705111	Ridwanul Haque (Ridy)	1705111@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$IdGHpbKQiGS6QdiR$37899b043ce90dd46db70fc25df4afaeff1f456c03ba98f175de9adc6f8f11ed	\N	M	picsum.photos/200	\N
1705112	Zahin Hasan	zahinhasan2510@gmail.com	pbkdf2:sha256:260000$piz9PLsthFE4BKuR$b19d22ac751bb281545535cff47c58405dac5be09d10edcee9be37141ff8e300	\N	M	picsum.photos/200	\N
1705113	Mahir Shahriar Dhrubo	msdhrubo98@gmail.com	pbkdf2:sha256:260000$WCX5zgaGq1xAQ9u7$5acc154375ebd5addc5b58cfab6a961ff53260e99f35469f2c90254a3141c419	\N	M	picsum.photos/200	\N
1705114	Nuraiyad Nafiz Islam	nafizislam09@gmail.com	pbkdf2:sha256:260000$cUxd7onNduuAV1PL$e72d018201c5b024d16b5601886f9857a7db3e863ff2890abfea23fe7a37494e	\N	M	picsum.photos/200	\N
1705115	Nazmul Hasan	nazmul.buet17@gmail.com	pbkdf2:sha256:260000$9gnq0MbU5Xs3DnXb$d99e6d17fff6bbf84fe459915a20d87fe873adf4a70a576a9a7cf7a60302511b	\N	M	picsum.photos/200	\N
1705116	Saikat Ghatak	1705116@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$zFQ1IdrzIaleAWJZ$d9d6834533413bccf333e389cdcc7c8888a3bf1d1e7334832690ea8eb712955d	\N	M	picsum.photos/200	\N
1705118	Sharjil Hasan Mahir	sharjilmahir@gmail.com	pbkdf2:sha256:260000$YTszXtIwDNVHG60Q$d26ff1b45a98efe2d9f2aec24d6551d550820e155baad2c1636c4b820dc0c198	\N	M	picsum.photos/200	\N
1705119	Shariful Islam	sharifulislam08031998@gmail.com	pbkdf2:sha256:260000$xOe5VR0V8Ptl0kYR$752e26b10be273dec874a77c31a6c546125372c9e182bc64ca6531e0dac68b15	\N	M	picsum.photos/200	\N
1705120	Soham Khisa	1705120@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$oXvL3n7KAq9AbVm7$26426700de7d5c2f8c65d3822c69ca85ce89721cd89fcce5cd0a634e920bf47a	\N	M	picsum.photos/200	\N
1705121	Aman Ray	1705121@ugrad.cse.buet.ac.bd	pbkdf2:sha256:260000$Jy7tyn6WKTlhAAxQ$bd50087fe74095eb5dbd263af1a6048432ed91f4e6cde78fa78bdb7b128069de	\N	M	picsum.photos/200	\N
\.


--
-- Data for Name: psychiatrists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.psychiatrists (psychiatrist_id, is_verified, available_times, certificate_id) FROM stdin;
1705002	t	sometimes	BMDC_A_47808
1705044	t	always	BMDC_A_70777
1705045	f	never	swfewfgewg
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (question_id, question_text, created_at, is_approved) FROM stdin;
1	Little interest or pleasure in doing things?	2022-07-15 19:10:55.09782	t
2	Feeling more irritated, grouchy, or angry than usual?	2022-07-15 19:10:55.09782	t
3	Sleeping less than usual, but still have a lot of energy?	2022-07-15 19:10:55.09782	t
4	Feeling nervous, anxious, frightened, worried, or on edge?	2022-07-15 19:10:55.09782	t
5	Unexplained aches and pains (e.g., head, back, joints, abdomen, legs)?	2022-07-15 19:10:55.09782	t
6	Thoughts of actually hurting yourself?	2022-07-15 19:10:55.09782	t
7	Hearing things other people couldn’t hear, such as voices even when no one was around?	2022-07-15 19:10:55.09782	t
8	Problems with sleep that affected your sleep quality over all?	2022-07-15 19:10:55.09782	t
9	Problems with memory (e.g., learning new information) or with location (e.g., finding your way home)?	2022-07-15 19:10:55.09782	t
10	Unpleasant thoughts, urges, or images that repeatedly enter your mind?	2022-07-15 19:10:55.09782	t
11	Feeling detached or distant from yourself, your body, your physical surroundings, or your memories?	2022-07-15 19:10:55.09782	t
12	Not knowing who you really are or what you want out of life?	2022-07-15 19:10:55.09782	t
13	Drinking at least 4 drinks of any kind of alcohol in a single day?	2022-07-15 19:10:55.09782	t
14	I felt worthless.	2022-07-15 19:10:55.09782	t
15	I felt that I had nothing to look forward to.	2022-07-15 19:10:55.09782	t
16	I felt helpless.	2022-07-15 19:10:55.09782	t
17	I felt sad.	2022-07-15 19:10:55.09782	t
18	I felt like a failure.	2022-07-15 19:10:55.09782	t
19	I felt depressed.	2022-07-15 19:10:55.09782	t
20	I felt unhappy.	2022-07-15 19:10:55.09782	t
21	I felt hopeless.	2022-07-15 19:10:55.09782	t
22	I was irritated more than people knew.	2022-07-15 19:10:55.09782	t
23	I felt angry.	2022-07-15 19:10:55.09782	t
24	I felt like I was ready to explode.	2022-07-15 19:10:55.09782	t
25	I was grouchy.	2022-07-15 19:10:55.09782	t
26	I felt annoyed.	2022-07-15 19:10:55.09782	t
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name) FROM stdin;
\.


--
-- Data for Name: test_question; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_question (test_id, question_id, is_approved) FROM stdin;
1	1	t
1	2	t
1	3	t
1	4	t
1	5	t
1	6	t
1	7	t
1	8	t
1	9	t
1	10	t
1	11	t
1	12	t
1	13	t
2	14	t
2	15	t
2	16	t
2	17	t
2	18	t
2	19	t
2	20	t
2	21	t
3	22	t
3	23	t
3	24	t
3	25	t
3	26	t
\.


--
-- Data for Name: test_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_results (test_result_id, test_id, patient_id, submitted_at, verifier_id, verified_at, machine_report, manual_report, score) FROM stdin;
4	2	1705016	2022-01-01 01:00:00	\N	\N	\N	\N	\N
1	2	1705002	2022-07-15 21:29:35	\N	\N	\N	\N	8
5	2	1705017	2022-02-01 01:00:00	\N	\N	\N	\N	11
6	2	1705008	2022-02-01 01:00:00	\N	\N	\N	\N	12
7	2	1705008	2022-02-01 02:00:00	\N	\N	\N	\N	12
16	2	1705008	2022-02-01 04:00:00	\N	\N	\N	\N	12
17	2	1705008	2022-02-01 04:00:00	\N	\N	\N	\N	12
18	2	1705008	2022-02-01 04:00:00	\N	\N	\N	\N	12
19	2	1705008	2022-02-01 05:00:00	\N	\N	\N	\N	12
20	2	1705008	2022-02-01 05:00:00	\N	\N	\N	\N	12
21	2	1705008	2022-02-01 05:00:00	\N	\N	\N	\N	12
22	2	1705008	2022-02-01 05:00:00	\N	\N	\N	\N	12
36	2	1705008	2022-07-17 00:44:28	\N	\N	\N	\N	19
37	2	1705002	2022-07-17 00:45:52	\N	\N	\N	\N	19
38	2	1705008	2022-12-07 00:44:28	\N	\N	\N	\N	19
54	2	1705008	2022-11-07 00:44:28	\N	\N	\N		19
71	2	1705008	2022-11-07 00:44:28	\N	\N	\N	\N	19
72	2	1705008	2022-11-07 00:44:28	\N	\N	\N	\N	19
73	2	1705008	2022-11-07 00:44:28	\N	\N	\N	\N	19
74	2	1705008	2022-11-07 00:44:28	\N	\N	\N	\N	19
75	2	1705008	2022-11-07 00:44:28	\N	\N	\N	\N	0
76	2	1705002	2022-07-17 03:29:27	\N	\N	\N	\N	0
78	2	1705002	2022-07-17 10:15:16	\N	\N	\N	\N	0
79	3	1705002	2022-07-17 10:49:44	\N	\N	\N	\N	0
80	2	1705002	2022-07-17 14:42:00	\N	\N	\N	\N	0
\.


--
-- Data for Name: tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tests (test_id, name, description, created_at, is_approved, psychiatrist_id_of_added_by) FROM stdin;
1	DSM-5 Level 1 Cross-Cutting Symptom Measure	The questions below ask about things that might have bothered you.For each question, circle the number that bestdescribes how much (or how often) you have been bothered by each problem during the past TWO (2) WEEKS.	2022-07-14 15:12:32	t	1705002
2	LEVEL 2—Depression—Adult	Are you depressed for any recent happenings aroung you? 	2022-07-14 15:12:44	t	1705044
3	LEVEL 2—Anger—Adult	The questions below ask about these feelings in more detail and especially how often you (the individual receiving care) have been bothered by a list of symptoms during the past 7 days. 	2022-07-16 00:50:22	t	1705002
\.


--
-- Name: options_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.options_option_id_seq', 130, true);


--
-- Name: persons_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persons_person_id_seq', 5, true);


--
-- Name: questions_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_question_id_seq', 26, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- Name: test_results_test_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_results_test_result_id_seq', 80, true);


--
-- Name: tests_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tests_test_id_seq', 3, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: answer answer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_pkey PRIMARY KEY (test_result_id, option_id);


--
-- Name: counselling_suggestion counselling_suggestion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.counselling_suggestion
    ADD CONSTRAINT counselling_suggestion_pkey PRIMARY KEY (test_result_id, psychiatrist_id);


--
-- Name: options options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_pkey PRIMARY KEY (option_id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (patient_id);


--
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (person_id);


--
-- Name: psychiatrists psychiatrists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrists
    ADD CONSTRAINT psychiatrists_pkey PRIMARY KEY (psychiatrist_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: test_question test_question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_question
    ADD CONSTRAINT test_question_pkey PRIMARY KEY (test_id, question_id);


--
-- Name: test_results test_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_pkey PRIMARY KEY (test_result_id);


--
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (test_id);


--
-- Name: answer answer_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_option_id_fkey FOREIGN KEY (option_id) REFERENCES public.options(option_id);


--
-- Name: answer answer_test_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_test_result_id_fkey FOREIGN KEY (test_result_id) REFERENCES public.test_results(test_result_id);


--
-- Name: counselling_suggestion counselling_suggestion_psychiatrist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.counselling_suggestion
    ADD CONSTRAINT counselling_suggestion_psychiatrist_id_fkey FOREIGN KEY (psychiatrist_id) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- Name: counselling_suggestion counselling_suggestion_test_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.counselling_suggestion
    ADD CONSTRAINT counselling_suggestion_test_result_id_fkey FOREIGN KEY (test_result_id) REFERENCES public.test_results(test_result_id);


--
-- Name: options options_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- Name: patients patients_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.persons(person_id);


--
-- Name: psychiatrists psychiatrists_psychiatrist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psychiatrists
    ADD CONSTRAINT psychiatrists_psychiatrist_id_fkey FOREIGN KEY (psychiatrist_id) REFERENCES public.persons(person_id);


--
-- Name: test_question test_question_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_question
    ADD CONSTRAINT test_question_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- Name: test_question test_question_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_question
    ADD CONSTRAINT test_question_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.tests(test_id);


--
-- Name: test_results test_results_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(patient_id);


--
-- Name: test_results test_results_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.tests(test_id);


--
-- Name: test_results test_results_verifier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_verifier_id_fkey FOREIGN KEY (verifier_id) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- Name: tests tests_psychiatrist_id_of_added_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_psychiatrist_id_of_added_by_fkey FOREIGN KEY (psychiatrist_id_of_added_by) REFERENCES public.psychiatrists(psychiatrist_id);


--
-- PostgreSQL database dump complete
--

