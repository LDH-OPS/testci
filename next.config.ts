import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  eslint: {
    ignoreDuringBuilds: true, // 🚀 빌드할 때 ESLint 검사 비활성화
  },
};

export default nextConfig;
