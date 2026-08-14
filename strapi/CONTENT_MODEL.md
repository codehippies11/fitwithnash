# Content model

Create these collection types in the Strapi admin. Use a `uid` field named `slug` for every public type.

| Type | Required fields |
| --- | --- |
| Instructor | `fullName`, `slug`, `bio`, `image`, `social` (JSON), `metaTitle`, `metaDesc` |
| Program | `title`, `slug`, `excerpt`, `body` (rich text), `goal`, `level`, `durationWeeks`, `price`, `currency`, `coverImage`, `featured`, `metaTitle`, `metaDesc` |
| Workout | `title`, `slug`, `excerpt`, `body` (rich text), `goal`, `level`, `daysPerWeek`, `durationMinutes`, `equipment` (JSON), `coverImage`, `featured` |
| Blog post | `title`, `slug`, `excerpt`, `body` (rich text), `coverImage`, `category`, `author`, `publishedAt`, `metaTitle`, `metaDesc` |
| Testimonial | `name`, `quote`, `result`, `photo`, `approved` |
| Lead | `name`, `email`, `phone`, `goal`, `message`, `source`, `consent` |
| Site settings (single type) | `heroTitle`, `heroText`, `instagramUrl`, `seoTitle`, `seoDescription`, `primaryCtaLabel`, `primaryCtaUrl` |

Public permissions: read-only `find` and `findOne` for published Program, Workout, Blog post, Instructor, Testimonial, and Site settings. Keep Leads private; accept them only through a protected custom endpoint with rate limiting and CAPTCHA.
