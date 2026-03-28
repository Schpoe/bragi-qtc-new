--
-- PostgreSQL database dump
--

\restrict tW94aDjl5U0wccyrgUhHjTYei8ApS2xOgRRNRrIQeIgQr06v6IxtjDUzltna7Vn

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Allocation; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."Allocation" (
    id text NOT NULL,
    sprint_id text NOT NULL,
    team_member_id text NOT NULL,
    work_area_id text NOT NULL,
    percent integer NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Allocation" OWNER TO bragi;

--
-- Name: JiraSyncHistory; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."JiraSyncHistory" (
    id text NOT NULL,
    "timestamp" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    jql text,
    result_summary jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."JiraSyncHistory" OWNER TO bragi;

--
-- Name: QuarterlyAllocation; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."QuarterlyAllocation" (
    id text NOT NULL,
    quarter text NOT NULL,
    team_member_id text NOT NULL,
    work_area_id text NOT NULL,
    percent integer NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."QuarterlyAllocation" OWNER TO bragi;

--
-- Name: QuarterlyPlanHistory; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."QuarterlyPlanHistory" (
    id text NOT NULL,
    quarter text NOT NULL,
    action text,
    team_id text,
    team_member_id text,
    work_area_id text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    changed_at timestamp(3) without time zone,
    member_discipline text,
    member_name text,
    new_percent integer,
    old_percent integer,
    team_name text,
    work_area_name text,
    work_area_type text
);


ALTER TABLE public."QuarterlyPlanHistory" OWNER TO bragi;

--
-- Name: QuarterlyPlanSnapshot; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."QuarterlyPlanSnapshot" (
    id text NOT NULL,
    quarter text NOT NULL,
    team_id text NOT NULL,
    team_name text,
    label text NOT NULL,
    note text,
    created_by_email text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    allocations jsonb NOT NULL
);


ALTER TABLE public."QuarterlyPlanSnapshot" OWNER TO bragi;

--
-- Name: QuarterlyWorkAreaSelection; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."QuarterlyWorkAreaSelection" (
    id text NOT NULL,
    quarter text NOT NULL,
    team_id text NOT NULL,
    work_area_ids text[],
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."QuarterlyWorkAreaSelection" OWNER TO bragi;

--
-- Name: Sprint; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."Sprint" (
    id text NOT NULL,
    team_id text,
    name text NOT NULL,
    quarter text NOT NULL,
    start_date timestamp(3) without time zone,
    end_date timestamp(3) without time zone,
    is_cross_team boolean DEFAULT false NOT NULL,
    is_template boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    relevant_work_area_ids text[]
);


ALTER TABLE public."Sprint" OWNER TO bragi;

--
-- Name: Team; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."Team" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    lead_id text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    color text
);


ALTER TABLE public."Team" OWNER TO bragi;

--
-- Name: TeamMember; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."TeamMember" (
    id text NOT NULL,
    team_id text NOT NULL,
    name text NOT NULL,
    discipline text NOT NULL,
    availability_percent integer DEFAULT 100 NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."TeamMember" OWNER TO bragi;

--
-- Name: User; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."User" (
    id text NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    full_name text,
    role text DEFAULT 'viewer'::text NOT NULL,
    managed_team_ids text[],
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    first_name text,
    last_name text,
    "position" text
);


ALTER TABLE public."User" OWNER TO bragi;

--
-- Name: WorkArea; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."WorkArea" (
    id text NOT NULL,
    name text NOT NULL,
    type text,
    leading_team_id text,
    supporting_team_ids text[],
    prod_id text,
    jira_key text,
    jira_status text,
    jira_progress integer,
    last_synced timestamp(3) without time zone,
    linked_epic_keys text[],
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    color text
);


ALTER TABLE public."WorkArea" OWNER TO bragi;

--
-- Name: WorkAreaType; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public."WorkAreaType" (
    id text NOT NULL,
    name text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    color text
);


ALTER TABLE public."WorkAreaType" OWNER TO bragi;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: bragi
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO bragi;

--
-- Data for Name: Allocation; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."Allocation" (id, sprint_id, team_member_id, work_area_id, percent, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: JiraSyncHistory; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."JiraSyncHistory" (id, "timestamp", jql, result_summary, created_at) FROM stdin;
\.


--
-- Data for Name: QuarterlyAllocation; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."QuarterlyAllocation" (id, quarter, team_member_id, work_area_id, percent, created_at, updated_at) FROM stdin;
0f0c0d86-cd6d-4824-a94d-f501b4dcdfb3	Q2 2026	69b1547e9aa954f7307facb7	69b1859edef14df1ef2c9eb4	20	2026-03-27 18:00:17.587	2026-03-27 18:00:17.587
2fbabeac-13c0-4279-9756-66d2f67a66b1	Q2 2026	69b1547e9aa954f7307facb7	69b185a409577dbee0b9b90d	85	2026-03-27 18:00:21.158	2026-03-27 18:00:21.158
329df9b9-64a3-4a95-9b66-d855ab4c8730	Q2 2026	69b154af77d58bf4c3897c6c	69b1859edef14df1ef2c9eb4	20	2026-03-27 19:15:49.126	2026-03-27 19:15:49.126
e86d68d0-8ebc-4a14-8a3d-424753b4e518	Q2 2026	69b154af77d58bf4c3897c6c	69b185b3af96b945e88e884f	15	2026-03-27 19:15:52.561	2026-03-27 19:15:52.561
7d2094f3-2e35-45e5-a356-ac25b56c6302	Q2 2026	69b154af77d58bf4c3897c6c	69b185b4e92ef3b524f9d648	20	2026-03-27 19:15:57.77	2026-03-27 19:15:57.77
647ba7a3-2d8e-4dc6-9d44-f06fbc77b4aa	Q2 2026	69b154af77d58bf4c3897c6c	69b185b2e3897d2857a85f2d	15	2026-03-27 19:15:51.04	2026-03-27 19:16:04.589
21683add-3ac4-4a3b-8c9d-0c2e8fa12d40	Q2 2026	69b154af77d58bf4c3897c6c	69b185a409577dbee0b9b90d	25	2026-03-27 19:15:49.96	2026-03-27 19:16:08.622
e1fe84ae-a5b4-4249-a7a9-14188dab69bb	Q2 2026	69b154c497d6a38db8d76a24	69b1859edef14df1ef2c9eb4	15	2026-03-27 19:16:12.909	2026-03-27 19:16:12.909
7a610a43-3c38-4cd6-96d4-51165c903bcd	Q2 2026	69b154c497d6a38db8d76a24	69b185a409577dbee0b9b90d	15	2026-03-27 19:16:14.001	2026-03-27 19:16:14.001
e2aa9379-c82b-442f-bb61-4694ebb88529	Q2 2026	69b154c497d6a38db8d76a24	69b185b2e3897d2857a85f2d	15	2026-03-27 19:16:15.372	2026-03-27 19:16:15.372
87280c9f-7349-48a0-b56e-68a6f94ab42d	Q2 2026	69b154c497d6a38db8d76a24	69b185b3af96b945e88e884f	15	2026-03-27 19:16:18.628	2026-03-27 19:16:18.628
333f8110-cc93-4590-84cf-11db57c35760	Q2 2026	69b154c497d6a38db8d76a24	69b185b4e92ef3b524f9d648	15	2026-03-27 19:16:20.34	2026-03-27 19:16:20.34
a21a17b5-4c8b-4f33-8f9b-f6b5864b9ca9	Q2 2026	69b154e4fb62afd7f3d4004a	69b1859edef14df1ef2c9eb4	12	2026-03-27 19:16:25.572	2026-03-27 19:16:25.572
b8f025b2-70bc-4911-aa72-fe8766cf4a67	Q2 2026	69b154e4fb62afd7f3d4004a	69b185a409577dbee0b9b90d	23	2026-03-27 19:16:26.771	2026-03-27 19:16:26.771
cae9225c-b958-4156-afb9-409f44e99269	Q2 2026	69b154e4fb62afd7f3d4004a	69b185b3af96b945e88e884f	23	2026-03-27 19:16:30.456	2026-03-27 19:16:30.456
71ace1d8-98aa-4eb1-9876-bc5a570f8df0	Q2 2026	69b154e4fb62afd7f3d4004a	69b185b4e92ef3b524f9d648	13	2026-03-27 19:16:33.454	2026-03-27 19:16:33.454
117b47e2-bed6-47ac-b6d1-519855678b21	Q2 2026	69b154e4fb62afd7f3d4004a	69b185b2e3897d2857a85f2d	12	2026-03-27 19:16:28.761	2026-03-27 19:16:42.524
1a1020c0-d4c6-4135-8cf7-be2bf5543ccb	Q2 2026	69b154f88704ff2f2e96c8da	69b1859edef14df1ef2c9eb4	10	2026-03-27 19:16:43.747	2026-03-27 19:16:43.747
02f4d37c-35c8-4753-9c80-c25b771a46fa	Q2 2026	69b154f88704ff2f2e96c8da	69b185a409577dbee0b9b90d	10	2026-03-27 19:16:44.544	2026-03-27 19:16:44.544
5918ee46-523d-4976-ac6b-429da3a9fafe	Q2 2026	69b154f88704ff2f2e96c8da	69b185b2e3897d2857a85f2d	25	2026-03-27 19:16:45.549	2026-03-27 19:16:45.549
02c2011d-abea-476b-958a-21016f549e47	Q2 2026	69b154f88704ff2f2e96c8da	69b185b3af96b945e88e884f	20	2026-03-27 19:16:46.341	2026-03-27 19:16:46.341
f5eef64e-f54e-4c5b-ad73-ac6b79c1e093	Q2 2026	69b154f88704ff2f2e96c8da	69b185b4e92ef3b524f9d648	12	2026-03-27 19:16:49.519	2026-03-27 19:16:49.519
\.


--
-- Data for Name: QuarterlyPlanHistory; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."QuarterlyPlanHistory" (id, quarter, action, team_id, team_member_id, work_area_id, created_at, changed_at, member_discipline, member_name, new_percent, old_percent, team_name, work_area_name, work_area_type) FROM stdin;
ab22a408-51ab-4dfc-8dd8-69d7ed23f1b9	Q2 2026	removed	69b119d6b705fe95e0c67bcf	69b154f88704ff2f2e96c8da	69b185ba101b59c82aa3f2a9	2026-03-27 17:53:26.011	2026-03-27 17:53:26.002	Cloud	CloudDude	\N	89	Growth	QCC | Bragi AI v2.2 enabling "Bragi AI PRO" scope	Product | Platform
a3b19ce8-d57a-479b-b667-c9d6a9f84944	Q2 2026	removed	69b119d6b705fe95e0c67bcf	69b154f88704ff2f2e96c8da	69b185bbc70cf147f383b5c6	2026-03-27 17:53:27.959	2026-03-27 17:53:27.951	Cloud	CloudDude	\N	20	Growth	Growth Team | Tech Debt & Maintenance | Q3+Q4 2025	Product | Platform
be9603a5-06ec-4ae8-aa71-e6574566103b	Q2 2026	removed	69b119d6b705fe95e0c67bcf	69b154f88704ff2f2e96c8da	69b185be7a1c273241518cc9	2026-03-27 17:53:29.794	2026-03-27 17:53:29.785	Cloud	CloudDude	\N	20	Growth	QCC | Bragi AI v2.1 enabling "Bragi AI Scope"	Product | Platform
6795ffd4-c05d-4d8d-b3b8-0b1821871a45	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b1547e9aa954f7307facb7	69b1859edef14df1ef2c9eb4	2026-03-27 18:00:17.59	2026-03-27 18:00:17.58	Android	AndroidDev	20	\N	Growth	Amazon Poplar | Sensor Workpackage for QCC S7	Product | Platform
0380f871-5440-4814-964c-b5c78ad991fd	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b1547e9aa954f7307facb7	69b185a409577dbee0b9b90d	2026-03-27 18:00:21.155	2026-03-27 18:00:21.148	Android	AndroidDev	85	\N	Growth	Golden ADK | QCC ADK Update to latest Version	Roadmap Initiative
f90575b1-534a-4ea2-a135-06850f90119b	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154af77d58bf4c3897c6c	69b1859edef14df1ef2c9eb4	2026-03-27 19:15:49.129	2026-03-27 19:15:49.116	iOS	iOSDev	20	\N	Growth	Amazon Poplar | Sensor Workpackage for QCC S7	Product | Platform
456ab8d9-d6d5-4c3d-8f82-9269e0c647c4	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154af77d58bf4c3897c6c	69b185a409577dbee0b9b90d	2026-03-27 19:15:49.964	2026-03-27 19:15:49.954	iOS	iOSDev	30	\N	Growth	Golden ADK | QCC ADK Update to latest Version	Roadmap Initiative
d8bf72e8-db79-48db-9533-5450ac60332f	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154af77d58bf4c3897c6c	69b185b2e3897d2857a85f2d	2026-03-27 19:15:51.038	2026-03-27 19:15:51.032	iOS	iOSDev	30	\N	Growth	WQ | Bragi AI v2.0 enabling "App-only" Scope	Product | Platform
e2b9ab3c-7b4a-4a3d-9c6c-a819a30b4afd	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154af77d58bf4c3897c6c	69b185b3af96b945e88e884f	2026-03-27 19:15:52.558	2026-03-27 19:15:52.552	iOS	iOSDev	15	\N	Growth	Actions | Bragi AI v2.0 enabling "App-only" scope	Product | Platform
49d4c912-d098-4046-a52a-5f7c8e2f9620	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154af77d58bf4c3897c6c	69b185b4e92ef3b524f9d648	2026-03-27 19:15:57.771	2026-03-27 19:15:57.763	iOS	iOSDev	20	\N	Growth	Actions | Bragi AI v2.2 enabling "Bragi AI PRO" scope	Product | Platform
78e27b47-3d36-4cd6-a4e1-0e8a91f8241e	Q2 2026	updated	69b119d6b705fe95e0c67bcf	69b154af77d58bf4c3897c6c	69b185b2e3897d2857a85f2d	2026-03-27 19:16:04.592	2026-03-27 19:16:04.582	iOS	iOSDev	15	30	Growth	WQ | Bragi AI v2.0 enabling "App-only" Scope	Product | Platform
82b100a0-a972-4b69-9617-ff75ae58c632	Q2 2026	updated	69b119d6b705fe95e0c67bcf	69b154af77d58bf4c3897c6c	69b185a409577dbee0b9b90d	2026-03-27 19:16:08.625	2026-03-27 19:16:08.615	iOS	iOSDev	25	30	Growth	Golden ADK | QCC ADK Update to latest Version	Roadmap Initiative
98d3e4ba-27aa-4e90-84ca-5dc77d5b77a9	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154c497d6a38db8d76a24	69b1859edef14df1ef2c9eb4	2026-03-27 19:16:12.911	2026-03-27 19:16:12.904	QA	QAGuy	15	\N	Growth	Amazon Poplar | Sensor Workpackage for QCC S7	Product | Platform
3239ca51-8b7d-49e1-8199-1d2356b871da	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154c497d6a38db8d76a24	69b185a409577dbee0b9b90d	2026-03-27 19:16:13.999	2026-03-27 19:16:13.992	QA	QAGuy	15	\N	Growth	Golden ADK | QCC ADK Update to latest Version	Roadmap Initiative
4d19de90-d8ce-4f09-92ba-10c61716275a	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154c497d6a38db8d76a24	69b185b2e3897d2857a85f2d	2026-03-27 19:16:15.374	2026-03-27 19:16:15.365	QA	QAGuy	15	\N	Growth	WQ | Bragi AI v2.0 enabling "App-only" Scope	Product | Platform
a68d3654-8e2a-443d-956c-f15fb99a560e	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154c497d6a38db8d76a24	69b185b3af96b945e88e884f	2026-03-27 19:16:18.633	2026-03-27 19:16:18.62	QA	QAGuy	15	\N	Growth	Actions | Bragi AI v2.0 enabling "App-only" scope	Product | Platform
851b5bd3-fd99-4e0e-9720-4cf344962372	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154c497d6a38db8d76a24	69b185b4e92ef3b524f9d648	2026-03-27 19:16:20.338	2026-03-27 19:16:20.331	QA	QAGuy	15	\N	Growth	Actions | Bragi AI v2.2 enabling "Bragi AI PRO" scope	Product | Platform
6f1fcdbb-7113-4280-9835-4534199994ee	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154e4fb62afd7f3d4004a	69b1859edef14df1ef2c9eb4	2026-03-27 19:16:25.574	2026-03-27 19:16:25.566	embedded	FWDev	12	\N	Growth	Amazon Poplar | Sensor Workpackage for QCC S7	Product | Platform
a92d781d-1a62-409b-b023-3b83c218184d	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154e4fb62afd7f3d4004a	69b185a409577dbee0b9b90d	2026-03-27 19:16:26.773	2026-03-27 19:16:26.764	embedded	FWDev	23	\N	Growth	Golden ADK | QCC ADK Update to latest Version	Roadmap Initiative
9f7734ee-7584-43d5-aec7-852897837c99	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154e4fb62afd7f3d4004a	69b185b2e3897d2857a85f2d	2026-03-27 19:16:28.763	2026-03-27 19:16:28.753	embedded	FWDev	2	\N	Growth	WQ | Bragi AI v2.0 enabling "App-only" Scope	Product | Platform
3e22c14f-a456-4978-9563-12f88013f930	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154e4fb62afd7f3d4004a	69b185b3af96b945e88e884f	2026-03-27 19:16:30.454	2026-03-27 19:16:30.447	embedded	FWDev	23	\N	Growth	Actions | Bragi AI v2.0 enabling "App-only" scope	Product | Platform
ef5f7eec-ec52-47f4-bcd9-7fbf8ee1440b	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154e4fb62afd7f3d4004a	69b185b4e92ef3b524f9d648	2026-03-27 19:16:33.456	2026-03-27 19:16:33.447	embedded	FWDev	13	\N	Growth	Actions | Bragi AI v2.2 enabling "Bragi AI PRO" scope	Product | Platform
5efb5b8b-bda6-4e2d-bf5e-d0baec3ecde7	Q2 2026	updated	69b119d6b705fe95e0c67bcf	69b154e4fb62afd7f3d4004a	69b185b2e3897d2857a85f2d	2026-03-27 19:16:42.522	2026-03-27 19:16:42.514	embedded	FWDev	12	2	Growth	WQ | Bragi AI v2.0 enabling "App-only" Scope	Product | Platform
e6b98e10-ecc2-4fb0-b1f1-c454709b7fe7	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154f88704ff2f2e96c8da	69b1859edef14df1ef2c9eb4	2026-03-27 19:16:43.749	2026-03-27 19:16:43.74	Cloud	CloudDude	10	\N	Growth	Amazon Poplar | Sensor Workpackage for QCC S7	Product | Platform
19b79084-213d-4a65-9837-137675b28818	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154f88704ff2f2e96c8da	69b185a409577dbee0b9b90d	2026-03-27 19:16:44.542	2026-03-27 19:16:44.535	Cloud	CloudDude	10	\N	Growth	Golden ADK | QCC ADK Update to latest Version	Roadmap Initiative
1c2ea78c-f42b-4b72-b0e2-286fd034fb3f	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154f88704ff2f2e96c8da	69b185b2e3897d2857a85f2d	2026-03-27 19:16:45.546	2026-03-27 19:16:45.538	Cloud	CloudDude	25	\N	Growth	WQ | Bragi AI v2.0 enabling "App-only" Scope	Product | Platform
146862dd-e3c7-4bc9-a01f-92960006cede	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154f88704ff2f2e96c8da	69b185b3af96b945e88e884f	2026-03-27 19:16:46.343	2026-03-27 19:16:46.335	Cloud	CloudDude	20	\N	Growth	Actions | Bragi AI v2.0 enabling "App-only" scope	Product | Platform
40a54201-48ed-4829-8e3e-3b38fd3b1f03	Q2 2026	set	69b119d6b705fe95e0c67bcf	69b154f88704ff2f2e96c8da	69b185b4e92ef3b524f9d648	2026-03-27 19:16:49.518	2026-03-27 19:16:49.513	Cloud	CloudDude	12	\N	Growth	Actions | Bragi AI v2.2 enabling "Bragi AI PRO" scope	Product | Platform
76af3522-ea8f-4059-87b5-c0bfc72400e8	Q1 2026	set	69aff2f04b4fb2a08f82c193	69b1826f53a8e09756e703d2	69b18598a15dffb12de87aa5	2026-03-27 20:53:04.945	2026-03-27 20:53:04.933	embedded	Valerián	1	\N	AA2	Dev Portal v1.2 (external web apps for new X team)	Audio App
3fa35847-9b40-4914-bd9e-a5dcf1f39fab	Q1 2026	removed	69aff2f04b4fb2a08f82c193	69b1826f53a8e09756e703d2	69b18598a15dffb12de87aa5	2026-03-27 20:53:08.74	2026-03-27 20:53:08.733	embedded	Valerián	\N	1	AA2	Dev Portal v1.2 (external web apps for new X team)	Audio App
\.


--
-- Data for Name: QuarterlyPlanSnapshot; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."QuarterlyPlanSnapshot" (id, quarter, team_id, team_name, label, note, created_by_email, created_at, allocations) FROM stdin;
1838c201-5599-45ed-a8b3-bc4d0b1cbb2c	Q2 2026	69b119d6b705fe95e0c67bcf	Growth	Test save	\N	benjamin.spiss@gmail.com	2026-03-27 19:00:28.92	[{"percent": 20, "member_name": "AndroidDev", "work_area_id": "69b1859edef14df1ef2c9eb4", "team_member_id": "69b1547e9aa954f7307facb7", "work_area_name": "Amazon Poplar | Sensor Workpackage for QCC S7", "work_area_type": "Product | Platform", "member_discipline": "Android"}, {"percent": 85, "member_name": "AndroidDev", "work_area_id": "69b185a409577dbee0b9b90d", "team_member_id": "69b1547e9aa954f7307facb7", "work_area_name": "Golden ADK | QCC ADK Update to latest Version", "work_area_type": "Roadmap Initiative", "member_discipline": "Android"}]
\.


--
-- Data for Name: QuarterlyWorkAreaSelection; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."QuarterlyWorkAreaSelection" (id, quarter, team_id, work_area_ids, created_at, updated_at) FROM stdin;
69c2a934919dd073a1541cd5	Q1 2026	69aff3c2522f033339b5d0d6	{}	2026-03-24 15:09:40.417	2026-03-27 15:20:08.162
69bd5e50d99cc1810db9ba69	Q1 2026	69b119d6b705fe95e0c67bcf	{}	2026-03-20 14:48:48.762	2026-03-27 15:20:27.972
69c26be043187ad8f98593af	Q2 2026	69aff2f04b4fb2a08f82c193	{}	2026-03-24 10:48:00.125	2026-03-27 15:23:35.165
69c6305ae04a1019dafac1f7	Q2 2026	69aff2f04b4fb2a08f82c191	{}	2026-03-27 07:23:06.221	2026-03-27 15:23:55.301
69c291c80bdfd0dcb16862ea	Q2 2026	69aff2f04b4fb2a08f82c192	{}	2026-03-24 13:29:44.991	2026-03-27 15:24:15.16
69c282a75d883e815e1ff5ba	Q2 2026	69aff3c2522f033339b5d0d6	{}	2026-03-24 12:25:11.901	2026-03-27 15:24:53.996
69bd596b7f3f8c122163fe8e	Q2 2026	69b119d6b705fe95e0c67bcf	{69b185a409577dbee0b9b90d,69b1859edef14df1ef2c9eb4,69b185b4e92ef3b524f9d648,69b185b3af96b945e88e884f,69b185b2e3897d2857a85f2d}	2026-03-20 14:27:55.729	2026-03-27 19:15:42.389
242f9630-8525-488b-a9cf-ad128a3f6a0a	Q1 2026	69aff2f04b4fb2a08f82c193	{}	2026-03-27 20:52:50.75	2026-03-27 20:53:23.392
\.


--
-- Data for Name: Sprint; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."Sprint" (id, team_id, name, quarter, start_date, end_date, is_cross_team, is_template, created_at, updated_at, relevant_work_area_ids) FROM stdin;
69bd70b2ba97a635dbcbfafa	\N	Q1-6	Q1 2026	2026-03-23 00:00:00	2026-07-05 00:00:00	t	f	2026-03-20 16:07:14.808	2026-03-20 16:07:14.808	\N
69b1cc4275b2fcd82a8a83c0	\N	Q2-1	Q2 2026	2026-04-06 00:00:00	2026-04-19 00:00:00	t	f	2026-03-11 20:10:42.757	2026-03-11 20:11:14.589	\N
69b1ab9e1be918ccf19160d0	\N	Q2-2	Q2 2026	2026-04-20 00:00:00	2026-05-03 00:00:00	t	f	2026-03-11 17:51:26.098	2026-03-11 19:36:20.118	\N
69b151f92daa230af3673c5f	\N	Q2-6	Q2 2026	2026-06-15 00:00:00	2026-06-28 00:00:00	t	f	2026-03-11 11:28:57.672	2026-03-11 12:23:55.726	\N
69b12a320ca097cf0fce7cd3	\N	Q2-5	Q2 2026	2026-06-01 00:00:00	2026-06-14 00:00:00	t	f	2026-03-11 08:39:14.046	2026-03-11 12:23:55.726	\N
69b12a0edaad6b55b674305f	\N	Q2-4	Q2 2026	2026-05-18 00:00:00	2026-05-31 00:00:00	t	f	2026-03-11 08:38:38.96	2026-03-11 12:23:55.726	\N
69b129f5361ff033a909018a	\N	Q2-3	Q2 2026	2026-05-04 00:00:00	2026-05-17 00:00:00	t	f	2026-03-11 08:38:13.076	2026-03-24 12:33:46.393	\N
\.


--
-- Data for Name: Team; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."Team" (id, name, description, lead_id, created_at, updated_at, color) FROM stdin;
69b119dae2f92006c4346e61	Enabler	\N	\N	2026-03-11 07:29:30.883	2026-03-27 14:24:34.307	blue
69b119cecb30e08ae1f2238d	CSAT	\N	\N	2026-03-11 07:29:18.378	2026-03-27 14:24:34.317	pink
69aff3c2522f033339b5d0d6	App & Cloud	Bragi AI, Cloud and Store	\N	2026-03-10 10:34:42.842	2026-03-27 14:24:34.318	indigo
69aff2f04b4fb2a08f82c193	AA2	Audio Apps and Capabilities	\N	2026-03-10 10:31:12.199	2026-03-27 14:24:34.319	orange
69aff2f04b4fb2a08f82c191	Connect	mSDK - Connect middleware	\N	2026-03-10 10:31:12.199	2026-03-27 14:24:34.319	teal
69aff2f04b4fb2a08f82c192	AA1	Cloud & Backend Services	\N	2026-03-10 10:31:12.199	2026-03-27 14:24:34.32	purple
69b119d6b705fe95e0c67bcf	Growth		\N	2026-03-11 07:29:26.996	2026-03-27 14:28:03.566	sky
19647f4f-4820-4b1c-bb18-5bade52f81d4	UX	Test	\N	2026-03-27 16:33:15.414	2026-03-27 16:33:15.414	indigo
\.


--
-- Data for Name: TeamMember; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."TeamMember" (id, team_id, name, discipline, availability_percent, created_at, updated_at) FROM stdin;
69b184710cf0d3d33eb2c121	69aff2f04b4fb2a08f82c191	Sergiu	QA	100	2026-03-11 15:04:17.863	2026-03-11 15:04:17.863
69b1845bbc70288377fe9e1d	69aff2f04b4fb2a08f82c191	Piotr	Android	100	2026-03-11 15:03:55.917	2026-03-11 15:03:55.917
69b184525ef24ab534f06d10	69aff2f04b4fb2a08f82c191	Nikola	Android	100	2026-03-11 15:03:46.329	2026-03-11 15:03:46.329
69b184453cbaa9449aae26c3	69aff2f04b4fb2a08f82c191	Rustam	Android	100	2026-03-11 15:03:33.758	2026-03-11 15:03:33.758
69b184403db537db90729ecd	69aff2f04b4fb2a08f82c191	Pepi	Android	100	2026-03-11 15:03:28.462	2026-03-11 15:03:28.462
69b1837604a0e6adf39ff77c	69aff2f04b4fb2a08f82c191	Aleksander	iOS	100	2026-03-11 15:00:06.316	2026-03-11 15:00:06.316
69b183679cb33d3549d987e4	69aff2f04b4fb2a08f82c191	Jugoslav	iOS	100	2026-03-11 14:59:51.054	2026-03-11 14:59:51.054
69b1834aa1cec08def422762	69aff2f04b4fb2a08f82c191	Cole	Test Automation	100	2026-03-11 14:59:22.163	2026-03-11 14:59:22.163
69b18341ab3cdbe7937d1841	69aff2f04b4fb2a08f82c191	Akos	iOS	100	2026-03-11 14:59:13.025	2026-03-11 14:59:13.025
69b182f5b505d72980bace2a	69b119cecb30e08ae1f2238d	Jiny	embedded	75	2026-03-11 14:57:57.789	2026-03-11 14:57:57.789
69b182cdf6718ed92e3473ab	69aff2f04b4fb2a08f82c193	Bashir	Cloud	100	2026-03-11 14:57:17.13	2026-03-11 14:57:17.13
69b182c7ea1b9f6bf50243e7	69aff2f04b4fb2a08f82c193	Milos	Cloud	100	2026-03-11 14:57:11.053	2026-03-11 14:57:11.053
69b182bb63bce22962cf6be1	69aff2f04b4fb2a08f82c193	Enrik	QA	50	2026-03-11 14:56:59.351	2026-03-11 14:56:59.351
69b182adde4e286f531fe818	69aff2f04b4fb2a08f82c193	Florian	Android	100	2026-03-11 14:56:45.615	2026-03-11 14:56:45.615
69b182a6d7ab1e43c96186b9	69aff2f04b4fb2a08f82c193	Dejan K.	iOS	100	2026-03-11 14:56:38.826	2026-03-11 14:56:38.826
69b182973a34809994e2475f	69aff2f04b4fb2a08f82c193	Kaveen	Algo	100	2026-03-11 14:56:23.136	2026-03-11 14:56:23.136
69b18292586fef9591cd3bf1	69aff2f04b4fb2a08f82c193	Namrata	Algo	100	2026-03-11 14:56:18.692	2026-03-11 14:56:18.692
69b18282da7c54bd01582116	69aff2f04b4fb2a08f82c193	Deniz A.	Test Automation	0	2026-03-11 14:56:02.813	2026-03-24 10:39:37.154
69b1824f0ae457658af710a4	69aff2f04b4fb2a08f82c192	Enrik	QA	50	2026-03-11 14:55:11.324	2026-03-11 14:55:11.324
69b182442ad4f78326e44c33	69aff2f04b4fb2a08f82c192	Simon	Cloud	100	2026-03-11 14:55:00.087	2026-03-11 14:55:00.087
69b1823eecfb1ff3108b8613	69aff2f04b4fb2a08f82c192	Tobias	Cloud	50	2026-03-11 14:54:54.427	2026-03-24 13:25:30.549
69b18237e4854b926dd80076	69aff2f04b4fb2a08f82c192	Wojtek	Android	100	2026-03-11 14:54:47.4	2026-03-11 14:54:47.4
69b1822f069c553465002a06	69aff2f04b4fb2a08f82c192	Irfan	iOS	100	2026-03-11 14:54:39.2	2026-03-11 14:54:39.2
69b1821a5521941b0291121a	69aff2f04b4fb2a08f82c192	Daniel	UX	50	2026-03-11 14:54:18.46	2026-03-11 14:54:18.46
69b181b274cd150d9502f8ee	69aff3c2522f033339b5d0d6	Giovanni	UX	25	2026-03-11 14:52:34.932	2026-03-24 12:31:39.212
69b181784189710842d0ef4e	69b119cecb30e08ae1f2238d	Adnan	Android	100	2026-03-11 14:51:36.768	2026-03-11 14:51:36.768
69b18174bb2d0f8877d36b09	69b119cecb30e08ae1f2238d	Oskar	QA	100	2026-03-11 14:51:32.902	2026-03-11 14:51:32.902
69b1816b434be90340109bc5	69b119cecb30e08ae1f2238d	Sinisa	iOS	100	2026-03-11 14:51:23.175	2026-03-11 14:51:23.175
69b1813fa582f84d20357a8e	69b119cecb30e08ae1f2238d	Dejan B.	Android	100	2026-03-11 14:50:39.385	2026-03-11 14:51:07.8
69b18132e6ad92698fbb7fc5	69b119cecb30e08ae1f2238d	Agustin	Android	100	2026-03-11 14:50:26.506	2026-03-11 14:50:26.506
69b1812912dc74315ee96c4b	69b119cecb30e08ae1f2238d	Ahmed	embedded	100	2026-03-11 14:50:17.854	2026-03-11 14:50:17.854
69b18121d6d1eef46f30b2a0	69b119cecb30e08ae1f2238d	Aurelien	embedded	100	2026-03-11 14:50:09.663	2026-03-11 14:50:09.663
69b181182b1fbe16840057dd	69b119cecb30e08ae1f2238d	Gwen	embedded	100	2026-03-11 14:50:00.553	2026-03-11 14:50:00.553
69b180f5b5a96b29ca4e761b	69b119cecb30e08ae1f2238d	Andrea	UX	50	2026-03-11 14:49:25.094	2026-03-11 14:49:37.66
69b180d42e4489fa1c5c2168	69b119dae2f92006c4346e61	Emmanouil	QA	100	2026-03-11 14:48:52.216	2026-03-11 14:48:52.216
69b180bf824466c6cb79a108	69b119dae2f92006c4346e61	Sonia	Test Automation	100	2026-03-11 14:48:31.162	2026-03-11 14:48:31.162
69b180b6bf79d98074953756	69b119dae2f92006c4346e61	Stefano	embedded	100	2026-03-11 14:48:22.401	2026-03-11 14:48:22.401
69b180aa5ac30ba098d148fa	69b119dae2f92006c4346e61	Martin	embedded	50	2026-03-11 14:48:10.281	2026-03-11 14:48:10.281
69b18098843cf11e0c13e92d	69b119dae2f92006c4346e61	Sim	embedded	100	2026-03-11 14:47:52.966	2026-03-11 14:47:52.966
69b18061b49305b829eeb659	69b119dae2f92006c4346e61	Madis	embedded	100	2026-03-11 14:46:57.272	2026-03-11 14:47:40.226
69b18059b425efe207a199f4	69b119dae2f92006c4346e61	Luigi	embedded	100	2026-03-11 14:46:49.001	2026-03-11 14:47:25.458
69b154f88704ff2f2e96c8da	69b119d6b705fe95e0c67bcf	CloudDude	Cloud	100	2026-03-11 11:41:44.727	2026-03-11 11:41:44.727
69b154e4fb62afd7f3d4004a	69b119d6b705fe95e0c67bcf	FWDev	embedded	100	2026-03-11 11:41:24.9	2026-03-11 14:47:29.198
69b154c497d6a38db8d76a24	69b119d6b705fe95e0c67bcf	QAGuy	QA	100	2026-03-11 11:40:52.381	2026-03-11 11:40:52.381
69b154af77d58bf4c3897c6c	69b119d6b705fe95e0c67bcf	iOSDev	iOS	100	2026-03-11 11:40:31.387	2026-03-11 11:40:31.387
69b1547e9aa954f7307facb7	69b119d6b705fe95e0c67bcf	AndroidDev	Android	100	2026-03-11 11:39:42.919	2026-03-11 11:40:23.805
69b0149b549bf30b357983ca	69aff3c2522f033339b5d0d6	Maciej	QA	100	2026-03-10 12:54:51.583	2026-03-10 12:54:51.583
69b0143e5079cf11510460f0	69aff3c2522f033339b5d0d6	Burak	Cloud	100	2026-03-10 12:53:18.001	2026-03-24 12:29:30.516
69b01435b96540391b91f472	69aff3c2522f033339b5d0d6	Axel	Cloud	100	2026-03-10 12:53:09.964	2026-03-10 12:53:09.964
69b0142fa3949f7dd6441765	69aff3c2522f033339b5d0d6	Christoph	Cloud	100	2026-03-10 12:53:03.082	2026-03-10 12:53:03.082
69b013d38a07ef42e03db38e	69aff3c2522f033339b5d0d6	Alex	Android	100	2026-03-10 12:51:31.812	2026-03-10 12:51:31.812
69b013ce2af9acc2a4be5892	69aff3c2522f033339b5d0d6	Jasiu	Android	100	2026-03-10 12:51:26.19	2026-03-10 12:51:26.19
69b013612a8a314380ed4d1b	69aff3c2522f033339b5d0d6	Moreira	iOS	100	2026-03-10 12:49:37.596	2026-03-10 12:49:37.596
69b0123f1630d6dc0c97db5a	69aff3c2522f033339b5d0d6	Nermin	iOS	100	2026-03-10 12:44:47.878	2026-03-10 12:47:53.648
69b1826f53a8e09756e703d2	69aff2f04b4fb2a08f82c193	Valerián	embedded	80	2026-03-11 14:55:43.211	2026-03-27 20:31:50.92
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."User" (id, email, password_hash, full_name, role, managed_team_ids, created_at, updated_at, first_name, last_name, "position") FROM stdin;
7df3a6b6-0ed5-4082-95a5-1b3b94651445	ruby.tysall@bragi.com	$2a$10$dKace.lIQjhpePZyR4d85emfMj0uTN3ZBZsXlWp5KVuhrwptxNHL.	\N	team_manager	{69aff2f04b4fb2a08f82c193}	2026-03-27 14:15:42.406	2026-03-27 14:25:08.805	Ruby	Tysall	PO
ec3fdea5-7e1b-4293-bb93-f50782e83892	pouria.zafarabadi@bragi.com	$2a$10$YhiwQRsqINBMbYrwd.kWwOsUWvPZy/ewwxnx87XgqHQFdNH3.Ji2i	\N	admin	{}	2026-03-27 14:25:24.938	2026-03-27 14:25:38.375	Pouria	Zafarabadi	CTO
59bf0fd4-93ce-4d0d-bf04-718f6eaf87d1	baris.tabak@bragi.com	$2a$10$Z/YV5n6s6KYco9urpaLqP.0adnBisW/VwBsquz7f0Rx1t8kNb8dLa	\N	team_manager	{69aff3c2522f033339b5d0d6}	2026-03-27 14:25:55.702	2026-03-27 14:27:26.007	Baris	Tabak	PO
a7d3a735-3662-4ef8-8cb4-4ea3a5ab5fa1	douglas.mackay@bragi.com	$2a$10$vVkPUXTn.1yGIqnIqDwWA.0I83raQPnvp.8lKfuGDakppL0tYeNtO	\N	team_manager	{69aff2f04b4fb2a08f82c192}	2026-03-27 14:26:17.367	2026-03-27 14:27:48.676	Douglas	Mackay	PO
495c567a-41a0-49e0-9207-d96dbf18b659	benjamin.spiss@gmail.com	$2a$10$6i84El3ZhmZUCAP.fRKHn.aoY.o2h1lPBUv8M/PC1XfD0/Ujr0ER6	\N	admin	{}	2026-03-27 14:14:18.515	2026-03-27 19:34:18.716	Benjamin	Spiss	Head of PO
c4a228ad-3c66-4750-96f8-f8f7a3d1fb7c	admin@example.com	$2a$10$apovZaPbkdygrlCJVy2aruDqKsY5EyCpT94aZjvjJK9VMstvEcM2C	Admin	admin	{}	2026-03-27 20:00:41.258	2026-03-27 20:00:41.258	\N	\N	\N
\.


--
-- Data for Name: WorkArea; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."WorkArea" (id, name, type, leading_team_id, supporting_team_ids, prod_id, jira_key, jira_status, jira_progress, last_synced, linked_epic_keys, created_at, updated_at, color) FROM stdin;
69c4fad443a3f7fc62994eef	‼️ Bose BMAP integration with Bragi mSDK (for Bose Leo)	New Opportunities	69aff2f04b4fb2a08f82c191	{69b119dae2f92006c4346e61,69aff3c2522f033339b5d0d6}	PROD-307	\N	\N	0	\N	{}	2026-03-26 09:22:28.98	2026-03-26 09:22:28.98	\N
69c4fad44c72ad01019f1806	Trigger: Head gesture detected (noding, shaking) AB1585	Capability	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192}	PROD-344	\N	\N	0	\N	{}	2026-03-26 09:22:28.481	2026-03-26 09:22:28.481	\N
69c4fad3d855d6a9a9cf36c7	Emotion detection for Strava Audio App	Capability	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192}	PROD-346	\N	\N	0	\N	{}	2026-03-26 09:22:27.981	2026-03-26 09:22:27.981	\N
69c4fad3bbea7d76eb1091f5	Discovery | Tech foundation for GPT-powered services	Product | Baseline-App	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192}	PROD-359	\N	\N	0	\N	{}	2026-03-26 09:22:27.272	2026-03-26 09:22:27.272	\N
69c4fad2a10fee863fabeafc	Bragi AI app | w/  AI chat bot optimised for post-e-comm sales.	Product | Bragi-app	69aff3c2522f033339b5d0d6	{}	PROD-378	\N	\N	0	\N	{}	2026-03-26 09:22:26.301	2026-03-26 09:22:26.301	\N
69c4facf8f3a9940c999d9f6	Bragi AI – Self-service Concept for 3rd Party embedded SW Integration	Product | Platform	69b119d6b705fe95e0c67bcf	{69b119dae2f92006c4346e61,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6}	PROD-389	\N	\N	0	\N	{}	2026-03-26 09:22:23.797	2026-03-26 09:22:23.797	\N
69c4facf9caaaeb5f22569d7	Trigger: Noise environment change detected	Capability	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192}	PROD-410	\N	\N	0	\N	{}	2026-03-26 09:22:23.336	2026-03-26 09:22:23.336	\N
69c4face12cd1f79d982c8e7	Mini BAATS v1.6 (10 devices, Reporting)	Capability	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193}	PROD-411	\N	\N	0	\N	{}	2026-03-26 09:22:22.853	2026-03-26 09:22:22.853	\N
69c4face4deb110f6b852870	Trigger: Someone started/stopped speaking	Capability	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192}	PROD-438	\N	\N	0	\N	{}	2026-03-26 09:22:22.363	2026-03-26 09:22:22.363	\N
69c4facd91b11a0e778ee30c	"BOS Applet" Scripting Module	Capability	69b119d6b705fe95e0c67bcf	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6}	PROD-453	\N	\N	0	\N	{}	2026-03-26 09:22:21.885	2026-03-26 09:22:21.885	\N
69c4faccf0e2fe6457162904	Unified iOS & Android release management w/ end-to-end automation	Product | Baseline-App	69aff3c2522f033339b5d0d6	{}	PROD-522	\N	\N	0	\N	{}	2026-03-26 09:22:20.429	2026-03-26 09:22:20.429	\N
69c4fac7ac47768058836493	mSDK self-integration Concept & Blueprint Part II – 3rd party SW Vendors	Product | Platform	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6}	PROD-615	\N	\N	0	\N	{}	2026-03-26 09:22:15.403	2026-03-26 09:22:15.403	\N
69c4fac648b651d754a0e27a	Bragi AI | Baseline |  Evolution | App Web Kit integration	Product | Baseline-App	69aff3c2522f033339b5d0d6	{69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192}	PROD-675	\N	\N	0	\N	{}	2026-03-26 09:22:14.445	2026-03-26 09:22:14.445	\N
69c4fac5f57507fd39eecbed	Notes Audio App v1.0 (web based)	Audio App	69aff2f04b4fb2a08f82c193	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-701	\N	\N	0	\N	{}	2026-03-26 09:22:13.457	2026-03-27 16:33:30.265	\N
69c4fac7cd83ecad3f76c6e5	Voice AI v3 (Audio Chain, Multiple Speakers & Improvements)	Feature	69aff2f04b4fb2a08f82c193	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-612	\N	\N	0	\N	{}	2026-03-26 09:22:15.899	2026-03-27 16:33:30.423	\N
69c4fac890c20971b78fd6a0	Bragi DX/CX suite portal | Public Launch | v1.0.0 | Q1-Q2 2026	Product | Bragi-DX/CX-Suite	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-558	\N	\N	0	\N	{}	2026-03-26 09:22:16.901	2026-03-27 16:33:30.504	\N
69c4fac90a300a593641fd84	Bragi AI | Baseline | Universal iOS Archi & Kotlin Multiplatform PoC	Product | Baseline-App	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-540	\N	\N	0	\N	{}	2026-03-26 09:22:17.45	2026-03-27 16:33:30.552	\N
69c4fac9bdc1f3c2c07c26d4	Bragi AI |  Baseline | China availability	Product | Baseline-App	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-538	\N	\N	0	\N	{}	2026-03-26 09:22:17.91	2026-03-27 16:33:30.574	\N
69c4facaaa3b0bf10aa1dc76	Bragi AI app | Customer Support infra	Product | Bragi-app	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-536	\N	\N	0	\N	{}	2026-03-26 09:22:18.917	2026-03-27 16:33:30.599	\N
69c4facbedbc5daadd84b70a	 Bragi AI | Baseline | UIUX | Loading states	Product | Baseline-App	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-526	\N	\N	0	\N	{}	2026-03-26 09:22:19.977	2026-03-27 16:33:30.648	\N
69c4fad00e9df1b3636e658e	Bragi AI | Play to earn	Product | Baseline-App	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-383	\N	\N	0	\N	{}	2026-03-26 09:22:24.293	2026-03-27 16:33:30.819	\N
69c4fad06f409492fcde0d8d	Bragi AI app |  Tailored shopping experience for registered users.	Product | Bragi-app	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-382	\N	\N	0	\N	{}	2026-03-26 09:22:24.812	2026-03-27 16:33:30.844	\N
69c4fad1110e17395f215179	Bragi AI | Loyalty programs & Gamification kick-off	Product | Baseline-App	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-381	\N	\N	0	\N	{}	2026-03-26 09:22:25.308	2026-03-27 16:33:30.869	\N
69c4fad15a51cf6e0893f3ce	Bragi AI | Baseline | Community | AA testimonials	Product | Baseline-App	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-379	\N	\N	0	\N	{}	2026-03-26 09:22:25.822	2026-03-27 16:33:30.894	\N
69c4fad5b158941456e09017	Meeting Audio App	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-268	\N	\N	0	\N	{}	2026-03-26 09:22:29.435	2026-03-27 16:33:30.994	\N
69c4fad668fd77b36b1db9e4	App without connected headphone (use smartphone mic and speaker)	Product | Baseline-App	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-249	\N	\N	0	\N	{}	2026-03-26 09:22:30.187	2026-03-27 16:33:31.02	\N
69c4fad6d0c8ed3145e708d3	QCC | MVP of "Bragi AI Custom" for QCC S7 (Retail AI / HP)	Product | Platform	69b119d6b705fe95e0c67bcf	{69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-232	\N	\N	0	\N	{}	2026-03-26 09:22:30.656	2026-03-27 16:33:31.046	\N
69c4fad7efff5ca3bf1208a9	Bragi AI | Baseline | Onboarding UX |  App Clips "Frictionless Pairing"	Product | Baseline-App	69aff3c2522f033339b5d0d6	{69b119dae2f92006c4346e61,69aff3c2522f033339b5d0d6,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-219	\N	\N	0	\N	{}	2026-03-26 09:22:31.125	2026-03-27 16:33:31.068	\N
69c4fad7d2a34fc607ce313c	Meet AI - Teams by Microsoft v1	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-215	\N	\N	0	\N	{}	2026-03-26 09:22:31.754	2026-03-27 16:33:31.094	\N
69c4fac3a153dd51a8c8009e	Go AI v1	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193}	PROD-820	\N	\N	0	\N	{}	2026-03-26 09:22:11.021	2026-03-26 09:22:11.021	\N
69c4fac2dd7771b866968ab0	Belkin - SAP170 (JL7016G6 TWS) 	Product | Customer	69b119cecb30e08ae1f2238d	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192}	PROD-846	\N	\N	0	\N	{}	2026-03-26 09:22:10.544	2026-03-26 09:22:10.544	\N
69c4fac253b11a942e4900a8	Belkin - App V1.0	Product | Customer Release	69b119cecb30e08ae1f2238d	{69b119d6b705fe95e0c67bcf,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192}	PROD-849	\N	\N	0	\N	{}	2026-03-26 09:22:10.075	2026-03-26 09:22:10.075	\N
69c4fabf91be17c90031f091	Audio AppKit v1.5	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-947	\N	\N	0	\N	{}	2026-03-26 09:22:07.391	2026-03-26 09:22:07.391	\N
69c4fabe38276c6a3676fa8f	Tech Roadmap | Airoha | Baseline Refactoring and "Slim Down"	Tech Roadmap	69b119dae2f92006c4346e61	{69aff2f04b4fb2a08f82c191,69b119cecb30e08ae1f2238d}	PROD-963	\N	\N	0	\N	{}	2026-03-26 09:22:06.92	2026-03-26 09:22:06.92	\N
69c4fabdf6c339356dbc59bb	AA Dashboard v1.2 (for all new internal AA)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1001	\N	\N	0	\N	{}	2026-03-26 09:22:05.042	2026-03-26 09:22:05.042	\N
69c4fabc7d4fbd2d8b8e920b	Audio AppKit v1.4 (for exernal AA)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1002	\N	\N	0	\N	{}	2026-03-26 09:22:04.578	2026-03-26 09:22:04.578	\N
69c4fabc03c3fa87a96e2518	Audio AppKit v1.3 (deploy AA without any code change, Agents config Chat v2.0, Playground, MCP, Memory, remove VC dependency)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1006	\N	\N	0	\N	{}	2026-03-26 09:22:04.009	2026-03-26 09:22:04.009	\N
69c4fabb5a07717d669a0dfe	Brand Agent v2.1.0 (+Improvements)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1016	\N	\N	0	\N	{}	2026-03-26 09:22:03.525	2026-03-26 09:22:03.525	\N
69c4fabae70f51eaf4e4e89a	Skullcandy Skull AI v1.1.0 (on device STT and TTS)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1018	\N	\N	0	\N	{}	2026-03-26 09:22:02.958	2026-03-26 09:22:02.958	\N
69c4faba7c3530764ae9580a	Brand Agent v1.3.0 (on device STT &TTS)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1019	\N	\N	0	\N	{}	2026-03-26 09:22:02.491	2026-03-26 09:22:02.491	\N
69c4fab97b3cd3addf0f0e2f	Bragi Agent  v1.0.0 (Bragi Brand Agent for demos)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1054	\N	\N	0	\N	{}	2026-03-26 09:22:01.479	2026-03-26 09:22:01.479	\N
69c4fab8a7f301b632b253c6	Memory GPT	Audio App	69aff2f04b4fb2a08f82c193	{}	PROD-1063	\N	\N	0	\N	{}	2026-03-26 09:22:00.98	2026-03-26 09:22:00.98	\N
69c4fab8c232638a97181133	Belkin - SAP175 (JL7103D6 TWS) 	Product | Customer	69b119cecb30e08ae1f2238d	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192}	PROD-1065	\N	\N	0	\N	{}	2026-03-26 09:22:00.519	2026-03-26 09:22:00.519	\N
69c4fab829343a68416bacb8	Belkin - SAP181 (JL7103D6 TWS) 	Product | Customer	69b119cecb30e08ae1f2238d	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192}	PROD-1066	\N	\N	0	\N	{}	2026-03-26 09:22:00.034	2026-03-26 09:22:00.034	\N
69c4fab7bf5ef3eac85b7d8c	AppKit | Infra Ready to be deployed China	Product | AppKit	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1069	\N	\N	0	\N	{}	2026-03-26 09:21:59.553	2026-03-26 09:21:59.553	\N
69c4f9e3a30eb823519d268f	Update baseline to latest Airoha SDK 5.8 (AB157x, AB158x, AB159x)	Roadmap Initiative	69b119dae2f92006c4346e61	{69aff2f04b4fb2a08f82c191}	PROD-1082	\N	\N	0	\N	{}	2026-03-26 09:18:27.955	2026-03-26 09:18:27.955	\N
69c4f9e311f487a6e487abb2	Bragi Platform | Make App Connection mandatory before allowing BT Classic connection	Roadmap Initiative	69b119dae2f92006c4346e61	{69b119d6b705fe95e0c67bcf,69aff2f04b4fb2a08f82c191}	PROD-1110	\N	\N	0	\N	{}	2026-03-26 09:18:27.41	2026-03-26 09:18:27.41	\N
69c4f9e21f8e7cd0e6b2e645	Cloud Domain | Customer Usage Metering	Strategy	69aff3c2522f033339b5d0d6	{69aff3c2522f033339b5d0d6}	PROD-1118	\N	\N	0	\N	{}	2026-03-26 09:18:26.812	2026-03-26 09:18:26.812	\N
69c4f9e11928960fef82ab9d	Dev Portal v1.4 (for exernal AA)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1165	\N	\N	0	\N	{}	2026-03-26 09:18:25.12	2026-03-26 09:18:25.12	\N
69c4f9e0e739fe98839a13f1	Dev Portal v1.5	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1166	\N	\N	0	\N	{}	2026-03-26 09:18:24.565	2026-03-26 09:18:24.565	\N
69c4f9df306cd90a50c527fe	Dev Portal v1.3 (deploy AA without any code change, Agents config Chat v2.0, Playground, MCP, Memory, remove VC dependency)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1167	\N	\N	0	\N	{}	2026-03-26 09:18:23.975	2026-03-26 09:18:23.975	\N
69c4f9dea87ed41663a224fb	Control AI v1.1 (on phone STT, TTS, LLM)	Audio App	69aff2f04b4fb2a08f82c192	{}	PROD-1181	\N	\N	0	\N	{}	2026-03-26 09:18:22.695	2026-03-26 09:18:22.695	\N
69c4f9e5386e747ae8f079c0	Bragi CX Suite | Enabling Bragi AI Network effects	Product | Bragi-DX/CX-Suite	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1071	\N	\N	0	\N	{}	2026-03-26 09:18:29.277	2026-03-27 16:33:29.727	\N
69c4fabe561bd738d18ff863	Voice AI V2 (on device NLU for flexible product control) (Bose Workbench))	Feature	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-971	\N	\N	0	\N	{}	2026-03-26 09:22:06.43	2026-03-27 16:33:29.919	\N
69c4fac029e356744cb43ecc	Reactive Voice AI v0.1 (iOS MVP)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-882	\N	\N	0	\N	{}	2026-03-26 09:22:08.965	2026-03-27 16:33:30.003	\N
69c4fac35cd011e1cadfb517	Innovation Rush: Eval MCP servers for faster intergration of 3rd party with agents	Audio App	69aff2f04b4fb2a08f82c192	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-818	\N	\N	0	\N	{}	2026-03-26 09:22:11.54	2026-03-27 16:33:30.097	\N
69c4fac4c220fdc504ea2917	Innovation Rush: Eval 3rd party agentic paltforms for 3rd party devs	Audio App	69aff2f04b4fb2a08f82c192	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-738	\N	\N	0	\N	{}	2026-03-26 09:22:12.015	2026-03-27 16:33:30.157	\N
69c4fac42674c3ab7a13f3f0	Voice AI part of Product AI	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-710	\N	\N	0	\N	{}	2026-03-26 09:22:12.477	2026-03-27 16:33:30.218	\N
69c4f9de0ca5fe53789366ca	Altec Lansing - AL Hydrabuds App V1.0	Product | Customer Release	69b119cecb30e08ae1f2238d	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192}	PROD-1189	\N	\N	0	\N	{}	2026-03-26 09:18:22.14	2026-03-26 09:18:22.14	\N
69c4f9dd8b50b316d28b179f	mimi mandatory SDK Update to 11.5.0 or later	Roadmap Initiative	69aff3c2522f033339b5d0d6	{69b119dae2f92006c4346e61}	PROD-1216	\N	\N	0	\N	{}	2026-03-26 09:18:21.624	2026-03-26 09:18:21.624	\N
69c4f9db3ef330782ba60db0	Store | D2C | One Subscription bundle	Product | Store	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,69b119cecb30e08ae1f2238d}	PROD-1219	\N	\N	0	\N	{}	2026-03-26 09:18:19.762	2026-03-26 09:18:19.762	\N
69c4f9dba6fd631ffcaae1df	Brand Agent v1.2.0 (for China)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1220	\N	\N	0	\N	{}	2026-03-26 09:18:19.178	2026-03-26 09:18:19.178	\N
69c252cb4d039a673a6dae0f	Time Off	Feature	69b119d6b705fe95e0c67bcf	{69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c193,69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c191,69b119cecb30e08ae1f2238d,69b119dae2f92006c4346e61}	\N	\N	\N	0	\N	{}	2026-03-24 09:00:59.635	2026-03-24 12:32:54.837	\N
69b185dad24a0c03be75b9f0	AI Display V1 | Bragi AI Charger Platform RDP v1.0 (JL701n) 	Product | Platform	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6}	PROD-299	\N	\N	0	\N	{}	2026-03-11 15:10:18.062	2026-03-11 15:10:18.062	\N
69b185d9a163278f40a909c3	Bragi AI SOC Kit – Bragi AI PRO mSDK Test App v2 (Self-Certification Tool for 3rd parties)	Product | Platform	69aff2f04b4fb2a08f82c191	{69b119d6b705fe95e0c67bcf,69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d}	PROD-322	\N	\N	0	\N	{}	2026-03-11 15:10:17.517	2026-03-11 15:10:17.517	\N
69b185d8f13792be1a6b73e5	Cloud Domain | Strengthen and Secure the Cloud Foundation	Tech Roadmap	69aff3c2522f033339b5d0d6	{}	PROD-332	\N	\N	0	\N	{}	2026-03-11 15:10:16.936	2026-03-11 15:10:16.936	\N
69b185d7275806d272762c2c	Bragi AI SOC Kit | Self-Test, Infrastructure & Tools V1	Product | Platform	69aff2f04b4fb2a08f82c191	{69b119cecb30e08ae1f2238d}	PROD-457	\N	\N	0	\N	{}	2026-03-11 15:10:15.903	2026-03-26 09:22:21.417	\N
69b185d6391daac167a9a45f	UI Automation Runs + Reports + Coverage (Ongoing Initiative)	Tech Roadmap	69aff3c2522f033339b5d0d6	{}	PROD-463	\N	\N	0	\N	{}	2026-03-11 15:10:14.925	2026-03-11 15:10:14.925	\N
69b185d3f8d40a9f60eecfef	Bragi AI |  Baseline | Update analytics coverage for Shortcuts, Audio AI apps	Product | Analytics & Reporting	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192}	PROD-527	\N	\N	0	\N	{}	2026-03-11 15:10:11.905	2026-03-11 15:10:11.905	\N
69b185d20b96e0741cd32a83	AI Monetisation MVP: Streamlining Subscription and Credit Options for Fast Launch	Product | Baseline-App	69aff3c2522f033339b5d0d6	{}	PROD-569	\N	\N	0	\N	{}	2026-03-11 15:10:10.94	2026-03-11 15:10:10.94	\N
69b185d2385a54364f0e8185	Bragi AI | Platform Governance System v1	Capability	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d}	PROD-579	\N	\N	0	\N	{}	2026-03-11 15:10:10.434	2026-03-26 09:22:16.41	\N
69b185d1c12a2de9846a99da	Motion AI v1.0 (Head nod&shake for AB1585)	Feature	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193}	PROD-585	\N	\N	0	\N	{}	2026-03-11 15:10:09.161	2026-03-11 15:10:09.161	\N
69b185d08d59847d9bfeb4bb	Play for Deezer v1.0	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193}	PROD-603	\N	\N	0	\N	{}	2026-03-11 15:10:08.185	2026-03-11 15:10:08.185	\N
69b1859a4130457c18c5948c	Voicemod v1.1 Audio App (Bose Workbench)	Audio App	69aff2f04b4fb2a08f82c192	{}	PROD-1146	\N	\N	0	\N	{}	2026-03-11 15:09:14.659	2026-03-11 15:09:14.659	\N
69b185cfe00b8ea982ae3b5f	LE Audio Auracast v1.0 | AB1595 (CHP300)	Feature	69b119dae2f92006c4346e61	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-609	\N	\N	0	\N	{}	2026-03-11 15:10:07.698	2026-03-27 16:33:30.453	\N
69b185d0ef519fbcc85c5232	Copy of AI Speakerphone RDP ("Dola Cose")	Product | Platform	69b119cecb30e08ae1f2238d	{69b119d6b705fe95e0c67bcf,69aff3c2522f033339b5d0d6,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-587	\N	\N	0	\N	{}	2026-03-11 15:10:08.679	2026-03-27 16:33:30.481	\N
69b185d3e886369429a4e9cd	AI Headphones app XP | Available for Customer Branded apps | Beginning of Q1 2025	Product | Baseline-App	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-553	\N	\N	0	\N	{}	2026-03-11 15:10:11.422	2026-03-27 16:33:30.53	\N
69b185d44971e0ff7bb3e873	Bragi AI | Baseline | Optimise App Accessibility Foundation	Product | Baseline-App	69aff3c2522f033339b5d0d6	{69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-525	\N	\N	0	\N	{}	2026-03-11 15:10:12.389	2026-03-27 16:33:30.672	\N
69b185d4afd332fb9731400b	CMSv2.1 | w/ Bragi AI branded app Self-built	Product | Bragi-DX/CX-Suite	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-519	\N	\N	0	\N	{}	2026-03-11 15:10:12.904	2026-03-27 16:33:30.699	\N
69b185d5e94ea0cd22ba2f03	Playground Audio App	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-486	\N	\N	0	\N	{}	2026-03-11 15:10:13.925	2026-03-27 16:33:30.748	\N
69b185d65d3b50ed6955016c	Voice AI V1.5 (4x fixed Shortcut Hotwords)	Feature	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-475	\N	\N	0	\N	{}	2026-03-11 15:10:14.418	2026-03-27 16:33:30.77	\N
69b185d7bb616e3331635857	TuneIn v1 (biz dev requ.)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-458	\N	\N	0	\N	{}	2026-03-11 15:10:15.412	2026-03-27 16:33:30.795	\N
69b185d80bda98c21dbe870a	Bragi Reporting | Multi-Brand IAP Aggregation Dashboard	Product | Analytics & Reporting	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-376	\N	\N	0	\N	{}	2026-03-11 15:10:16.402	2026-03-27 16:33:30.921	\N
69b185db932fb02373b58c15	Bragi CMSv2 | Work smarter, not harder w/ CMS for Bragi app configurations - Cloud only	Product | Bragi-DX/CX-Suite	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-171	\N	\N	0	\N	{}	2026-03-11 15:10:19.049	2026-03-27 16:33:31.116	\N
69b185dbd8915a42862557ec	Bragi AI | Baseline | Offer an alternative payment solution to end-consumers w/ Paddle or alike.	Product | Store	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-93	\N	\N	0	\N	{}	2026-03-11 15:10:19.512	2026-03-27 16:33:31.135	\N
69b185dbe1b90ccab6d02259	mimi - Personal Hearing Upgrade v2.4 (mobile SDK gen10)	Feature	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-54	\N	\N	0	\N	{}	2026-03-11 15:10:19.963	2026-03-27 16:33:31.154	\N
69b185cf0c847ab4ae0009f1	Dynamic Device Configuration V2 (mSDK, App, Cloud)	Product | Bragi-app	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c191}	PROD-613	\N	\N	0	\N	{}	2026-03-11 15:10:07.193	2026-03-11 15:10:07.193	\N
69b185cebbf50a51b6d836aa	Noise - App MR01	Product | Customer Release	69b119cecb30e08ae1f2238d	{69b119d6b705fe95e0c67bcf,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d}	PROD-636	\N	\N	0	\N	{}	2026-03-11 15:10:06.698	2026-03-11 15:10:06.698	\N
69b185cbe797633bf00d5931	Ovia - ZIP23/SD - RC03	Product | Customer Release	69b119cecb30e08ae1f2238d	{69b119d6b705fe95e0c67bcf,69aff2f04b4fb2a08f82c191,69b119cecb30e08ae1f2238d}	PROD-660	\N	\N	0	\N	{}	2026-03-11 15:10:03.237	2026-03-11 15:10:03.237	\N
69b185c6f8cc61f0ddd0059a	Bluetrum | Bragi AI v2.0 enabling "App-only" scope	Product | Platform	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6}	PROD-669	\N	\N	0	\N	{}	2026-03-11 15:09:58.198	2026-03-11 15:09:58.198	\N
69b185c3a59d54df67056ee0	Play for Tidal v1.0	Audio App	69aff2f04b4fb2a08f82c193	{}	PROD-696	\N	\N	0	\N	{}	2026-03-11 15:09:55.577	2026-03-11 15:09:55.577	\N
69b185c2def14df1ef2c9ebf	Fender App V1 RC01	Product | Customer Release	69b119cecb30e08ae1f2238d	{69b119dae2f92006c4346e61,69b119d6b705fe95e0c67bcf,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192,69b119cecb30e08ae1f2238d}	PROD-731	\N	\N	0	\N	{}	2026-03-11 15:09:54.139	2026-03-11 15:09:54.139	\N
69b185c1a72b77079d89551e	mSDK Core Plugin Rollout v2 – Scripts and Tools	Product | Platform	69aff2f04b4fb2a08f82c191	{}	PROD-736	\N	\N	0	\N	{}	2026-03-11 15:09:53.662	2026-03-11 15:09:53.662	\N
69b185c1d65d921b0d85fd79	Audio AppKit v1.2 (using Dev Dashboard, dynamic AA states)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-737	\N	\N	0	\N	{}	2026-03-11 15:09:53.104	2026-03-11 15:09:53.104	\N
69b185c0cd59b3ea3b8e4b57	BES | Bragi AI v2.0 enabling "App-only" scope	Product | Platform	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6}	PROD-744	\N	\N	0	\N	{}	2026-03-11 15:09:52.567	2026-03-11 15:09:52.567	\N
69b185c0221ccfb783717f56	Airoha | Bragi AI v2.1 enabling "Bragi AI" scope	Product | Platform	69b119dae2f92006c4346e61	{69aff2f04b4fb2a08f82c191}	PROD-745	\N	\N	0	\N	{}	2026-03-11 15:09:52.058	2026-03-11 15:09:52.058	\N
69b185be7a1c273241518cc9	QCC | Bragi AI v2.1 enabling "Bragi AI Scope"	Product | Platform	69b119d6b705fe95e0c67bcf	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c193,69b119cecb30e08ae1f2238d}	PROD-746	\N	\N	0	\N	{}	2026-03-11 15:09:50.815	2026-03-11 15:09:50.815	\N
69b185bdab0739abb88b9e5d	Formalisation of Mobile Release Process	Tech Roadmap	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,69b119cecb30e08ae1f2238d}	PROD-782	\N	\N	0	\N	{}	2026-03-11 15:09:49.796	2026-03-11 15:09:49.796	\N
69b185bdd2c5ee6405d74d5d	QCC | Bragi AI v2.0 enabling "App Only"	Product | Platform	69aff2f04b4fb2a08f82c191	{69b119d6b705fe95e0c67bcf,69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d}	PROD-787	\N	\N	0	\N	{}	2026-03-11 15:09:49.328	2026-03-11 15:09:49.328	\N
69b185bca15dffb12de87aad	Bluetrum | Bragi AI v2.1 enabling "Bragi AI" scope	Product | Platform	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6}	PROD-794	\N	\N	0	\N	{}	2026-03-11 15:09:48.868	2026-03-11 15:09:48.868	\N
69b185bc9db6da5cdee65724	Enabler Team | Tech Debt & Maintenance	Product | Platform	69b119dae2f92006c4346e61	{}	PROD-807	\N	\N	0	\N	{}	2026-03-11 15:09:48.401	2026-03-11 15:09:48.401	\N
69b185bbc70cf147f383b5c6	Growth Team | Tech Debt & Maintenance | Q3+Q4 2025	Product | Platform	69b119d6b705fe95e0c67bcf	{}	PROD-811	\N	\N	0	\N	{}	2026-03-11 15:09:47.448	2026-03-11 15:09:47.448	\N
69b185ba101b59c82aa3f2a9	QCC | Bragi AI v2.2 enabling "Bragi AI PRO" scope	Product | Platform	69b119d6b705fe95e0c67bcf	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c193,69b119cecb30e08ae1f2238d}	PROD-812	\N	\N	0	\N	{}	2026-03-11 15:09:46.979	2026-03-11 15:09:46.979	\N
69b185ba9db6da5cdee65722	WQ | Bragi AI v2.2 enabling "Bragi AI PRO" Scope | WQ7036	Product | Platform	69b119d6b705fe95e0c67bcf	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d}	PROD-814	\N	\N	0	\N	{}	2026-03-11 15:09:46.493	2026-03-11 15:09:46.493	\N
69b185b9c02484a4a79b587d	AB1595 Headset – Update to latest Airoha SDK 5.6	Product | Platform	69b119dae2f92006c4346e61	{}	PROD-839	\N	\N	0	\N	{}	2026-03-11 15:09:45.462	2026-03-11 15:09:45.462	\N
69b185ba1144d603a6a51328	Airoha | Bragi AI & USB Audio (Status Quo Evaluation)	Product | Platform	69b119dae2f92006c4346e61	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-832	\N	\N	0	\N	{}	2026-03-11 15:09:46.012	2026-03-27 16:33:30.073	\N
69b185bbd3a17ddd4c810681	Bragi AI via LE Audio (LE Transport) | AB1585	Feature	69b119dae2f92006c4346e61	{69b119d6b705fe95e0c67bcf,69aff2f04b4fb2a08f82c191,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-808	\N	\N	0	\N	{}	2026-03-11 15:09:47.903	2026-03-27 16:33:30.116	\N
69b185be5a7dea3dcadc66e1	Amazon - Poplar (S7Gen1 TWS)	Product | Customer	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-777	\N	\N	0	\N	{}	2026-03-11 15:09:50.286	2026-03-27 16:33:30.135	\N
69b185c218a878145fbf9116	Play for Apple Music Audio App v1.1 (web UI) 	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-713	\N	\N	0	\N	{}	2026-03-11 15:09:54.637	2026-03-27 16:33:30.178	\N
69b185c43882b08138714472	Bose <> Bragi AI Audio App Integration	Audio App	69aff2f04b4fb2a08f82c193	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-693	\N	\N	0	\N	{}	2026-03-11 15:09:56.041	2026-03-27 16:33:30.283	\N
69b185c4fb2122147a065b8c	Chat v2.1 (interrupt by voice, turn detection, memory, location, time +3 agents)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-691	\N	\N	0	\N	{}	2026-03-11 15:09:56.512	2026-03-27 16:33:30.302	\N
69b185c7217678c21a4bea0a	Voice AI v2 (+ Speaker Separation)	Feature	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-665	\N	\N	0	\N	{}	2026-03-11 15:09:59.893	2026-03-27 16:33:30.349	\N
69b185c9e478e56c16423b49	Voice AI V2 (Speaker recoginition (verification), Voice AI UI change from VC to Product AI)	Feature	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-662	\N	\N	0	\N	{}	2026-03-11 15:10:01.581	2026-03-27 16:33:30.372	\N
69b185b86e00d0c7e585e2dd	EN18031 Cybersecurity | Implementation of Required Changes (Jieli)	Tech Roadmap	69aff2f04b4fb2a08f82c191	{}	PROD-852	\N	\N	0	\N	{}	2026-03-11 15:09:44.479	2026-03-26 09:22:09.591	\N
69b185b7e50a69d6fa7d3671	2025 Q3 – Improve Chat AI, +2 Brand Agents, +2 AA in Play bundle, +health vertical Strava, MVPs to show future of AI in audio	Strategy	69aff2f04b4fb2a08f82c192	{}	PROD-857	\N	\N	0	\N	{}	2026-03-11 15:09:43.972	2026-03-11 15:09:43.972	\N
69b185b6e0d041ff1776b20f	AB1595 TWS – Update to latest Airoha SDK 5.6 (SDK 5.8!)	Product | Platform	69b119dae2f92006c4346e61	{}	PROD-885	\N	\N	0	\N	{}	2026-03-11 15:09:42.961	2026-03-11 15:09:42.961	\N
69b185b6bcf38dab16e73393	AB1585 Headset – Update to latest Airoha SDK 5.6 (SDK 5.8!)	Product | Platform	69b119dae2f92006c4346e61	{}	PROD-886	\N	\N	0	\N	{}	2026-03-11 15:09:42.427	2026-03-11 15:09:42.427	\N
69b185b509fb8b4f2b0cf43c	Jieli | Bragi AI v2.0 enabling "App Only" | JL701x & JL700x	Product | Platform	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6}	PROD-889	\N	\N	0	\N	{}	2026-03-11 15:09:41.463	2026-03-11 15:09:41.463	\N
69b185b4c69b65f1eb8c4ade	Actions | Bragi AI v2.1 enabling "Bragi AI" scope	Product | Platform	69b119d6b705fe95e0c67bcf	{}	PROD-893	\N	\N	0	\N	{}	2026-03-11 15:09:40.946	2026-03-11 15:09:40.946	\N
69b185b4e92ef3b524f9d648	Actions | Bragi AI v2.2 enabling "Bragi AI PRO" scope	Product | Platform	69b119d6b705fe95e0c67bcf	{}	PROD-894	\N	\N	0	\N	{}	2026-03-11 15:09:40.453	2026-03-11 15:09:40.453	\N
69b185b353b65f8ce2b2efe0	Airoha | Bragi AI v2.2 enabling "Bragi AI PRO" scope	Product | Platform	69b119dae2f92006c4346e61	{69aff2f04b4fb2a08f82c191}	PROD-896	\N	\N	0	\N	{}	2026-03-11 15:09:39.992	2026-03-11 15:09:39.992	\N
69b185b3ec520b5591fd28fd	Jieli | Bragi AI v2.3 enabling "AI Display" scope | JL701x & JL700x	Product | Platform	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c193}	PROD-898	\N	\N	0	\N	{}	2026-03-11 15:09:39.472	2026-03-11 15:09:39.472	\N
69b185b3af96b945e88e884f	Actions | Bragi AI v2.0 enabling "App-only" scope	Product | Platform	69b119d6b705fe95e0c67bcf	{69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d}	PROD-899	\N	\N	0	\N	{}	2026-03-11 15:09:39.006	2026-03-11 15:09:39.006	\N
69b185b2e3897d2857a85f2d	WQ | Bragi AI v2.0 enabling "App-only" Scope	Product | Platform	69b119d6b705fe95e0c67bcf	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d}	PROD-900	\N	\N	0	\N	{}	2026-03-11 15:09:38.537	2026-03-11 15:09:38.537	\N
69b185b2d65d921b0d85fd74	Solution via RDP - "P6_JL/Display" ｜MP Scope	Product | Platform	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d}	PROD-903	\N	\N	0	\N	{}	2026-03-11 15:09:38.043	2026-03-26 09:22:08.395	\N
69b185b1c0ee46a0c7a2ab78	0->1  | Product Apps | Enable Natural, Voice-First Control for Effortless Device Interactions	Product | Baseline-App	69aff3c2522f033339b5d0d6	{69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192}	PROD-921	\N	\N	0	\N	{}	2026-03-11 15:09:37.072	2026-03-11 15:09:37.072	\N
69b185b0323ddee63f3bc600	Jieli | Bragi AI v2.1 ready for Speaker	Roadmap Initiative	69aff2f04b4fb2a08f82c191	{69b119cecb30e08ae1f2238d}	PROD-923	\N	\N	0	\N	{}	2026-03-11 15:09:36.576	2026-03-26 09:22:07.904	\N
69b185b054215b1272e01614	Jieli | Bragi AI v2.2 enabling "Bragi AI PRO" scope | JL701x & JL700x	Product | Platform	69aff2f04b4fb2a08f82c191	{69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c193}	PROD-927	\N	\N	0	\N	{}	2026-03-11 15:09:36.089	2026-03-11 15:09:36.089	\N
69b185af7e94e4835a125c9e	Leo AI v1.3.0 (interrupt, memory)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-937	\N	\N	0	\N	{}	2026-03-11 15:09:35.14	2026-03-11 15:09:35.14	\N
69b185ae58bc7843bb2332b5	Bragi AI | Platform Governance System v2	Capability	69b119d6b705fe95e0c67bcf	{69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d}	PROD-938	\N	\N	0	\N	{}	2026-03-11 15:09:34.393	2026-03-11 15:09:34.393	\N
69b185ad2a0d0be54b9946d2	EN18031 Cybersecurity | Implementation of Required Changes (QCC)	Tech Roadmap	69b119d6b705fe95e0c67bcf	{69b119dae2f92006c4346e61,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6}	PROD-939	\N	\N	0	\N	{}	2026-03-11 15:09:33.908	2026-03-11 15:09:33.908	\N
69b185ad1c1abddee7e3ca21	EN18031 Cybersecurity | Implementation of Required Changes | Airoha SDK3.7 & 5.6	Tech Roadmap	69b119dae2f92006c4346e61	{69aff2f04b4fb2a08f82c191}	PROD-940	\N	\N	0	\N	{}	2026-03-11 15:09:33.423	2026-03-11 15:09:33.423	\N
69b185ace1ec632dcfce7d96	Loewe - OverEar - MR2	Product | Customer Release	69b119cecb30e08ae1f2238d	{69b119dae2f92006c4346e61,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192}	PROD-960	\N	\N	0	\N	{}	2026-03-11 15:09:32.954	2026-03-11 15:09:32.954	\N
69b185aca0c9b07c9ad2b56b	Pebble - Pebble Hear - DVT RC01	Product | Customer Release	69b119cecb30e08ae1f2238d	{69b119dae2f92006c4346e61,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6}	PROD-966	\N	\N	0	\N	{}	2026-03-11 15:09:32.475	2026-03-11 15:09:32.475	\N
69b185acfd0bfd30e94e5304	Pebble - Pebble Hear - PVT RC01	Product | Customer Release	69b119cecb30e08ae1f2238d	{69b119dae2f92006c4346e61,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6}	PROD-968	\N	\N	0	\N	{}	2026-03-11 15:09:32.015	2026-03-11 15:09:32.015	\N
69b185abed6ea4021191686a	AI Display V1 | Display API	Capability	69aff2f04b4fb2a08f82c191	{69b119d6b705fe95e0c67bcf,69aff3c2522f033339b5d0d6}	PROD-969	\N	\N	0	\N	{}	2026-03-11 15:09:31.548	2026-03-11 15:09:31.548	\N
69b185aa77cb367934e66376	Bose - Stromae (AB1585 TWS) 	Product | Customer	69b119cecb30e08ae1f2238d	{69b119dae2f92006c4346e61,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192}	PROD-976	\N	\N	0	\N	{}	2026-03-11 15:09:30.991	2026-03-11 15:09:30.991	\N
69b185aa0e0092df8224f57c	Bose - Stromae - DVT RC01	Product | Customer Release	69b119cecb30e08ae1f2238d	{69b119dae2f92006c4346e61,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6}	PROD-979	\N	\N	0	\N	{}	2026-03-11 15:09:30.537	2026-03-11 15:09:30.537	\N
69b1859a9c57a195d8e553e4	Translate v1 Audio App (on phone models, in person meetings) (Bose Workbench)	Audio App	69aff2f04b4fb2a08f82c192	{}	PROD-1150	\N	\N	0	\N	{}	2026-03-11 15:09:14.197	2026-03-11 15:09:14.197	\N
69b185b19b0065c39350c8ce	PlayKit v1.0 (Blueprint for all Play for AAs)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-904	\N	\N	0	\N	{}	2026-03-11 15:09:37.565	2026-03-27 16:33:29.964	\N
69b185b7c1709644923467ed	Play for Tidal v1.0	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-859	\N	\N	0	\N	{}	2026-03-11 15:09:43.477	2026-03-27 16:33:30.026	\N
69b185aaf2a65a2a652bb3ab	Bose - Stromae - PVT RC01	Product | Customer Release	69b119cecb30e08ae1f2238d	{69b119dae2f92006c4346e61,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6}	PROD-980	\N	\N	0	\N	{}	2026-03-11 15:09:30.064	2026-03-11 15:09:30.064	\N
69b185a9919ec657c70c1819	Skdy Skull AI v1.2.0 (interrupt by voice, turn detection, memory, location, time)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-986	\N	\N	0	\N	{}	2026-03-11 15:09:29.133	2026-03-11 15:09:29.133	\N
69b185a8d506684c3a00fb0b	Chat v2.2 (Improvements)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-988	\N	\N	0	\N	{}	2026-03-11 15:09:28.667	2026-03-11 15:09:28.667	\N
69b185a8971ad2b37799c6f3	Mobile Test Coverage Improvement [Phase 1]	Tech Roadmap	69aff2f04b4fb2a08f82c191	{69b119dae2f92006c4346e61,69b119d6b705fe95e0c67bcf,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,69b119cecb30e08ae1f2238d}	PROD-989	\N	\N	0	\N	{}	2026-03-11 15:09:28.065	2026-03-11 15:09:28.065	\N
69b185a76153409471370640	EN18031 Cybersecurity | Implementation of Required Changes (Bluetrum)	Tech Roadmap	69aff2f04b4fb2a08f82c191	{}	PROD-996	\N	\N	0	\N	{}	2026-03-11 15:09:27.612	2026-03-26 09:22:05.497	\N
69b185a74753856a711f5786	Playground v1.0 (config via AA Dashboard)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-998	\N	\N	0	\N	{}	2026-03-11 15:09:27.109	2026-03-11 15:09:27.109	\N
69b185a502a23be0703ec3af	Audio AppKit v1.2 (Bragi JS API v1.2)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1000	\N	\N	0	\N	{}	2026-03-11 15:09:25.987	2026-03-11 15:09:25.987	\N
69b185a409577dbee0b9b90d	Golden ADK | QCC ADK Update to latest Version	Roadmap Initiative	69b119d6b705fe95e0c67bcf	{}	PROD-1009	\N	\N	0	\N	{}	2026-03-11 15:09:24.293	2026-03-11 15:09:24.293	\N
69b185a3b619c787d00fa76a	Enabler contribution for CHP300 DVT 	Product | Customer Release	69b119dae2f92006c4346e61	{69aff2f04b4fb2a08f82c191}	PROD-1011	\N	\N	0	\N	{}	2026-03-11 15:09:23.805	2026-03-11 15:09:23.805	\N
69b185a3be73b52dafdaaf50	Parametrised Client Builds [Phase 1 Foundation & Prototype]	Tech Roadmap	69b119cecb30e08ae1f2238d	{69b119cecb30e08ae1f2238d}	PROD-1012	\N	\N	0	\N	{}	2026-03-11 15:09:23.332	2026-03-11 15:09:23.332	\N
69b185a24ce499bef9db1c42	Cloud Domain | Improve Cloud Maintainability and Operational Efficiency	Tech Roadmap	69aff3c2522f033339b5d0d6	{}	PROD-1028	\N	\N	0	\N	{}	2026-03-11 15:09:22.881	2026-03-11 15:09:22.881	\N
69b185a2ddb71e613d649cfe	Unify and modernize Mobile library documentation and integration guides (Phase 1)	Tech Roadmap	69aff3c2522f033339b5d0d6	{}	PROD-1030	\N	\N	0	\N	{}	2026-03-11 15:09:22.339	2026-03-11 15:09:22.339	\N
69b185a1bbbda4efe9a43099	Altec Lansing CES Demo App V1.0	Product | Customer Release	69b119cecb30e08ae1f2238d	{69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1037	\N	\N	0	\N	{}	2026-03-11 15:09:21.855	2026-03-11 15:09:21.855	\N
69b185a0bc70288377fe9e74	Skullcandy - Method 540 ANC MR02	Product | Customer Release	69b119cecb30e08ae1f2238d	{}	PROD-1049	\N	\N	0	\N	{}	2026-03-11 15:09:20.469	2026-03-11 15:09:20.469	\N
69b1859f6e00d0c7e585e2cf	Bragi AI | Baseline | Home Screen Improvements	Product | Baseline-App	69aff3c2522f033339b5d0d6	{}	PROD-1074	\N	\N	0	\N	{}	2026-03-11 15:09:19.508	2026-03-11 15:09:19.508	\N
69b1859f2b8e1499af1bf770	Bragi CMS v1 Improvements | Work smarter, not harder w/ CMS for Bragi app configurations - Cloud only	Product | Bragi-DX/CX-Suite	69aff3c2522f033339b5d0d6	{}	PROD-1076	\N	\N	0	\N	{}	2026-03-11 15:09:19.029	2026-03-11 15:09:19.029	\N
69b1859edef14df1ef2c9eb4	Amazon Poplar | Sensor Workpackage for QCC S7	Product | Platform	69b119d6b705fe95e0c67bcf	{69aff2f04b4fb2a08f82c191}	PROD-1084	\N	\N	0	\N	{}	2026-03-11 15:09:18.533	2026-03-11 15:09:18.533	\N
69b1859e06686d5e961844a0	AB1585 | Support Legato "Ludwig" Hearing Assist Frames	Product | Customer	69b119dae2f92006c4346e61	{69b119d6b705fe95e0c67bcf,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d}	PROD-1109	\N	\N	0	\N	{}	2026-03-11 15:09:18.023	2026-03-11 15:09:18.023	\N
69b1859cb9888c1b3ba0cee9	Fireflies v1.0 (on cloud STT)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192}	PROD-1119	\N	\N	0	\N	{}	2026-03-11 15:09:16.55	2026-03-11 15:09:16.55	\N
69b1859c519fe4a8295bdb46	Control AI v1.0 (replaces Voice Control, on cloud STT, TTS, LLM)	Audio App	69aff2f04b4fb2a08f82c192	{}	PROD-1122	\N	\N	0	\N	{}	2026-03-11 15:09:16.095	2026-03-11 15:09:16.095	\N
69b1859bf180e50ea67536b3	Play for Apple Music v2 Audio App (Bose Workbench)	Audio App	69aff2f04b4fb2a08f82c193	{}	PROD-1142	\N	\N	0	\N	{}	2026-03-11 15:09:15.657	2026-03-11 15:09:15.657	\N
69b1859b52804571a7953509	Bose Brand Agent v1.0 Audio App (cloud models Product AI, Brand Agent) (Bose Workbench)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192}	PROD-1143	\N	\N	0	\N	{}	2026-03-11 15:09:15.174	2026-03-11 15:09:15.174	\N
69b1859f2a0d0be54b9946cf	Strategy | Growth | AppKit (+mSDK) | 100M 	Strategy	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c191,69aff2f04b4fb2a08f82c193,69b119cecb30e08ae1f2238d,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1068	\N	\N	0	\N	{}	2026-03-11 15:09:19.987	2026-03-27 16:33:29.748	\N
69b185a0b1943cf359186000	Skullcandy | One App	Product | AppKit	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c191,69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,69b119cecb30e08ae1f2238d,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1042	\N	\N	0	\N	{}	2026-03-11 15:09:20.944	2026-03-27 16:33:29.768	\N
69b185a15cd408161656dbee	Play for Apple Music v1.1 (Native iOS) (Bose Workbench)	Audio App	69aff2f04b4fb2a08f82c193	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1038	\N	\N	0	\N	{}	2026-03-11 15:09:21.399	2026-03-27 16:33:29.787	\N
69b185a4db195794c5c198b5	Play for Endel v1.0	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1008	\N	\N	0	\N	{}	2026-03-11 15:09:24.876	2026-03-27 16:33:29.832	\N
69b185a51d7c5b343ac68d20	PlayKit v1.2 (Speak to Pause, Improvements)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1005	\N	\N	0	\N	{}	2026-03-11 15:09:25.426	2026-03-27 16:33:29.855	\N
69b185a64753856a711f5785	AgentKit v1.2 (websearch, Dev Dashboard new agent config)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-999	\N	\N	0	\N	{}	2026-03-11 15:09:26.582	2026-03-27 16:33:29.878	\N
69b185a9e0d041ff1776b209	AgentKit v1.3 (multichat/agent)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-985	\N	\N	0	\N	{}	2026-03-11 15:09:29.616	2026-03-27 16:33:29.9	\N
69b18598a15dffb12de87aa5	Dev Portal v1.2 (external web apps for new X team)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1164	\N	\N	0	\N	{}	2026-03-11 15:09:12.689	2026-03-11 15:09:12.689	\N
69b185989719901932f476ea	Bragi AppKit | Bose Madrid - Priority 1	Roadmap Initiative	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1170	\N	\N	0	\N	{}	2026-03-11 15:09:12.203	2026-03-11 15:09:12.203	\N
69b18595e0aeade56645ff0b	Bragi CMS v1.1 Improvements | Work smarter, not harder w/ CMS for Bragi app configurations - Cloud only	Product | Bragi-DX/CX-Suite	69aff3c2522f033339b5d0d6	{}	PROD-1177	\N	\N	0	\N	{}	2026-03-11 15:09:09.175	2026-03-11 15:09:09.175	\N
69b18594019fd9ae42577aab	Audio AppKit v1.3 (Bragi JS API v1.3)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193}	PROD-1182	\N	\N	0	\N	{}	2026-03-11 15:09:08.198	2026-03-11 15:09:08.198	\N
69b185937e94e4835a125c99	AB1577 | Enable Bragi AI Custom (porting)	Product | Platform	69b119dae2f92006c4346e61	{69aff2f04b4fb2a08f82c191}	PROD-1210	\N	\N	0	\N	{}	2026-03-11 15:09:07.734	2026-03-11 15:09:07.734	\N
69b18593ddb71e613d649cfb	Bose Brand Agent v1.1 Audio App (on phone models Product AI, Brand Agent) (Bose Workbench)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192}	PROD-1211	\N	\N	0	\N	{}	2026-03-11 15:09:07.248	2026-03-11 15:09:07.248	\N
69b18592ca17b825a0581905	Fireflies v1.1 (on phone STT)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192}	PROD-1215	\N	\N	0	\N	{}	2026-03-11 15:09:06.269	2026-03-11 15:09:06.269	\N
69c4f9dc5c3dc9fc4aea3936	Stingray Calm v1 (biz dev requ.)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1218	\N	\N	0	\N	{}	2026-03-26 09:18:20.295	2026-03-27 16:33:29.365	\N
69c4f9dd3953fdf3e6bb90e2	Stingray Music v1 (biz dev requ.)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1217	\N	\N	0	\N	{}	2026-03-26 09:18:21.09	2026-03-27 16:33:29.41	\N
69b18592419a51a099da2d6c	AgentKit v2.1 (interrupt by voice, turn detection, record mode, memory, location, time)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1212	\N	\N	0	\N	{}	2026-03-11 15:09:06.773	2026-03-27 16:33:29.434	\N
69b185944b7676d67f5c5bec	PlayKit v1.1 (Tap/Plus version, Cross Audio App API)	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1178	\N	\N	0	\N	{}	2026-03-11 15:09:08.696	2026-03-27 16:33:29.461	\N
69b18595c9db847b1694acc5	Amazon - Poplar PVT V1.0	Product | Customer Release	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1175	\N	\N	0	\N	{}	2026-03-11 15:09:09.665	2026-03-27 16:33:29.487	\N
69b18596c9da5f702e78a224	Amazon - Poplar DVT V1.0	Product | Customer Release	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1174	\N	\N	0	\N	{}	2026-03-11 15:09:10.258	2026-03-27 16:33:29.514	\N
69b185961b5e2297782e189f	Amazon - Poplar EVT V1.0	Product | Customer Release	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1173	\N	\N	0	\N	{}	2026-03-11 15:09:10.769	2026-03-27 16:33:29.535	\N
69b185973359bbbe9926f20e	Amazon - Poplar HVT V1.0	Product | Customer Release	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1172	\N	\N	0	\N	{}	2026-03-11 15:09:11.252	2026-03-27 16:33:29.555	\N
69b18597f8134c9f8ec12ec9	Play for Apple Music v1.2 (based PlayKit) 	Audio App	69aff2f04b4fb2a08f82c193	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1171	\N	\N	0	\N	{}	2026-03-11 15:09:11.725	2026-03-27 16:33:29.579	\N
69b18599d523061158464a95	Copy of Voice AI V1.1 (on phone STT + TTS) (Bose Workbench)	Feature	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1162	\N	\N	0	\N	{}	2026-03-11 15:09:13.228	2026-03-27 16:33:29.6	\N
69b185992a55c288d93c7d88	Brussels - Bose QCE App 3.0.0	Product | Customer Release	69b119cecb30e08ae1f2238d	{69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1156	\N	\N	0	\N	{}	2026-03-11 15:09:13.729	2026-03-27 16:33:29.631	\N
69b1859da3142eddd54c6a5c	 Bragi AI AppKit |  Monthly Updates | Q1 '26	Product | AppKit	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1116	\N	\N	0	\N	{}	2026-03-11 15:09:17.062	2026-03-27 16:33:29.656	\N
69b1859d995221c7150da872	 Bragi AI app | 2 App Stores Updates | Q1 '26	Product | Bragi-app	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c191,69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1115	\N	\N	0	\N	{}	2026-03-11 15:09:17.517	2026-03-27 16:33:29.678	\N
69c4f9e486d77e09861dc087	Bragi CMS v2.1 | Enables AppKit configuration	Product | Bragi-DX/CX-Suite	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1072	\N	\N	0	\N	{}	2026-03-26 09:18:28.567	2026-03-27 16:33:29.7	\N
69c4fab91928960fef82ac6a	Voice AI - Button to Voice, PTT v2	Capability	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-1023	\N	\N	0	\N	{}	2026-03-26 09:22:01.938	2026-03-27 16:33:29.81	\N
69b185afa48c351d9200d1f4	Chat AI v1.1.1 (5 languages with cloud STT/TTS with old native UI for Baseus)	Audio App	69aff2f04b4fb2a08f82c192	{69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-930	\N	\N	0	\N	{}	2026-03-11 15:09:35.626	2026-03-27 16:33:29.941	\N
69b185b59bfc694e209603e1	Bragi AI via LE Audio (LE Transport) | AB1595	Feature	69b119dae2f92006c4346e61	{69b119d6b705fe95e0c67bcf,69aff2f04b4fb2a08f82c191,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-888	\N	\N	0	\N	{}	2026-03-11 15:09:41.962	2026-03-27 16:33:29.985	\N
69b185b8f98ed67924d689b7	EN18031 Cybersecurity | Audit	Tech Roadmap	69b119dae2f92006c4346e61	{69b119dae2f92006c4346e61,69b119d6b705fe95e0c67bcf,69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69b119cecb30e08ae1f2238d,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-851	\N	\N	0	\N	{}	2026-03-11 15:09:44.976	2026-03-27 16:33:30.05	\N
69b185c3d460df3f46badc83	Voice AI V1.1 (on phone STT + TTS) (Bose Workbench)	Feature	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-712	\N	\N	0	\N	{}	2026-03-11 15:09:55.112	2026-03-27 16:33:30.197	\N
69c4fac43575e3e3b086fefd	Bragi AI | Baseline | RevenueCat Integration	Product | Store	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-708	\N	\N	0	\N	{}	2026-03-26 09:22:12.945	2026-03-27 16:33:30.246	\N
69c4fac55627645ec59e5a6a	Audio App | Headphone Stereo Crossfeed	Feature	69b119dae2f92006c4346e61	{69aff3c2522f033339b5d0d6,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-682	\N	\N	0	\N	{}	2026-03-26 09:22:13.963	2026-03-27 16:33:30.323	\N
69b185ccce4f7af3d010ef30	Bragi "AI Audio Stick" v1 （Fireflies PoC Scope）	New Opportunities	69aff2f04b4fb2a08f82c191	{69aff2f04b4fb2a08f82c191,69aff3c2522f033339b5d0d6,69aff2f04b4fb2a08f82c192,69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-641	\N	\N	0	\N	{}	2026-03-11 15:10:04.955	2026-03-27 16:33:30.4	\N
69c4facb72a589a03b631a2b	Bragi AI app | End-user audio app store purchase | Credit based system | Public Beta	Product | Bragi-app	69aff3c2522f033339b5d0d6	{69aff2f04b4fb2a08f82c192,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-531	\N	\N	0	\N	{}	2026-03-26 09:22:19.51	2026-03-27 16:33:30.622	\N
69b185d5c82acc0b6310a09d	Play for Soundcloud v1.0	Audio App	69aff2f04b4fb2a08f82c193	{69aff2f04b4fb2a08f82c193,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-491	\N	\N	0	\N	{}	2026-03-11 15:10:13.414	2026-03-27 16:33:30.722	\N
69c4fad268fd77b36b1db9e2	Bragi CX/DX Suite | Alpha | Bragi AI experiences management 	Product | Bragi-DX/CX-Suite	69aff3c2522f033339b5d0d6	{19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-374	\N	\N	0	\N	{}	2026-03-26 09:22:26.774	2026-03-27 16:33:30.947	\N
69b185da78b3165e77b02bee	LE Audio Auracast v2 | Easy Broadcast Sharing	Feature	69b119dae2f92006c4346e61	{69aff3c2522f033339b5d0d6,19647f4f-4820-4b1c-bb18-5bade52f81d4}	PROD-298	\N	\N	0	\N	{}	2026-03-11 15:10:18.556	2026-03-27 16:33:30.969	\N
\.


--
-- Data for Name: WorkAreaType; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public."WorkAreaType" (id, name, created_at, updated_at, color) FROM stdin;
69c2845551ce47780208e400	Time off	2026-03-24 12:32:21.346	2026-03-24 12:32:21.346	\N
69b14f1148aad4e55eb09290	Product | Store	2026-03-11 11:16:33.633	2026-03-11 11:16:33.633	\N
69b14f11147cb30b76a38aa0	Product | Analytics & Reporting	2026-03-11 11:16:33.103	2026-03-11 11:16:33.103	\N
69b14f10f475e8411bfce8cd	New Opportunities	2026-03-11 11:16:32.57	2026-03-11 11:16:32.57	\N
69b14f10c93c71eaf4640522	PM Internal	2026-03-11 11:16:32.043	2026-03-11 11:16:32.043	\N
69b14f0f2fcb457ae1885947	Capability	2026-03-11 11:16:31.553	2026-03-11 11:16:31.553	\N
69b14f0fb54deb0124919579	Tech Roadmap	2026-03-11 11:16:31.049	2026-03-11 11:16:31.049	\N
69b14f0eb6104e35cef79b43	Product | Baseline-App	2026-03-11 11:16:30.589	2026-03-11 11:16:30.589	\N
69b14f0e45862f6735c7bd68	Strategy	2026-03-11 11:16:30.112	2026-03-11 11:16:30.112	\N
69b14f0d59505c7acb67f893	Product | Bragi-app	2026-03-11 11:16:29.595	2026-03-11 11:16:29.595	\N
69b14f0dffe5a576322e98fc	Product | AppKit	2026-03-11 11:16:29.149	2026-03-11 11:16:29.149	\N
69b14f0cc41d9175dd1b9e6e	Feature	2026-03-11 11:16:28.681	2026-03-11 11:16:28.681	\N
69b14f0c4877db051d642e4d	Roadmap Initiative	2026-03-11 11:16:28.115	2026-03-11 11:16:28.115	\N
69b14f0b6c1b605b228e3316	Product | Customer Release	2026-03-11 11:16:27.645	2026-03-11 11:16:27.645	\N
69b14f0bda34945f506de8f8	Product | Bragi-DX/CX-Suite	2026-03-11 11:16:27.186	2026-03-11 11:16:27.186	\N
69b14f0a8a8279417a742014	Product | Customer	2026-03-11 11:16:26.704	2026-03-11 11:16:26.704	\N
69b14f0a4aab091491f7e4ca	Product | Platform	2026-03-11 11:16:26.11	2026-03-11 11:16:26.11	\N
69b14f09fb56d3cb2932d28d	Audio App	2026-03-11 11:16:25.666	2026-03-11 11:16:25.666	\N
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: bragi
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
\.


--
-- Name: Allocation Allocation_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."Allocation"
    ADD CONSTRAINT "Allocation_pkey" PRIMARY KEY (id);


--
-- Name: JiraSyncHistory JiraSyncHistory_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."JiraSyncHistory"
    ADD CONSTRAINT "JiraSyncHistory_pkey" PRIMARY KEY (id);


--
-- Name: QuarterlyAllocation QuarterlyAllocation_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."QuarterlyAllocation"
    ADD CONSTRAINT "QuarterlyAllocation_pkey" PRIMARY KEY (id);


--
-- Name: QuarterlyPlanHistory QuarterlyPlanHistory_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."QuarterlyPlanHistory"
    ADD CONSTRAINT "QuarterlyPlanHistory_pkey" PRIMARY KEY (id);


--
-- Name: QuarterlyPlanSnapshot QuarterlyPlanSnapshot_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."QuarterlyPlanSnapshot"
    ADD CONSTRAINT "QuarterlyPlanSnapshot_pkey" PRIMARY KEY (id);


--
-- Name: QuarterlyWorkAreaSelection QuarterlyWorkAreaSelection_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."QuarterlyWorkAreaSelection"
    ADD CONSTRAINT "QuarterlyWorkAreaSelection_pkey" PRIMARY KEY (id);


--
-- Name: Sprint Sprint_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."Sprint"
    ADD CONSTRAINT "Sprint_pkey" PRIMARY KEY (id);


--
-- Name: TeamMember TeamMember_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."TeamMember"
    ADD CONSTRAINT "TeamMember_pkey" PRIMARY KEY (id);


--
-- Name: Team Team_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."Team"
    ADD CONSTRAINT "Team_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: WorkAreaType WorkAreaType_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."WorkAreaType"
    ADD CONSTRAINT "WorkAreaType_pkey" PRIMARY KEY (id);


--
-- Name: WorkArea WorkArea_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public."WorkArea"
    ADD CONSTRAINT "WorkArea_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: bragi
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: bragi
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- PostgreSQL database dump complete
--

\unrestrict tW94aDjl5U0wccyrgUhHjTYei8ApS2xOgRRNRrIQeIgQr06v6IxtjDUzltna7Vn

