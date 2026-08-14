# Serverless CMS (Supabase)

This replaces the need to run Strapi for the initial editorial CMS. Supabase provides hosted PostgreSQL, Auth, Storage, and a REST API; Vercel serves the Astro frontend and trainer pages as serverless routes.

1. Create a Supabase project and run `schema.sql` in its SQL Editor.
2. Create an Auth user, then promote it with the final SQL comment in `schema.sql`.
3. Add Vercel environment variables: `PUBLIC_SUPABASE_URL` and `PUBLIC_SUPABASE_ANON_KEY`.
4. Sign in to `/studio` with the Auth user. Upload trainer imagery, create trainers, then publish them.

The anon key is deliberately public; row-level security prevents unauthorised writes. Never expose a Supabase service-role key to Vercel client code.
