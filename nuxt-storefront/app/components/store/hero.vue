<script setup lang="ts">
import { theme } from '~/config/theme'

const currentSlide = ref(0)
const banners = theme.homepage.carouselBanners

function hexToRgba(hex: string, alpha: number) {
  const r = parseInt(hex.slice(1, 3), 16)
  const g = parseInt(hex.slice(3, 5), 16)
  const b = parseInt(hex.slice(5, 7), 16)
  return `rgba(${r}, ${g}, ${b}, ${alpha})`
}

const overlayColor = computed(() =>
  hexToRgba(theme.brand.backgroundColor, theme.homepage.heroOverlayOpacity),
)

function nextSlide() {
  currentSlide.value = (currentSlide.value + 1) % banners.length
}

function prevSlide() {
  currentSlide.value = (currentSlide.value - 1 + banners.length) % banners.length
}

function goToSlide(index: number) {
  currentSlide.value = index
}

let autoplayInterval: ReturnType<typeof setInterval>
onMounted(() => {
  autoplayInterval = setInterval(nextSlide, theme.homepage.carouselIntervalMs)
})
onUnmounted(() => {
  clearInterval(autoplayInterval)
})
</script>

<template>
  <div class="w-full h-[75vh] relative overflow-hidden group">
    <div
      class="flex transition-transform duration-500 h-full"
      :style="{ transform: 'translateX(-' + (currentSlide * 100) + '%)' }"
    >
      <div
        v-for="(banner, index) in banners"
        :key="index"
        class="w-full h-full flex-shrink-0 relative"
      >
        <img
          :src="banner"
          :alt="'Banner ' + (index + 1)"
          class="w-full h-full object-cover"
        />
        <div
          v-if="index === 0"
          class="absolute inset-0 flex flex-col justify-center items-center text-center" :style="{ backgroundColor: overlayColor, color: theme.homepage.heroTextColor }"
          
        >
          <h1 class="text-4xl md:text-5xl font-bold mb-4">
            {{ theme.homepage.heroTitle }}
          </h1>
          <h2 class="text-xl md:text-2xl mb-8">
            {{ theme.homepage.heroSubtitle }}
          </h2>
          <UButton
            :to="theme.homepage.heroButtonLink"
            color="primary"
            variant="solid"
            size="lg"
          >
            {{ theme.homepage.heroButtonText }}
          </UButton>
        </div>
      </div>
    </div>

    <button
      @click="prevSlide"
      class="absolute left-4 top-1/2 -translate-y-1/2 bg-white/80 hover:bg-white text-black p-2 rounded-full opacity-0 group-hover:opacity-100 transition-opacity"
    >
      <UIcon name="i-lucide-chevron-left" class="size-6" />
    </button>
    <button
      @click="nextSlide"
      class="absolute right-4 top-1/2 -translate-y-1/2 bg-white/80 hover:bg-white text-black p-2 rounded-full opacity-0 group-hover:opacity-100 transition-opacity"
    >
      <UIcon name="i-lucide-chevron-right" class="size-6" />
    </button>

    <div class="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2">
      <button
        v-for="(_, index) in banners"
        :key="index"
        @click="goToSlide(index)"
        class="w-3 h-3 rounded-full transition-colors"
        :class="index === currentSlide ? 'bg-white' : 'bg-white/50'"
      />
    </div>
  </div>
</template>
