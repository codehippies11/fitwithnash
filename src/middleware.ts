import { defineMiddleware } from 'astro:middleware';

export const onRequest = defineMiddleware((context, next) => {
  const hostname = context.url.hostname.toLowerCase();

  if (hostname === 'fitwithnash.com' || hostname === 'www.fitwithnash.com') {
    return Response.redirect(
      new URL(`${context.url.pathname}${context.url.search}`, 'https://consult.fitwithnash.com'),
      308,
    );
  }

  if (hostname === 'consult.fitwithnash.com' && context.url.pathname === '/') {
    return context.rewrite('/consult');
  }
  if (hostname === 'consult.fitwithnash.com' && context.url.pathname === '/sitemap.xml') {
    return context.rewrite('/consult-sitemap.xml');
  }
  if (hostname === 'consult.fitwithnash.com' && context.url.pathname === '/robots.txt') {
    return context.rewrite('/consult-robots.txt');
  }
  if (hostname === 'consult.fitwithnash.com' && context.url.pathname === '/transformations') {
    return Response.redirect(new URL('/#proof', context.url), 308);
  }

  return next();
});
