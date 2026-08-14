# FitWithNash CMS

This folder deploys Strapi and PostgreSQL on a VPS. Put it behind Caddy or Nginx with HTTPS at `cms.yourdomain.com`; Strapi is bound to localhost and must not be exposed directly to the internet.

## First deploy

1. Copy this repository to the VPS and install Docker Compose.
2. Copy `.env.example` to `.env`, then replace every placeholder with securely generated values (`openssl rand -base64 48` is suitable).
3. Run `docker compose up -d` from this directory.
4. Visit `https://cms.yourdomain.com/admin` and create the first Strapi administrator.
5. Create public collection types using `CONTENT_MODEL.md`, then create a read-only API token for Vercel.

Use automated database backups and move media to Cloudflare R2/S3 before production launch. The local Docker volume is acceptable only for initial setup; it is not a backup strategy.

## Publishing workflow

Editors publish in Strapi. Configure a Strapi webhook for the `entry.publish` event to call a Vercel Deploy Hook for the `main` branch. Vercel then rebuilds the static Astro pages from the CMS. Store the API URL in Vercel as `PUBLIC_API_URL` and the read-only token as `CMS_API_TOKEN`.
