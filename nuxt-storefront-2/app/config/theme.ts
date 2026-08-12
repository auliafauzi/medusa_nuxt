// app/config/theme.ts
// Ganti nilai di bawah ini untuk setiap klien

export const theme = {
  // Regional & Pagination Defaults
  defaultCountry: 'id',
  defaultProductsPerPage: 12,

  // Brand Identity
  brand: {
    name: 'Icebee Kids',
    logo: '/logo.png',
    logoAlt: 'Logo Brand Klien',
    favicon: '/favicon.ico',
    primaryColor: '#3B82F6',
    secondaryColor: '#A89B8C',
    accentColor: '#25D366',
    backgroundColor: '#F0E6D8',
    font: 'Inter',
  },

  // Homepage
  homepage: {
    heroTitle: 'Welcome to Rahasia Fragance',
    heroSubtitle: 'Jelajahi aroma eksklusif kami dan temukan keharuman yang memikat.',
    heroImage: '/hero-banner.jpg',
    carouselIntervalMs: 7000,
    heroOverlayOpacity: 0.35,
    heroTextColor: '#e08181',
    carouselBanners: [
      '/banner1.png',
      '/banner2.png',
      '/banner3.png',
      '/banner4.png',
      '/banner5.png',
    ],
    heroButtonText: 'Belanja Sekarang',
    heroButtonLink: '/store',
    featuredCollections: ['latest-drops2', 'nagita', 'cinta'],
  },

  // Header
  header: {
    showCountrySelector: true,
    showSearch: true,
    menuItems: [
      { label: 'Home', link: '/' },
      { label: 'Store', link: '/store' },
      { label: 'Account', link: '/account' },
    ],
  },

  // Footer
  footer: {
    showSocial: true,
    socialLinks: {
      instagram: 'https://instagram.com/icebee-kids',
      facebook: 'https://facebook.com/icebee-kids',
      twitter: 'https://twitter.com/icebee-kids',
      tiktok: '',
    },
    copyright: 'Copyright ' + new Date().getFullYear() + ' Icebee Kids. All rights reserved.',
    showNewsletter: true,
    newsletterText: 'Dapatkan update terbaru dari kami',
  },

  // Contact
  contact: {
    email: 'hello@icebee-kids.com',
    phone: '+62 812-3456-7890',
    address: 'Jl. Gatot Subroto No. 123, Jakarta',
    whatsapp: 'https://wa.me/6281234567890',
  },
}

export type Theme = typeof theme
