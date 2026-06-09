import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

const DASHBOARD_PORT = process.env.DASHBOARD_PORT || 3456
const VITE_PORT = process.env.VITE_PORT || 3457

export default defineConfig({
  plugins: [react()],
  server: {
    port: parseInt(VITE_PORT, 10),
    proxy: {
      '/api': {
        target: `http://127.0.0.1:${DASHBOARD_PORT}`,
        changeOrigin: true
      },
      '/ws': {
        target: `ws://127.0.0.1:${DASHBOARD_PORT}`,
        changeOrigin: true,
        ws: true
      }
    }
  },
  build: {
    outDir: 'dist',
    sourcemap: false
  }
})
