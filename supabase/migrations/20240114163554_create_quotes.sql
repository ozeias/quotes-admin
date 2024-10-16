--
-- Name: quotes; Type: TABLE; Schema: public;
--
DROP TABLE IF EXISTS public.quotes;

CREATE TABLE public.quotes (
    id uuid NOT NULL,
    content character varying NOT NULL,
    author_id uuid NOT NULL,
    categories_slug character varying[] DEFAULT '{}'::character varying[],
    bible_reference character varying,
    active boolean DEFAULT true NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    background_image json,
    likes_count bigint DEFAULT 0 NOT NULL,
    shares_count bigint DEFAULT 0 NOT NULL,
    favorites_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

--
-- Name: quotes quotes_pkey; Type: CONSTRAINT; Schema: public;
--
ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (id);

--
-- Name: index_quotes_on_author_id; Type: INDEX; Schema: public;
--
CREATE INDEX index_quotes_on_author_id ON public.quotes USING btree (author_id);

--
-- Name: index_quotes_on_categories_slug; Type: INDEX; Schema: public;
--
CREATE INDEX index_quotes_on_categories_slug ON public.quotes USING gin (categories_slug);

--
-- Name: quotes fk_3d9d6db8c2; Type: FK CONSTRAINT; Schema: public;
--
ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT fk__3d9d6db8c2 FOREIGN KEY (author_id) REFERENCES public.authors(id);

--
-- Security
--
ALTER TABLE "public"."quotes" OWNER TO "postgres";
ALTER TABLE "public"."quotes" ENABLE ROW LEVEL SECURITY;

-- GRANT ALL ON TABLE "public"."quotes" TO "anon";
GRANT ALL ON TABLE "public"."quotes" TO "authenticated";
GRANT ALL ON TABLE "public"."quotes" TO "service_role";

CREATE POLICY "Enable read access for authenticated users" ON "public"."quotes"
AS PERMISSIVE FOR SELECT
TO authenticated
USING (true);

--
-- Name: random_quote; Type: View; Schema: public;
--
CREATE VIEW public.random_quote WITH (security_invoker = true) AS
SELECT
  quotes.id,
  quotes.content,
  quotes.categories_slug,
  quotes.bible_reference,
  quotes.author_id,
  authors.name AS author_name,
  authors.proverb AS author_proverb,
  authors.bible AS author_bible,
  quotes.background_image,
  quotes.likes_count,
  quotes.shares_count,
  quotes.favorites_count,
  quotes.updated_at
FROM
  quotes
  JOIN authors ON quotes.author_id = authors.id
WHERE
  quotes.active = TRUE
ORDER BY
  random()
LIMIT 1;

--
-- Security
--
ALTER TABLE "public"."random_quote" OWNER TO "postgres";

-- GRANT ALL ON TABLE "public"."random_quote" TO "anon";
GRANT ALL ON TABLE "public"."random_quote" TO "authenticated";
GRANT ALL ON TABLE "public"."random_quote" TO "service_role";

-- CREATE POLICY "Enable read access for anon users" ON "public"."random_quote"
-- AS PERMISSIVE FOR SELECT TO anon USING (true);

-- REVOKE USAGE ON SCHEMA public FROM anon;
-- REVOKE ALL ON ALL TABLES IN SCHEMA public from anon;
-- REVOKE USAGE ON SCHEMA public FROM authenticated;
-- REVOKE ALL ON ALL TABLES IN SCHEMA public from authenticated;
