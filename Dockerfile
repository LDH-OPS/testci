# 1️⃣ 빌드 스테이지 (dependencies 설치 & Next.js 빌드)
FROM node:18 AS builder

# package.json 및 lock 파일 복사 (의존성 캐싱 최적화)
COPY package.json package-lock.json ./

# 의존성 설치 (npm ci는 lock 파일 기반 설치, 더 빠르고 안정적)
RUN npm ci

# ✅ 시간 동기화 (Google Fonts SSL 문제 해결)
RUN apt-get update && apt-get install -y tzdata
 
# 모든 소스 코드 복사
COPY . .

# 환경변수 설정
ENV NEXT_DISABLE_ESLINT=1
ENV ESLINT_NO_DEV_ERRORS=1
ENV NEXT_DISABLE_NET_CONNECT=1

# Next.js 빌드 실행
RUN npm run build

# 2️⃣ 실행 스테이지 (경량 이미지에서 실행)
FROM node:18-alpine

# 빌드된 파일과 node_modules 복사
COPY --from=builder package.json package-lock.json ./
COPY --from=builder .next .next
COPY --from=builder public public
COPY --from=builder node_modules node_modules
COPY --from=builder src src

# 실행 포트 설정 (3000: Next.js)
EXPOSE 3000

# ✅ Next.js 실행 (localhost:3000)
CMD ["npm", "run", "start", "--", "-H", "0.0.0.0"]

