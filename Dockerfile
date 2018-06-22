FROM swift:4.1 as build
WORKDIR /app
COPY . .
RUN swift build --configuration release
FROM swift:4.1
WORKDIR /app
COPY --from=build /app/.build/release/Sample .
EXPOSE 8080
CMD ./Sample
