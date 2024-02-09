--
-- Name: quotes; Type: TABLE; Schema: public;
--
DROP TABLE IF EXISTS public.quotes;

CREATE TABLE public.quotes (
    id uuid NOT NULL,
    content character varying NOT NULL,
    author_id uuid NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    bible_reference character varying,
    active boolean DEFAULT true NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    likes_count bigint DEFAULT 0 NOT NULL,
    shares_count bigint DEFAULT 0 NOT NULL,
    bookmarks_count bigint DEFAULT 0 NOT NULL,
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
-- Name: index_quotes_on_tags; Type: INDEX; Schema: public;
--

CREATE INDEX index_quotes_on_tags ON public.quotes USING gin (tags);

--
-- Name: quotes fk_rails_3d9d6db8c2; Type: FK CONSTRAINT; Schema: public;
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT fk_rails_3d9d6db8c2 FOREIGN KEY (author_id) REFERENCES public.authors(id);


--
-- Name: random_quote; Type: View; Schema: public;
--

CREATE VIEW public.random_quote AS
SELECT
	quotes.id,
	quotes.content,
	quotes.tags,
	quotes.bible_reference,
	quotes.author_id,
	authors.name AS author_name,
	authors.proverb AS author_proverb,
	authors.bible AS author_bible
FROM
	quotes
	JOIN authors ON quotes.author_id = authors.id
WHERE
	quotes.active = TRUE
ORDER BY
	random()
LIMIT 1;
