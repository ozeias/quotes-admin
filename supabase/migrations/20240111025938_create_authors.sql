--
-- Name: pgcrypto; Type: EXTENSION; Schema: -;
--
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -;
--
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';

--
-- Name: authors; Type: TABLE; Schema: public;
--
DROP TABLE IF EXISTS public.authors;

CREATE TABLE public.authors (
    id uuid NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    aka character varying[],
    link character varying,
    bio character varying,
    description character varying,
    gender character varying,
    genres character varying[] DEFAULT '{}'::character varying[],
    birthplace character varying,
    proverb boolean DEFAULT false NOT NULL,
    bible boolean DEFAULT false NOT NULL,
    active boolean DEFAULT true NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    quotes_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public;
--
ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);

--
-- Name: index_authors_on_slug; Type: INDEX; Schema: public; Owner: oz
--
CREATE UNIQUE INDEX index_authors_on_slug ON public.authors USING btree (slug);

--
-- Name: index_authors_on_genres; Type: INDEX; Schema: public; Owner: oz
--
CREATE INDEX index_authors_on_genres ON public.authors USING gin (genres);

--
-- Security
--
ALTER TABLE "public"."authors" OWNER TO "postgres";
ALTER TABLE "public"."authors" ENABLE ROW LEVEL SECURITY;

-- GRANT ALL ON TABLE "public"."authors" TO "anon";
GRANT ALL ON TABLE "public"."authors" TO "authenticated";
GRANT ALL ON TABLE "public"."authors" TO "service_role";


CREATE POLICY "Enable read access for authenticated users" ON "public"."authors"
AS PERMISSIVE FOR SELECT
TO authenticated
USING (true);
