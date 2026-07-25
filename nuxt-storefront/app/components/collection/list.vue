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
