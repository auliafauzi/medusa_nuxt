#!/bin/sh
# apply-theme-migration.sh
# Migrates components from useAppConfig() to the custom app/config/theme.ts
# Run this INSIDE the nuxt-storefront container:
#   docker compose exec nuxt-storefront sh apply-theme-migration.sh

set -e

echo "==> Writing app/config/theme.ts"
cat > app/config/theme.ts << 'EOF'
// app/config/theme.ts
// Ganti nilai di bawah ini untuk setiap klien

export const theme = {
  // Regional & Pagination Defaults
  defaultCountry: 'id',
  defaultProductsPerPage: 12,

  // Brand Identity
  brand: {
    name: 'Nama Brand Klien',
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
    heroTitle: 'Selamat Datang di Toko Kami',
    heroSubtitle: 'Temukan produk terbaik untuk kebutuhan Anda',
    heroImage: '/hero-banner.jpg',
    carouselBanners: [
      '/banner1.png',
      '/banner2.png',
      '/banner3.png',
      '/banner4.png',
      '/banner5.png',
    ],
    heroButtonText: 'Belanja Sekarang',
    heroButtonLink: '/store',
    featuredCollections: ['new-arrivals', 'best-sellers'],
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
      instagram: 'https://instagram.com/brand',
      facebook: 'https://facebook.com/brand',
      twitter: 'https://twitter.com/brand',
      tiktok: '',
    },
    copyright: 'Copyright ' + new Date().getFullYear() + ' Nama Brand Klien. All rights reserved.',
    showNewsletter: true,
    newsletterText: 'Dapatkan update terbaru dari kami',
  },

  // Contact
  contact: {
    email: 'hello@brand.com',
    phone: '+62 812-3456-7890',
    address: 'Jl. Contoh No. 123, Jakarta',
    whatsapp: 'https://wa.me/6281234567890',
  },
}

export type Theme = typeof theme
EOF

echo "==> Writing app/components/app/footer/copyright.vue"
cat > app/components/app/footer/copyright.vue << 'EOF'
<script lang="ts" setup>
import { theme } from '~/config/theme'

const {
  minimal,
} = defineProps<{
  minimal?: boolean
}>()
</script>

<template>
  <div
    class="flex w-full text-color-dimmed text-xs"
    :class="[minimal ? 'py-4 justify-center' : 'mb-16 justify-between']"
  >
    <div
      v-if="!minimal"
      class=""
    >
      Ã‚Â© 2025 {{ theme.brand.name }}. All rights reserved.
    </div>
    <div class="flex gap-x-2 items-center">
      <div>Powered by</div>
      <NuxtLink
        href="https://medusajs.com"
        target="_blank"
        class="hover:text-color-muted"
      >
        <UIcon
          name="i-simple-icons-medusa"
          class="size-5"
        />
      </NuxtLink>
      <span>&</span>
      <NuxtLink
        href="https://nuxt.com/"
        target="_blank"
        class="hover:text-color-muted"
      >
        <UIcon
          name="i-simple-icons-nuxtdotjs"
          class="size-6"
        />
      </NuxtLink>
    </div>
  </div>
</template>
EOF

echo "==> Writing app/components/app/footer/menu/index.vue"
cat > app/components/app/footer/menu/index.vue << 'EOF'
<script lang="ts" setup>
import { theme } from '~/config/theme'
</script>

<template>
  <footer class="flex flex-col gap-y-6 sm:flex-row items-start justify-between py-40">
    <AppLink
      to="/"
      class="text-lg uppercase font-medium text-color-highlighted"
    >
      {{ theme.brand.name }}
    </AppLink>
    <div class="gap-10 md:gap-x-16 grid grid-cols-2 sm:grid-cols-3 text-sm">
      <AppFooterMenuCategories />
      <AppFooterMenuCollections />
      <AppFooterMenuBrand />
    </div>
  </footer>
</template>
EOF

echo "==> Writing app/components/app/header/checkout.vue"
cat > app/components/app/header/checkout.vue << 'EOF'
<script setup lang="ts">
import { theme } from '~/config/theme'
</script>

<template>
  <header class="h-16 mx-auto duration-200 bg-white border-b border-color-muted">
    <UContainer class="flex items-center justify-between w-full h-full text-xs">
      <AppLink
        to="/cart"
        class=" -full flex-1 basis-0"
      >
        <div class="flex items-center gap-2 uppercase text-xs font-medium">
          <UIcon
            name="i-lucide-chevron-left"
            class="size-4"
          />
          <span>Back to shopping cart</span>
        </div>
      </AppLink>
      <AppLink
        to="/"
        class="uppercase text-lg font-medium h-full flex items-center"
      >
        {{ theme.brand.name }}
      </AppLink>
      <div class="flex-1 basis-0" />
    </UContainer>
  </header>
</template>
EOF

echo "==> Writing app/components/app/header/side-menu.vue"
cat > app/components/app/header/side-menu.vue << 'EOF'
<script setup lang="ts">
import { theme } from '~/config/theme'

const isOpen = defineModel<boolean>()

const countries = await useCountries()
const { country } = useCountry()
</script>

<template>
  <USlideover
    v-model:open="isOpen"
    side="left"
    title="Menu"
    description="Navigation menu"
  >
    <template #body>
      <div class="h-full min-h-48 flex flex-col justify-between">
        <div class="flex flex-col space-y-4">
          <AppLink
            v-for="item in theme.header.menuItems"
            :key="item.link"
            :to="item.link"
            @click="isOpen = false"
          >
            {{ item.label }}
          </AppLink>
        </div>

        <div v-if="theme.header.showCountrySelector">
          <AppHeaderCountrySelector
            :countries="countries"
            @select:country="isOpen = false"
          >
            <div class="flex items-center justify-between cursor-pointer group">
              <div class="text-xs flex items-center space-x-2">
                <span>Shipping to:</span>
                <UIcon :name="'i-flag-' + country?.iso_2 + '-4x3'" />
                <span>{{ country?.display_name }}</span>
              </div>
              <UIcon
                name="i-lucide-arrow-right"
                class="group-hover:-rotate-90 ease-in-out duration-150 size-5"
              />
            </div>
          </AppHeaderCountrySelector>
        </div>
      </div>
    </template>

    <template #footer>
      <div v-if="theme.footer.showSocial" class="flex gap-4 mb-4">
        <a v-for="(link, name) in theme.footer.socialLinks"
           :key="name"
           v-if="link"
           :href="link"
           target="_blank"
           class="text-color-muted hover:text-color-default">
          {{ name }}
        </a>
      </div>
      <p class="text-xs text-color-muted">
        {{ theme.footer.copyright }}
      </p>
    </template>
  </USlideover>
</template>
EOF

echo "==> Writing app/components/collection/list.vue"
cat > app/components/collection/list.vue << 'EOF'
<script setup lang="ts">
import { theme } from '~/config/theme'

const { featuredCollections } = theme.homepage
</script>

<template>
  <div class="py-12">
    <CollectionPreview
      v-for="collection in featuredCollections"
      :key="collection"
      :handle="collection"
    />
  </div>
</template>
EOF

echo "==> Patching app/components/store/catalog.vue"
sed -i \
  -e "s/const { defaultProductsPerPage } = useAppConfig()/import { theme } from '~\/config\/theme'\n\nconst { defaultProductsPerPage } = theme/" \
  app/components/store/catalog.vue

echo "==> Patching app/middleware/region.global.ts"
sed -i \
  -e "1i import { theme } from '~/config/theme'\n" \
  -e "s/const { defaultCountry: defaultCountryCode } = useAppConfig()/const { defaultCountry: defaultCountryCode } = theme/" \
  app/middleware/region.global.ts

echo ""
echo "==> Done! 8 files updated:"
echo "  - app/config/theme.ts"
echo "  - app/components/app/footer/copyright.vue"
echo "  - app/components/app/footer/menu/index.vue"
echo "  - app/components/app/header/checkout.vue"
echo "  - app/components/app/header/side-menu.vue"
echo "  - app/components/collection/list.vue"
echo "  - app/components/store/catalog.vue"
echo "  - app/middleware/region.global.ts"
echo ""
echo "Refresh your browser (Ctrl+Shift+R) after the dev server picks up the changes."
