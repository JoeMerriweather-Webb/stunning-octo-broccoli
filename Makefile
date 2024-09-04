.PHONY: http_tests
http_tests:
	docker container run -v ./http_tests:/app -w /app -it ghcr.io/orange-opensource/hurl:latest --verbose --test documents.hurl

.PHONY: up
up:
	docker compose up -d

.PHONY: down
down:
	docker compose down