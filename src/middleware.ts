import { defineMiddleware } from 'astro:middleware';

export const onRequest = defineMiddleware((context, next) => {
  if (context.url.hostname === 'consult.fitwithnash.com' && context.url.pathname === '/') {
    return context.rewrite('/consult');
  }

  return next();
});
