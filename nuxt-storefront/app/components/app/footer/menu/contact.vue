<script lang="ts" setup>
import { theme } from '~/config/theme'

const socialLinks = computed(() =>
  Object.entries(theme.footer.socialLinks).filter(([, link]) => link),
)
</script>

<template>
  <div class="flex flex-col gap-y-4">
    <div class="font-medium text-color-highlighted">
      Contact
    </div>
    <ul class="grid grid-cols-1 gap-y-2">
      <li>
        <a
          :href="`mailto:${theme.contact.email}`"
          class="hover:text-color-highlighted"
        >
          {{ theme.contact.email }}
        </a>
      </li>
      <li>
        <a
          :href="`tel:${theme.contact.phone}`"
          class="hover:text-color-highlighted"
        >
          {{ theme.contact.phone }}
        </a>
      </li>
      <li class="text-color-dimmed">
        {{ theme.contact.address }}
      </li>
      <li v-if="theme.contact.whatsapp">
        <a
          :href="theme.contact.whatsapp"
          target="_blank"
          class="hover:text-color-highlighted"
        >
          WhatsApp
        </a>
      </li>
    </ul>
    <div
      v-if="theme.footer.showSocial && socialLinks.length"
      class="flex gap-3 mt-2"
    >
      <a
        v-for="[name, link] in socialLinks"
        :key="name"
        :href="link"
        target="_blank"
        class="hover:text-color-highlighted capitalize text-xs"
      >
        {{ name }}
      </a>
    </div>
  </div>
</template>
