import type { StoreRegion } from '@medusajs/types'
// https://nuxt.com/docs/api/configuration/nuxt-config

const baseURL = '/demo/store/'

export default defineNuxtConfig({
  vite: {
    server: {
      watch: {
        usePolling: true,
        interval: 1000,
      },
    },
  },
  modules: [
    '@nuxtjs/medusa',
    '@nuxt/ui',
    '@nuxt/image',
    '@nuxt/eslint',
  ],
  devtools: { enabled: true },
  app: {
    baseURL,
    pageTransition: { name: 'page', mode: 'out-in' },
    head: {
      link: [
        { rel: 'icon', type: 'image/x-icon', href: `${baseURL}favicon.ico` },
      ],
    },
  },
  css: ['~/assets/css/main.css'],
  ui: {
    colorMode: false,
  },
  runtimeConfig: {
    public: {
      stripeKey: process.env.NUXT_PUBLIC_STRIPE_KEY || '',
    },
  },
  routeRules: {
    '/**/': { prerender: false },
    '/**/products/**': { ssr: true },
    '/**/collections/**': { ssr: true },
    '/**/categories/**': { ssr: true },
    '/**/account': { ssr: true },
    '/**/store': { ssr: true },
    '/**/cart': { ssr: true },
    '/**/checkout': { ssr: true },
  },
  future: {
    compatibilityVersion: 4,
  },
  experimental: {
    payloadExtraction: true,
  },
  compatibilityDate: '2024-11-06',
  nitro: {
    preset: 'node-server',
  },
  hooks: {
    async 'prerender:routes'(ctx) {
      if (!process.env.NUXT_PUBLIC_MEDUSA_BACKEND_URL) {
        console.warn('[prerender:routes] NUXT_PUBLIC_MEDUSA_BACKEND_URL not set, skipping per-country prerender.')
        return
      }
      try {
        const { regions } = await fetch(`${process.env.NUXT_PUBLIC_MEDUSA_BACKEND_URL}/store/regions`, {
          credentials: 'include',
          headers: {
            'Content-Type': 'application/json',
            'x-publishable-api-key': process.env.NUXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || '',
          },
        }).then(res => res.json())
        const countries = regions?.map((region: StoreRegion) => region.countries).flat()
        for (const country of countries) {
          ctx.routes.add(`/${country.iso_2}`)
        }
      }
      catch (err) {
        console.warn('[prerender:routes] Backend unreachable during build, skipping per-country prerender:', (err as Error).message)
      }
    },
  },
  eslint: {
    config: {
      stylistic: true,
    },
  },
  medusa: {
    baseUrl: process.env.NUXT_PUBLIC_MEDUSA_BACKEND_URL,
    publishableKey: process.env.NUXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY,
    server: true,
  },
})
