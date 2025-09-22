import { defineConfig } from 'vite';

export default defineConfig({
    root: '.',                     // current frontend root
    base: '/',                     // important for correct asset paths
    build: {
        outDir: '../src/main/resources/static', // <-- put built files into the JAR
        emptyOutDir: true
    }
});
