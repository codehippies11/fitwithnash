import { defineMiddleware } from 'astro:middleware';

export const onRequest = defineMiddleware((context, next) => {
  if (context.url.hostname === 'consult.fitwithnash.com' && context.url.pathname === '/') {
    return context.rewrite('/consult');
  }
  if (context.url.hostname === 'consult.fitwithnash.com' && context.url.pathname === '/sitemap.xml') {
    return context.rewrite('/consult-sitemap.xml');
  }
  if (context.url.hostname === 'consult.fitwithnash.com' && context.url.pathname === '/robots.txt') {
    return context.rewrite('/consult-robots.txt');
  }

  return next();
});
