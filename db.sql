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
-- Name: person_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.person_role AS ENUM (
    'PATIENT',
    'PSYCHIATRIST',
    'BOARD MEMBER'
);


ALTER TYPE public.person_role OWNER TO postgres;

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
    available_times character varying(256)
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
    submitted_at timestamp without time zone NOT NULL,
    verifier_id integer,
    verified_at timestamp without time zone,
    machine_report character varying(256),
    manual_report character varying(256)
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
0d20ee4105a4
\.


--
-- Data for Name: answer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answer (test_result_id, option_id) FROM stdin;
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
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients (height_inches, weight_kgs, location, patient_id) FROM stdin;
\.


--
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persons (person_id, name, email, password_hash, date_of_birth, gender, photo_path, cellphone) FROM stdin;
1705001	Kowshic Roy	vdrkowshic@gmail.com	1521249494	\N	M	picsum.photos/200	\N
1705002	Sheikh Azizul Hakim	1705002@ugrad.cse.buet.ac.bd	1911302328	\N	M	picsum.photos/200	\N
1705003	Mahdi Hasnat Siyam	mahdibuet3@gmail.com	1991227787	\N	M	picsum.photos/200	\N
1705004	Ramisa Alam	ramisa2108@gmail.com	1751703524	\N	F	picsum.photos/200	\N
1705005	Mashiat Mustaq	mashiatmustaq98@gmail.com	1511048861	\N	F	picsum.photos/200	\N
1705006	Saiful Islam	saifulislambuet11@gmail.com	1734569581	\N	M	picsum.photos/200	\N
1705007	Md. Tawsif Shahriar Dipto	tawsifshahriar7@gmail.com	1786058248	\N	M	picsum.photos/200	\N
1705008	Sheikh Saifur Rahman Jony	srj.buet17@gmail.com	1735722087	\N	M	picsum.photos/200	\N
1705009	Shayekh Bin Islam	shayekh.bin.islam@gmail.com	1742000526	\N	M	picsum.photos/200	\N
1705010	Md. Zarif-Ul-Alam	zarif98sjs@gmail.com	1915616046	\N	M	picsum.photos/200	\N
1705011	Md. Salman Farsi	salman201103@gmail.com	1783043130	\N	M	picsum.photos/200	\N
1705012	Jamilus Sheium	sheium1998@gmail.com	1533579090	\N	M	picsum.photos/200	\N
1705013	Md. Olid Hasan Bhuiyan	1705013@ugrad.cse.buet.ac.bd	1721875431	\N	M	picsum.photos/200	\N
1705014	Naeem Ahmed	naeemtanveer1024@gmail.com	1830343798	\N	M	picsum.photos/200	\N
1705015	Zaber Ibn Abdul Hakim	ak5236638@gmail.com	1961896264	\N	M	picsum.photos/200	\N
1705016	Ridwanul Hasan Tanvir	1705016@ugrad.cse.buet.ac.bd	1954597897	\N	M	picsum.photos/200	\N
1705017	Towhidul Islam	towhidpqrst@gmail.com	1784176662	\N	M	picsum.photos/200	\N
1705018	Shakil Ahmed	shakilahmedndc@gmail.com	1993401991	\N	M	picsum.photos/200	\N
1705019	Adrita Hossain Nakshi	1705019@ugrad.cse.buet.ac.bd	1878046439	\N	F	picsum.photos/200	\N
1705020	Md. Arafat Hossain	araf.reputation1999@gmail.com	1315167327	\N	M	picsum.photos/200	\N
1705021	Md. Shadmim Hasan Sifat	sifathshadmim@gmail.com	1706758392	\N	M	picsum.photos/200	\N
1705022	Solaiman Ahmed	solaimanahmed112@gmail.com	1956944711	\N	M	picsum.photos/200	\N
1705023	S. M. Zuhair Jawhar Zaki	zuhairzaki500@gmail.com	1914254395	\N	M	picsum.photos/200	\N
1705024	Khandokar Md. Rahat Hossain	rahat2975134@gmail.com	1552420536	\N	M	picsum.photos/200	\N
1705025	Swapnil Dey	swapnildey1999@gmail.com	1747734570	\N	M	picsum.photos/200	\N
1705026	Shafqat Rakin	shafqatrakin@gmail.com	1521560131	\N	M	picsum.photos/200	\N
1705027	Saem Hasan	sayim.hasan30@gmail.com	1626187505	\N	M	picsum.photos/200	\N
1705028	Samira Islam	samiraakhter8657@gmail.com	1742758184	\N	F	picsum.photos/200	\N
1705029	Simantika Dristi	queendristi27@gmail.com	1871666053	\N	F	picsum.photos/200	\N
1705030	Joy Saha	iamjoysaha1.0@gmail.com	1795909318	\N	M	picsum.photos/200	\N
1705031	Md. Mahedi Hasan Rigan	mahedihasanrigan82@gmail.com	1871045199	\N	M	picsum.photos/200	\N
1705032	Tanjim Ahmed Khan	tanjim.ak49@gmail.com	1986342049	\N	M	picsum.photos/200	\N
1705033	Tanberul Islam Ruhan	tanberulislam98@gmail.com	1861078518	\N	M	picsum.photos/200	\N
1705034	Souvik Das	souvik.piyal@gmail.com	1988912542	\N	M	picsum.photos/200	\N
1705035	A. Z. M Mehedi Hasan	mehedihm2015@gmail.com	1723976954	\N	M	picsum.photos/200	\N
1705036	Ayan Antik Khan	ayanantikkhan@gmail.com	1777187087	\N	M	picsum.photos/200	\N
1705037	Mushtari Sadia	mushtarisadia98@gmail.com	1746518030	\N	F	picsum.photos/200	\N
1705038	Fardin Hossain	fardinoyon123@gmail.com	1864712959	\N	M	picsum.photos/200	\N
1705039	Tahmeed Tarek	tahmeedtarek@gmail.com	1764496362	\N	M	picsum.photos/200	\N
1705040	Umama Rahman	umamarahman5177@gmail.com	1799358591	\N	F	picsum.photos/200	\N
1705041	Asif Mustafa Hassan	asifmustafahassan@gmail.com	1783942932	\N	M	picsum.photos/200	\N
1705042	Sadat Shahriyar	shahriyarsadat@gmail.com	1552477731	\N	M	picsum.photos/200	\N
1705043	Kawshik Kumar Paul	kawshik.kumar.paul@gmail.com	1516763648	\N	M	picsum.photos/200	\N
1705044	Najibul Haque Sarker	najibhaq98@gmail.com	1927152595	\N	M	picsum.photos/200	\N
1705045	Iftekhar Hakim Kaowsar	iftekharhakimkaowsar88@gmail.com	1842223102	\N	M	picsum.photos/200	\N
1705047	Jayanta Sadhu	jayantasadhu4557@gmail.com	1627772729	\N	M	picsum.photos/200	\N
1705048	Sumaiya Azad	azadsumaiya00@gmail.com	1711332312	\N	F	picsum.photos/200	\N
1705049	Taufiqun Nur Farid	1705049@ugrad.cse.buet.ac.bd	1831690061	\N	M	picsum.photos/200	\N
1705050	Musharaf Hossain	mdmusharaf8071@gmail.com	1782938071	\N	M	picsum.photos/200	\N
1705051	Rasman Mubtasim Swargo	rmswargo98@gmail.com	1744922677	\N	M	picsum.photos/200	\N
1705052	Pushpita Joardar	pushpitajoardar21@gmail.com	1777675377	\N	F	picsum.photos/200	\N
1705053	Tousif Tanjim Anan	anantousif@gmail.com	1521222210	\N	M	picsum.photos/200	\N
1705054	Monirul Haq Imon	worstemon8@gmail.com	1703843992	\N	M	picsum.photos/200	\N
1705055	Md. Anwarul Karim	1705055@ugrad.cse.buet.ac.bd	1534559185	\N	M	picsum.photos/200	\N
1705056	Apurba Saha	diponsaha007@gmail.com	1776198230	\N	M	picsum.photos/200	\N
1705057	Tanveer Hossain Munim	munim987654321@gmail.com	1768244283	\N	M	picsum.photos/200	\N
1705058	Fattah-zul-ikram	galib05058@gmail.com	1799410446	\N	M	picsum.photos/200	\N
1705059	Shahriar-al-mohaiminul	mohaiminultanmoy@gmail.com	1704301039	\N	M	picsum.photos/200	\N
1705060	Maisha Rahman Mim	maisharahman494@gmail.com	1919922921	\N	F	picsum.photos/200	\N
1705061	Maksudur Rahaman Rana	mksdrrana@gmail.com	1521115388	\N	M	picsum.photos/200	\N
1705062	Jawad Ul Kabir	jawaduk15@gmail.com	1621852592	\N	M	picsum.photos/200	\N
1705063	Mahfuzur Rahman Rifat	mahfuzrifat7@gmail.com	1949351035	\N	M	picsum.photos/200	\N
1705064	Tanvir Raihan	traihan3130@gmail.com	1643171903	\N	M	picsum.photos/200	\N
1705065	Tashin Mubassira	taseen123buet@gmail.com	1975005282	\N	F	picsum.photos/200	\N
1705066	Ataf Fazledin Ahamed	rabidahamed@gmail.com	1789949615	\N	M	picsum.photos/200	\N
1705067	Purbasha Nishat	purbashafarhana@gmail.com	1771054459	\N	F	picsum.photos/200	\N
1705068	Saadman Ahmed	1705068@ugrad.cse.buet.ac.bd	1711153713	\N	M	picsum.photos/200	\N
1705069	Tanzim Hossain Romel	1705069@ugrad.cse.buet.ac.bd	1771600158	\N	M	picsum.photos/200	\N
1705070	Al Arafat Tanin	1705070@ugrad.cse.buet.ac.bd	1715006772	\N	M	picsum.photos/200	\N
1705071	Prantik Paul	prantik0299@outlook.com	1521527491	\N	M	picsum.photos/200	\N
1705072	Sourov Jajodia	sourov.jph@gmail.com	1752612637	\N	M	picsum.photos/200	\N
1705073	Istiak Bin Mahmod	1705073@ugrad.cse.buet.ac.bd	1521528392	\N	M	picsum.photos/200	\N
1705074	Md. Tanzim Azad	nishan.tan.2015@gmail.com	1724729159	\N	M	picsum.photos/200	\N
1705075	Ovi Poddar	ovi.poddar2@gmail.com	1624932354	\N	M	picsum.photos/200	\N
1705076	Md Sabbir Rahman	red.abiir@gmail.com	1766805221	\N	M	picsum.photos/200	\N
1705077	Fahim Faysal	ffalsoy@gmail.com	1797128891	\N	M	picsum.photos/200	\N
1705078	Emamul Haque Pranta	mehpranta2015@gmail.com	1835108487	\N	M	picsum.photos/200	\N
1705079	Kazi Wasif Shammya	kaziwasifamin@hotmail.com	1521259956	\N	M	picsum.photos/200	\N
1705080	Shafayat Hossain Majumder	monsieurmajumder@gmail.com	1830994274	\N	M	picsum.photos/200	\N
1705081	Md.kamrujjaman Kamrul	1705081@ugrad.cse.buet.ac.bd	1781155771	\N	M	picsum.photos/200	\N
1705082	Md. Mehedi Hasan	1705082@ugrad.cse.buet.ac.bd	1945551171	\N	M	picsum.photos/200	\N
1705083	Hozifa Rahman Hamim	hozifahamim150@gmail.com	1919202834	\N	M	picsum.photos/200	\N
1705084	Asif Ahmed Utsa	1705084@ugrad.cse.buet.ac.bd	1700545293	\N	M	picsum.photos/200	\N
1705085	Mehedi Hasan (moidda)	mhasan912@gmail.com	1969500278	\N	M	picsum.photos/200	\N
1705086	Shafaet Zaman	shafaetzaman937@gmail.com	1717016754	\N	M	picsum.photos/200	\N
1705087	Fahmid Al Rifat	alrifatfahmid@gmail.com	1774550000	\N	M	picsum.photos/200	\N
1705088	Abdullah Al Noman	nomana589@gmail.com	1521103929	\N	M	picsum.photos/200	\N
1705089	Noshin Ulfat	1705089@ugrad.cse.buet.ac.bd	1723820529	\N	F	picsum.photos/200	\N
1705090	Ashrafi Zannat Ankon	1705090@ugrad.cse.buet.ac.bd	1876349517	\N	F	picsum.photos/200	\N
1705091	Nahian Salsabil	cse_salsabil@yahoo.com	1750090319	\N	F	picsum.photos/200	\N
1705092	Asif Ajrof	asifajrof@gmail.com	1521337268	\N	M	picsum.photos/200	\N
1705093	Fatima Nawmi	fatimanawmi@gmail.com	1795383737	\N	F	picsum.photos/200	\N
1705094	Kazi Md.irshad	1705094@ugrad.cse.buet.ac.bd	1625216217	\N	M	picsum.photos/200	\N
1705095	Arif Shariar Rahman	1705095@ugrad.cse.buet.ac.bd	1722536574	\N	M	picsum.photos/200	\N
1705096	Kazim Abrar Mahi	kazimabrarmahi135@gmail.com	1771300000	\N	M	picsum.photos/200	\N
1705097	Mohammad Shamim Ahsan	shamim19119@gmail.com	1765102940	\N	M	picsum.photos/200	\N
1705098	Sihat Afnan	sihatafnan15.9.1997@gmail.com	1710680500	\N	M	picsum.photos/200	\N
1705099	Abrar Shariare	abrar.cse17.buet@gmail.com	1736953245	\N	M	picsum.photos/200	\N
1705100	Farhana Khan	farhanakhanhp@gmail.com	1552431224	\N	F	picsum.photos/200	\N
1705101	Abdur Rahman Shibly	shibly.ar@gmail.com	1521515755	\N	M	picsum.photos/200	\N
1705102	Sadia Saman	1705102@ugrad.cse.buet.ac.bd	1703746964	\N	M	picsum.photos/200	\N
1705103	Nazmul Takbir	nazmultakbir98@gmail.com	1727498589	\N	M	picsum.photos/200	\N
1705104	Anik Islam Pantha	1705104@ugrad.cse.buet.ac.bd	1784805803	\N	M	picsum.photos/200	\N
1705105	Rittik Basak Utsha	rittik.basak@gmail.com	1786044714	\N	M	picsum.photos/200	\N
1705106	Sakibur Reza	sakiburrezajony@gmail.com	1727543124	\N	M	picsum.photos/200	\N
1705107	Abu Nowshed Sakib	ansakib04@gmail.com	1799556469	\N	M	picsum.photos/200	\N
1705108	Muhtasim Noor Alif	muhtasimnoor@gmail.com	1756466856	\N	M	picsum.photos/200	\N
1705109	Muhammad Nasif Imtiaz	nasif.imtiaz1997@gmail.com	1706363005	\N	M	picsum.photos/200	\N
1705110	Saif A. Khan	ksaifahmed4@gmail.com	1685337373	\N	M	picsum.photos/200	\N
1705111	Ridwanul Haque (Ridy)	1705111@ugrad.cse.buet.ac.bd	1971302600	\N	M	picsum.photos/200	\N
1705112	Zahin Hasan	zahinhasan2510@gmail.com	1913096613	\N	M	picsum.photos/200	\N
1705113	Mahir Shahriar Dhrubo	msdhrubo98@gmail.com	1731694903	\N	M	picsum.photos/200	\N
1705114	Nuraiyad Nafiz Islam	nafizislam09@gmail.com	1717547591	\N	M	picsum.photos/200	\N
1705115	Nazmul Hasan	nazmul.buet17@gmail.com	1621143677	\N	M	picsum.photos/200	\N
1705116	Saikat Ghatak	1705116@ugrad.cse.buet.ac.bd	1981869210	\N	M	picsum.photos/200	\N
1705118	Sharjil Hasan Mahir	sharjilmahir@gmail.com	1747903902	\N	M	picsum.photos/200	\N
1705119	Shariful Islam	sharifulislam08031998@gmail.com	1721346220	\N	M	picsum.photos/200	\N
1705120	Soham Khisa	1705120@ugrad.cse.buet.ac.bd	1890311264	\N	M	picsum.photos/200	\N
1705121	Aman Ray	1705121@ugrad.cse.buet.ac.bd	9819697906	\N	M	picsum.photos/200	\N
\.


--
-- Data for Name: psychiatrists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.psychiatrists (psychiatrist_id, is_verified, available_times) FROM stdin;
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (question_id, question_text, created_at, is_approved) FROM stdin;
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
\.


--
-- Data for Name: test_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_results (test_result_id, test_id, patient_id, submitted_at, verifier_id, verified_at, machine_report, manual_report) FROM stdin;
\.


--
-- Data for Name: tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tests (test_id, name, description, created_at, is_approved, psychiatrist_id_of_added_by) FROM stdin;
\.


--
-- Name: options_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.options_option_id_seq', 1, false);


--
-- Name: persons_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persons_person_id_seq', 1, false);


--
-- Name: questions_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_question_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- Name: test_results_test_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_results_test_result_id_seq', 1, false);


--
-- Name: tests_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tests_test_id_seq', 1, false);


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

