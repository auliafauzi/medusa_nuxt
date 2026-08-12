<script setup lang="ts">
import { theme } from '~/config/theme'

const isSideMenuOpen = ref(false)
</script>

<template>
  <div class="sticky top-0 inset-x-0 z-50">
    <header class="h-16 mx-auto duration-200 bg-white border-b border-color-muted">
      <UContainer class="flex items-center justify-between w-full h-full text-xs">
        <div
          class="cursor-pointer h-full flex items-center flex-1 basis-0"
          @click="isSideMenuOpen = !isSideMenuOpen"
        >
          Menu
        </div>

        <AppLink
          to="/"
          class="h-full flex items-center justify-center"
        >
          <img 
            :src="assetUrl(theme.brand.logo)" 
            :alt="theme.brand.logoAlt" 
            class="h-16 w-auto"
          />
        </AppLink>

        <nav class="flex items-center space-x-6 flex-1 basis-0 justify-end">
          <AppLink
            v-for="item in theme.header.menuItems"
            :key="item.link"
            :to="item.link"
            class="hidden sm:flex"
          >
            {{ item.label }}
          </AppLink>

          <ClientOnly>
            <LazyCartDropdown />
            <template #fallback>
              <AppLink to="/cart" class="hidden sm:flex">Cart</AppLink>
            </template>
          </ClientOnly>
        </nav>
      </UContainer>

      <AppHeaderSideMenu v-model="isSideMenuOpen" />
    </header>
  </div>
</template>
