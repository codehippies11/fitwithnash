import type { APIRoute } from 'astro';

export const GET: APIRoute = ({ url }) => {
  const origin = import.meta.env.PUBLIC_SITE_URL || 'https://www.fitwithnash.com';
  const pages = ['/', '/contact', '/transformations'];
  const lastmod = new Date().toISOString();
  const urls = pages.map((path) => `<url><loc>${origin}${path}</loc><lastmod>${lastmod}</lastmod><changefreq>weekly</changefreq><priority>${path === '/' ? '1.0' : '0.8'}</priority></url>`).join('');
  return new Response(`<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${urls}</urlset>`, {
    headers: { 'Content-Type': 'application/xml; charset=utf-8' },
  });
};
