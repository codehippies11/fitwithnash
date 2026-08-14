export interface SeoData {
  title: string;
  description: string;
  image?: string;
}

/**
 * Merge provided overrides with global SEO defaults.
 * If any field is empty, the global default from Strapi `seoSettings` is used.
 * For now we just return a static default; in production you would fetch from Strapi.
 */
export const getSEO = (
  title?: string,
  desc?: string,
  img?: string
): SeoData => {
  const defaultTitle = 'FitWithNash – Fitness Courses & Certification';
  const defaultDesc =
    'India’s leading platform for personal trainer certification, courses, and fitness education. Join thousands of certified professionals.';
  const defaultImg = '/favicon.svg';

  return {
    title: title || defaultTitle,
    description: desc || defaultDesc,
    image: img || defaultImg,
  };
};