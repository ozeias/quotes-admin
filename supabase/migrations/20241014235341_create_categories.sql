--
-- Name: categories; Type: TABLE; Schema: public;
--
DROP TABLE IF EXISTS public.categories;

CREATE TABLE public.categories (
    id uuid NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying,
    active boolean DEFAULT true NOT NULL,
    featured boolean DEFAULT false NOT NULL,
    background_image json,
    quotes_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public;
--
ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);

--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public;
--
CREATE UNIQUE INDEX index_categories_on_slug ON public.categories USING btree (slug);

--
-- Security
--
ALTER TABLE "public"."categories" OWNER TO "postgres";
ALTER TABLE "public"."categories" ENABLE ROW LEVEL SECURITY;

-- GRANT ALL ON TABLE "public"."categories" TO "anon";
GRANT ALL ON TABLE "public"."categories" TO "authenticated";
GRANT ALL ON TABLE "public"."categories" TO "service_role";

CREATE POLICY "Enable read access for authenticated users" ON "public"."categories"
AS PERMISSIVE FOR SELECT
TO authenticated
USING (true);
