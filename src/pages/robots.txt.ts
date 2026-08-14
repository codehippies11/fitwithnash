import type { APIRoute } from 'astro';

export const GET: APIRoute = ({ url }) => {
  const origin = import.meta.env.PUBLIC_SITE_URL || url.origin;
  return new Response(`User-agent: *\nAllow: /\nDisallow: /studio\n\nSitemap: ${origin}/sitemap.xml\n`, {
    headers: { 'Content-Type': 'text/plain; charset=utf-8' },
  });
};
