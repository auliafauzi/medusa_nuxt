<script lang="ts" setup>
import { theme } from '~/config/theme'
</script>

<template>
  <footer class="flex flex-col gap-y-6 sm:flex-row items-start justify-between py-40">
    <AppLink to="/" class="flex items-center">
      <img
        :src="theme.brand.logo"
        :alt="theme.brand.logoAlt"
        class="h-38 w-auto"
      />
    </AppLink>
    <div class="gap-10 md:gap-x-16 grid grid-cols-2 sm:grid-cols-3 text-sm">
      <AppFooterMenuCategories />
      <AppFooterMenuCollections />
      <AppFooterMenuBrand />
    </div>
  </footer>
</template>


