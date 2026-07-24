# E-Commerce Theme Customization Guide

## Overview

This guide explains how to customize the Nuxt + Medusa e-commerce starter for different client brands. All brand-specific configurations are centralized in a single file: `app/config/theme.ts`.

---

## Quick Start

1. Clone the project
2. Edit `app/config/theme.ts`
3. Replace logo and favicon in `public/`
4. Customize colors in `app/assets/css/tailwind.css`
5. Test with `pnpm run dev`
6. Build with `pnpm run build`

---

## File Structure

```
nuxt-storefront/
├── app/
│   ├── config/
│   │   └── theme.ts          # Central theme configuration
│   ├── components/
│   │   ├── app/
│   │   │   ├── header/       # Header components
│   │   │   │   ├── index.vue
│   │   │   │   ├── side-menu.vue
│   │   │   │   └── country-selector.vue
│   │   │   └── footer/       # Footer components
│   │   └── store/
│   │       └── hero.vue      # Homepage hero section
│   ├── assets/
│   │   └── css/
│   │       └── tailwind.css  # Global styles and colors
│   └── pages/
│       └── [countryCode]/
│           └── index.vue     # Homepage
├── public/
│   ├── logo.svg              # Brand logo
│   └── favicon.ico           # Browser favicon
└── nuxt.config.ts            # App metadata
```

---

## Theme Configuration

### 1. Brand Identity (`app/config/theme.ts`)

```typescript
export const theme = {
  brand: {
    name: 'Client Brand Name',      // Website title
    logo: '/logo.svg',               // Path to logo in public/
    logoAlt: 'Client Brand Logo',    // Alt text for accessibility
    favicon: '/favicon.ico',         // Path to favicon in public/
    primaryColor: '#3B82F6',       // Main brand color (Tailwind blue-500)
    secondaryColor: '#10B981',       // Secondary color (Tailwind emerald-500)
    accentColor: '#F59E0B',          // Accent/CTA color (Tailwind amber-500)
    font: 'Inter',                   // Google Font name
  },
  // ...
}
```

**How to customize:**
- Change `name` to your client's brand name
- Replace `logo.svg` and `favicon.ico` in the `public/` folder
- Adjust `primaryColor`, `secondaryColor`, and `accentColor` to match brand guidelines

---

### 2. Homepage Content

```typescript
homepage: {
  heroTitle: 'Welcome to Our Store',
  heroSubtitle: 'Discover the best products curated for you',
  heroImage: '/hero-banner.jpg',        // Background image for hero
  heroButtonText: 'Shop Now',
  heroButtonLink: '/store',
  featuredCollections: ['new-arrivals', 'best-sellers'],
},
```

**How to customize:**
- Update `heroTitle` and `heroSubtitle` with client messaging
- Replace `heroImage` with client's banner image (place in `public/`)
- Change `heroButtonText` for CTA customization
- Update `featuredCollections` with actual collection handles from Medusa admin

---

### 3. Navigation Menu

```typescript
header: {
  showCountrySelector: true,    // Show/hide country dropdown
  showSearch: true,             // Show/hide search bar
  menuItems: [
    { label: 'Home', link: '/' },
    { label: 'Store', link: '/store' },
    { label: 'Account', link: '/account' },
    { label: 'Cart', link: '/cart' },
  ],
},
```

**How to customize:**
- Add/remove menu items as needed
- Change labels to match client's language preference
- Set `showCountrySelector: false` if not needed

---

### 4. Footer

```typescript
footer: {
  showSocial: true,
  socialLinks: {
    instagram: 'https://instagram.com/brand',
    facebook: 'https://facebook.com/brand',
    twitter: 'https://twitter.com/brand',
    tiktok: '',                   // Leave empty to hide
  },
  copyright: 'Copyright 2026 Client Name. All rights reserved.',
  showNewsletter: true,
  newsletterText: 'Get the latest updates',
},
```

**How to customize:**
- Update social media links (leave empty string to hide)
- Change `copyright` text with client name and year
- Set `showNewsletter: false` if not needed

---

### 5. Contact Information

```typescript
contact: {
  email: 'hello@client.com',
  phone: '+62 812-3456-7890',
  address: 'Jl. Example No. 123, Jakarta',
  whatsapp: 'https://wa.me/6281234567890',
},
```

**How to customize:**
- Update with client's actual contact details
- Used in footer, contact page, and order confirmations

---

## Carousel Hero Banner

### Setup

Place banner images in `public/` folder:

```
public/
├── banner1.png
├── banner2.png
├── banner3.png
├── banner4.png
└── banner5.png
```

### Configuration

Update `app/config/theme.ts`:

```typescript
homepage: {
  heroTitle: 'Welcome to Our Store',
  heroSubtitle: 'Discover the best products',
  heroButtonText: 'Shop Now',
  heroButtonLink: '/store',
  carouselBanners: [           // ⭐ Add banner images
    '/banner1.png',
    '/banner2.png',
    '/banner3.png',
    '/banner4.png',
    '/banner5.png',
  ],
},
```

### Features

| Feature | Description |
|---------|-------------|
| Autoplay | Auto-rotate every 5 seconds |
| Navigation arrows | Previous/Next buttons (hover to show) |
| Dots pagination | Click to jump to specific slide |
| Infinite loop | Continuous rotation |
| Overlay text | Title, subtitle, CTA button on first slide |

### Customize Overlay

Edit `app/components/store/hero.vue` to change overlay text or show on all slides:

```vue
<!-- Show overlay on all slides (remove v-if) -->
<div class="absolute inset-0 bg-black/30 ...">
  <!-- Content -->
</div>
```

### Customize Timing

Edit autoplay interval in `hero.vue`:

```typescript
// Change 5000 to desired milliseconds
autoplayInterval = setInterval(nextSlide, 5000)  // 5 seconds
```

---

## Color Customization (Tailwind CSS)

### Method 1: Theme Config (Recommended)

Edit `app/assets/css/tailwind.css`:

```css
@theme {
  --color-primary: #3B82F6;      /* Brand primary color */
  --color-secondary: #10B981;    /* Brand secondary color */
  --color-accent: #F59E0B;       /* CTA buttons, highlights */
  --color-muted: #F3F4F6;        /* Backgrounds, borders */
}
```

### Method 2: Tailwind Config

Edit `tailwind.config.ts`:

```typescript
export default {
  theme: {
    extend: {
      colors: {
        primary: '#3B82F6',
        secondary: '#10B981',
        accent: '#F59E0B',
      },
    },
  },
}
```

---

## Asset Replacement

### Logo

1. Prepare logo file (SVG recommended, PNG also works)
2. Name it `logo.svg` (or update path in `theme.ts`)
3. Place in `public/logo.svg`
4. Update `theme.ts`: `logo: '/logo.svg'`

### Favicon

1. Generate favicon from logo (use favicon.io or similar)
2. Name it `favicon.ico`
3. Place in `public/favicon.ico`
4. Update `theme.ts`: `favicon: '/favicon.ico'`

### Hero Banner

1. Prepare banner image (recommended: 1920x1080px)
2. Name it `hero-banner.jpg`
3. Place in `public/hero-banner.jpg`
4. Update `theme.ts`: `heroImage: '/hero-banner.jpg'`

---

## Per-Client Workflow

```
Step 1: Clone the starter template
  git clone [repo-url] client-name-store

Step 2: Install dependencies
  pnpm install

Step 3: Edit theme configuration
  # Edit app/config/theme.ts

Step 4: Replace assets
  # Replace public/logo.svg
  # Replace public/favicon.ico
  # Add public/hero-banner.jpg

Step 5: Customize colors (if needed)
  # Edit app/assets/css/tailwind.css

Step 6: Test locally
  pnpm run dev

Step 7: Build for production
  pnpm run build

Step 8: Deploy
  # Vercel, Cloudflare, or self-hosted
```

---

## Advanced Customization

### Adding New Pages

Create new Vue files in `app/pages/[countryCode]/`:

```vue
<!-- app/pages/[countryCode]/about.vue -->
<template>
  <div class="container mx-auto py-12">
    <h1 class="text-3xl font-bold">About {{ theme.brand.name }}</h1>
    <p class="mt-4">{{ theme.brand.name }} is...</p>
  </div>
</template>

<script setup>
import { theme } from '~/config/theme'
</script>
```

### Adding New Components

1. Create component file: `app/components/CustomSection.vue`
2. Import theme config: `import { theme } from '~/config/theme'`
3. Use in pages or layouts

### Custom Fonts

1. Add Google Font link in `nuxt.config.ts`:

```typescript
export default defineNuxtConfig({
  app: {
    head: {
      link: [
        { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap' }
      ]
    }
  }
})
```

2. Update `theme.ts`: `font: 'Poppins'`
3. Update Tailwind config to use the font

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Changes not reflecting | Restart dev server: `pnpm run dev` |
| Logo not showing | Check file path in `public/` and `theme.ts` |
| Colors not applying | Clear `.nuxt` cache: `rm -rf .nuxt` |
| Font not loading | Check Google Fonts URL and network connection |
| Build errors | Check for syntax errors in `theme.ts` |
| Carousel not rotating | Check `carouselBanners` array in `theme.ts` |
| Images not loading | Verify file names match exactly (case-sensitive) |

---

## Best Practices

1. **Always use `theme.ts`** for brand-specific values — never hardcode in components
2. **Keep original files** as backup before customization
3. **Use SVG for logos** — scalable and crisp on all devices
4. **Optimize images** — compress hero banners before adding to `public/`
5. **Test on mobile** — check responsive design after color/font changes
6. **Document customizations** — keep notes of what was changed per client
7. **Use consistent naming** — banner1.png, banner2.png (not Banner1.PNG)
8. **Check file extensions** — `.png` vs `.jpg` vs `.svg`

---

## Support

For questions or issues:
- Medusa Docs: https://docs.medusajs.com
- Nuxt Docs: https://nuxt.com/docs
- Starter Repo: https://github.com/OlivierBelaud/nuxt-starter-medusa
