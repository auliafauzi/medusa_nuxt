<script setup lang="ts">
import { theme } from '~/config/theme'

useHead({
  bodyAttrs: {
    style: `background-color: ${theme.brand.backgroundColor}`,
  },
})
</script>

<template>
  <UApp>
    <NuxtRouteAnnouncer />
    <AppHeader />
    <NuxtLoadingIndicator color="black" />
    <main class="relative">
      <slot />
    </main>
    <AppFooter />
  </UApp>
</template>