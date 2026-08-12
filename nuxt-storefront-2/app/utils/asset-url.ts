export function assetUrl(path: string) {
  const config = useRuntimeConfig()
  const base = config.app.baseURL.replace(/\/$/, '')
  return `${base}${path}`
}
