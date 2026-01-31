import { defineConfig } from 'vite'
//import { defineConfig, loadEnv } from 'vite'

import react from '@vitejs/plugin-react-swc'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
})

// https://dev.to/boostup/uncaught-referenceerror-process-is-not-defined-12kg
/*
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');
  return {
    define: {
      'process.env.clientIdentifier': JSON.stringify(env.clientIdentifier),
      'process.env.featureToggleSlug': JSON.stringify(env.featureToggleSlug),
    },
    plugins: [react()],
  }
})
*/