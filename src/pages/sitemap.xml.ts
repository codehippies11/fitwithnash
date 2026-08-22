import type { APIRoute } from 'astro';

export const GET: APIRoute = ({ url }) => {
  const origin = import.meta.env.PUBLIC_SITE_URL || 'https://www.fitwithnash.com';
  const pages = [
    { path: '/', changefreq: 'weekly', priority: '1.0' },
    { path: '/transformations', changefreq: 'weekly', priority: '0.9' },
    { path: '/contact', changefreq: 'monthly', priority: '0.7' },
  ];
  const urls = pages.map(({ path, changefreq, priority }) => `<url><loc>${origin}${path}</loc><changefreq>${changefreq}</changefreq><priority>${priority}</priority></url>`).join('');
  return new Response(`<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${urls}</urlset>`, {
    headers: { 'Content-Type': 'application/xml; charset=utf-8' },
  });
};
