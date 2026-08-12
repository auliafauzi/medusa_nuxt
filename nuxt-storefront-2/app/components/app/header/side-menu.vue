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
